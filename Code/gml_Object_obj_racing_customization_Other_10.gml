var player = instance_find(obj_player);

if (player == -4)
    exit;

var this_racer = network_manager.this_racer;
player.col_snail_outline = this_racer.outline_color;
player.col_snail_body = this_racer.body_color;
player.col_snail_shell = this_racer.shell_color;
player.col_snail_eye = this_racer.eye_color;
player.eye1.col_snail_outline = this_racer.outline_color;
player.eye1.col_snail_body = this_racer.body_color;
player.eye1.col_snail_shell = this_racer.shell_color;
player.eye1.col_snail_eye = this_racer.eye_color;
player.eye2.col_snail_outline = this_racer.outline_color;
player.eye2.col_snail_body = this_racer.body_color;
player.eye2.col_snail_shell = this_racer.shell_color;
player.eye2.col_snail_eye = this_racer.eye_color;
