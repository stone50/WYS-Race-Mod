if (current_time >= sound_timeout)
    audio_stop_sound(sound);

if (countdown == network_manager.countdown)
    exit;

countdown = network_manager.countdown;

switch (countdown)
{
    case 3:
        audio_stop_sound(sound);
        sound = loca_sound("tutorial_skill-test_F");
        sound_timeout = current_time + 1000;
        audio_sound_set_track_position(sound, 1.4);
        audio_play_sound(sound, 0.8, false);
        break;
    
    case 2:
        audio_stop_sound(sound);
        sound = loca_sound("tutorial_skill-test_F");
        sound_timeout = current_time + 1000;
        audio_sound_set_track_position(sound, 2.7);
        audio_play_sound(sound, 0.8, false);
        break;
    
    case 1:
        audio_stop_sound(sound);
        sound = loca_sound("tutorial_skill-test_F");
        sound_timeout = current_time + 1000;
        audio_sound_set_track_position(sound, 3.91);
        audio_play_sound(sound, 0.8, false);
        break;
    
    case 0:
        audio_stop_sound(sound);
        sound = loca_sound("levelstart_C06_longrace");
        sound_timeout = current_time + 4000;
        audio_sound_set_track_position(sound, 1.35);
        audio_play_sound(sound, 0.8, false);
        audio_play_sound(sou_gunshot, 1, false);
        break;
}
