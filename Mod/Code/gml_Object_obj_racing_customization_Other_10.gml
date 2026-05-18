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
    
    if (gui_mouse_x >= 335 && gui_mouse_x <= 625)
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
    
    if (gui_mouse_x >= 300 && gui_mouse_x <= 940 && gui_mouse_y >= 762.5 && gui_mouse_y <= 1052.5)
    {
        var selected_color;
        
        switch (selected_color_category)
        {
            case 0:
                selected_color = this_racer.name_color;
                break;
            
            case 1:
                selected_color = this_racer.shell_color;
                break;
            
            case 2:
                selected_color = this_racer.body_color;
                break;
            
            case 3:
                selected_color = this_racer.eye_color;
                break;
            
            case 4:
                selected_color = this_racer.outline_color;
                break;
        }
        
        var selected_red = color_get_red(selected_color);
        var selected_green = color_get_green(selected_color);
        var selected_blue = color_get_blue(selected_color);
        
        if (gui_mouse_y <= 822.5)
            selected_red = clamp((gui_mouse_x - 320) / 600, 0, 1) * 255;
        
        if (gui_mouse_y >= 877.5 && gui_mouse_y <= 937.5)
            selected_green = clamp((gui_mouse_x - 320) / 600, 0, 1) * 255;
        
        if (gui_mouse_y >= 992.5)
            selected_blue = clamp((gui_mouse_x - 320) / 600, 0, 1) * 255;
        
        selected_color = make_color_rgb(selected_red, selected_green, selected_blue);
        
        switch (selected_color_category)
        {
            case 0:
                this_racer.name_color = selected_color;
                break;
            
            case 1:
                this_racer.shell_color = selected_color;
                break;
            
            case 2:
                this_racer.body_color = selected_color;
                break;
            
            case 3:
                this_racer.eye_color = selected_color;
                break;
            
            case 4:
                this_racer.outline_color = selected_color;
                break;
        }
    }
}

if (!device_mouse_check_button_released(0, mb_left))
    exit;

if (gui_mouse_x >= 760 && gui_mouse_x <= 940 && gui_mouse_y >= 565 && gui_mouse_y <= 615)
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

if (gui_mouse_y < 635 || gui_mouse_y > 735)
    exit;

if (gui_mouse_x >= 0 && gui_mouse_x <= 192)
{
    selected_color_category = 0;
    exit;
}

if (gui_mouse_x >= 192 && gui_mouse_x <= 384)
{
    selected_color_category = 1;
    exit;
}

if (gui_mouse_x >= 384 && gui_mouse_x <= 576)
{
    selected_color_category = 2;
    exit;
}

if (gui_mouse_x >= 576 && gui_mouse_x <= 768)
{
    selected_color_category = 3;
    exit;
}

if (gui_mouse_x >= 768 && gui_mouse_x <= 960)
{
    selected_color_category = 4;
    exit;
}
