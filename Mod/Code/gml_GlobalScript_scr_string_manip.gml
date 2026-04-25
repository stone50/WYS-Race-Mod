function scr_string_trim_start(arg0)
{
    var len = string_length(arg0);
    var index = 1;
    
    while (index <= len && string_char_at(arg0, index) == " ")
        index++;
    
    return string_delete(arg0, 1, index - 1);
}

function scr_string_trim_end(arg0)
{
    var len = string_length(arg0);
    var index = len;
    
    while (index > 0 && string_char_at(arg0, index) == " ")
        index--;
    
    if (index == 0)
        return "";
    
    return string_copy(arg0, 1, index);
}
