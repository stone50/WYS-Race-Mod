if (room != menu)
{
    var player = instance_find(obj_player);
    this_racer.current_room = room;
    this_racer.x = (player == -4) ? -infinity : player.x;
    this_racer.y = (player == -4) ? -infinity : player.y;
    this_racer.is_looking_right = player == -4 || player.lookdir == 1;
    this_racer.gun = (player == -4) ? 0 : player.gun_equipped;
    this_racer.house_height = (player == -4) ? 1 : player.house_height;
    this_racer.house_tilt = (player == -4) ? 0 : player.house_tilt;
    this_racer.eye_1_x = (player == -4) ? -infinity : player.eye1.x;
    this_racer.eye_1_y = (player == -4) ? -infinity : player.eye1.y;
    this_racer.eye_2_x = (player == -4) ? -infinity : player.eye2.x;
    this_racer.eye_2_y = (player == -4) ? -infinity : player.eye2.y;
}

if (!is_connected)
    exit;

send_metadata_cooldown++;

if (is_host)
    event_user(0);
else
    event_user(1);
