if (is_spectating)
    instance_activate_object(menu_main);
else
    instance_deactivate_object(menu_main);

is_spectating = !is_spectating;
