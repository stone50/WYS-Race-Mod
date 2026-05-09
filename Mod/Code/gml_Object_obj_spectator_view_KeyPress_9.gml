if (!visible)
    exit;

var num_other_racers = ds_list_size(other_racers);

if (selected_racer == -4)
{
    if (num_other_racers != 0)
        selected_racer = ds_list_find_value(other_racers, 0);
    
    exit;
}

selected_racer_index = -1;

for (var i = 0; i < num_other_racers; i++)
{
    if (selected_racer == ds_list_find_value(other_racers, i))
    {
        selected_racer_index = i;
        break;
    }
}

if (selected_racer_index == -1)
{
    selected_racer = -4;
    exit;
}

if (selected_racer_index == (num_other_racers - 1))
{
    selected_racer = -4;
    exit;
}

selected_racer = ds_list_find_value(other_racers, selected_racer_index + 1);
