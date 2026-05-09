depth = original_depth;
var num_other_racers = ds_list_size(other_racers);
var other_racers_alpha = racing_customization.other_racers_alpha;
var other_racer_names_alpha = racing_customization.other_racer_names_alpha;
var other_racer_names_scale = racing_customization.other_racer_names_scale;

for (var i = 0; i < num_other_racers; i++)
{
    var other_racer = ds_list_find_value(other_racers, i);
    var other_racer_room = scr_get_mapped_room(other_racer.current_room, other_racer.on_speedrunner_version);
    
    if (other_racer_room == -1 || other_racer_room != room)
        continue;
    
    var version_x_offset = 0;

    if (room == level_select && scr_get_is_speedrunner_version() != other_racer.on_speedrunner_version)
        version_x_offset = (other_racer.on_speedrunner_version ? 300 : -300);

    var other_racer_x = other_racer.x + version_x_offset;
    var other_racer_y = other_racer.y;
    var look_dir = other_racer.is_looking_right ? 1 : -1;
    var house_x = other_racer_x - (15 * look_dir);
    var house_y = other_racer_y + 16;
    var house_height = other_racer.house_height;
    var house_x_scale = clamp(1 / house_height, 0.8, 5) * look_dir;
    var house_tilt = other_racer.house_tilt;
    var outline_color = other_racer.outline_color;
    draw_sprite_ext(spr_snail_house, 0, house_x, house_y, house_x_scale, house_height, house_tilt, other_racer.shell_color, other_racers_alpha);
    draw_sprite_ext(spr_snail_house, 1, house_x, house_y, house_x_scale, house_height, house_tilt, outline_color, other_racers_alpha);
    var body_color = other_racer.body_color;
    draw_sprite_ext(spr_player_base, 0, other_racer_x, other_racer_y, look_dir, 1, 0, body_color, other_racers_alpha);
    draw_sprite_ext(spr_player_base, 1, other_racer_x, other_racer_y, look_dir, 1, 0, outline_color, other_racers_alpha);
    var eye_y_connection = other_racer_y + 15;
    var eye_1_x = other_racer.eye_1_x + version_x_offset;
    var eye_1_y = other_racer.eye_1_y;
    var eye_1_x_connection = other_racer_x + (8 * look_dir);
    var eye_1_x_scale = point_distance(eye_1_x, eye_1_y, eye_1_x_connection, eye_y_connection) / 11;
    var eye_1_dir = point_direction(eye_1_x_connection, eye_y_connection, eye_1_x, eye_1_y);
    var eye_color = other_racer.eye_color;
    draw_sprite_ext(spr_snail_eye_connection, 0, eye_1_x_connection, eye_y_connection, eye_1_x_scale, 1, eye_1_dir, body_color, other_racers_alpha);
    draw_sprite_ext(spr_snail_eye_connection, 1, eye_1_x_connection, eye_y_connection, eye_1_x_scale, 1, eye_1_dir, outline_color, other_racers_alpha);
    draw_sprite_ext(spr_snail_eye, 0, eye_1_x, eye_1_y, 1, 1, 0, eye_color, other_racers_alpha);
    draw_sprite_ext(spr_snail_eye, 1, eye_1_x, eye_1_y, 1, 1, 0, outline_color, other_racers_alpha);
    draw_sprite_ext(spr_snail_pupil, 0, eye_1_x + (look_dir * 2), eye_1_y, 1, 1, 0, outline_color, other_racers_alpha);
    var eye_2_x = other_racer.eye_2_x + version_x_offset;
    var eye_2_y = other_racer.eye_2_y;
    var eye_2_x_connection = other_racer_x + (20 * look_dir);
    var eye_2_x_scale = point_distance(eye_2_x, eye_2_y, eye_2_x_connection, eye_y_connection) / 11;
    var eye_2_dir = point_direction(eye_2_x_connection, eye_y_connection, eye_2_x, eye_2_y);
    draw_sprite_ext(spr_snail_eye_connection, 0, eye_2_x_connection, eye_y_connection, eye_2_x_scale, 1, eye_2_dir, body_color, other_racers_alpha);
    draw_sprite_ext(spr_snail_eye_connection, 1, eye_2_x_connection, eye_y_connection, eye_2_x_scale, 1, eye_2_dir, outline_color, other_racers_alpha);
    draw_sprite_ext(spr_snail_eye, 0, eye_2_x, eye_2_y, 1, 1, 0, eye_color, other_racers_alpha);
    draw_sprite_ext(spr_snail_eye, 1, eye_2_x, eye_2_y, 1, 1, 0, outline_color, other_racers_alpha);
    draw_sprite_ext(spr_snail_pupil, 0, eye_2_x + (look_dir * 2), eye_2_y, 1, 1, 0, outline_color, other_racers_alpha);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    var name_color = other_racer.name_color;
    draw_text_transformed_color(other_racer_x, other_racer_y - 32, other_racer.name, other_racer_names_scale, other_racer_names_scale, 0, name_color, name_color, name_color, name_color, other_racer_names_alpha);
}
