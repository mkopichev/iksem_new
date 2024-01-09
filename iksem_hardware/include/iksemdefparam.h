#ifndef IKSEMDEFPARAM_H
#define IKSEMDEFPARAM_H

#ifdef IKS01
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CALIBR_MAIN_DATA N01
#define N_string "AT+NAMEIKSEM#01\r\n"
// uint16_t WEIGHT_NULL=7039, LOADCELL_NULL=1807, DELTA_WEIGHT10KG=842, DELTA_LOADCELL10KG=513;
// uint16_t WEIGHT_NULL=7023, LOADCELL_NULL=1900, DELTA_WEIGHT10KG=834, DELTA_LOADCELL10KG=508;
uint16_t WEIGHT_NULL = 6752, LOADCELL_NULL = 2089, DELTA_WEIGHT10KG = 800, DELTA_LOADCELL10KG = 475; // march 17 2023 Mishanja
uint16_t R_IK = 202, R_TK = 333, ZADANIE_S = 15;
uint8_t SETUP_MAS[8] = {0, 0, 0, 0, 0, 0, 0, 0};
uint8_t CALIBR_MAS[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
uint8_t DEFAULT_SETUP_MAS[8] = {248, 202, 133, 15, 1, 0, 0, (202 + 133 + 15 + 1) / 6};
// uint8_t DEFAULT_CALIBR_MAS[10]={249,70,39,18,7,8,42,5,13,(70+39+18+7+8+42+5+13)/8};
// uint8_t DEFAULT_CALIBR_MAS[10]={249,70,23,19,0,8,34,5,8,(70+23+19+0+8+34+5+8)/8};
uint8_t DEFAULT_CALIBR_MAS[10] = {249, 67, 52, 20, 89, 8, 0, 4, 75, (67 + 52 + 20 + 89 + 8 + 0 + 4 + 75) / 8};
int ADC_0_KG = 1524, ADC_100_KG = 6759;
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CALIBR_MAIN_DATA N01
#endif

#ifdef IKS02
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CALIBR_MAIN_DATA N02
#define N_string "AT+NAMEIKSEM#02\r\n"
// uint16_t WEIGHT_NULL=6846, LOADCELL_NULL=400, DELTA_WEIGHT10KG=835, DELTA_LOADCELL10KG=495;
// uint16_t WEIGHT_NULL=6914, LOADCELL_NULL=395, DELTA_WEIGHT10KG=863, DELTA_LOADCELL10KG=511;
uint16_t WEIGHT_NULL = 6838, LOADCELL_NULL = 364, DELTA_WEIGHT10KG = 856, DELTA_LOADCELL10KG = 516;
uint16_t R_IK = 202, R_TK = 333, ZADANIE_S = 15;
uint8_t SETUP_MAS[8] = {0, 0, 0, 0, 0, 0, 0, 0};
uint8_t CALIBR_MAS[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
uint8_t DEFAULT_SETUP_MAS[8] = {248, 202, 133, 15, 1, 0, 0, (202 + 133 + 15 + 1) / 6};
// uint8_t DEFAULT_CALIBR_MAS[10]={249,68,46,4,0,8,35,4,95,(68+46+4+0+8+35+4+95)/8};
// uint8_t DEFAULT_CALIBR_MAS[10]={249,69,14,3,95,8,63,5,11,(69+14+3+95+8+63+5+11)/8};
uint8_t DEFAULT_CALIBR_MAS[10] = {249, 68, 38, 3, 64, 8, 56, 5, 16, (68 + 38 + 3 + 64 + 8 + 56 + 5 + 16) / 8};

uint8_t ADC_0_KG = 88, ADC_100_KG = 6759;
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CALIBR_MAIN_DATA N02
#endif

#ifdef IKS03
////!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CALIBR_MAIN_DATA N03
#define N_string "AT+NAMEIKSEM#03\r\n"
// uint16_t WEIGHT_NULL=6944, LOADCELL_NULL=313, DELTA_WEIGHT10KG=825, DELTA_LOADCELL10KG=495;
uint16_t WEIGHT_NULL = 7093, LOADCELL_NULL = 402, DELTA_WEIGHT10KG = 843, DELTA_LOADCELL10KG = 500;
uint16_t R_IK = 202, R_TK = 333, ZADANIE_S = 15;
uint8_t SETUP_MAS[8] = {0, 0, 0, 0, 0, 0, 0, 0};
uint8_t CALIBR_MAS[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
uint8_t DEFAULT_SETUP_MAS[8] = {248, 202, 133, 15, 1, 0, 0, (202 + 133 + 15 + 1) / 6};
// uint8_t DEFAULT_CALIBR_MAS[10]={249,69,44,3,13,8,25,4,95,(69+44+3+13+8+25+4+95)/8};
uint8_t DEFAULT_CALIBR_MAS[10] = {249, 70, 93, 4, 2, 8, 43, 5, 0, (70 + 93 + 4 + 2 + 8 + 43 + 5 + 0) / 8};

uint8_t ADC_0_KG = 88, ADC_100_KG = 6759;
////!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CALIBR_MAIN_DATA N03
#endif

#ifdef IKS04
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!PCS_WITHOUT_TELEGA
#define N_string "AT+NAMEIKSEM#04\r\n"
uint16_t WEIGHT_NULL = 6752, LOADCELL_NULL = 2089, DELTA_WEIGHT10KG = 800, DELTA_LOADCELL10KG = 475; // march 17 2023 Mishanja
uint16_t R_IK = 202, R_TK = 333, ZADANIE_S = 15;
uint8_t SETUP_MAS[8] = {0, 0, 0, 0, 0, 0, 0, 0};
uint8_t CALIBR_MAS[10] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
uint8_t DEFAULT_SETUP_MAS[8] = {248, 202, 133, 15, 1, 0, 0, (202 + 133 + 15 + 1) / 6};
uint8_t DEFAULT_CALIBR_MAS[10] = {249, 67, 52, 20, 89, 8, 0, 4, 75, (67 + 52 + 20 + 89 + 8 + 0 + 4 + 75) / 8};
int ADC_0_KG = 1524, ADC_100_KG = 6759;
#endif

#endif