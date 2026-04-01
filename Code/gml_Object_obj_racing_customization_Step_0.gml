if (!visible)
    exit;

var gui_mouse_x = device_mouse_x_to_gui(0);
var gui_mouse_y = device_mouse_y_to_gui(0);

if (device_mouse_check_button(0, mb_left))
{
    if (gui_mouse_x >= 30 && gui_mouse_x <= 210)
    {
        if (gui_mouse_y >= 221.25 && gui_mouse_y <= 251.25)
            leaderboard_background_alpha = clamp((gui_mouse_x - 50) / 140, 0, 1);
        
        if (gui_mouse_y >= 356.25 && gui_mouse_y <= 386.25)
            leaderboard_text_alpha = clamp((gui_mouse_x - 50) / 140, 0, 1);
        
        if (gui_mouse_y >= 491.25 && gui_mouse_y <= 521.25)
            leaderboard_scale = clamp((gui_mouse_x - 50) / 140, 0, 1);
    }
    else if (gui_mouse_x >= 270 && gui_mouse_x <= 450)
    {
        if (gui_mouse_y >= 221.25 && gui_mouse_y <= 251.25)
            other_racers_alpha = clamp((gui_mouse_x - 290) / 140, 0, 1);
        
        if (gui_mouse_y >= 356.25 && gui_mouse_y <= 386.25)
            other_racer_names_alpha = clamp((gui_mouse_x - 290) / 140, 0, 1);
        
        if (gui_mouse_y >= 491.25 && gui_mouse_y <= 521.25)
            other_racer_names_scale = clamp((gui_mouse_x - 290) / 140, 0, 1);
    }
}

if (!device_mouse_check_button_released(0, mb_left))
    exit;

