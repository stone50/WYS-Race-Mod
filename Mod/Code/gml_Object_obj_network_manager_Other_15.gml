var data_buffer = ds_map_find_value(async_load, "buffer");
var response = scr_handle_dns_response(data_buffer);
var resources = response.resources;
var domain_name = "";
var priority = -1;
var weight = 0;

for (var i = 0; i < array_length(resources); i++)
{
    var resource = resources[i];
    
    switch (resource.type)
    {
        case 1:
            if (host_ip == "")
                host_ip = resource.data;
            
            break;
        
        case 5:
        case 12:
            if (domain_name == "")
                domain_name = resource.data;
            
            break;
        
        case 33:
            var data = resource.data;
            var incoming_priority = data.priority;
            var incoming_weight = data.weight;
            
            if (priority == -1)
            {
                priority = incoming_priority;
                weight = incoming_weight;
                host_port = data.port;
                domain_name = data.target;
                break;
            }
            
            if (incoming_priority > priority)
                break;
            
            if (incoming_priority == priority && incoming_weight < weight)
                break;
            
            priority = incoming_priority;
            weight = incoming_weight;
            host_port = data.port;
            domain_name = data.target;
            break;
    }
}

if (domain_name == "")
    exit;

var questions = response.questions;
var asked_for_a = false;
var asked_for_srv = false;

for (var i = 0; i < array_length(questions); i++)
{
    switch (questions[i].type)
    {
        case 1:
            asked_for_a = true;
            break;
        
        case 33:
            asked_for_srv = true;
            break;
    }
}

if (host_port == -1 && !asked_for_srv)
{
    scr_send_dns_lookup(server, 33, domain_name);
    exit;
}

if (host_ip == "" && !asked_for_a)
    scr_send_dns_lookup(server, 1, domain_name);
