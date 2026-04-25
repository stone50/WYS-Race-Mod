visible = false;
scale = 1;
x_offset = 0;
y_offset = 0;
prev_gui_mouse_x = device_mouse_x_to_gui(0);
prev_gui_mouse_y = device_mouse_y_to_gui(0);
var data = scr_get_spectator_view_data();
sprites = data.sprites;
grid_offsets = data.grid_offsets;
level_indices = data.level_indices;
prefetched_flags = data.prefetched_flags;
menu_main = instance_find(obj_menu_MAIN);
other_racers = instance_find(obj_network_manager).other_racers;
selected_racer = -4;

function get_transformed_x(arg0)
{
    return (((arg0 + x_offset) - 960) * scale) + 960;
}

function get_transformed_y(arg0)
{
    return (((arg0 + y_offset) - 540) * scale) + 540;
}
