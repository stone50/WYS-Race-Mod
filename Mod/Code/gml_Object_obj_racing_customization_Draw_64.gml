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
draw_text_transformed(800, 60, "Hat", 0.8, 0.8, 0);
draw_set_color((gui_mouse_x >= 660 && gui_mouse_x <= 740 && gui_mouse_y >= 110 && gui_mouse_y <= 190) ? c_purple : c_dkgray);
draw_rectangle(660, 110, 740, 190, false);
draw_sprite_stretched(spr_hat_cylinder, 0, 670, 127, 60, 46);
draw_set_color((gui_mouse_x >= 760 && gui_mouse_x <= 840 && gui_mouse_y >= 110 && gui_mouse_y <= 190) ? c_purple : c_dkgray);
draw_rectangle(760, 110, 840, 190, false);
draw_sprite_stretched(spr_hat_shelly, 0, 770, 129.5, 60, 41);
draw_set_color((gui_mouse_x >= 860 && gui_mouse_x <= 940 && gui_mouse_y >= 110 && gui_mouse_y <= 190) ? c_purple : c_dkgray);
draw_rectangle(860, 110, 940, 190, false);
draw_sprite_stretched(spr_hat_poopoo, 0, 876.5, 120, 47, 60);
draw_set_color((gui_mouse_x >= 660 && gui_mouse_x <= 740 && gui_mouse_y >= 210 && gui_mouse_y <= 290) ? c_purple : c_dkgray);
draw_rectangle(660, 210, 740, 290, false);
draw_sprite_stretched(spr_hat_human, 0, 688.5, 220, 23, 60);
draw_set_color((gui_mouse_x >= 760 && gui_mouse_x <= 840 && gui_mouse_y >= 210 && gui_mouse_y <= 290) ? c_purple : c_dkgray);
draw_rectangle(760, 210, 840, 290, false);
draw_sprite_stretched(spr_hat_winter, 0, 770, 225.5, 60, 49);
draw_set_color((gui_mouse_x >= 860 && gui_mouse_x <= 940 && gui_mouse_y >= 210 && gui_mouse_y <= 290) ? c_purple : c_dkgray);
draw_rectangle(860, 210, 940, 290, false);
draw_sprite_stretched(spr_hat_squid, 0, 868, 208, 70, 70);
draw_set_color((gui_mouse_x >= 710 && gui_mouse_x <= 790 && gui_mouse_y >= 310 && gui_mouse_y <= 390) ? c_purple : c_dkgray);
draw_rectangle(710, 310, 790, 390, false);
draw_sprite_stretched(spr_hat_unicorn, 0, 724.5, 320, 51, 60);
draw_set_color((gui_mouse_x >= 810 && gui_mouse_x <= 890 && gui_mouse_y >= 310 && gui_mouse_y <= 390) ? c_purple : c_dkgray);
draw_rectangle(810, 310, 890, 390, false);
var level_styler = instance_find(obj_levelstyler);
draw_sprite_stretched_ext(spr_hat_hart, 0, 820, 329.5, 60, 41, merge_color(level_styler.col_ai, level_styler.col_ai2, 0.5), 1);
draw_set_color((gui_mouse_x >= 760 && gui_mouse_x <= 840 && gui_mouse_y >= 410 && gui_mouse_y <= 490) ? c_purple : c_dkgray);
draw_rectangle(760, 410, 840, 490, false);
draw_sprite_stretched(spr_hat_noone, 0, 771, 421, 60, 60);
var selected_hat_outline_center_x, selected_hat_outline_center_y;

switch (this_racer.hat)
{
    case 0:
        selected_hat_outline_center_x = 700;
        selected_hat_outline_center_y = 150;
        break;
    
    case 1:
        selected_hat_outline_center_x = 800;
        selected_hat_outline_center_y = 150;
        break;
    
    case 6:
        selected_hat_outline_center_x = 900;
        selected_hat_outline_center_y = 150;
        break;
    
    case 3:
        selected_hat_outline_center_x = 700;
        selected_hat_outline_center_y = 250;
        break;
    
    case 4:
        selected_hat_outline_center_x = 800;
        selected_hat_outline_center_y = 250;
        break;
    
    case 5:
        selected_hat_outline_center_x = 900;
        selected_hat_outline_center_y = 250;
        break;
    
    case 2:
        selected_hat_outline_center_x = 750;
        selected_hat_outline_center_y = 350;
        break;
    
    case 7:
        selected_hat_outline_center_x = 850;
        selected_hat_outline_center_y = 350;
        break;
    
    case -1:
        selected_hat_outline_center_x = 800;
        selected_hat_outline_center_y = 450;
        break;
}

draw_set_color(c_aqua);
draw_rectangle(selected_hat_outline_center_x - 44, selected_hat_outline_center_y - 44, selected_hat_outline_center_x + 44, selected_hat_outline_center_y - 40);
draw_rectangle(selected_hat_outline_center_x - 44, selected_hat_outline_center_y + 40, selected_hat_outline_center_x + 44, selected_hat_outline_center_y + 44);
draw_rectangle(selected_hat_outline_center_x - 44, selected_hat_outline_center_y - 44, selected_hat_outline_center_x - 40, selected_hat_outline_center_y + 44);
draw_rectangle(selected_hat_outline_center_x + 40, selected_hat_outline_center_y - 44, selected_hat_outline_center_x + 44, selected_hat_outline_center_y + 44);
draw_set_color(c_black);
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
var should_shift_this_racer = !instance_exists(obj_player);

if (should_shift_this_racer)
{
    this_racer.x = 0;
    this_racer.y = 0;
    this_racer.eye_1_x = 8;
    this_racer.eye_1_y = -15;
    this_racer.eye_2_x = 20;
    this_racer.eye_2_y = -15;
}

scr_draw_snail_from_racer_object_transformed(this_racer, 
{
    transform: transform_preview_x_closure_transform,
    args: [this_racer.x]
}, 
{
    transform: transform_preview_y_closure_transform,
    args: [this_racer.y]
}, 5, 1);

if (should_shift_this_racer)
{
    this_racer.x = -infinity;
    this_racer.y = -infinity;
    this_racer.eye_1_x = -infinity;
    this_racer.eye_1_y = -infinity;
    this_racer.eye_2_x = -infinity;
    this_racer.eye_2_y = -infinity;
}

scr_draw_mouse();
