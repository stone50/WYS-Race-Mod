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
draw_text_transformed(20, 590, this_racer.name, 1.1, 1.1, 0);
draw_set_halign(fa_center);
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
var selected_color_category_outline_center_x;

switch (selected_color_category)
{
    case 0:
        selected_color_category_outline_center_x = 96;
        var selected_color = this_racer.name_color;
        break;
    
    case 1:
        selected_color_category_outline_center_x = 288;
        var selected_color = this_racer.shell_color;
        break;
    
    case 2:
        selected_color_category_outline_center_x = 480;
        var selected_color = this_racer.body_color;
        break;
    
    case 3:
        selected_color_category_outline_center_x = 672;
        var selected_color = this_racer.eye_color;
        break;
    
    case 4:
        selected_color_category_outline_center_x = 864;
        var selected_color = this_racer.outline_color;
        break;
}

draw_rectangle(selected_color_category_outline_center_x - 96, 635, selected_color_category_outline_center_x + 96, 640);
draw_rectangle(selected_color_category_outline_center_x - 96, 730, selected_color_category_outline_center_x + 96, 735);
draw_rectangle(selected_color_category_outline_center_x - 96, 635, (selected_color_category_outline_center_x - 96) + 5, 735);
draw_rectangle(selected_color_category_outline_center_x + 96, 635, (selected_color_category_outline_center_x + 96) - 5, 735);
draw_set_color(c_white);
draw_text_transformed(96, 685, "Name", 0.5, 0.5, 0);
draw_text_transformed(288, 685, "Shell", 0.5, 0.5, 0);
draw_text_transformed(480, 685, "Body", 0.5, 0.5, 0);
draw_text_transformed(672, 685, "Eye", 0.5, 0.5, 0);
draw_text_transformed(864, 685, "Outline", 0.5, 0.5, 0);
var preview_scale = 10;
var preview_x = 1920 - (26 * preview_scale) - 100;
var preview_y = 1080 - (20 * preview_scale) - 100;
var house_x = preview_x - (15 * preview_scale);
var house_y = preview_y + (16 * preview_scale);
var outline_color = this_racer.outline_color;
draw_sprite_ext(spr_snail_house, 0, house_x, house_y, preview_scale, preview_scale, 0, this_racer.shell_color, 1);
draw_sprite_ext(spr_snail_house, 1, house_x, house_y, preview_scale, preview_scale, 0, outline_color, 1);
var body_color = this_racer.body_color;
draw_sprite_ext(spr_player_base, 0, preview_x, preview_y, preview_scale, preview_scale, 0, body_color, 1);
draw_sprite_ext(spr_player_base, 1, preview_x, preview_y, preview_scale, preview_scale, 0, outline_color, 1);
var eye_y_connection = preview_y + (15 * preview_scale);
var eye_1_x = preview_x + (8 * preview_scale);
var eye_1_y = preview_y - (15 * preview_scale);
var eye_1_x_connection = preview_x + (8 * preview_scale);
var eye_1_x_scale = point_distance(eye_1_x, eye_1_y, eye_1_x_connection, eye_y_connection) / 11;
var eye_1_dir = point_direction(eye_1_x_connection, eye_y_connection, eye_1_x, eye_1_y);
var eye_color = this_racer.eye_color;
draw_sprite_ext(spr_snail_eye_connection, 0, eye_1_x_connection, eye_y_connection, eye_1_x_scale, preview_scale, eye_1_dir, body_color, 1);
draw_sprite_ext(spr_snail_eye_connection, 1, eye_1_x_connection, eye_y_connection, eye_1_x_scale, preview_scale, eye_1_dir, outline_color, 1);
draw_sprite_ext(spr_snail_eye, 0, eye_1_x, eye_1_y, preview_scale, preview_scale, 0, eye_color, 1);
draw_sprite_ext(spr_snail_eye, 1, eye_1_x, eye_1_y, preview_scale, preview_scale, 0, outline_color, 1);
draw_sprite_ext(spr_snail_pupil, 0, eye_1_x + (2 * preview_scale), eye_1_y, preview_scale, preview_scale, 0, outline_color, 1);
var eye_2_x = preview_x + (20 * preview_scale);
var eye_2_y = preview_y - (15 * preview_scale);
var eye_2_x_connection = preview_x + (20 * preview_scale);
var eye_2_x_scale = point_distance(eye_2_x, eye_2_y, eye_2_x_connection, eye_y_connection) / 11;
var eye_2_dir = point_direction(eye_2_x_connection, eye_y_connection, eye_2_x, eye_2_y);
draw_sprite_ext(spr_snail_eye_connection, 0, eye_2_x_connection, eye_y_connection, eye_2_x_scale, preview_scale, eye_2_dir, body_color, 1);
draw_sprite_ext(spr_snail_eye_connection, 1, eye_2_x_connection, eye_y_connection, eye_2_x_scale, preview_scale, eye_2_dir, outline_color, 1);
draw_sprite_ext(spr_snail_eye, 0, eye_2_x, eye_2_y, preview_scale, preview_scale, 0, eye_color, 1);
draw_sprite_ext(spr_snail_eye, 1, eye_2_x, eye_2_y, preview_scale, preview_scale, 0, outline_color, 1);
draw_sprite_ext(spr_snail_pupil, 0, eye_2_x + (2 * preview_scale), eye_2_y, preview_scale, preview_scale, 0, outline_color, 1);
scr_draw_mouse();
