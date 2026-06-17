function scr_draw_snail(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16)
{
    static house_sprites = [spr_snail_house, spr_snail_house_gun, spr_snail_house_gun2, spr_snail_house_gun3, spr_snail_house_gun4];
    
    var look_dir = arg2 ? 1 : -1;
    var scaled_look_dir = look_dir * arg9;
    var house_x = arg0 - (15 * scaled_look_dir);
    var house_y = arg1 + (16 * arg9);
    var house_x_scale = clamp(1 / arg3, 0.8, 5) * scaled_look_dir;
    var house_y_scale = arg3 * arg9;
    var house_sprite = (arg16 < 0 || arg16 > 4) ? house_sprites[0] : house_sprites[arg16];
    draw_sprite_ext(house_sprite, 0, house_x, house_y, house_x_scale, house_y_scale, arg4, arg12, arg14);
    draw_sprite_ext(house_sprite, 1, house_x, house_y, house_x_scale, house_y_scale, arg4, arg10, arg14);
    draw_sprite_ext(spr_player_base, 0, arg0, arg1, scaled_look_dir, arg9, 0, arg11, arg14);
    draw_sprite_ext(spr_player_base, 1, arg0, arg1, scaled_look_dir, arg9, 0, arg10, arg14);
    var should_draw_hat = true;
    var hat_dist, hat_sprite, hat_color;
    
    switch (arg15)
    {
        case 0:
            hat_dist = 41;
            hat_sprite = spr_hat_cylinder;
            hat_color = 16777215;
            break;
        
        case 1:
            hat_dist = 39;
            hat_sprite = spr_hat_shelly;
            hat_color = 16777215;
            break;
        
        case 2:
            hat_dist = 39;
            hat_sprite = spr_hat_unicorn;
            hat_color = 16777215;
            break;
        
        case 3:
            hat_dist = 39;
            hat_sprite = spr_hat_human;
            hat_color = 16777215;
            break;
        
        case 4:
            hat_dist = 39;
            hat_sprite = spr_hat_winter;
            hat_color = 16777215;
            break;
        
        case 5:
            hat_dist = 39;
            hat_sprite = spr_hat_squid;
            hat_color = 16777215;
            break;
        
        case 6:
            hat_dist = 39;
            hat_sprite = spr_hat_poopoo;
            hat_color = 16777215;
            break;
        
        case 7:
            hat_dist = 39;
            hat_sprite = spr_hat_hart;
            var level_styler = instance_find(obj_levelstyler, 0);
            hat_color = merge_color(level_styler.col_ai, level_styler.col_ai2, 0.5);
            break;
        
        default:
            should_draw_hat = false;
            break;
    }
    
    if (should_draw_hat)
    {
        var hat_scaled_dist = hat_dist * house_y_scale;
        var house_tangent = arg4 + 90;
        var hat_x, hat_angle, hat_y;
        
        if (arg16 == 1)
        {
            hat_x = (arg0 - (26 * scaled_look_dir)) + lengthdir_x(20 * house_y_scale, house_tangent);
            hat_y = arg1 + (16 * arg9) + lengthdir_y(20 * house_y_scale, house_tangent);
            hat_angle = house_tangent * look_dir;
        }
        else
        {
            hat_x = house_x + lengthdir_x(hat_scaled_dist, house_tangent);
            hat_y = house_y + lengthdir_y(hat_scaled_dist, house_tangent);
            hat_angle = arg4;
        }
        
        if (arg15 == 3)
        {
            var x1 = hat_x + lengthdir_x(9 * scaled_look_dir, hat_angle) + lengthdir_x(10 * arg9, hat_angle + 90);
            var y1 = hat_y + lengthdir_y(9 * scaled_look_dir, hat_angle) + lengthdir_y(10 * arg9, hat_angle + 90);
            var x2 = arg0 + (22 * scaled_look_dir);
            var y2 = arg1 + (17 * arg9);
            draw_sprite_ext(spr_riders_rope, 0, x1, y1, point_distance(x1, y1, x2, y2) / 100, scaled_look_dir, point_direction(x1, y1, x2, y2), c_white, arg14);
        }
        
        draw_sprite_ext(hat_sprite, 0, hat_x, hat_y, scaled_look_dir, arg9, hat_angle, hat_color, arg14);
    }
    
    var eye_y_connection = arg1 + (15 * arg9);
    var eye_1_x_connection = arg0 + (8 * scaled_look_dir);
    var eye_1_x_scale = point_distance(arg5, arg6, eye_1_x_connection, eye_y_connection) / 11;
    var eye_1_dir = point_direction(eye_1_x_connection, eye_y_connection, arg5, arg6);
    draw_sprite_ext(spr_snail_eye_connection, 0, eye_1_x_connection, eye_y_connection, eye_1_x_scale, arg9, eye_1_dir, arg11, arg14);
    draw_sprite_ext(spr_snail_eye_connection, 1, eye_1_x_connection, eye_y_connection, eye_1_x_scale, arg9, eye_1_dir, arg10, arg14);
    draw_sprite_ext(spr_snail_eye, 0, arg5, arg6, arg9, arg9, 0, arg13, arg14);
    draw_sprite_ext(spr_snail_eye, 1, arg5, arg6, arg9, arg9, 0, arg10, arg14);
    draw_sprite_ext(spr_snail_pupil, 0, arg5 + (2 * scaled_look_dir), arg6, arg9, arg9, 0, arg10, arg14);
    var eye_2_x_connection = arg0 + (20 * scaled_look_dir);
    var eye_2_x_scale = point_distance(arg7, arg8, eye_2_x_connection, eye_y_connection) / 11;
    var eye_2_dir = point_direction(eye_2_x_connection, eye_y_connection, arg7, arg8);
    draw_sprite_ext(spr_snail_eye_connection, 0, eye_2_x_connection, eye_y_connection, eye_2_x_scale, arg9, eye_2_dir, arg11, arg14);
    draw_sprite_ext(spr_snail_eye_connection, 1, eye_2_x_connection, eye_y_connection, eye_2_x_scale, arg9, eye_2_dir, arg10, arg14);
    draw_sprite_ext(spr_snail_eye, 0, arg7, arg8, arg9, arg9, 0, arg13, arg14);
    draw_sprite_ext(spr_snail_eye, 1, arg7, arg8, arg9, arg9, 0, arg10, arg14);
    draw_sprite_ext(spr_snail_pupil, 0, arg7 + (2 * scaled_look_dir), arg8, arg9, arg9, 0, arg10, arg14);
}

function scr_draw_snail_from_racer_object_transformed(arg0, arg1, arg2, arg3, arg4)
{
    var get_transformed_value = function(arg0, arg1)
    {
        return arg0.transform(arg1, arg0.args);
    };
    
    scr_draw_snail(get_transformed_value(arg1, arg0.x), get_transformed_value(arg2, arg0.y), arg0.is_looking_right, arg0.house_height, arg0.house_tilt, get_transformed_value(arg1, arg0.eye_1_x), get_transformed_value(arg2, arg0.eye_1_y), get_transformed_value(arg1, arg0.eye_2_x), get_transformed_value(arg2, arg0.eye_2_y), arg3, arg0.outline_color, arg0.body_color, arg0.shell_color, arg0.eye_color, arg4, arg0.hat, arg0.gun);
}
