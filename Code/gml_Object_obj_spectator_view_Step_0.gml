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
