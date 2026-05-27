var spectator_view = instance_find(obj_spectator_view);

if (spectator_view == -4)
{
    event_user(0);
    exit;
}

if (!spectator_view.visible)
    exit;

depth = spectator_view.depth - 1;
var spectator_view_scale = spectator_view.scale;
var get_transformed_x = spectator_view.get_transformed_x;
var get_transformed_y = spectator_view.get_transformed_y;
var num_other_racers = ds_list_size(other_racers);
var other_racer_names_scale = racing_customization.other_racer_names_scale * spectator_view_scale;
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);

for (var i = 0; i < num_other_racers; i++)
{
    var other_racer = ds_list_find_value(other_racers, i);
    var other_racer_room = scr_get_mapped_room(other_racer.current_room, other_racer.on_speedrunner_version);
    
    if (other_racer_room == -1)
        continue;
    
    var level_index = ds_list_find_index(global.li_lvldat_ids, other_racer_room);
    
    if (level_index == -1)
        continue;
    
    var level_offset = scr_get_level_offset(level_index);
    
    if (level_offset == -4)
        continue;
    
    scr_draw_snail_from_racer_object_transformed(other_racer, 
    {
        transform: transform_value_closure_transform,
        args: [get_transformed_x, level_offset[0]]
    }, 
    {
        transform: transform_value_closure_transform,
        args: [get_transformed_y, level_offset[1]]
    }, spectator_view_scale, 1);
    draw_set_color(other_racer.name_color);
    draw_text_transformed(get_transformed_x(other_racer.x + level_offset[0]), get_transformed_y(other_racer.y + level_offset[1]) - (32 * spectator_view_scale), other_racer.name, other_racer_names_scale, other_racer_names_scale, 0);
}
