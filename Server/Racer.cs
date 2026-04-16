namespace Server {
    using System;
    using System.Buffers.Binary;
    using System.Net;

    internal class Racer(IPEndPoint endpoint, byte[] data) {
        internal readonly IPEndPoint Endpoint = endpoint;
        internal byte[] Data = data;
        public byte Placement;
        public byte[] DiffToFirst = new byte[sizeof(float)];
        internal DateTime LastPacketReceivedDate = DateTime.UtcNow;

        internal float GetCheckpointAt(int index) => BinaryPrimitives.ReadSingleLittleEndian(Data.AsSpan(Constants.CheckpointOffset + index * sizeof(float), sizeof(float)));

        internal byte GetFurthestCheckpoint() => Data[Constants.FurthestCheckpointOffset];
    }
}
