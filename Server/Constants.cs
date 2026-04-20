namespace Server {
    internal static class Constants {
        internal const int DefaultPort = 25565;
        internal const int NumMaxRacers = 16;
        internal const double RegularDataTickRateSeconds = 1d / 62d; // 1/fps
        internal const double MetaDataTickRateSeconds = 3d;
        internal const int NumMaxPackets = NumMaxRacers * 2;
        internal const double DisconnectTimeoutSeconds = 3d;
        internal const int EmptyServerSleepMillis = 3000;

        internal const int NumCheckpoints = 91;
        internal const int NumCheckpointBytes = NumCheckpoints * sizeof(float);
        internal const int NumMaxNameChars = 21; // 20 chars + null char

        internal const int CheckpointRacerDataOffset =
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
        internal const int FurthestCheckpointRacerDataOffset =
            CheckpointRacerDataOffset +
            NumCheckpointBytes;
        internal const int PlacementRacerDataOffset =
            FurthestCheckpointRacerDataOffset +
            sizeof(byte);   // furthest_checkpoint
        internal const int DiffToFirstRacerDataOffset =
            PlacementRacerDataOffset +
            sizeof(byte);   // placement
        internal const int NameRacerDataOffset =
            DiffToFirstRacerDataOffset +
            sizeof(float);  // diff_to_first

        internal const int CurrentRoomPacketDataOffset =
            sizeof(byte);   // packet_type
        internal const int NamePacketDataOffset =
            sizeof(byte) +      // packet_type
            PlacementRacerDataOffset;

        internal const int NumMaxRacerDataBytes =
            NameRacerDataOffset +
            NumMaxNameChars +
            sizeof(uint) +  // name_color
            sizeof(uint) +  // outline_color
            sizeof(uint) +  // body_color
            sizeof(uint) +  // shell_color
            sizeof(uint);   // eye_color
        internal const int NumPastCheckpointsRacerOutboundPacketDataBytes =
            sizeof(byte) +  // furthest_checkpoint
            sizeof(byte) +  // placement
            sizeof(float);  // diff_to_first
        internal const int NumMaxRacerOutboundPacketDataBytes =
            sizeof(byte) +  // packet_type
            sizeof(byte) +  // num_other_racers
            (
                CheckpointRacerDataOffset +
                NumPastCheckpointsRacerOutboundPacketDataBytes
            ) * NumMaxRacers +
            sizeof(byte) +  // placement
            sizeof(float);  // diff_to_first
        internal const int NumMaxPacketDataBytes =
            NamePacketDataOffset +
            NumMaxNameChars +
            sizeof(uint) +  // name_color
            sizeof(uint) +  // outline_color
            sizeof(uint) +  // body_color
            sizeof(uint) +  // shell_color
            sizeof(uint);   // eye_color
        internal const int NumMinPacketDataBytes =
            NamePacketDataOffset;
        internal const byte RegularPacketType = 1;
        internal const byte MetaDataPacketType = 2;

        internal static readonly byte[] DefaultMetaDataBytes = [
            80, 108, 97, 121, 101, 114, 0,  // "Player" + null char
            255, 255, 255, 0,               // name_color (RGBA)
            18, 20, 66, 0,                  // outline_color (RGBA)
            60, 92, 153, 0,                 // body_color (RGBA)
            70, 108, 178, 0,                // shell_color (RGBA)
            183, 184, 229, 0                // eye_color (RGBA)
        ];
    }
}
