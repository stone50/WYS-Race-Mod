if ((current_time - latest_packet_time) > 3000)
{
    var num_other_racers = ds_list_size(other_racers);
    ds_list_clear(other_racers);
    this_racer.placement = 0;
    this_racer.diff_to_first = 0;
}

var should_send_metadata = send_metadata_cooldown >= 180;
buffer_seek(buffer, buffer_seek_start, 0);
buffer_write(buffer, buffer_u8, should_send_metadata ? 2 : 1);
buffer_write(buffer, buffer_u16, this_racer.current_room);
buffer_write(buffer, buffer_f32, this_racer.x);
buffer_write(buffer, buffer_f32, this_racer.y);
var flags = (real(this_racer.on_speedrunner_version) << 1) | real(this_racer.is_looking_right);
buffer_write(buffer, buffer_u8, flags);
buffer_write(buffer, buffer_f32, this_racer.house_height);
buffer_write(buffer, buffer_f32, this_racer.house_tilt);
buffer_write(buffer, buffer_f32, this_racer.eye_1_x);
buffer_write(buffer, buffer_f32, this_racer.eye_1_y);
buffer_write(buffer, buffer_f32, this_racer.eye_2_x);
buffer_write(buffer, buffer_f32, this_racer.eye_2_y);

for (var i = 0; i < 91; i++)
    buffer_write(buffer, buffer_f32, this_racer.checkpoints[i]);

buffer_write(buffer, buffer_u8, this_racer.furthest_checkpoint);

if (should_send_metadata)
{
    buffer_write(buffer, buffer_string, this_racer.name);
    buffer_write(buffer, buffer_u32, this_racer.name_color);
    buffer_write(buffer, buffer_u32, this_racer.outline_color);
    buffer_write(buffer, buffer_u32, this_racer.body_color);
    buffer_write(buffer, buffer_u32, this_racer.shell_color);
    buffer_write(buffer, buffer_u32, this_racer.eye_color);
    send_metadata_cooldown = 0;
}

network_send_udp_raw(server, host_ip, host_port, buffer, buffer_tell(buffer));
