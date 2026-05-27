depth = original_depth;
var num_other_racers = ds_list_size(other_racers);
var other_racer_names_alpha = racing_customization.other_racer_names_alpha;
var other_racer_names_scale = racing_customization.other_racer_names_scale;
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

for (var i = 0; i < num_other_racers; i++)
{
    var other_racer = ds_list_find_value(other_racers, i);
    var other_racer_room = scr_get_mapped_room(other_racer.current_room, other_racer.on_speedrunner_version);
    
    if (other_racer_room == -1 || other_racer_room != room)
        continue;
    
    var version_x_offset = 0;
    
    if (room == level_select && scr_get_is_speedrunner_version() != other_racer.on_speedrunner_version)
        version_x_offset = other_racer.on_speedrunner_version ? 300 : -300;
    
    scr_draw_snail_from_racer_object_transformed(other_racer, 
    {
        transform: add_closure_transform,
        args: [version_x_offset]
    }, nothing_closure, 1, racing_customization.other_racers_alpha);
    var name_color = other_racer.name_color;
    draw_text_transformed_color(other_racer.x + version_x_offset, other_racer.y - 32, other_racer.name, other_racer_names_scale, other_racer_names_scale, 0, name_color, name_color, name_color, name_color, other_racer_names_alpha);
}
