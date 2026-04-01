network_manager = instance_find(833);
other_racers_alpha = 0.5;
other_racer_names_alpha = 0.5;
other_racer_names_scale = 0.5;
leaderboard_background_alpha = 0.5;
leaderboard_text_alpha = 0.5;
leaderboard_scale = 0.5;
auto_auto_difficulty_off = true;
depth = -1;

function draw_slider(arg0, arg1, arg2)
{
    draw_roundrect(arg0 - 70, arg1 - 4, arg0 + 70, arg1 + 4, false);
    draw_set_color(c_dkgray);
    var nob_x = ((arg2 * 140) + arg0) - 70;
    draw_roundrect(nob_x - 10, arg1 - 15, nob_x + 10, arg1 + 15, false);
    draw_set_color(c_white);
}

function draw_color_grid(arg0, arg1, arg2)
{
    draw_set_color(arg2);
    draw_rectangle(arg0 - 78, arg1 - 38, arg0 - 42, arg1 - 2);
    draw_set_color(c_red);
    draw_rectangle(arg0 - 38, arg1 - 38, arg0 - 2, arg1 - 2);
    draw_set_color(c_fuchsia);
    draw_rectangle(arg0 + 38, arg1 - 38, arg0 + 2, arg1 - 2);
    draw_set_color(c_aqua);
    draw_rectangle(arg0 + 78, arg1 - 38, arg0 + 42, arg1 - 2);
    draw_set_color(c_lime);
    draw_rectangle(arg0 - 78, arg1 + 2, arg0 - 42, arg1 + 38);
    draw_set_color(c_yellow);
    draw_rectangle(arg0 - 38, arg1 + 2, arg0 - 2, arg1 + 38);
    draw_set_color(c_white);
    draw_rectangle(arg0 + 38, arg1 + 2, arg0 + 2, arg1 + 38);
}
