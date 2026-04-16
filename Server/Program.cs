namespace Server {
    using System.Buffers;
    using System.Buffers.Binary;
    using System.Collections.Concurrent;
    using System.Net;
    using System.Net.Sockets;
    using System.Runtime.InteropServices;

    internal class Program {
        private static readonly UdpClient Client = new();
        private static readonly ConcurrentQueue<Packet> PacketQueue = new();
        private static readonly List<Racer> Racers = new(Constants.NumMaxConnections);
        private static DateTime LastMetadataPacketsSentDate = DateTime.UtcNow;
        private static readonly byte[] PacketBuffer = new byte[Constants.NumMaxPacketBytes];
        private static readonly List<Racer> SortedRacers = new(Constants.NumMaxConnections);
        private static readonly byte[] DefaultMetadataBlock = [
            80, 108, 97, 121, 101, 114, 0,  // "Player" + null char
            255, 255, 255, 0,               // name_color (RGBA)
            18, 20, 66, 0,                  // outline_color (RGBA)
            60, 92, 153, 0,                 // body_color (RGBA)
            70, 108, 178, 0,                // shell_color (RGBA)
            183, 184, 229, 0                // eye_color (RGBA)
        ];

        private static async Task Main(string[] args) {
            Client.Client.Bind(new IPEndPoint(IPAddress.Any, args.Length > 0 && int.TryParse(args[0], out var port) ? port : Constants.DefaultPort));
            _ = Task.Run(ContinuouslyReceivePackets);
            await ContinuouslySendPacketsAsync();
        }

        private static void ContinuouslyReceivePackets() {
            while (true) {
                var endpoint = new IPEndPoint(IPAddress.Any, 0);
                var data = Client.Receive(ref endpoint);
                if (data.Length > Constants.MetadataOffset && data.Length <= Constants.NumMaxPacketBytes && PacketQueue.Count < Constants.MaxPacketQueueSize) {
                    PacketQueue.Enqueue(new(endpoint, data));
                }
            }
        }

        private static async Task ContinuouslySendPacketsAsync() {
            var timer = new PeriodicTimer(TimeSpan.FromSeconds(Constants.TickRateSeconds));
            while (await timer.WaitForNextTickAsync()) {
                ProcessPacketQueue();
                FilterRacers();
                if (Racers.Count == 0) {
                    Thread.Sleep(Constants.EmptyServerSleepMillis);
                    continue;
                }

                CalculateLeaderboardData();
                SendRegularPackets();
                if ((DateTime.UtcNow - LastMetadataPacketsSentDate).TotalSeconds > Constants.MetadataSendTimeoutSeconds) {
                    SendMetadataPackets();
                }
            }
        }

        private static void ProcessPacketQueue() {
            for (var numPacketsToProcess = PacketQueue.Count; numPacketsToProcess > 0; numPacketsToProcess--) {
                _ = PacketQueue.TryDequeue(out var packet);
                var racerExists = false;
                var racerSpan = CollectionsMarshal.AsSpan(Racers);
                for (var i = 0; i < racerSpan.Length; i++) {
                    var racer = racerSpan[i];
                    if (racer.Endpoint.Equals(packet!.Endpoint)) {
                        racerExists = true;
                        switch (packet.Data[0]) {
                            case Constants.RegularPacketType:
                                Buffer.BlockCopy(packet.Data, 1, racer.Data, 0, Constants.MetadataOffset);
                                break;
                            case Constants.MetadataPacketType:
                                Buffer.BlockCopy(packet.Data, 1, racer.Data, 0, packet.Data.Length - 1);
                                break;
                        }

                        racer.LastPacketReceivedDate = packet.ReveivedDate;
                        break;
                    }
                }

                if (racerExists || Racers.Count >= Constants.NumMaxConnections) {
                    continue;
                }

                var numDataBytes = packet!.Data.Length - 1;
                byte[] data;
                switch (packet.Data[0]) {
                    case Constants.RegularPacketType:
                        data = new byte[numDataBytes + DefaultMetadataBlock.Length];
                        packet.Data.AsSpan(1).CopyTo(data.AsSpan());
                        DefaultMetadataBlock.CopyTo(data.AsSpan(numDataBytes));
                        break;
                    case Constants.MetadataPacketType:
                        data = new byte[numDataBytes];
                        packet.Data.AsSpan(1).CopyTo(data.AsSpan());
                        break;
                    default:
                        return;
                }

                Racers.Add(new(packet!.Endpoint, data));
            }
        }

        private static void FilterRacers() {
            for (var i = Racers.Count - 1; i >= 0; i--) {
                if ((DateTime.UtcNow - Racers[i].LastPacketReceivedDate).TotalSeconds >= Constants.DisconnectTimeoutSeconds) {
                    Racers.RemoveAt(i);
                }
            }
        }

        private static void SendRegularPackets() {
            var racerSpan = CollectionsMarshal.AsSpan(Racers);
            PacketBuffer[0] = Constants.RegularPacketType;
            PacketBuffer[1] = (byte)(racerSpan.Length - 1);
            int offset;
            for (var i = 0; i < racerSpan.Length; i++) {
                var racer = racerSpan[i];
                offset = 2;
                for (var ii = 0; ii < racerSpan.Length; ii++) {
                    if (i == ii) {
                        continue;
                    }

                    var otherRacer = racerSpan[ii];
                    Buffer.BlockCopy(otherRacer.Data, 0, PacketBuffer, offset, Constants.CheckpointOffset);
                    offset += Constants.CheckpointOffset;
                    PacketBuffer[offset++] = otherRacer.GetFurthestCheckpoint();
                    PacketBuffer[offset++] = otherRacer.Placement;
                    Buffer.BlockCopy(otherRacer.DiffToFirst, 0, PacketBuffer, offset, sizeof(float));
                    offset += sizeof(float);
                }

                PacketBuffer[offset++] = racer.Placement;
                Buffer.BlockCopy(racer.DiffToFirst, 0, PacketBuffer, offset, sizeof(float));
                offset += sizeof(float);
                _ = Client.Send(PacketBuffer, offset, racer.Endpoint);
            }
        }

        private static void CalculateLeaderboardData() {
            SortedRacers.Clear();
            SortedRacers.AddRange(Racers);
            SortedRacers.Sort(CompareRacers);
            var racerSpan = CollectionsMarshal.AsSpan(SortedRacers);
            for (var i = 0; i < racerSpan.Length; i++) {
                var racer = racerSpan[i];
                var furthestCheckpoint = racer.GetFurthestCheckpoint();
                racer.Placement = (byte)i;
                var diffToFirst = (furthestCheckpoint == Constants.NumCheckpoints - 1) ? racer.GetCheckpointAt(Constants.NumCheckpoints - 1) : (racer.GetCheckpointAt(furthestCheckpoint) - racerSpan[0].GetCheckpointAt(furthestCheckpoint));
                BinaryPrimitives.WriteSingleLittleEndian(racer.DiffToFirst, diffToFirst);
            }
        }

        private static int CompareRacers(Racer a, Racer b) {
            var aFurthestCheckpoint = a.GetFurthestCheckpoint();
            var bFurthestCheckpoint = b.GetFurthestCheckpoint();
            return aFurthestCheckpoint == bFurthestCheckpoint
                ? a.GetCheckpointAt(aFurthestCheckpoint).CompareTo(b.GetCheckpointAt(bFurthestCheckpoint))
                : bFurthestCheckpoint.CompareTo(aFurthestCheckpoint);
        }

        private static void SendMetadataPackets() {
            var racerSpan = CollectionsMarshal.AsSpan(Racers);
            PacketBuffer[0] = Constants.MetadataPacketType;
            PacketBuffer[1] = (byte)(Racers.Count - 1);
            int offset;
            for (var i = 0; i < racerSpan.Length; i++) {
                var racer = racerSpan[i];
                offset = 2;
                for (var ii = 0; ii < racerSpan.Length; ii++) {
                    if (i == ii) {
                        continue;
                    }

                    var otherRacer = racerSpan[ii];
                    var count = otherRacer.Data.Length - Constants.MetadataOffset;
                    Buffer.BlockCopy(otherRacer.Data, Constants.MetadataOffset, PacketBuffer, offset, count);
                    offset += count;
                }

                _ = Client.Send(PacketBuffer, offset, racer.Endpoint);
            }

            LastMetadataPacketsSentDate = DateTime.UtcNow;
        }
    }
}
