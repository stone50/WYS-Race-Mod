draw_set_color(c_fuchsia);
var gui_mouse_x = device_mouse_x_to_gui(0);
var gui_mouse_y = device_mouse_y_to_gui(0);
var button_scale = racing_customization.leaderboard_scale * 32;
var button_x = 1920 - (29 * button_scale);
var button_x_2 = button_x + button_scale;

for (var i = 0; i < ds_list_size(other_racers); i++)
{
    var other_racer = ds_list_find_value(other_racers, i);
    var button_y = other_racer.placement * button_scale;
    var button_y_2 = button_y + button_scale;
    var is_hovering = gui_mouse_x >= button_x && gui_mouse_y >= button_y && gui_mouse_y <= button_y_2;
    var alpha = is_hovering ? 1 : 0.5;
    draw_set_alpha(alpha);
    var pupil_padding = 0.359375 * button_scale;
    
    if (ds_list_find_index(selected_racers, other_racer) == -1)
    {
        draw_rectangle(button_x, button_y + pupil_padding, button_x_2, button_y_2 - pupil_padding, false);
    }
    else
    {
        draw_sprite_stretched_ext(spr_eye_px_neutral_b, 0, button_x, button_y, button_scale, button_scale, c_fuchsia, alpha);
        draw_rectangle(button_x + pupil_padding, button_y + pupil_padding, button_x_2 - pupil_padding, button_y_2 - pupil_padding, false);
    }
}

draw_set_alpha(1);
