namespace Server {
    using System;
    using System.Net;

    internal class Packet(IPEndPoint ipEndPoint, byte[] data) {
        internal readonly IPEndPoint IPEndPoint = ipEndPoint;
        internal readonly byte[] Data = data;
        internal readonly DateTime ReceivedDate = DateTime.UtcNow;
    }
}
