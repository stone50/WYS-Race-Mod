namespace Server {
    internal static class Constants {
        internal const int DefaultPort = 25565;
        internal const int NumMaxConnections = 16;

        internal const int Fps = 60;
        internal const double TickRateSeconds = 1d / (Fps + 2);
        internal const int EmptyServerSleepMillis = 3000;
        internal const int MaxPacketQueueSize = NumMaxConnections * Fps * EmptyServerSleepMillis / 1000;
        internal const int NumMaxPacketBytes = 1024;

        internal const double DisconnectTimeoutSeconds = 3d;
        internal const double MetadataSendTimeoutSeconds = 3d;

        internal const int NumCheckpoints = 91;
        internal const int CheckpointOffset =
            sizeof(ushort) +    // current_room
            sizeof(float) +     // x
            sizeof(float) +     // y
            sizeof(sbyte) +     // look_dir
            sizeof(float) +     // house_height
            sizeof(float) +     // house_tilt
            sizeof(float) +     // eye_1_x
            sizeof(float) +     // eye_1_y
            sizeof(float) +     // eye_2_x
            sizeof(float);      // eye_2_y
        internal const int FurthestCheckpointOffset = CheckpointOffset + NumCheckpoints * sizeof(float);
        internal const int MetadataOffset = FurthestCheckpointOffset + sizeof(byte);
        internal const int NumOutboundOpponentRegularPacketBytes = CheckpointOffset +
            sizeof(byte) +  // furthest_checkpoint
            sizeof(byte) +  // placement
            sizeof(float);  // diff_to_first
        internal const int NumOutboundOtherRegularPacketBytes =
            sizeof(byte) +  // packet_type
            sizeof(byte) +  // num_other_racers
            sizeof(byte) +  // placement
            sizeof(float);  // diff_to_first

        internal const byte RegularPacketType = 1;
        internal const byte MetadataPacketType = 2;
    }
}
