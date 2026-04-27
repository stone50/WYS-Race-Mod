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
    var name = get_string("Name (max 20 characters)", this_racer.name);
    name = scr_filter_unsupported_ords(name);
    name = scr_string_trim_start(name);
    
    if (string_length(name) > 20)
        name = string_copy(name, 1, 20);
    
    name = scr_string_trim_end(name);
    
    if (name != "")
        this_racer.name = name;
}
else if (gui_mouse_y >= 198.25 && gui_mouse_y <= 234.25)
{
    if (gui_mouse_x >= 762 && gui_mouse_x <= 798)
        this_racer.name_color = name_colors[0];
    
    if (gui_mouse_x >= 802 && gui_mouse_x <= 838)
        this_racer.name_color = name_colors[1];
    
    if (gui_mouse_x >= 842 && gui_mouse_x <= 878)
        this_racer.name_color = name_colors[2];
    
    if (gui_mouse_x >= 882 && gui_mouse_x <= 918)
        this_racer.name_color = name_colors[3];
}
else if (gui_mouse_y >= 238.25 && gui_mouse_y <= 274.25)
{
    if (gui_mouse_x >= 762 && gui_mouse_x <= 798)
        this_racer.name_color = name_colors[4];
    
    if (gui_mouse_x >= 802 && gui_mouse_x <= 838)
        this_racer.name_color = name_colors[5];
    
    if (gui_mouse_x >= 842 && gui_mouse_x <= 878)
        this_racer.name_color = name_colors[6];
    
    if (gui_mouse_x >= 882 && gui_mouse_x <= 918)
        this_racer.name_color = name_colors[7];
}
else if (gui_mouse_y >= 333.25 && gui_mouse_y <= 369.25)
{
    if (gui_mouse_x >= 522 && gui_mouse_x <= 558)
        this_racer.outline_color = outline_colors[0];
    
    if (gui_mouse_x >= 562 && gui_mouse_x <= 598)
        this_racer.outline_color = outline_colors[1];
    
    if (gui_mouse_x >= 602 && gui_mouse_x <= 638)
        this_racer.outline_color = outline_colors[2];
    
    if (gui_mouse_x >= 642 && gui_mouse_x <= 678)
        this_racer.outline_color = outline_colors[3];
    
    if (gui_mouse_x >= 762 && gui_mouse_x <= 798)
        this_racer.body_color = body_colors[0];
    
    if (gui_mouse_x >= 802 && gui_mouse_x <= 838)
        this_racer.body_color = body_colors[1];
    
    if (gui_mouse_x >= 842 && gui_mouse_x <= 878)
        this_racer.body_color = body_colors[2];
    
    if (gui_mouse_x >= 882 && gui_mouse_x <= 918)
        this_racer.body_color = body_colors[3];
}
else if (gui_mouse_y >= 373.25 && gui_mouse_y <= 409.25)
{
    if (gui_mouse_x >= 522 && gui_mouse_x <= 558)
        this_racer.outline_color = outline_colors[4];
    
    if (gui_mouse_x >= 562 && gui_mouse_x <= 598)
        this_racer.outline_color = outline_colors[5];
    
    if (gui_mouse_x >= 602 && gui_mouse_x <= 638)
        this_racer.outline_color = outline_colors[6];
    
    if (gui_mouse_x >= 642 && gui_mouse_x <= 678)
        this_racer.outline_color = outline_colors[7];
    
    if (gui_mouse_x >= 762 && gui_mouse_x <= 798)
        this_racer.body_color = body_colors[4];
    
    if (gui_mouse_x >= 802 && gui_mouse_x <= 838)
        this_racer.body_color = body_colors[5];
    
    if (gui_mouse_x >= 842 && gui_mouse_x <= 878)
        this_racer.body_color = body_colors[6];
    
    if (gui_mouse_x >= 882 && gui_mouse_x <= 918)
        this_racer.body_color = body_colors[7];
}
else if (gui_mouse_y >= 468.25 && gui_mouse_y <= 504.25)
{
    if (gui_mouse_x >= 522 && gui_mouse_x <= 558)
        this_racer.shell_color = shell_colors[0];
    
    if (gui_mouse_x >= 562 && gui_mouse_x <= 598)
        this_racer.shell_color = shell_colors[1];
    
    if (gui_mouse_x >= 602 && gui_mouse_x <= 638)
        this_racer.shell_color = shell_colors[2];
    
    if (gui_mouse_x >= 642 && gui_mouse_x <= 678)
        this_racer.shell_color = shell_colors[3];
    
    if (gui_mouse_x >= 762 && gui_mouse_x <= 798)
        this_racer.eye_color = eye_colors[0];
    
    if (gui_mouse_x >= 802 && gui_mouse_x <= 838)
        this_racer.eye_color = eye_colors[1];
    
    if (gui_mouse_x >= 842 && gui_mouse_x <= 878)
        this_racer.eye_color = eye_colors[2];
    
    if (gui_mouse_x >= 882 && gui_mouse_x <= 918)
        this_racer.eye_color = eye_colors[3];
}
else if (gui_mouse_y >= 508.25 && gui_mouse_y <= 544.25)
{
    if (gui_mouse_x >= 522 && gui_mouse_x <= 558)
        this_racer.shell_color = shell_colors[4];
    
    if (gui_mouse_x >= 562 && gui_mouse_x <= 598)
        this_racer.shell_color = shell_colors[5];
    
    if (gui_mouse_x >= 602 && gui_mouse_x <= 638)
        this_racer.shell_color = shell_colors[6];
    
    if (gui_mouse_x >= 642 && gui_mouse_x <= 678)
        this_racer.shell_color = shell_colors[7];
    
    if (gui_mouse_x >= 762 && gui_mouse_x <= 798)
        this_racer.eye_color = eye_colors[4];
    
    if (gui_mouse_x >= 802 && gui_mouse_x <= 838)
        this_racer.eye_color = eye_colors[5];
    
    if (gui_mouse_x >= 842 && gui_mouse_x <= 878)
        this_racer.eye_color = eye_colors[6];
    
    if (gui_mouse_x >= 882 && gui_mouse_x <= 918)
        this_racer.eye_color = eye_colors[7];
}
