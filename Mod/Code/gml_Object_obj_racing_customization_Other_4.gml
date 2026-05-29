if (global.save_equipped_hat != this_racer.hat)
{
    global.save_equipped_hat = this_racer.hat;
    
    if (instance_exists(obj_player))
        scr_spawn_correct_hat();
}

if (auto_auto_difficulty_off && room == T_01_first_contact && global.save_speedrun_timer_game == 0)
    global.save_auto_difficulty = false;
