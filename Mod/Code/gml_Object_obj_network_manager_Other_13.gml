var data_buffer = ds_map_find_value(async_load, "buffer");
buffer_seek(data_buffer, buffer_seek_start, 0);
var packet_type = buffer_read(data_buffer, buffer_u8);
var num_other_racers = buffer_read(data_buffer, buffer_u8);

while (ds_list_size(other_racers) > num_other_racers)
    ds_list_delete(other_racers, ds_list_size(other_racers) - 1);

while (ds_list_size(other_racers) < num_other_racers)
{
    ds_list_add(other_racers, 
    {
        current_room: -1,
        x: -9999,
        y: -9999,
        look_dir: 1,
        house_height: 1,
        house_tilt: 0,
        eye_1_x: -9999,
        eye_1_y: -9999,
        eye_2_x: -9999,
        eye_2_y: -9999,
        furthest_checkpoint: 0,
        placement: 0,
        diff_to_first: 0,
        name: "Player",
        name_color: 16777215,
        outline_color: make_color_rgb(18, 20, 66),
        body_color: make_color_rgb(60, 92, 153),
        shell_color: make_color_rgb(70, 108, 178),
        eye_color: make_color_rgb(183, 184, 229)
    });
}

switch (packet_type)
{
    case 1:
        for (var i = 0; i < num_other_racers; i++)
        {
            var other_racer = ds_list_find_value(other_racers, i);
            other_racer.current_room = buffer_read(data_buffer, buffer_u16);
            other_racer.x = buffer_read(data_buffer, buffer_f32);
            other_racer.y = buffer_read(data_buffer, buffer_f32);
            other_racer.look_dir = buffer_read(data_buffer, buffer_s8);
            other_racer.house_height = buffer_read(data_buffer, buffer_f32);
            other_racer.house_tilt = buffer_read(data_buffer, buffer_f32);
            other_racer.eye_1_x = buffer_read(data_buffer, buffer_f32);
            other_racer.eye_1_y = buffer_read(data_buffer, buffer_f32);
            other_racer.eye_2_x = buffer_read(data_buffer, buffer_f32);
            other_racer.eye_2_y = buffer_read(data_buffer, buffer_f32);
            other_racer.furthest_checkpoint = buffer_read(data_buffer, buffer_u8);
            other_racer.placement = buffer_read(data_buffer, buffer_u8);
            other_racer.diff_to_first = buffer_read(data_buffer, buffer_f32);
        }
        
        this_racer.placement = buffer_read(data_buffer, buffer_u8);
        this_racer.diff_to_first = buffer_read(data_buffer, buffer_f32);
        break;
    
    case 2:
        for (var i = 0; i < num_other_racers; i++)
        {
            var other_racer = ds_list_find_value(other_racers, i);
            other_racer.name = buffer_read(data_buffer, buffer_string);
            other_racer.name_color = buffer_read(data_buffer, buffer_u32);
            other_racer.outline_color = buffer_read(data_buffer, buffer_u32);
            other_racer.body_color = buffer_read(data_buffer, buffer_u32);
            other_racer.shell_color = buffer_read(data_buffer, buffer_u32);
            other_racer.eye_color = buffer_read(data_buffer, buffer_u32);
        }
        
        break;
}
