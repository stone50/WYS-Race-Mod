visible = false;
persistent = true;
depth = -1;
this_racer = instance_find(obj_network_manager).this_racer;
other_racers_alpha = 0.5;
other_racer_names_alpha = 0.5;
other_racer_names_scale = 0.5;
leaderboard_background_alpha = 0.5;
leaderboard_text_alpha = 0.5;
leaderboard_scale = 0.5;
auto_auto_difficulty_off = true;
selected_color_category = 0;
default_outline_color = make_color_rgb(18, 20, 66);
default_body_color = make_color_rgb(60, 92, 153);
default_shell_color = make_color_rgb(70, 108, 178);
default_eye_color = make_color_rgb(183, 184, 229);

function draw_slider(arg0, arg1, arg2, arg3)
{
    var half_width = arg2 / 2;
    draw_roundrect(arg0 - half_width, arg1 - 4, arg0 + half_width, arg1 + 4, false);
    draw_set_color(c_dkgray);
    var nob_x = ((arg3 * arg2) + arg0) - half_width;
    draw_roundrect(nob_x - 10, arg1 - 15, nob_x + 10, arg1 + 15, false);
    draw_set_color(c_white);
}