if (gui_mouse_y >= 152.5 && gui_mouse_y <= 252.5 && gui_mouse_x >= 500 && gui_mouse_x <= 700)
{
    var raw_name = get_string("Name (max 10 characters)", network_manager.this_racer.name);
    var filtered_name = "";
    
    for (var i = 1; i <= string_length(raw_name); i++)
    {
        var char = string_char_at(raw_name, i);
        var code = ord(char);
        
        if (code >= 32 && code <= 126)
            filtered_name += char;
    }
    
    filtered_name = string_trim_start(filtered_name);
    
    if (string_length(filtered_name) > 10)
        filtered_name = string_copy(filtered_name, 1, 10);
    
    filtered_name = string_trim_end(filtered_name);
    
    if (filtered_name == "")
        filtered_name = "Player";
    
    network_manager.this_racer.name = filtered_name;
}
else if (gui_mouse_y >= 198.25 && gui_mouse_y <= 234.25)
{
    if (gui_mouse_x >= 762 && gui_mouse_x <= 798)
        network_manager.this_racer.name_color = 16777215;
    
    if (gui_mouse_x >= 802 && gui_mouse_x <= 838)
        network_manager.this_racer.name_color = 255;
    
    if (gui_mouse_x >= 842 && gui_mouse_x <= 878)
        network_manager.this_racer.name_color = 16711935;
    
    if (gui_mouse_x >= 882 && gui_mouse_x <= 918)
        network_manager.this_racer.name_color = 16776960;
}
else if (gui_mouse_y >= 238.25 && gui_mouse_y <= 274.25)
{
    if (gui_mouse_x >= 762 && gui_mouse_x <= 798)
        network_manager.this_racer.name_color = 65280;
    
    if (gui_mouse_x >= 802 && gui_mouse_x <= 838)
        network_manager.this_racer.name_color = 65535;
    
    if (gui_mouse_x >= 842 && gui_mouse_x <= 878)
        network_manager.this_racer.name_color = 16777215;
}
else if (gui_mouse_y >= 333.25 && gui_mouse_y <= 369.25)
{
    if (gui_mouse_x >= 522 && gui_mouse_x <= 558)
    {
        network_manager.this_racer.outline_color = make_color_rgb(18, 20, 66);
        event_user(0);
    }
    
    if (gui_mouse_x >= 562 && gui_mouse_x <= 598)
    {
        network_manager.this_racer.outline_color = 255;
        event_user(0);
    }
    
    if (gui_mouse_x >= 602 && gui_mouse_x <= 638)
    {
        network_manager.this_racer.outline_color = 16711935;
        event_user(0);
    }
    
    if (gui_mouse_x >= 642 && gui_mouse_x <= 678)
    {
        network_manager.this_racer.outline_color = 16776960;
        event_user(0);
    }
    
    if (gui_mouse_x >= 762 && gui_mouse_x <= 798)
    {
        network_manager.this_racer.body_color = make_color_rgb(60, 92, 153);
        event_user(0);
    }
    
    if (gui_mouse_x >= 802 && gui_mouse_x <= 838)
    {
        network_manager.this_racer.body_color = 255;
        event_user(0);
    }
    
    if (gui_mouse_x >= 842 && gui_mouse_x <= 878)
    {
        network_manager.this_racer.body_color = 16711935;
        event_user(0);
    }
    
    if (gui_mouse_x >= 882 && gui_mouse_x <= 918)
    {
        network_manager.this_racer.body_color = 16776960;
        event_user(0);
    }
}
else if (gui_mouse_y >= 373.25 && gui_mouse_y <= 409.25)
{
    if (gui_mouse_x >= 522 && gui_mouse_x <= 558)
    {
        network_manager.this_racer.outline_color = 65280;
        event_user(0);
    }
    
    if (gui_mouse_x >= 562 && gui_mouse_x <= 598)
    {
        network_manager.this_racer.outline_color = 65535;
        event_user(0);
    }
    
    if (gui_mouse_x >= 602 && gui_mouse_x <= 638)
    {
        network_manager.this_racer.outline_color = 16777215;
        event_user(0);
    }
    
    if (gui_mouse_x >= 762 && gui_mouse_x <= 798)
    {
        network_manager.this_racer.body_color = 65280;
        event_user(0);
    }
    
    if (gui_mouse_x >= 802 && gui_mouse_x <= 838)
    {
        network_manager.this_racer.body_color = 65535;
        event_user(0);
    }
    
    if (gui_mouse_x >= 842 && gui_mouse_x <= 878)
    {
        network_manager.this_racer.body_color = 16777215;
        event_user(0);
    }
}
else if (gui_mouse_y >= 468.25 && gui_mouse_y <= 504.25)
{
    if (gui_mouse_x >= 522 && gui_mouse_x <= 558)
    {
        network_manager.this_racer.shell_color = make_color_rgb(70, 108, 178);
        event_user(0);
    }
    
    if (gui_mouse_x >= 562 && gui_mouse_x <= 598)
    {
        network_manager.this_racer.shell_color = 255;
        event_user(0);
    }
    
    if (gui_mouse_x >= 602 && gui_mouse_x <= 638)
    {
        network_manager.this_racer.shell_color = 16711935;
        event_user(0);
    }
    
    if (gui_mouse_x >= 642 && gui_mouse_x <= 678)
    {
        network_manager.this_racer.shell_color = 16776960;
        event_user(0);
    }
    
    if (gui_mouse_x >= 762 && gui_mouse_x <= 798)
    {
        network_manager.this_racer.eye_color = make_color_rgb(183, 184, 229);
        event_user(0);
    }
    
    if (gui_mouse_x >= 802 && gui_mouse_x <= 838)
    {
        network_manager.this_racer.eye_color = 255;
        event_user(0);
    }
    
    if (gui_mouse_x >= 842 && gui_mouse_x <= 878)
    {
        network_manager.this_racer.eye_color = 16711935;
        event_user(0);
    }
    
    if (gui_mouse_x >= 882 && gui_mouse_x <= 918)
    {
        network_manager.this_racer.eye_color = 16776960;
        event_user(0);
    }
}
else if (gui_mouse_y >= 508.25 && gui_mouse_y <= 544.25)
{
    if (gui_mouse_x >= 522 && gui_mouse_x <= 558)
    {
        network_manager.this_racer.shell_color = 65280;
        event_user(0);
    }
    
    if (gui_mouse_x >= 562 && gui_mouse_x <= 598)
    {
        network_manager.this_racer.shell_color = 65535;
        event_user(0);
    }
    
    if (gui_mouse_x >= 602 && gui_mouse_x <= 638)
    {
        network_manager.this_racer.shell_color = 16777215;
        event_user(0);
    }
    
    if (gui_mouse_x >= 762 && gui_mouse_x <= 798)
    {
        network_manager.this_racer.eye_color = 65280;
        event_user(0);
    }
    
    if (gui_mouse_x >= 802 && gui_mouse_x <= 838)
    {
        network_manager.this_racer.eye_color = 65535;
        event_user(0);
    }
    
    if (gui_mouse_x >= 842 && gui_mouse_x <= 878)
    {
        network_manager.this_racer.eye_color = 16777215;
        event_user(0);
    }
}
