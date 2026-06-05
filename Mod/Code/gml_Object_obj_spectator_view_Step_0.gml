if (!visible)
    exit;

var num_other_racers = ds_list_size(other_racers);
var i = ds_list_size(selected_racers) - 1;

while (i >= 0)
{
    var selected_racer = ds_list_find_value(selected_racers, i);
    var is_selected_racer_connected = false;
    
    for (var ii = 0; ii < num_other_racers; ii++)
    {
        if (selected_racer == ds_list_find_value(other_racers, ii))
        {
            is_selected_racer_connected = true;
            break;
        }
    }
    
    if (!is_selected_racer_connected)
        ds_list_delete(selected_racers, i);
    
    i--;
}

var gui_mouse_x = device_mouse_x_to_gui(0);
var gui_mouse_y = device_mouse_y_to_gui(0);

if (device_mouse_check_button_released(0, mb_left))
{
    var button_scale = racing_customization.leaderboard_scale * 32;
    var button_x = 1920 - (29 * button_scale);
    
    if (gui_mouse_x >= button_x)
    {
        for (i = 0; i < ds_list_size(other_racers); i++)
        {
            var other_racer = ds_list_find_value(other_racers, i);
            var button_y = other_racer.placement * button_scale;
            
            if (gui_mouse_y < button_y || gui_mouse_y > (button_y + button_scale))
                continue;
            
            var selected_racer_index = ds_list_find_index(selected_racers, other_racer);
            
            if (selected_racer_index == -1)
                ds_list_add(selected_racers, other_racer);
            else
                ds_list_delete(selected_racers, selected_racer_index);
        }
    }
}

var num_selected_racers = ds_list_size(selected_racers);

if (num_selected_racers != 0)
{
    var min_x = infinity;
    var min_y = infinity;
    var max_x = -infinity;
    var max_y = -infinity;
    
    for (i = 0; i < num_selected_racers; i++)
    {
        var selected_racer = ds_list_find_value(selected_racers, i);
        var level_index = ds_list_find_index(global.li_lvldat_ids, scr_get_mapped_room(selected_racer.current_room, selected_racer.on_speedrunner_version));
        
        if (level_index == -1)
            continue;
        
        var level_offset = scr_get_level_offset(level_index);
        
        if (level_offset == -4)
            continue;
        
        var selected_racer_transformed_x = level_offset[0] + selected_racer.x;
        var selected_racer_transformed_y = level_offset[1] + selected_racer.y;
        min_x = min(min_x, selected_racer_transformed_x);
        min_y = min(min_y, selected_racer_transformed_y);
        max_x = max(max_x, selected_racer_transformed_x);
        max_y = max(max_y, selected_racer_transformed_y);
    }
    
    if (min_x != infinity && min_y != infinity && max_x != -infinity && max_y != -infinity)
    {
        var target_x_offset = 960 - ((min_x + max_x) / 2);
        var target_y_offset = 540 - ((min_y + max_y) / 2);
        x_offset = (x_offset * 0.9) + (target_x_offset * 0.1);
        y_offset = (y_offset * 0.9) + (target_y_offset * 0.1);
        var target_scale_x = 1920 / ((max_x - min_x) + 1920);
        var target_scale_y = 1080 / ((max_y - min_y) + 1080);
        var target_scale = min(target_scale_x, target_scale_y);
        scale = (scale * 0.9) + (target_scale * 0.1);
        exit;
    }
}

if (racing_customization.visible)
    exit;

if (mouse_wheel_up())
    scale *= 1.2;

if (mouse_wheel_down())
    scale = max(0.01, scale * 0.8);

if (device_mouse_check_button(0, mb_left))
{
    x_offset += ((gui_mouse_x - prev_gui_mouse_x) / scale);
    y_offset += ((gui_mouse_y - prev_gui_mouse_y) / scale);
}

prev_gui_mouse_x = gui_mouse_x;
prev_gui_mouse_y = gui_mouse_y;
