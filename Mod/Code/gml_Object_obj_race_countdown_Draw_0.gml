if (countdown == -1)
    exit;

draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_fuchsia);
draw_text_transformed(550, 660, (countdown == 0) ? "GO!" : string(countdown), 1, 1, 0);
