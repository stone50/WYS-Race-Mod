visible = false;
persistent = true;
is_connected = false;
is_host = false;
host_ip = "127.0.0.1";
host_port = 25565;
server = -1;
buffer = buffer_create(1024, buffer_fixed, 1);
latest_packet_time = 0;
send_metadata_cooldown = 0;
other_racers = ds_list_create();
this_racer = 
{
    current_room: room,
    x: 0,
    y: 0,
    on_speedrunner_version: scr_get_is_speedrunner_version(),
    is_looking_right: true,
    house_height: 1,
    house_tilt: 0,
    eye_1_x: 8,
    eye_1_y: -15,
    eye_2_x: 20,
    eye_2_y: -15,
    checkpoints: array_create(91, 0),
    furthest_checkpoint: 0,
    placement: 0,
    diff_to_first: 0
};

process_connection_string = function()
{
    if (server == -1)
        server = network_create_socket(network_socket_udp);
    
    var handle_ipv4_or_domain = function(arg0)
    {
        var is_ipv4 = true;
        var reversed_ipv4 = "";
        var num_parts = 1;
        var end_index = string_length(arg0);
        
        for (var i = end_index; i > 0; i--)
        {
            if (string_char_at(arg0, i) != ".")
                continue;
            
            var part = string_copy(arg0, i + 1, end_index - i);
            
            if (part == "" || string_length(part) != string_length(string_digits(part)) || real(part) > 255 || ++num_parts > 4)
            {
                is_ipv4 = false;
                break;
            }
            
            reversed_ipv4 += (part + ".");
            end_index = i - 1;
        }
        
        if (is_ipv4 && num_parts == 4)
        {
            var first_part = string_copy(arg0, 1, end_index);
            
            if (first_part != "" && string_length(first_part) == string_length(string_digits(first_part)) && real(first_part) <= 255)
            {
                host_ip = arg0;
                
                if (host_port != -1)
                    scr_send_dns_lookup(server, 12, reversed_ipv4 + first_part + ".in-addr.arpa");
                
                exit;
            }
        }
        
        scr_send_dns_lookup(server, (host_port == -1) ? 33 : 1, arg0);
    };
    
    host_ip = "";
    host_port = -1;
    var colon_index = string_last_pos(":", connection_string);
    
    if (colon_index == 0)
    {
        handle_ipv4_or_domain(connection_string);
        exit;
    }
    
    if (string_pos(":", connection_string) == colon_index)
    {
        host_port = real(string_digits(string_copy(connection_string, colon_index + 1, string_length(connection_string) - colon_index)));
        handle_ipv4_or_domain(string_copy(connection_string, 1, colon_index - 1));
        exit;
    }
    
    var ipv6;
    
    if (string_char_at(connection_string, 1) == "[")
    {
        host_port = real(string_digits(string_copy(connection_string, colon_index + 1, string_length(connection_string) - colon_index)));
        ipv6 = string_copy(connection_string, 2, colon_index - 3);
    }
    else
    {
        ipv6 = connection_string;
    }
    
    var reversed_ipv6 = "";
    var last_char_was_colon = false;
    var expand_at_index = -1;
    var num_colons = 0;
    var i = string_length(ipv6);
    
    while (i > 0)
    {
        var char = string_char_at(ipv6, i);
        
        if (char == ":")
        {
            if (last_char_was_colon)
                expand_at_index = string_length(reversed_ipv6);
            
            last_char_was_colon = true;
            num_colons++;
        }
        else
        {
            last_char_was_colon = false;
            reversed_ipv6 += (char + ".");
        }
        
        i--;
    }
    
    if (expand_at_index != -1)
    {
        for (i = 0; i < ((8 - num_colons) * 4); i++)
            reversed_ipv6 = string_insert(".0", reversed_ipv6, expand_at_index);
    }
    
    scr_send_dns_lookup(server, 12, reversed_ipv6 + "ip6.arpa");
};

ini_open("racing_settings.ini");
connection_string = ini_read_string("Network", "connection_string", "127.0.0.1:25565");
ini_close();
process_connection_string();
