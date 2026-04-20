namespace Server {
    using System;
    using System.Buffers.Binary;
    using System.Net;

    internal class Racer(IPEndPoint ipEndPoint) {
        internal readonly IPEndPoint IPEndPoint = ipEndPoint;
        internal readonly byte[] Data = new byte[Constants.NumMaxRacerDataBytes];
        internal int NumDataBytes;
        internal DateTime LastPacketReceivedDate = DateTime.UtcNow;

        internal void ProcessPacket(Packet packet) {
            switch (packet.Data[0]) {
                case Constants.RegularPacketType:
                    packet.Data.AsSpan(Constants.CurrentRoomPacketDataOffset).CopyTo(Data);
                    if (NumDataBytes == 0) {
                        Constants.DefaultMetaDataBytes.CopyTo(Data.AsSpan(Constants.NameRacerDataOffset));
                        NumDataBytes = Constants.NameRacerDataOffset + Constants.DefaultMetaDataBytes.Length;
                    }

                    break;
                case Constants.MetaDataPacketType:
                    packet.Data.AsSpan(Constants.CurrentRoomPacketDataOffset, Constants.NamePacketDataOffset - Constants.CurrentRoomPacketDataOffset).CopyTo(Data);
                    packet.Data.AsSpan(Constants.NamePacketDataOffset).CopyTo(Data.AsSpan(Constants.NameRacerDataOffset));
                    NumDataBytes =
                        packet.Data.Length -
                        Constants.CurrentRoomPacketDataOffset +
                        sizeof(byte) +  // placement
                        sizeof(float);  // diff_to_first
                    break;
            }

            LastPacketReceivedDate = packet.ReceivedDate;
        }

        internal float GetCheckpointTimeAt(int checkpointIndex) => BinaryPrimitives.ReadSingleLittleEndian(Data.AsSpan(Constants.CheckpointRacerDataOffset + checkpointIndex * sizeof(float)));

        internal byte GetFurthestCheckpoint() => Data[Constants.FurthestCheckpointRacerDataOffset];

        internal void SetPlacement(byte placement) => Data[Constants.PlacementRacerDataOffset] = placement;

        internal void SetDiffToFirst(float diffToFirst) => BinaryPrimitives.WriteSingleLittleEndian(Data.AsSpan(Constants.DiffToFirstRacerDataOffset), diffToFirst);
    }
}
