visible = false;
persistent = true;
this_racer = instance_find(obj_network_manager).this_racer;
auto_auto_difficulty_off = true;
selected_color_category = 0;

function draw_slider(arg0, arg1, arg2, arg3)
{
    var half_width = arg2 / 2;
    draw_roundrect(arg0 - half_width, arg1 - 4, arg0 + half_width, arg1 + 4, false);
    draw_set_color(c_dkgray);
    var nob_x = ((arg3 * arg2) + arg0) - half_width;
    draw_roundrect(nob_x - 10, arg1 - 15, nob_x + 10, arg1 + 15, false);
    draw_set_color(c_white);
}

function transform_preview_x_closure_transform(arg0, arg1)
{
    return ((arg0 - arg1[0] - 26) * 5) + 1570;
}

function transform_preview_y_closure_transform(arg0, arg1)
{
    return ((arg0 - arg1[0] - 20) * 5) + 1030;
}

ini_open("racing_settings.ini");
this_racer.name = ini_read_string("Customization", "name", "Player");
this_racer.hat = ini_read_real("Customization", "hat", -1);
this_racer.name_color = ini_read_real("Customization", "name_color", 16777215);
this_racer.outline_color = ini_read_real("Customization", "outline_color", make_color_rgb(18, 20, 66));
this_racer.body_color = ini_read_real("Customization", "body_color", make_color_rgb(60, 92, 153));
this_racer.shell_color = ini_read_real("Customization", "shell_color", make_color_rgb(70, 108, 178));
this_racer.eye_color = ini_read_real("Customization", "eye_color", make_color_rgb(183, 184, 229));
leaderboard_background_alpha = ini_read_real("Customization", "leaderboard_background_alpha", 0.5);
leaderboard_text_alpha = ini_read_real("Customization", "leaderboard_text_alpha", 0.5);
leaderboard_scale = ini_read_real("Customization", "leaderboard_scale", 0.5);
other_racers_alpha = ini_read_real("Customization", "other_racers_alpha", 0.5);
other_racer_names_alpha = ini_read_real("Customization", "other_racer_names_alpha", 0.5);
other_racer_names_scale = ini_read_real("Customization", "other_racer_names_scale", 0.5);
ini_close();
global.save_equipped_hat = this_racer.hat;
