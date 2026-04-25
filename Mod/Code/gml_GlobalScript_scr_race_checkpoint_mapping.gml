function scr_get_checkpoint_index(arg0)
{
    if (arg0 == EndGameCredits)
        return 90;
    
    var level_data_index = ds_list_find_index(global.li_lvldat_ids, arg0);
    
    switch (level_data_index)
    {
        case 0:
            return 0;
        
        case 1:
            return 0;
        
        case 7:
            return 1;
        
        case 8:
            return 2;
        
        case 9:
            return 3;
        
        case 10:
            return 4;
        
        case 11:
            return 5;
        
        case 12:
            return 6;
        
        case 15:
            return 7;
        
        case 16:
            return 8;
        
        case 17:
            return 9;
        
        case 18:
            return 10;
        
        case 20:
            return 11;
        
        case 21:
            return 12;
        
        case 22:
            return 13;
        
        case 23:
            return 14;
        
        case 24:
            return 15;
        
        case 25:
            return 16;
        
        case 26:
            return 17;
        
        case 27:
            return 18;
        
        case 28:
            return 19;
        
        case 31:
            return 20;
        
        case 36:
            return 21;
        
        case 37:
            return 22;
        
        case 38:
            return 23;
        
        case 39:
            return 24;
        
        case 40:
            return 25;
        
        case 41:
            return 26;
        
        case 42:
            return 27;
        
        case 43:
            return 28;
        
        case 44:
            return 29;
        
        case 45:
            return 30;
        
        case 46:
            return 31;
        
        case 47:
            return 32;
        
        case 48:
            return 33;
        
        case 49:
            return 34;
        
        case 50:
            return 35;
        
        case 51:
            return 36;
        
        case 55:
            return 37;
        
        case 56:
            return 38;
        
        case 57:
            return 39;
        
        case 58:
            return 40;
        
        case 59:
            return 41;
        
        case 60:
            return 42;
        
        case 61:
            return 43;
        
        case 62:
            return 44;
        
        case 63:
            return 45;
        
        case 64:
            return 46;
        
        case 66:
            return 47;
        
        case 67:
            return 48;
        
        case 68:
            return 49;
        
        case 69:
            return 50;
        
        case 70:
            return 51;
        
        case 71:
            return 52;
        
        case 72:
            return 53;
        
        case 73:
            return 54;
        
        case 74:
            return 55;
        
        case 75:
            return 56;
        
        case 80:
            return 57;
        
        case 83:
            return 58;
        
        case 89:
            return 59;
        
        case 90:
            return 60;
        
        case 91:
            return 61;
        
        case 92:
            return 62;
        
        case 94:
            return 63;
        
        case 95:
            return 64;
        
        case 96:
            return 65;
        
        case 97:
            return 66;
        
        case 98:
            return 67;
        
        case 99:
            return 68;
        
        case 100:
            return 69;
        
        case 101:
            return 70;
        
        case 102:
            return 71;
        
        case 103:
            return 72;
        
        case 104:
            return 73;
        
        case 105:
            return 74;
        
        case 109:
            return 75;
        
        case 110:
            return 76;
        
        case 112:
            return 77;
        
        case 113:
            return 78;
        
        case 114:
            return 79;
        
        case 115:
            return 80;
        
        case 116:
            return 81;
        
        case 117:
            return 82;
        
        case 118:
            return 83;
        
        case 119:
            return 84;
        
        case 120:
            return 85;
        
        case 123:
            return 86;
        
        case 124:
            return 87;
        
        case 125:
            return 88;
        
        case 126:
            return 89;
    }
    
    return -1;
}

function scr_get_checkpoint_name(arg0)
{
    static checkpoint_names = ["A0*", "A05", "A06", "A07", "A08", "A09", "A10", "A11", "A12", "A13", "A14", "A15", "A16", "A17", "A18", "A19", "A20", "A21", "B01", "B02", "B04", "B05", "B06", "B07", "B08", "B09", "B10", "B11", "B12", "B13", "B14", "B15", "B16", "B17", "B18", "B19", "C01", "C04", "C05", "C06", "C07", "C08", "C09", "C10", "C11", "C12", "C13", "C14", "C15", "C16", "C17", "C18", "C19", "C20", "C21", "C22", "D01", "D05", "D06", "D07", "D08", "D09", "D10", "D11", "D12", "D13", "D14", "D15", "D16", "D17", "D18", "D19", "D20", "E01", "E02", "E05", "E06", "E07", "E08", "E09", "E10", "E11", "E12", "E13", "E14", "E15", "E16", "E17", "E18", "E19", "FIN"];
    return checkpoint_names[arg0];
}
