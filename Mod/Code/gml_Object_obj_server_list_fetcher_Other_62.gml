if (ds_map_find_value(async_load, "id") != request_id)
    exit;

if (ds_map_find_value(async_load, "status") != 0)
{
    instance_destroy(self);
    exit;
}

var json_string = ds_map_find_value(async_load, "result");

try
{
    var server_list = json_parse(json_string);
    var network_manager = instance_find(obj_network_manager);
    network_manager.server_list_string += "\nServers:";
    for (var i = 0; i < array_length(server_list); i++)
    {
        network_manager.server_list_string += "\n";
        var server_info = server_list[i];
        
        if (server_info.name != "")
            network_manager.server_list_string += server_info.name + " - ";
        
        network_manager.server_list_string += server_info.connection_string;
    }
}
catch (_e)
{
}
finally
{
    instance_destroy(self);
}
