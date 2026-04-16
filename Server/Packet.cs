namespace Server {
    using System;
    using System.Net;

    internal class Packet(IPEndPoint endpoint, byte[] data) {
        internal readonly IPEndPoint Endpoint = endpoint;
        internal readonly byte[] Data = data;
        internal readonly DateTime ReveivedDate = DateTime.UtcNow;
    }
}
