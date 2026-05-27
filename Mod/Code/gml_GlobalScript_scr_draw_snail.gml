function scr_draw_snail(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
{
    var look_dir = arg2 ? 1 : -1;
    var house_x = arg0 - (15 * look_dir * arg9);
    var house_y = arg1 + (16 * arg9);
    var house_x_scale = clamp(1 / arg3, 0.8, 5) * look_dir * arg9;
    var house_y_scale = arg3 * arg9;
    draw_sprite_ext(spr_snail_house, 0, house_x, house_y, house_x_scale, house_y_scale, arg4, arg12, arg14);
    draw_sprite_ext(spr_snail_house, 1, house_x, house_y, house_x_scale, house_y_scale, arg4, arg10, arg14);
    var body_scale = look_dir * arg9;
    draw_sprite_ext(spr_player_base, 0, arg0, arg1, body_scale, arg9, 0, arg11, arg14);
    draw_sprite_ext(spr_player_base, 1, arg0, arg1, body_scale, arg9, 0, arg10, arg14);
    var eye_y_connection = arg1 + (15 * arg9);
    var eye_1_x_connection = arg0 + (8 * look_dir * arg9);
    var eye_1_x_scale = point_distance(arg5, arg6, eye_1_x_connection, eye_y_connection) / 11;
    var eye_1_dir = point_direction(eye_1_x_connection, eye_y_connection, arg5, arg6);
    draw_sprite_ext(spr_snail_eye_connection, 0, eye_1_x_connection, eye_y_connection, eye_1_x_scale, arg9, eye_1_dir, arg11, arg14);
    draw_sprite_ext(spr_snail_eye_connection, 1, eye_1_x_connection, eye_y_connection, eye_1_x_scale, arg9, eye_1_dir, arg10, arg14);
    draw_sprite_ext(spr_snail_eye, 0, arg5, arg6, arg9, arg9, 0, arg13, arg14);
    draw_sprite_ext(spr_snail_eye, 1, arg5, arg6, arg9, arg9, 0, arg10, arg14);
    draw_sprite_ext(spr_snail_pupil, 0, arg5 + (look_dir * 2 * arg9), arg6, arg9, arg9, 0, arg10, arg14);
    var eye_2_x_connection = arg0 + (20 * look_dir * arg9);
    var eye_2_x_scale = point_distance(arg7, arg8, eye_2_x_connection, eye_y_connection) / 11;
    var eye_2_dir = point_direction(eye_2_x_connection, eye_y_connection, arg7, arg8);
    draw_sprite_ext(spr_snail_eye_connection, 0, eye_2_x_connection, eye_y_connection, eye_2_x_scale, arg9, eye_2_dir, arg11, arg14);
    draw_sprite_ext(spr_snail_eye_connection, 1, eye_2_x_connection, eye_y_connection, eye_2_x_scale, arg9, eye_2_dir, arg10, arg14);
    draw_sprite_ext(spr_snail_eye, 0, arg7, arg8, arg9, arg9, 0, arg13, arg14);
    draw_sprite_ext(spr_snail_eye, 1, arg7, arg8, arg9, arg9, 0, arg10, arg14);
    draw_sprite_ext(spr_snail_pupil, 0, arg7 + (look_dir * 2 * arg9), arg8, arg9, arg9, 0, arg10, arg14);
}

function scr_draw_snail_from_racer_object_transformed(arg0, arg1, arg2, arg3, arg4)
{
    var get_transformed_value = function(arg0, arg1)
    {
        return arg0.transform(arg1, arg0.args);
    };
    
    scr_draw_snail(get_transformed_value(arg1, arg0.x), get_transformed_value(arg2, arg0.y), arg0.is_looking_right, arg0.house_height, arg0.house_tilt, get_transformed_value(arg1, arg0.eye_1_x), get_transformed_value(arg2, arg0.eye_1_y), get_transformed_value(arg1, arg0.eye_2_x), get_transformed_value(arg2, arg0.eye_2_y), arg3, arg0.outline_color, arg0.body_color, arg0.shell_color, arg0.eye_color, arg4);
}
