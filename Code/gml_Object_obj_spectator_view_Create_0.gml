visible = false;
scale = 1;
x_offset = 0;
y_offset = 0;
prev_gui_mouse_x = device_mouse_x_to_gui(0);
prev_gui_mouse_y = device_mouse_y_to_gui(0);

function draw_level(arg0, arg1, arg2)
{
    var level_offset = scr_get_level_offset(arg2);
    var total_level_x_offset = x_offset + level_offset[0];
    var total_level_y_offset = y_offset + level_offset[1];
    var num_slices = array_length(arg0);
    draw_set_valign(fa_top);
    
    for (var i = 0; i < num_slices; i++)
    {
        var grid_offset = arg1[i];
        var level_x = (((total_level_x_offset + (2048 * grid_offset[0])) - 960) * scale) + 960;
        var level_y = (((total_level_y_offset + (2048 * grid_offset[1])) - 540) * scale) + 540;
        draw_sprite_ext(arg0[i], 0, level_x, level_y, scale, scale, 0, c_white, 1);
        
        if (i == 0)
        {
            var level_name = ds_list_find_value(global.li_lvldat_name, arg2);
            draw_set_color(c_black);
            draw_text_transformed(level_x + (3 * scale), level_y + (3 * scale), level_name, scale, scale, 0);
            draw_set_color(c_fuchsia);
            draw_text_transformed(level_x, level_y, level_name, scale, scale, 0);
        }
    }
}
