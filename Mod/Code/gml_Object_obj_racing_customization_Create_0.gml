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
name_colors = [16777215, 65535, 16776960, 65280, 16711935, 255, 4235519, 12632256];
outline_colors = [make_color_rgb(18, 20, 66), 16711680, 8421376, 32768, 8388736, 128, 4210752, 0];
body_colors = [make_color_rgb(60, 92, 153), 65535, 16776960, 65280, 16711935, 255, 4235519, 12632256];
shell_colors = [make_color_rgb(70, 108, 178), 65535, 16776960, 65280, 16711935, 255, 4235519, 12632256];
eye_colors = [make_color_rgb(183, 184, 229), 65535, 16776960, 65280, 16711935, 255, 4235519, 12632256];

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
    draw_set_color(arg2[0]);
    draw_rectangle(arg0 - 78, arg1 - 38, arg0 - 42, arg1 - 2);
    draw_set_color(arg2[1]);
    draw_rectangle(arg0 - 38, arg1 - 38, arg0 - 2, arg1 - 2);
    draw_set_color(arg2[2]);
    draw_rectangle(arg0 + 38, arg1 - 38, arg0 + 2, arg1 - 2);
    draw_set_color(arg2[3]);
    draw_rectangle(arg0 + 78, arg1 - 38, arg0 + 42, arg1 - 2);
    draw_set_color(arg2[4]);
    draw_rectangle(arg0 - 78, arg1 + 2, arg0 - 42, arg1 + 38);
    draw_set_color(arg2[5]);
    draw_rectangle(arg0 - 38, arg1 + 2, arg0 - 2, arg1 + 38);
    draw_set_color(arg2[6]);
    draw_rectangle(arg0 + 38, arg1 + 2, arg0 + 2, arg1 + 38);
    draw_set_color(arg2[7]);
    draw_rectangle(arg0 + 78, arg1 + 2, arg0 + 42, arg1 + 38);
    draw_set_color(c_white);
}
