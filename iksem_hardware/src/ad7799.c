#include "../include/ad7799.h"

void SET_AD7799(void) {
    _delay_ms(100);
    SPI_MasterTransmit(0b11111111);
    SPI_MasterTransmit(0b11111111);
    SPI_MasterTransmit(0b11111111);
    SPI_MasterTransmit(0b11111111);
    _delay_ms(100);
    SPI_MasterTransmit(0x10); // conf
    delay(10000);
    // #ifdef ADC_TO_KG
    // SPI_MasterTransmit(0b00000111); //bipolar and *128
    // #else
    SPI_MasterTransmit(0b00010111); // unipolar and *128
    // #endif
    SPI_MasterTransmit(0b00010000);
    delay(10000);

    SPI_MasterTransmit(0x08); // mode
    delay(10000);
    SPI_MasterTransmit(0b00000000);
    // SPI_MasterTransmit(0b00001111);

    SPI_MasterTransmit(0b00001100); // 10Hz
    // SPI_MasterTransmit(0b00001000);//20Hz
    delay(10000);
    SPI_MasterTransmit(0x5C);
    delay(10000);
}

uint16_t READ_AD7799(void) {
    uint8_t a1, a2;
    uint16_t M;
    delay(100);
    a1 = SPI_MasterReceive();
    a2 = SPI_MasterReceive();
    SPI_MasterReceive();
    M = (uint16_t)a1 * 256 + (uint16_t)a2;
    return M;
    // return a2;
}