if (!visible)
    exit;

var gui_mouse_x = device_mouse_x_to_gui(0);
var gui_mouse_y = device_mouse_y_to_gui(0);

if (device_mouse_check_button(0, mb_left))
{
    if (gui_mouse_x >= 15 && gui_mouse_x <= 305)
    {
        if (gui_mouse_y >= 180 && gui_mouse_y <= 240)
            leaderboard_background_alpha = clamp((gui_mouse_x - 35) / 250, 0, 1);
        
        if (gui_mouse_y >= 300 && gui_mouse_y <= 360)
            leaderboard_text_alpha = clamp((gui_mouse_x - 35) / 250, 0, 1);
        
        if (gui_mouse_y >= 420 && gui_mouse_y <= 480)
            leaderboard_scale = clamp((gui_mouse_x - 35) / 250, 0, 1);
    }
    else if (gui_mouse_x >= 335 && gui_mouse_x <= 625)
    {
        if (gui_mouse_y >= 180 && gui_mouse_y <= 240)
            other_racers_alpha = clamp((gui_mouse_x - 355) / 250, 0, 1);
        
        if (gui_mouse_y >= 300 && gui_mouse_y <= 360)
            other_racer_names_alpha = clamp((gui_mouse_x - 355) / 250, 0, 1);
        
        if (gui_mouse_y >= 420 && gui_mouse_y <= 480)
            other_racer_names_scale = clamp((gui_mouse_x - 355) / 250, 0, 1);
    }
}

if (!device_mouse_check_button_released(0, mb_left))
    exit;

if (gui_mouse_x >= 300 && gui_mouse_x <= 500 && gui_mouse_y >= 560 && gui_mouse_y <= 620)
{
    var name = get_string("Name (max 20 characters)", this_racer.name);
    name = scr_filter_unsupported_ords(name);
    name = scr_string_trim_start(name);
    
    if (string_length(name) > 20)
        name = string_copy(name, 1, 20);
    
    name = scr_string_trim_end(name);
    
    if (name != "")
        this_racer.name = name;
}
