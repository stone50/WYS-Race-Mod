function scr_get_is_speedrunner_version()
{
    static on_speedrunner_version = main_menu_backup == 0;
    
    return on_speedrunner_version;
}

function scr_get_mapped_room(arg0, arg1)
{
    static room_id_map = [159, 39, 70, 116, 165, 87, 24, 162, 40, 138, 37, 132, 18, 10, 163, 136, 164, 128, 135, 86, 38, 57, 8, 161, 0, 1, 2, 3, 4, 5, 6, 7, 9, 11, 12, 13, 14, 15, 16, 17, 20, 21, 22, 160, 23, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 41, 42, 43, 44, 45, 19, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 115, 84, 85, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 129, 130, 131, 133, 134, 137, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158];
    
    var on_speedrunner_version = scr_get_is_speedrunner_version();
    
    if (arg1 == on_speedrunner_version)
        return arg0;
    
    if (arg1)
        return room_id_map[arg0];
    
    for (var i = 0; i < 166; i++)
    {
        if (room_id_map[i] == arg0)
            return i;
    }
    
    return -1;
}
