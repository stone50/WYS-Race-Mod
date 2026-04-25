var spectator_view = instance_find(obj_spectator_view);

if (spectator_view == -4)
{
    event_user(0);
    exit;
}

if (!spectator_view.visible)
    exit;

depth = spectator_view.depth - 1;
var spectator_view_x_offset = spectator_view.x_offset;
var spectator_view_y_offset = spectator_view.y_offset;
var spectator_view_scale = spectator_view.scale;
var get_transformed_x = spectator_view.get_transformed_x;
var get_transformed_y = spectator_view.get_transformed_y;
var num_other_racers = ds_list_size(other_racers);
var other_racer_names_scale = racing_customization.other_racer_names_scale * spectator_view_scale;

for (var i = 0; i < num_other_racers; i++)
{
    var other_racer = ds_list_find_value(other_racers, i);
    var level_index = ds_list_find_index(global.li_lvldat_ids, other_racer.current_room);
    
    if (level_index == -1)
        continue;
    
    var level_offset = scr_get_level_offset(level_index);
    
    if (level_offset == -4)
        continue;
    
    var other_racer_x = get_transformed_x(other_racer.x + level_offset[0]);
    var other_racer_y = get_transformed_y(other_racer.y + level_offset[1]);
    var look_dir = other_racer.look_dir;
    var house_x = other_racer_x - (15 * look_dir * spectator_view_scale);
    var house_y = other_racer_y + (16 * spectator_view_scale);
    var house_height = other_racer.house_height;
    var house_x_scale = clamp(1 / house_height, 0.8, 5) * look_dir * spectator_view_scale;
    var house_y_scale = house_height * spectator_view_scale;
    var house_tilt = other_racer.house_tilt;
    var outline_color = other_racer.outline_color;
    draw_sprite_ext(spr_snail_house, 0, house_x, house_y, house_x_scale, house_y_scale, house_tilt, other_racer.shell_color, 1);
    draw_sprite_ext(spr_snail_house, 1, house_x, house_y, house_x_scale, house_y_scale, house_tilt, outline_color, 1);
    var body_color = other_racer.body_color;
    var body_scale = look_dir * spectator_view_scale;
    draw_sprite_ext(spr_player_base, 0, other_racer_x, other_racer_y, body_scale, spectator_view_scale, 0, body_color, 1);
    draw_sprite_ext(spr_player_base, 1, other_racer_x, other_racer_y, body_scale, spectator_view_scale, 0, outline_color, 1);
    var eye_y_connection = other_racer_y + (15 * spectator_view_scale);
    var eye_1_x = get_transformed_x(other_racer.eye_1_x + level_offset[0]);
    var eye_1_y = get_transformed_y(other_racer.eye_1_y + level_offset[1]);
    var eye_1_x_connection = other_racer_x + (8 * look_dir * spectator_view_scale);
    var eye_1_x_scale = point_distance(eye_1_x, eye_1_y, eye_1_x_connection, eye_y_connection) / 11;
    var eye_1_dir = point_direction(eye_1_x_connection, eye_y_connection, eye_1_x, eye_1_y);
    var eye_color = other_racer.eye_color;
    draw_sprite_ext(spr_snail_eye_connection, 0, eye_1_x_connection, eye_y_connection, eye_1_x_scale, spectator_view_scale, eye_1_dir, body_color, 1);
    draw_sprite_ext(spr_snail_eye_connection, 1, eye_1_x_connection, eye_y_connection, eye_1_x_scale, spectator_view_scale, eye_1_dir, outline_color, 1);
    draw_sprite_ext(spr_snail_eye, 0, eye_1_x, eye_1_y, spectator_view_scale, spectator_view_scale, 0, eye_color, 1);
    draw_sprite_ext(spr_snail_eye, 1, eye_1_x, eye_1_y, spectator_view_scale, spectator_view_scale, 0, outline_color, 1);
    draw_sprite_ext(spr_snail_pupil, 0, eye_1_x + (look_dir * 2 * spectator_view_scale), eye_1_y, spectator_view_scale, spectator_view_scale, 0, outline_color, 1);
    var eye_2_x = get_transformed_x(other_racer.eye_2_x + level_offset[0]);
    var eye_2_y = get_transformed_y(other_racer.eye_2_y + level_offset[1]);
    var eye_2_x_connection = other_racer_x + (20 * look_dir * spectator_view_scale);
    var eye_2_x_scale = point_distance(eye_2_x, eye_2_y, eye_2_x_connection, eye_y_connection) / 11;
    var eye_2_dir = point_direction(eye_2_x_connection, eye_y_connection, eye_2_x, eye_2_y);
    draw_sprite_ext(spr_snail_eye_connection, 0, eye_2_x_connection, eye_y_connection, eye_2_x_scale, spectator_view_scale, eye_2_dir, body_color, 1);
    draw_sprite_ext(spr_snail_eye_connection, 1, eye_2_x_connection, eye_y_connection, eye_2_x_scale, spectator_view_scale, eye_2_dir, outline_color, 1);
    draw_sprite_ext(spr_snail_eye, 0, eye_2_x, eye_2_y, spectator_view_scale, spectator_view_scale, 0, eye_color, 1);
    draw_sprite_ext(spr_snail_eye, 1, eye_2_x, eye_2_y, spectator_view_scale, spectator_view_scale, 0, outline_color, 1);
    draw_sprite_ext(spr_snail_pupil, 0, eye_2_x + (look_dir * 2 * spectator_view_scale), eye_2_y, spectator_view_scale, spectator_view_scale, 0, outline_color, 1);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(other_racer.name_color);
    draw_text_transformed(other_racer_x, other_racer_y - (32 * spectator_view_scale), other_racer.name, other_racer_names_scale, other_racer_names_scale, 0);
}
