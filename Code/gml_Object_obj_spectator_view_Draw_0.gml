draw_set_valign(fa_top);
var did_prefetch_this_frame = false;
var top_left_visible_limit = -2048 * scale;

for (var i = 0; i < 170; i++)
{
    var level_index = level_indices[i];
    var level_offset = scr_get_level_offset(level_index);
    var grid_offset = grid_offsets[i];
    var grid_x_offset = grid_offset[0];
    var grid_y_offset = grid_offset[1];
    var level_x = get_transformed_x(level_offset[0] + (2048 * grid_x_offset));
    var level_y = get_transformed_y(level_offset[1] + (2048 * grid_y_offset));
    
    if (level_x < top_left_visible_limit || level_x > 1920 || level_y < top_left_visible_limit || level_y > 1080)
        continue;
    
    var sprite = sprites[i];
    
    if (!prefetched_flags[i])
    {
        if (did_prefetch_this_frame)
        {
            continue;
        }
        else
        {
            sprite_prefetch(sprite);
            prefetched_flags[i] = true;
            did_prefetch_this_frame = true;
        }
    }
    
    draw_sprite_ext(sprite, 0, level_x, level_y, scale, scale, 0, c_white, 1);
    
    if (grid_x_offset == 0 && grid_y_offset == 0)
    {
        var level_name = ds_list_find_value(global.li_lvldat_name, level_index);
        draw_set_color(c_black);
        draw_text_transformed(level_x + (3 * scale), level_y + (3 * scale), level_name, scale, scale, 0);
        draw_set_color(c_fuchsia);
        draw_text_transformed(level_x, level_y, level_name, scale, scale, 0);
    }
}

scr_draw_mouse();
