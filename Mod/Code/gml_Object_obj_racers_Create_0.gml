persistent = true;
other_racers = instance_find(obj_network_manager).other_racers;
racing_customization = instance_find(obj_racing_customization);
original_depth = depth;

function transform_value_closure_transform(arg0, arg1)
{
    return arg1[0](arg0 + arg1[1]);
};

function add_closure_transform(arg0, arg1)
{
    return arg0 + arg1[0];
};

nothing_closure = 
{
    transform: function(arg0, arg1)
    {
        return arg0;
    },
    
    args: []
};
