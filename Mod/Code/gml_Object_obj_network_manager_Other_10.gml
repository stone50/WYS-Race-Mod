if (!visible)
    exit;

if (!device_mouse_check_button_released(0, mb_left))
    exit;

var gui_mouse_x = device_mouse_x_to_gui(0);

if (gui_mouse_x < 10 || gui_mouse_x > 390)
    exit;

var gui_mouse_y = device_mouse_y_to_gui(0);

if (gui_mouse_y >= 610 && gui_mouse_y <= 660)
{
    if (is_connected)
    {
        is_connected = false;
        
        if (server != -1)
        {
            network_destroy(server);
            server = -1;
        }
        
        ds_list_clear(other_racers);
        this_racer.placement = 0;
        this_racer.diff_to_first = 0;
    }
    else
    {
        var port = is_host ? host_port : 0;
        var num_max_connections = is_host ? 16 : 1;
        server = network_create_server_raw(1, port, num_max_connections);
        is_connected = true;
    }
}
else if (gui_mouse_y >= 710 && gui_mouse_y <= 760)
{
    if (is_connected)
        show_message("Disconnect before changing connection info");
    else
        is_host = !is_host;
}
else if (gui_mouse_y >= 810 && gui_mouse_y <= 860)
{
    if (is_connected)
    {
        show_message("Disconnect before changing connection info");
    }
    else
    {
        var new_host_ip = get_string("Host IP", host_ip);
        
        if (new_host_ip != "")
            host_ip = new_host_ip;
    }
}
else if (gui_mouse_y >= 910 && gui_mouse_y <= 960)
{
    if (is_connected)
    {
        show_message("Disconnect before changing connection info");
    }
    else
    {
        var new_host_port = get_integer("Host Port", host_port);
        
        if (is_numeric(new_host_port))
            host_port = new_host_port;
    }
}
