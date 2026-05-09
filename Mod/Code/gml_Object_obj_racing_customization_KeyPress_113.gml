if (visible)
{
    visible = false;
    exit;
}

var network_manager = instance_find(obj_network_manager);
network_manager.visible = false;
visible = true;
