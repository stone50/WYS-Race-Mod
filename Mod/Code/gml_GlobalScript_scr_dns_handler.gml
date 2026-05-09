function scr_buffer_write_u16_big_endian(arg0, arg1)
{
    buffer_write(arg0, buffer_u8, arg1 >> 8);
    buffer_write(arg0, buffer_u8, arg1);
}

function scr_set_dns_name(arg0, arg1)
{
    var part_length = 0;
    buffer_seek(arg0, buffer_seek_relative, 1);
    
    for (var i = 1; i <= string_length(arg1); i++)
    {
        var char = string_char_at(arg1, i);
        
        if (char == ".")
        {
            buffer_seek(arg0, buffer_seek_relative, -part_length - 1);
            buffer_write(arg0, buffer_u8, part_length);
            buffer_seek(arg0, buffer_seek_relative, part_length + 1);
            part_length = 0;
        }
        else
        {
            buffer_write(arg0, buffer_u8, ord(char));
            part_length++;
        }
    }
    
    buffer_seek(arg0, buffer_seek_relative, -part_length - 1);
    buffer_write(arg0, buffer_u8, part_length);
    buffer_seek(arg0, buffer_seek_relative, part_length);
    buffer_write(arg0, buffer_u8, 0);
}

function scr_send_dns_lookup(arg0, arg1, arg2)
{
    var data_buffer = buffer_create(256, buffer_grow, 1);
    scr_buffer_write_u16_big_endian(data_buffer, irandom(65535));
    scr_buffer_write_u16_big_endian(data_buffer, 256);
    scr_buffer_write_u16_big_endian(data_buffer, 1);
    scr_buffer_write_u16_big_endian(data_buffer, 0);
    scr_buffer_write_u16_big_endian(data_buffer, 0);
    scr_buffer_write_u16_big_endian(data_buffer, 0);
    scr_set_dns_name(data_buffer, arg2);
    scr_buffer_write_u16_big_endian(data_buffer, arg1);
    scr_buffer_write_u16_big_endian(data_buffer, 1);
    network_send_udp_raw(arg0, "8.8.8.8", 53, data_buffer, buffer_tell(data_buffer));
    buffer_delete(data_buffer);
}

function scr_buffer_read_u16_big_endian(arg0)
{
    return (buffer_read(arg0, buffer_u8) << 8) | buffer_read(arg0, buffer_u8);
}

function scr_buffer_read_u32_big_endian(arg0)
{
    return (buffer_read(arg0, buffer_u8) << 24) | (buffer_read(arg0, buffer_u8) << 16) | (buffer_read(arg0, buffer_u8) << 8) | buffer_read(arg0, buffer_u8);
}

function scr_get_dns_name(arg0)
{
    var name = "";
    var return_index = -1;
    
    while (true)
    {
        var name_part_length = buffer_read(arg0, buffer_u8);
        
        if (name_part_length == 0)
            break;
        
        if (name_part_length >= 192)
        {
            var pointer = ((name_part_length << 8) | buffer_read(arg0, buffer_u8)) & 16383;
            return_index = buffer_tell(arg0);
            buffer_seek(arg0, buffer_seek_start, pointer);
            name += scr_get_dns_name(arg0);
            buffer_seek(arg0, buffer_seek_start, return_index);
            return name;
        }
        
        for (var i = 0; i < name_part_length; i++)
            name += chr(buffer_read(arg0, buffer_u8));
        
        name += ".";
    }
    
    return string_copy(name, 0, string_length(name) - 1);
}

function scr_handle_dns_response(arg0)
{
    var data = {};
    data.response_id = scr_buffer_read_u16_big_endian(arg0);
    var flags = scr_buffer_read_u16_big_endian(arg0);
    data.is_response = (flags >> 15) & 1;
    data.operation_code = (flags >> 11) & 15;
    data.is_authoritative_answer = (flags >> 10) & 15;
    data.is_truncated = (flags >> 9) & 1;
    data.is_recursion_desired = (flags >> 8) & 1;
    data.is_recursion_available = (flags >> 7) & 1;
    data.response_code = flags & 15;
    data.question_count = scr_buffer_read_u16_big_endian(arg0);
    data.answer_count = scr_buffer_read_u16_big_endian(arg0);
    data.name_server_count = scr_buffer_read_u16_big_endian(arg0);
    data.additional_count = scr_buffer_read_u16_big_endian(arg0);
    data.questions = array_create(data.question_count);
    
    for (var i = 0; i < data.question_count; i++)
    {
        var question = {};
        question.name = scr_get_dns_name(arg0);
        question.type = scr_buffer_read_u16_big_endian(arg0);
        question.class = scr_buffer_read_u16_big_endian(arg0);
        data.questions[i] = question;
    }
    
    var resource_count = data.answer_count + data.name_server_count + data.additional_count;
    data.resources = array_create(resource_count);
    
    for (var i = 0; i < resource_count; i++)
    {
        var resource = {};
        resource.name = scr_get_dns_name(arg0);
        resource.type = scr_buffer_read_u16_big_endian(arg0);
        resource.class = scr_buffer_read_u16_big_endian(arg0);
        resource.time_to_live = scr_buffer_read_u32_big_endian(arg0);
        resource.data_length = scr_buffer_read_u16_big_endian(arg0);
        
        switch (resource.type)
        {
            case 1:
                resource.data = scr_handle_a_record(arg0);
                break;
            
            case 5:
            case 12:
                resource.data = scr_get_dns_name(arg0);
                break;
            
            case 33:
                resource.data = scr_handle_srv_record(arg0);
                break;
            
            default:
                buffer_seek(arg0, buffer_seek_relative, resource.data_length);
                break;
        }
        
        data.resources[i] = resource;
    }
    
    return data;
}

function scr_handle_a_record(arg0)
{
    return string(buffer_read(arg0, buffer_u8)) + "." + string(buffer_read(arg0, buffer_u8)) + "." + string(buffer_read(arg0, buffer_u8)) + "." + string(buffer_read(arg0, buffer_u8));
}

function scr_handle_srv_record(arg0)
{
    var data = {};
    data.priority = scr_buffer_read_u16_big_endian(arg0);
    data.weight = scr_buffer_read_u16_big_endian(arg0);
    data.port = scr_buffer_read_u16_big_endian(arg0);
    data.target = scr_get_dns_name(arg0);
    return data;
}
