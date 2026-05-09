var gui_mouse_x = device_mouse_x_to_gui(0);
var gui_mouse_y = device_mouse_y_to_gui(0);
var is_mouse_x_hovering = gui_mouse_x >= 10 && gui_mouse_x <= 390;
draw_set_color(c_gray);
draw_roundrect(0, 690, 400, 1080, false);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
var is_mouse_on_connect_button = is_mouse_x_hovering && gui_mouse_y >= 700 && gui_mouse_y <= 848;
var connect_button_color;

if (host_ip == "" || host_port == -1)
    connect_button_color = 4210752;
else if (is_connected)
    connect_button_color = is_mouse_on_connect_button ? 128 : 255;
else
    connect_button_color = is_mouse_on_connect_button ? 8388608 : 16711680;

draw_set_color(connect_button_color);
draw_roundrect(10, 700, 390, 848, false);
draw_set_color(c_white);
draw_text(200, 774, is_connected ? "Disconnect" : "Connect");
draw_set_color((is_mouse_x_hovering && gui_mouse_y >= 858 && gui_mouse_y <= 957) ? c_purple : c_dkgray);
draw_roundrect(10, 858, 390, 957, false);
draw_set_color(c_white);
draw_text_transformed(200, 907.5, "Edit\nConnection", 0.9, 0.9);
draw_set_color((is_mouse_x_hovering && gui_mouse_y >= 967 && gui_mouse_y <= 1041) ? c_purple : c_dkgray);
draw_roundrect(10, 967, 390, 1041, false);
draw_set_color(c_white);
draw_text_transformed(200, 1004, is_host ? "Stop Hosting" : "Become Host", 0.9, 0.9);
draw_set_color(c_white);
draw_text_transformed(200, 1062, "F1 to close", 0.5, 0.5, 0);
scr_draw_mouse();
