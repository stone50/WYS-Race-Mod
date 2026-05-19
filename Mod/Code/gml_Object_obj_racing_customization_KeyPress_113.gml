if (visible)
{
    ini_open("racing_settings.ini");
    ini_write_real("Customization", "name_color", this_racer.name_color);
    ini_write_real("Customization", "outline_color", this_racer.outline_color);
    ini_write_real("Customization", "body_color", this_racer.body_color);
    ini_write_real("Customization", "shell_color", this_racer.shell_color);
    ini_write_real("Customization", "eye_color", this_racer.eye_color);
    ini_write_real("Customization", "leaderboard_background_alpha", leaderboard_background_alpha);
    ini_write_real("Customization", "leaderboard_text_alpha", leaderboard_text_alpha);
    ini_write_real("Customization", "leaderboard_scale", leaderboard_scale);
    ini_write_real("Customization", "other_racers_alpha", other_racers_alpha);
    ini_write_real("Customization", "other_racer_names_alpha", other_racer_names_alpha);
    ini_write_real("Customization", "other_racer_names_scale", other_racer_names_scale);
    ini_close();
    visible = false;
    exit;
}

var network_manager = instance_find(obj_network_manager);
network_manager.visible = false;
visible = true;
