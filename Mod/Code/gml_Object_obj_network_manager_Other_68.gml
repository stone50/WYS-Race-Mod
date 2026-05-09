var type = ds_map_find_value(async_load, "type");

if (type != 3)
    exit;

try
{
    if (!is_connected)
    {
        if (host_ip == "" || host_port == -1)
            event_user(5);
        
        exit;
    }
    
    latest_packet_time = current_time;
    
    if (is_host)
        event_user(2);
    else
        event_user(3);
}
catch (_e)
{
}
