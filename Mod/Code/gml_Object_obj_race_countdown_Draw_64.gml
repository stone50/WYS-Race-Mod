if (global.save_speedrun_timer_game != 0)
    exit;

draw_set_halign(fa_left);
draw_text_transformed(10, 1070, "F4 to " + (network_manager.this_racer.is_ready ? "un-ready" : "ready up"), 0.5, 0.5, 0);
