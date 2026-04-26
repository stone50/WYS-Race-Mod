var data_buffer = ds_map_find_value(async_load, "buffer");
var other_racer_ip = string(ds_map_find_value(async_load, "ip"));
var other_racer_port = ds_map_find_value(async_load, "port");
var num_other_racers = ds_list_size(other_racers);
var other_racer = -4;

for (var i = 0; i < num_other_racers; i++)
{
    var searching_other_racer = ds_list_find_value(other_racers, i);
    
    if (searching_other_racer.ip == other_racer_ip && searching_other_racer.port == other_racer_port)
    {
        other_racer = searching_other_racer;
        break;
    }
}

if (other_racer == -4)
{
    other_racer = 
    {
        checkpoints: array_create(91, 0),
        placement: 0,
        diff_to_first: 0,
        name: "Player",
        name_color: 16777215,
        outline_color: make_color_rgb(18, 20, 66),
        body_color: make_color_rgb(60, 92, 153),
        shell_color: make_color_rgb(70, 108, 178),
        eye_color: make_color_rgb(183, 184, 229),
        ip: other_racer_ip,
        port: other_racer_port
    };
    ds_list_add(other_racers, other_racer);
    num_other_racers++;
}

other_racer.latest_packet_time = current_time;
buffer_seek(data_buffer, buffer_seek_start, 0);
var packet_type = buffer_read(data_buffer, buffer_u8);
other_racer.current_room = buffer_read(data_buffer, buffer_u16);
other_racer.x = buffer_read(data_buffer, buffer_f32);
other_racer.y = buffer_read(data_buffer, buffer_f32);
var flags = buffer_read(data_buffer, buffer_u8);
other_racer.is_looking_right = (flags & 1) != 0;
other_racer.on_speedrunner_version = (flags & 2) != 0;
other_racer.house_height = buffer_read(data_buffer, buffer_f32);
other_racer.house_tilt = buffer_read(data_buffer, buffer_f32);
other_racer.eye_1_x = buffer_read(data_buffer, buffer_f32);
other_racer.eye_1_y = buffer_read(data_buffer, buffer_f32);
other_racer.eye_2_x = buffer_read(data_buffer, buffer_f32);
other_racer.eye_2_y = buffer_read(data_buffer, buffer_f32);

for (var i = 0; i < 91; i++)
    other_racer.checkpoints[i] = buffer_read(data_buffer, buffer_f32);

other_racer.furthest_checkpoint = buffer_read(data_buffer, buffer_u8);

if (packet_type == 2)
{
    other_racer.name = buffer_read(data_buffer, buffer_string);
    other_racer.name_color = buffer_read(data_buffer, buffer_u32);
    other_racer.outline_color = buffer_read(data_buffer, buffer_u32);
    other_racer.body_color = buffer_read(data_buffer, buffer_u32);
    other_racer.shell_color = buffer_read(data_buffer, buffer_u32);
    other_racer.eye_color = buffer_read(data_buffer, buffer_u32);
}
