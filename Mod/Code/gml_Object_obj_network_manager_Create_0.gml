visible = false;
persistent = true;
is_connected = false;
is_host = false;
host_ip = "127.0.0.1";
host_port = 25565;
connection_string = host_ip + ":" + string(host_port);
server = -1;
buffer = buffer_create(1024, buffer_fixed, 1);
latest_packet_time = 0;
send_metadata_cooldown = 0;
other_racers = ds_list_create();
this_racer = 
{
    current_room: room,
    x: -9999,
    y: -9999,
    on_speedrunner_version: scr_get_is_speedrunner_version(),
    is_looking_right: true,
    house_height: 1,
    house_tilt: 0,
    eye_1_x: -9999,
    eye_1_y: -9999,
    eye_2_x: -9999,
    eye_2_y: -9999,
    checkpoints: array_create(91, 0),
    furthest_checkpoint: 0,
    placement: 0,
    diff_to_first: 0,
    name: "Player",
    name_color: 16777215,
    outline_color: make_color_rgb(18, 20, 66),
    body_color: make_color_rgb(60, 92, 153),
    shell_color: make_color_rgb(70, 108, 178),
    eye_color: make_color_rgb(183, 184, 229)
};
