function scr_get_checkpoint_index(arg0)
{
    switch (arg0)
    {
        case 6:
            return 0;
        
        case 7:
            return 0;
        
        case 12:
            return 1;
        
        case 13:
            return 2;
        
        case 14:
            return 3;
        
        case 15:
            return 4;
        
        case 16:
            return 5;
        
        case 17:
            return 6;
        
        case 20:
            return 7;
        
        case 21:
            return 8;
        
        case 22:
            return 9;
        
        case 23:
            return 10;
        
        case 25:
            return 11;
        
        case 26:
            return 12;
        
        case 27:
            return 13;
        
        case 28:
            return 14;
        
        case 29:
            return 15;
        
        case 30:
            return 16;
        
        case 31:
            return 17;
        
        case 32:
            return 18;
        
        case 33:
            return 19;
        
        case 36:
            return 20;
        
        case 41:
            return 21;
        
        case 42:
            return 22;
        
        case 43:
            return 23;
        
        case 44:
            return 24;
        
        case 45:
            return 25;
        
        case 46:
            return 26;
        
        case 47:
            return 27;
        
        case 48:
            return 28;
        
        case 49:
            return 29;
        
        case 50:
            return 30;
        
        case 51:
            return 31;
        
        case 52:
            return 32;
        
        case 53:
            return 33;
        
        case 54:
            return 34;
        
        case 55:
            return 35;
        
        case 56:
            return 36;
        
        case 60:
            return 37;
        
        case 61:
            return 38;
        
        case 62:
            return 39;
        
        case 63:
            return 40;
        
        case 64:
            return 41;
        
        case 65:
            return 42;
        
        case 66:
            return 43;
        
        case 67:
            return 44;
        
        case 68:
            return 45;
        
        case 69:
            return 46;
        
        case 71:
            return 47;
        
        case 72:
            return 48;
        
        case 73:
            return 49;
        
        case 74:
            return 50;
        
        case 75:
            return 51;
        
        case 76:
            return 52;
        
        case 77:
            return 53;
        
        case 78:
            return 54;
        
        case 79:
            return 55;
        
        case 80:
            return 56;
        
        case 85:
            return 57;
        
        case 88:
            return 58;
        
        case 94:
            return 59;
        
        case 95:
            return 60;
        
        case 96:
            return 61;
        
        case 97:
            return 62;
        
        case 99:
            return 63;
        
        case 100:
            return 64;
        
        case 101:
            return 65;
        
        case 102:
            return 66;
        
        case 103:
            return 67;
        
        case 104:
            return 68;
        
        case 105:
            return 69;
        
        case 106:
            return 70;
        
        case 107:
            return 71;
        
        case 108:
            return 72;
        
        case 109:
            return 73;
        
        case 110:
            return 74;
        
        case 114:
            return 75;
        
        case 115:
            return 76;
        
        case 117:
            return 77;
        
        case 118:
            return 78;
        
        case 119:
            return 79;
        
        case 120:
            return 80;
        
        case 121:
            return 81;
        
        case 122:
            return 82;
        
        case 123:
            return 83;
        
        case 124:
            return 84;
        
        case 125:
            return 85;
        
        case 128:
            return 86;
        
        case 129:
            return 87;
        
        case 130:
            return 88;
        
        case 131:
            return 89;
        
        case 133:
            return 90;
    }
    
    return -1;
}

function scr_get_checkpoint_name(arg0)
{
    var checkpoint_names = ["A0*", "A05", "A06", "A07", "A08", "A09", "A10", "A11", "A12", "A13", "A14", "A15", "A16", "A17", "A18", "A19", "A20", "A21", "B01", "B02", "B04", "B05", "B06", "B07", "B08", "B09", "B10", "B11", "B12", "B13", "B14", "B15", "B16", "B17", "B18", "B19", "C01", "C04", "C05", "C06", "C07", "C08", "C09", "C10", "C11", "C12", "C13", "C14", "C15", "C16", "C17", "C18", "C19", "C20", "C21", "C22", "D01", "D05", "D06", "D07", "D08", "D09", "D10", "D11", "D12", "D13", "D14", "D15", "D16", "D17", "D18", "D19", "D20", "E01", "E02", "E05", "E06", "E07", "E08", "E09", "E10", "E11", "E12", "E13", "E14", "E15", "E16", "E17", "E18", "E19", "FIN"];
    return checkpoint_names[arg0];
}
