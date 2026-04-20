if (!is_connected)
    exit;

var type = ds_map_find_value(async_load, "type");

if (type != 3)
    exit;

latest_packet_time = current_time;

if (is_host)
    event_user(2);
else
    event_user(3);
