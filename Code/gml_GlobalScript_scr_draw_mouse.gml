if (device_mouse_check_button(0, mb_left))
    draw_sprite_ext(spr_hat_unicorn, 0, device_mouse_x_to_gui(0) + 35, device_mouse_y_to_gui(0) + 33, 1.5, 1.5, 90, c_gray, 1);
else
    draw_sprite_ext(spr_hat_unicorn, 0, device_mouse_x_to_gui(0) + 46, device_mouse_y_to_gui(0) + 44, 2, 2, 90, c_white, 1);
