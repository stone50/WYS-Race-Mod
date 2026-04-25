var num_other_racers = ds_list_size(other_racers);
var num_all_racers = num_other_racers + 1;
var all_racers = array_create(num_all_racers, -4);

for (var i = 0; i < num_other_racers; i++)
{
    var other_racer = ds_list_find_value(other_racers, i);
    all_racers[other_racer.placement] = other_racer;
}

all_racers[this_racer.placement] = this_racer;
var scale = racing_customization.leaderboard_scale;
draw_set_alpha(racing_customization.leaderboard_background_alpha);
draw_set_color(c_black);
draw_rectangle(1920 - (891 * scale), 0, 1920, num_all_racers * 33 * scale, false);
draw_set_alpha(1);
draw_set_halign(fa_right);
draw_set_valign(fa_top);
draw_set_font(font_aiTalk);
var text_alpha = racing_customization.leaderboard_text_alpha;

for (var i = 0; i < num_all_racers; i++)
{
    var racer = all_racers[i];
    
    if (racer == -4)
        continue;
    
    var placement = racer.placement;
    var placement_text = string(placement + 1);
    
    if ((placement + 1) < 10)
        placement_text = "0" + placement_text;
    
    var name_text = racer.name;
    
    if (string_length(name_text) > 10)
    {
        name_text = string_copy(name_text, 1, 10);
    }
    else
    {
        while (string_length(name_text) < 10)
            name_text += " ";
    }
    
    var furthest_checkpoint = racer.furthest_checkpoint;
    var diff_to_first = racer.diff_to_first;
    var abs_diff_to_first = abs(diff_to_first);
    var time_text = ((furthest_checkpoint == 90) ? " " : ((diff_to_first >= 0) ? "+" : "-")) + scr_return_timer_string(abs_diff_to_first) + scr_return_timer_string_ms(abs_diff_to_first);
    var line = placement_text + "." + name_text + " " + scr_get_checkpoint_name(furthest_checkpoint) + " " + time_text;
    var racer_name_color = racer.name_color;
    draw_text_transformed_color(1920, i * 33 * scale, line, scale, scale, 0, racer_name_color, racer_name_color, racer_name_color, racer_name_color, text_alpha);
}
