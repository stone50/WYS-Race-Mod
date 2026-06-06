allow_ready_up = room == T_01_first_contact && global.save_speedrun_timer_game == 0;
this_racer.is_ready = allow_ready_up && this_racer.is_ready;

if (!visible)
    exit;

if (!device_mouse_check_button_released(0, mb_left))
    exit;

var gui_mouse_x = device_mouse_x_to_gui(0);

if (gui_mouse_x < 10 || gui_mouse_x > 390)
    exit;

var gui_mouse_y = device_mouse_y_to_gui(0);

if (gui_mouse_y >= 700 && gui_mouse_y <= 848)
{
    if (host_ip == "" || host_port == -1)
        exit;
    
    if (server != -1)
    {
        network_destroy(server);
        server = -1;
    }
    
    if (is_connected)
    {
        is_connected = false;
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
else if (gui_mouse_y >= 858 && gui_mouse_y <= 957)
{
    if (is_connected)
    {
        show_message("Disconnect before changing connection info");
    }
    else
    {
        var input = get_string("Connection String (default is 127.0.0.1:25565)" + server_list_string, connection_string);
        
        if (input == "")
            exit;
        
        connection_string = input;
        ini_open("racing_settings.ini");
        ini_write_string("Network", "connection_string", connection_string);
        ini_close();
        process_connection_string();
    }
}
else if (gui_mouse_y >= 967 && gui_mouse_y <= 1041)
{
    if (is_connected)
        show_message("Disconnect before changing connection info");
    else
        is_host = !is_host;
}
