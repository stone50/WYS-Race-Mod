var num_other_racers = ds_list_size(other_racers);

for (var i = 0; i < num_other_racers; i++)
{
    var other_racer = ds_list_find_value(other_racers, i);
    
    if ((current_time - other_racer.latest_packet_time) > 3000)
    {
        ds_list_delete(other_racers, i);
        num_other_racers--;
        i--;
    }
}

var num_all_racers = num_other_racers + 1;
var all_racers = array_create(num_all_racers, 0);

for (var i = 0; i < num_other_racers; i++)
    all_racers[i] = ds_list_find_value(other_racers, i);

all_racers[num_other_racers] = this_racer;
array_sort(all_racers, function(arg0, arg1)
{
    if (arg0.furthest_checkpoint > arg1.furthest_checkpoint)
        return -1;
    else if (arg1.furthest_checkpoint > arg0.furthest_checkpoint)
        return 1;
    else
        return sign(arg0.checkpoints[arg0.furthest_checkpoint] - arg1.checkpoints[arg1.furthest_checkpoint]);
});
var first_racer_checkpoints = all_racers[0].checkpoints;

for (var i = 0; i < num_all_racers; i++)
{
    var racer = all_racers[i];
    racer.placement = i;
    var racer_furthest_checkpoint = racer.furthest_checkpoint;
    racer.diff_to_first = (racer_furthest_checkpoint == 90) ? racer.checkpoints[90] : (racer.checkpoints[racer_furthest_checkpoint] - first_racer_checkpoints[racer_furthest_checkpoint]);
}

for (var i = 0; i < num_other_racers; i++)
{
    var other_racer = ds_list_find_value(other_racers, i);
    buffer_seek(buffer, buffer_seek_start, 0);
    buffer_write(buffer, buffer_u8, 1);
    buffer_write(buffer, buffer_u8, num_other_racers);
    
    for (var ii = 0; ii < num_other_racers; ii++)
    {
        var other_other_racer = (i == ii) ? this_racer : ds_list_find_value(other_racers, ii);
        buffer_write(buffer, buffer_u16, other_other_racer.current_room);
        buffer_write(buffer, buffer_f32, other_other_racer.x);
        buffer_write(buffer, buffer_f32, other_other_racer.y);
        var flags = (real(other_other_racer.on_speedrunner_version) << 1) | real(other_other_racer.is_looking_right);
        buffer_write(buffer, buffer_u8, flags);
        buffer_write(buffer, buffer_f32, other_other_racer.house_height);
        buffer_write(buffer, buffer_f32, other_other_racer.house_tilt);
        buffer_write(buffer, buffer_f32, other_other_racer.eye_1_x);
        buffer_write(buffer, buffer_f32, other_other_racer.eye_1_y);
        buffer_write(buffer, buffer_f32, other_other_racer.eye_2_x);
        buffer_write(buffer, buffer_f32, other_other_racer.eye_2_y);
        buffer_write(buffer, buffer_u8, other_other_racer.furthest_checkpoint);
        buffer_write(buffer, buffer_u8, other_other_racer.placement);
        buffer_write(buffer, buffer_f32, other_other_racer.diff_to_first);
    }
    
    buffer_write(buffer, buffer_u8, other_racer.placement);
    buffer_write(buffer, buffer_f32, other_racer.diff_to_first);
    network_send_udp_raw(server, other_racer.ip, other_racer.port, buffer, buffer_tell(buffer));
}

if (send_metadata_cooldown >= 180)
{
    for (var i = 0; i < num_other_racers; i++)
    {
        var other_racer = ds_list_find_value(other_racers, i);
        buffer_seek(buffer, buffer_seek_start, 0);
        buffer_write(buffer, buffer_u8, 2);
        buffer_write(buffer, buffer_u8, num_other_racers);
        
        for (var ii = 0; ii < num_other_racers; ii++)
        {
            var other_other_racer = (i == ii) ? this_racer : ds_list_find_value(other_racers, ii);
            buffer_write(buffer, buffer_string, other_other_racer.name);
            buffer_write(buffer, buffer_u32, other_other_racer.name_color);
            buffer_write(buffer, buffer_u32, other_other_racer.outline_color);
            buffer_write(buffer, buffer_u32, other_other_racer.body_color);
            buffer_write(buffer, buffer_u32, other_other_racer.shell_color);
            buffer_write(buffer, buffer_u32, other_other_racer.eye_color);
        }
        
        network_send_udp_raw(server, other_racer.ip, other_racer.port, buffer, buffer_tell(buffer));
    }
    
    send_metadata_cooldown = 0;
}
