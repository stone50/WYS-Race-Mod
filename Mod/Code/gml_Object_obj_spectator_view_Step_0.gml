if (!visible)
    exit;

if (mouse_wheel_up())
    scale *= 1.2;

if (mouse_wheel_down())
    scale = max(0.01, scale * 0.8);

var gui_mouse_x = device_mouse_x_to_gui(0);
var gui_mouse_y = device_mouse_y_to_gui(0);

if (device_mouse_check_button(0, mb_left))
{
    x_offset += ((gui_mouse_x - prev_gui_mouse_x) / scale);
    y_offset += ((gui_mouse_y - prev_gui_mouse_y) / scale);
}

prev_gui_mouse_x = gui_mouse_x;
prev_gui_mouse_y = gui_mouse_y;

if (selected_racer == -4)
    exit;

var selected_racer_has_disconnected = true;

for (var i = 0; i < ds_list_size(other_racers); i++)
{
    var other_racer = ds_list_find_value(other_racers, i);
    
    if (other_racer == selected_racer)
    {
        selected_racer_has_disconnected = false;
        break;
    }
}

if (selected_racer_has_disconnected)
{
    selected_racer = -4;
    exit;
}

var level_index = ds_list_find_index(global.li_lvldat_ids, selected_racer.current_room);

if (level_index == -1)
    exit;

var level_offset = scr_get_level_offset(level_index);
var target_x_offset = 960 - (level_offset[0] + selected_racer.x);
var target_y_offset = 540 - (level_offset[1] + selected_racer.y);
x_offset = (x_offset * 0.9) + (target_x_offset * 0.1);
y_offset = (y_offset * 0.9) + (target_y_offset * 0.1);
