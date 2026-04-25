namespace Server {
    using System;
    using System.Collections.Concurrent;
    using System.Collections.Generic;
    using System.Net;
    using System.Net.Sockets;
    using System.Runtime.InteropServices;
    using System.Threading;
    using System.Threading.Tasks;

    internal class Program {
        private static readonly UdpClient Client = new();
        private static readonly ConcurrentQueue<Packet> PacketQueue = new();
        private static readonly List<Racer> Racers = new(Constants.NumMaxRacers);
        private static DateTime LastMetaDataPacketSentDate = DateTime.UtcNow;
        private static readonly CancellationTokenSource CancellationTokenSource = new();

        private static async Task Main(string[] args) {
            Console.CancelKeyPress += (s, e) => {
                e.Cancel = true;
                CancellationTokenSource.Cancel();
            };

            if (args.Length == 0 || !int.TryParse(args[0], out var port)) {
                port = Constants.DefaultPort;
            }

            Client.Client.Bind(new IPEndPoint(IPAddress.Any, port));

            if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows)) {
                _ = NativeMethods.TimeBeginPeriod(1);
            }

            _ = Task.Run(() => ContinuouslyReceivePackets(CancellationTokenSource.Token));
            try {
                await ContinuouslySendPacketsAsync(CancellationTokenSource.Token);
            } catch (OperationCanceledException) {
            } finally {
                if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows)) {
                    _ = NativeMethods.TimeEndPeriod(1);
                }
            }
        }

        private static void ContinuouslyReceivePackets(CancellationToken cancellationToken) {
            while (!cancellationToken.IsCancellationRequested) {
                var endpoint = new IPEndPoint(IPAddress.Any, 0);
                byte[] data;
                try {
                    data = Client.Receive(ref endpoint);
                } catch {
                    continue;
                }

                if (
                    data.Length < Constants.NumMinPacketDataBytes ||
                    data.Length > Constants.NumMaxPacketDataBytes ||
                    PacketQueue.Count > Constants.NumMaxPackets
                ) {
                    continue;
                }

                PacketQueue.Enqueue(new(endpoint, data));
            }
        }

        private static async Task ContinuouslySendPacketsAsync(CancellationToken cancellationToken) {
            var timer = new PeriodicTimer(TimeSpan.FromSeconds(Constants.RegularDataTickRateSeconds));
            while (!cancellationToken.IsCancellationRequested && await timer.WaitForNextTickAsync(cancellationToken)) {
                ProcessPacketQueue();
                FilterRacers();
                if (Racers.Count == 0) {
                    await Task.Delay(Constants.EmptyServerSleepMillis, cancellationToken);
                    continue;
                }

                CalculateLeaderboardData();
                SendRegularPackets();
                if ((DateTime.UtcNow - LastMetaDataPacketSentDate).TotalSeconds > Constants.MetaDataTickRateSeconds) {
                    SendMetaDataPackets();
                    GC.Collect();
                }
            }
        }

        private static void ProcessPacketQueue() {
            for (var packetCount = PacketQueue.Count; packetCount > 0; packetCount--) {
                _ = PacketQueue.TryDequeue(out var packet);
                Racer? matchingRacer = null;
                foreach (var racer in Racers) {
                    if (racer.IPEndPoint.Equals(packet!.IPEndPoint)) {
                        matchingRacer = racer;
                        break;
                    }
                }

                if (matchingRacer == null) {
                    matchingRacer = new Racer(packet!.IPEndPoint);
                    Racers.Add(matchingRacer);
                }

                matchingRacer.ProcessPacket(packet!);
            }
        }

        private static void FilterRacers() {
            for (var i = Racers.Count - 1; i >= 0; i--) {
                var racer = Racers[i];
                if ((DateTime.UtcNow - racer.LastPacketReceivedDate).TotalSeconds > Constants.DisconnectTimeoutSeconds) {
                    Racers.RemoveAt(i);
                }
            }
        }

        private static void CalculateLeaderboardData() {
            var sortedRacers = new List<Racer>(Racers);
            sortedRacers.Sort((a, b) => a.GetFurthestCheckpoint() > b.GetFurthestCheckpoint()
                    ? -1
                    : b.GetFurthestCheckpoint() > a.GetFurthestCheckpoint()
                        ? 1
                        : MathF.Sign(a.GetCheckpointTimeAt(a.GetFurthestCheckpoint()) - b.GetCheckpointTimeAt(b.GetFurthestCheckpoint())));

            for (var i = 0; i < sortedRacers.Count; i++) {
                var racer = sortedRacers[i];
                racer.SetPlacement((byte)i);
                var racerFurthestCheckpoint = racer.GetFurthestCheckpoint();
                if (racerFurthestCheckpoint == Constants.NumCheckpoints - 1) {
                    racer.SetDiffToFirst(racer.GetCheckpointTimeAt(Constants.NumCheckpoints - 1));
                } else {
                    racer.SetDiffToFirst(sortedRacers[0].GetCheckpointTimeAt(racerFurthestCheckpoint) - racer.GetCheckpointTimeAt(racerFurthestCheckpoint));
                }
            }
        }

        private static void SendRegularPackets() {
            var numOtherRacers = Racers.Count - 1;
            var numRegularPacketBytes =
                sizeof(byte) +  // packet_type
                sizeof(byte) +  // num_other_racers
                (
                    Constants.CheckpointRacerDataOffset +
                    sizeof(byte) +  // furthest_checkpoint
                    sizeof(byte) +  // placement
                    sizeof(float)   // diff_to_first
                ) * numOtherRacers +
                sizeof(byte) +  // placement
                sizeof(float);  // diff_to_first
            for (var i = 0; i < Racers.Count; i++) {
                var packet = new byte[numRegularPacketBytes];
                packet[0] = Constants.RegularPacketType;
                packet[1] = (byte)numOtherRacers;
                var offset = 2;
                for (var ii = 0; ii < Racers.Count; ii++) {
                    if (i == ii) {
                        continue;
                    }

                    var otherRacer = Racers[ii];
                    otherRacer.Data.AsSpan(0, Constants.CheckpointRacerDataOffset).CopyTo(packet.AsSpan(offset));
                    offset += Constants.CheckpointRacerDataOffset;
                    otherRacer.Data.AsSpan(Constants.FurthestCheckpointRacerDataOffset, Constants.NumPastCheckpointsRacerOutboundPacketDataBytes).CopyTo(packet.AsSpan(offset));
                    offset += Constants.NumPastCheckpointsRacerOutboundPacketDataBytes;
                }

                var racer = Racers[i];
                racer.Data.AsSpan(Constants.PlacementRacerDataOffset, sizeof(byte) + sizeof(float)).CopyTo(packet.AsSpan(offset));
                try {
                    _ = Client.Send(packet, racer.IPEndPoint);
                } catch {
                    continue;
                }
            }
        }

        private static void SendMetaDataPackets() {
            var numOtherRacers = Racers.Count - 1;
            var numMaxMetaDataPacketBytes =
                sizeof(byte) +  // packet_type
                sizeof(byte) +  // num_other_racers
                (
                    Constants.NumMaxNameChars +
                    sizeof(uint) +  // name_color
                    sizeof(uint) +  // outline_color
                    sizeof(uint) +  // body_color
                    sizeof(uint) +  // shell_color
                    sizeof(uint)    // eye_color
                ) * numOtherRacers;
            for (var i = 0; i < Racers.Count; i++) {
                var packet = new byte[numMaxMetaDataPacketBytes];
                packet[0] = Constants.MetaDataPacketType;
                packet[1] = (byte)numOtherRacers;
                var offset = 2;
                for (var ii = 0; ii < Racers.Count; ii++) {
                    if (i == ii) {
                        continue;
                    }

                    var otherRacer = Racers[ii];
                    var numBytesToCopy = otherRacer.NumDataBytes - Constants.NameRacerDataOffset;
                    otherRacer.Data.AsSpan(Constants.NameRacerDataOffset, numBytesToCopy).CopyTo(packet.AsSpan(offset));
                    offset += numBytesToCopy;
                }

                try {
                    _ = Client.Send(packet, offset, Racers[i].IPEndPoint);
                } catch {
                    continue;
                }
            }

            LastMetaDataPacketSentDate = DateTime.UtcNow;
        }
    }
}
