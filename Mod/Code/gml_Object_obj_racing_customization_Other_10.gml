if (!visible)
    exit;

var gui_mouse_x = device_mouse_x_to_gui(0);
var gui_mouse_y = device_mouse_y_to_gui(0);

if (device_mouse_check_button(0, mb_left))
{
    if (gui_mouse_x >= 15 && gui_mouse_x <= 305)
    {
        if (gui_mouse_y >= 180 && gui_mouse_y <= 240)
        {
            leaderboard_background_alpha = clamp((gui_mouse_x - 35) / 250, 0, 1);
            exit;
        }
        
        if (gui_mouse_y >= 300 && gui_mouse_y <= 360)
        {
            leaderboard_text_alpha = clamp((gui_mouse_x - 35) / 250, 0, 1);
            exit;
        }
        
        if (gui_mouse_y >= 420 && gui_mouse_y <= 480)
        {
            leaderboard_scale = clamp((gui_mouse_x - 35) / 250, 0, 1);
            exit;
        }
    }
    else if (gui_mouse_x >= 335 && gui_mouse_x <= 625)
    {
        if (gui_mouse_y >= 180 && gui_mouse_y <= 240)
        {
            other_racers_alpha = clamp((gui_mouse_x - 355) / 250, 0, 1);
            exit;
        }
        
        if (gui_mouse_y >= 300 && gui_mouse_y <= 360)
        {
            other_racer_names_alpha = clamp((gui_mouse_x - 355) / 250, 0, 1);
            exit;
        }
        
        if (gui_mouse_y >= 420 && gui_mouse_y <= 480)
        {
            other_racer_names_scale = clamp((gui_mouse_x - 355) / 250, 0, 1);
            exit;
        }
    }
    
    if (gui_mouse_x >= 510 && gui_mouse_x <= 930 && gui_mouse_y >= 570 && gui_mouse_y <= 990)
    {
        var hue = clamp((gui_mouse_x - 530) / 380, 0, 1) * 255;
        var saturation = 255 - (clamp((gui_mouse_y - 590) / 380, 0, 1) * 255);
        var value = 255;
        var new_color = make_color_hsv(hue, saturation, value);
        
        switch (selected_color_category)
        {
            case 0:
                this_racer.name_color = new_color;
                break;
            
            case 1:
                this_racer.eye_color = new_color;
                break;
            
            case 2:
                this_racer.body_color = new_color;
                break;
            
            case 3:
                this_racer.shell_color = new_color;
                break;
            
            case 4:
                this_racer.outline_color = new_color;
                break;
        }
        
        exit;
    }
}

if (!device_mouse_check_button_released(0, mb_left))
    exit;

if (gui_mouse_x >= 300 && gui_mouse_x <= 480 && gui_mouse_y >= 565 && gui_mouse_y <= 615)
{
    var name = get_string("Name (max 20 characters)", this_racer.name);
    name = scr_filter_unsupported_ords(name);
    name = scr_string_trim_start(name);
    
    if (string_length(name) > 20)
        name = string_copy(name, 1, 20);
    
    name = scr_string_trim_end(name);
    
    if (name != "")
        this_racer.name = name;
    
    exit;
}

if (gui_mouse_x >= 50 && gui_mouse_x <= 160 && gui_mouse_y >= 700 && gui_mouse_y <= 750)
{
    selected_color_category = 0;
    exit;
}

if (gui_mouse_x >= 210 && gui_mouse_x <= 320 && gui_mouse_y >= 700 && gui_mouse_y <= 750)
{
    selected_color_category = 1;
    exit;
}

if (gui_mouse_x >= 370 && gui_mouse_x <= 480 && gui_mouse_y >= 700 && gui_mouse_y <= 750)
{
    selected_color_category = 2;
    exit;
}

if (gui_mouse_x >= 70 && gui_mouse_x <= 240 && gui_mouse_y >= 775 && gui_mouse_y <= 825)
{
    selected_color_category = 3;
    exit;
}

if (gui_mouse_x >= 290 && gui_mouse_x <= 460 && gui_mouse_y >= 775 && gui_mouse_y <= 825)
{
    selected_color_category = 4;
    exit;
}
