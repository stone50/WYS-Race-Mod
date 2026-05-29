var gui_mouse_x = device_mouse_x_to_gui(0);
var gui_mouse_y = device_mouse_y_to_gui(0);
draw_set_color(c_gray);
draw_roundrect(0, 0, 960, 1080, false);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_black);
draw_text_transformed(160, 60, "Leaderboard", 0.8, 0.8, 0);
draw_set_color(c_white);
draw_text_transformed(160, 150, "Background\nOpacity", 0.6, 0.6, 0);
draw_slider(160, 210, 250, leaderboard_background_alpha);
draw_text_transformed(160, 270, "Text\nOpacity", 0.6, 0.6, 0);
draw_slider(160, 330, 250, leaderboard_text_alpha);
draw_text_transformed(160, 390, "Scale", 0.6, 0.6, 0);
draw_slider(160, 450, 250, leaderboard_scale);
draw_set_color(c_black);
draw_text_transformed(480, 60, "Other\nPlayers", 0.8, 0.8, 0);
draw_set_color(c_white);
draw_text_transformed(480, 150, "Opacity", 0.6, 0.6, 0);
draw_slider(480, 210, 250, other_racers_alpha);
draw_text_transformed(480, 270, "Name\nOpacity", 0.6, 0.6, 0);
draw_slider(480, 330, 250, other_racer_names_alpha);
draw_text_transformed(480, 390, "Name\nScale", 0.6, 0.6, 0);
draw_slider(480, 450, 250, other_racer_names_scale);
draw_set_color(c_black);
draw_text_transformed(800, 270, "Hats\n\nComing\n\nSoon", 1.5, 1.5, 0);
draw_set_halign(fa_left);
draw_text_transformed(25, 595, this_racer.name, 1.1, 1.1, 0);
draw_set_color(this_racer.name_color);
draw_text_transformed(20, 590, this_racer.name, 1.1, 1.1, 0);
draw_set_halign(fa_center);
draw_set_color(c_black);
draw_set_color((gui_mouse_x >= 760 && gui_mouse_x <= 940 && gui_mouse_y >= 565 && gui_mouse_y <= 615) ? c_purple : c_dkgray);
draw_roundrect(760, 565, 940, 615, false);
draw_set_color(c_white);
draw_text_transformed(850, 590, "Edit Name", 0.5, 0.5, 0);
draw_set_color(c_dkgray);
draw_rectangle(0, 635, 960, 735, false);
draw_set_color(c_purple);

if (gui_mouse_y >= 635 && gui_mouse_y <= 735)
{
    if (gui_mouse_x >= 0 && gui_mouse_x < 192)
        draw_rectangle(0, 635, 192, 735, false);
    
    if (gui_mouse_x >= 192 && gui_mouse_x < 384)
        draw_rectangle(192, 635, 384, 735, false);
    
    if (gui_mouse_x >= 384 && gui_mouse_x < 576)
        draw_rectangle(384, 635, 576, 735, false);
    
    if (gui_mouse_x >= 576 && gui_mouse_x < 768)
        draw_rectangle(576, 635, 768, 735, false);
    
    if (gui_mouse_x >= 768 && gui_mouse_x < 960)
        draw_rectangle(768, 635, 960, 735, false);
}

draw_set_color(c_black);
draw_rectangle(0, 635, 2, 735, false);
draw_rectangle(190, 635, 194, 735, false);
draw_rectangle(382, 635, 386, 735, false);
draw_rectangle(574, 635, 578, 735, false);
draw_rectangle(766, 635, 770, 735, false);
draw_rectangle(958, 635, 960, 735, false);
var selected_color_category_outline_center_x, selected_color;

switch (selected_color_category)
{
    case 0:
        selected_color_category_outline_center_x = 96;
        selected_color = this_racer.name_color;
        break;
    
    case 1:
        selected_color_category_outline_center_x = 288;
        selected_color = this_racer.shell_color;
        break;
    
    case 2:
        selected_color_category_outline_center_x = 480;
        selected_color = this_racer.body_color;
        break;
    
    case 3:
        selected_color_category_outline_center_x = 672;
        selected_color = this_racer.eye_color;
        break;
    
    case 4:
        selected_color_category_outline_center_x = 864;
        selected_color = this_racer.outline_color;
        break;
}

draw_set_color(c_aqua);
draw_rectangle(selected_color_category_outline_center_x - 96, 635, selected_color_category_outline_center_x + 96, 640);
draw_rectangle(selected_color_category_outline_center_x - 96, 730, selected_color_category_outline_center_x + 96, 735);
draw_rectangle(selected_color_category_outline_center_x - 96, 635, selected_color_category_outline_center_x - 91, 735);
draw_rectangle(selected_color_category_outline_center_x + 91, 635, selected_color_category_outline_center_x + 96, 735);
draw_set_color(c_white);
draw_text_transformed(96, 685, "Name", 0.5, 0.5, 0);
draw_text_transformed(288, 685, "Shell", 0.5, 0.5, 0);
draw_text_transformed(480, 685, "Body", 0.5, 0.5, 0);
draw_text_transformed(672, 685, "Eye", 0.5, 0.5, 0);
draw_text_transformed(864, 685, "Outline", 0.5, 0.5, 0);
draw_set_halign(fa_left);
draw_text_transformed(40, 792.5, "Red", 0.7, 0.7, 0);
draw_text_transformed(40, 907.5, "Green", 0.7, 0.7, 0);
draw_text_transformed(40, 1022.5, "Blue", 0.7, 0.7, 0);
var selected_red = color_get_red(selected_color);
var selected_green = color_get_green(selected_color);
var selected_blue = color_get_blue(selected_color);
draw_set_color(c_white);
draw_text_transformed(200, 792.5, string(selected_red), 0.7, 0.7, 0);
draw_text_transformed(200, 907.5, string(selected_green), 0.7, 0.7, 0);
draw_text_transformed(200, 1022.5, string(selected_blue), 0.7, 0.7, 0);
draw_set_color(make_color_rgb(255, 255 - selected_red, 255 - selected_red));
draw_slider(620, 792.5, 600, selected_red / 255);
draw_set_color(make_color_rgb(255 - selected_green, 255, 255 - selected_green));
draw_slider(620, 907.5, 600, selected_green / 255);
draw_set_color(make_color_rgb(255 - selected_blue, 255 - selected_blue, 255));
draw_slider(620, 1022.5, 600, selected_blue / 255);
scr_draw_snail_from_racer_object_transformed(this_racer, 
{
    transform: transform_preview_x_closure_transform,
    args: [this_racer.x]
}, 
{
    transform: transform_preview_y_closure_transform,
    args: [this_racer.y]
}, 5, 1);
scr_draw_mouse();
