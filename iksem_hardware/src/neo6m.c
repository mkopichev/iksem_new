#include "../include/neo6m.h"

uint8_t GPS_zap_counter = 0, GPS_sim_counter = 0, GPS_flag_ready = 0; // 1-ustanovlen 0-ne ustanovlen
uint8_t GPS_string_name[3] = {0, 0, 0}, GPS_flag_gp = 0;              // 0-no 1-1 bukva posle P, 2-2ya, 3-3ya, 4-GGA
uint16_t GPS_shir[4] = {1, 1, 1, 1}, GPS_dolg[4] = {1, 1, 1, 1};      // grad min .xxxx  NSWE
uint8_t GPS_solve = 0;
uint8_t GPS_ON_COUNTER = 0;

// USART0 Receiver interrupt service routine
ISR(USART0_RX_vect) {
    char simvol;
    simvol = UDR0;

    if(simvol == 'P') {
        GPS_flag_gp = 1;
        GPS_zap_counter = 0;
        return;
        // goto exit_int;
    }
    if(GPS_flag_gp == 1) {
        GPS_string_name[0] = simvol;
        GPS_flag_gp = 2;
        return;
        // goto exit_int;
    }
    if(GPS_flag_gp == 2) {
        GPS_string_name[1] = simvol;
        GPS_flag_gp = 3;
        return;
        // goto exit_int;
    }
    if(GPS_flag_gp == 3) {
        GPS_string_name[2] = simvol;
        if(GPS_string_name[0] == 'G' && GPS_string_name[1] == 'G' && GPS_string_name[2] == 'A') {
            GPS_flag_gp = 4;
            GPS_flag_ready = 0;
        } else
            GPS_flag_gp = 0;
        return;
        // goto exit_int;
    }

    if((GPS_flag_gp == 4) && (simvol == ',')) {
        GPS_zap_counter++;
        GPS_sim_counter = 0;
        return;
        // goto exit_int;
    }

    if(GPS_flag_gp == 4) {

        if(GPS_zap_counter == 2) // shir
        {
            switch(GPS_sim_counter) {
            case 0:
                GPS_shir[0] = (simvol - 48) * 10;
                break;
            case 1:
                GPS_shir[0] = GPS_shir[0] + (simvol - 48);
                break;
            case 2:
                GPS_shir[1] = (simvol - 48) * 10;
                break;
            case 3:
                GPS_shir[1] = GPS_shir[1] + (simvol - 48);
                break;
            case 5:
                GPS_shir[2] = (simvol - 48) * 1000;
                break;
            case 6:
                GPS_shir[2] = GPS_shir[2] + (simvol - 48) * 100;
                break;
            case 7:
                GPS_shir[2] = GPS_shir[2] + (simvol - 48) * 10;
                break;
            case 8:
                GPS_shir[2] = GPS_shir[2] + (simvol - 48);
            }
            GPS_sim_counter++;

            return;
            // goto exit_int;
        }
        if(GPS_zap_counter == 3) {
            GPS_shir[3] = simvol;
            return;
            // goto exit_int;
        }
        if(GPS_zap_counter == 4) // dolg
        {
            switch(GPS_sim_counter) {
            case 0:
                GPS_dolg[0] = (simvol - 48) * 100;
                break;
            case 1:
                GPS_dolg[0] = GPS_dolg[0] + (simvol - 48) * 10;
                break;
            case 2:
                GPS_dolg[0] = GPS_dolg[0] + (simvol - 48);
                break;
            case 3:
                GPS_dolg[1] = (simvol - 48) * 10;
                break;
            case 4:
                GPS_dolg[1] = GPS_dolg[1] + (simvol - 48);
                break;
            case 6:
                GPS_dolg[2] = (simvol - 48) * 1000;
                break;
            case 7:
                GPS_dolg[2] = GPS_dolg[2] + (simvol - 48) * 100;
                break;
            case 8:
                GPS_dolg[2] = GPS_dolg[2] + (simvol - 48) * 10;
                break;
            case 9:
                GPS_dolg[2] = GPS_dolg[2] + (simvol - 48);
            }
            GPS_sim_counter++;
            return;
            // goto exit_int;
        }
        if(GPS_zap_counter == 5) {
            GPS_dolg[3] = simvol;
            return;
            // goto exit_int;
        }
        if(GPS_zap_counter == 6) {
            GPS_solve = simvol;
            GPS_flag_ready = 1;
            GPS_flag_gp = 0;
            GPS_zap_counter = 0;
            GPS_ON_COUNTER = 0;

            SEND_MAS[12] = 1;

            SEND_MAS[13] = (uint8_t)GPS_shir[0];
            SEND_MAS[14] = (uint8_t)GPS_shir[1];
            SEND_MAS[15] = (uint8_t)(GPS_shir[2] / 100);
            SEND_MAS[16] = (uint8_t)(GPS_shir[2] % 100);

            SEND_MAS[17] = (uint8_t)GPS_dolg[0];
            SEND_MAS[18] = (uint8_t)GPS_dolg[1];
            SEND_MAS[19] = (uint8_t)(GPS_dolg[2] / 100);
            SEND_MAS[20] = (uint8_t)(GPS_dolg[2] % 100);

            SEND_MAS[21] = (uint8_t)GPS_shir[3];
            SEND_MAS[22] = (uint8_t)GPS_dolg[3];
        }
    }

    // exit_int:
}