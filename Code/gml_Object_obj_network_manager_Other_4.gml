if (room == T_01_first_contact && global.save_speedrun_timer_game == 0)
{
    for (var i = 0; i < 91; i++)
        this_racer.checkpoints[i] = 0;
    
    this_racer.furthest_checkpoint = 0;
    exit;
}

var level_transition = instance_find(obj_level_transition);

if (level_transition == -4)
    exit;

var checkpoint = scr_get_checkpoint_index(room);

if (checkpoint == -1)
    exit;

if (this_racer.checkpoints[checkpoint] != 0)
    exit;

this_racer.checkpoints[checkpoint] = level_transition.sr_game;
this_racer.furthest_checkpoint = max(this_racer.furthest_checkpoint, checkpoint);
