#include "../include/spiprot.h"

void SPI_MasterInit(void) {
    // DDRB.1=1; //SCK
    // PORTB.1=0;
    // DDRB.2=1; //MOSI
    // PORTB.2=1;
    // DDRB.3=0; //MISO
    // PORTB.3=0;

    DDRB |= (1 << 0) | (1 << 1) | (1 << 2); // SS, SCK, MOSI - out
    DDRB &= ~(1 << 3);                      // MISO - in
    SPCR = (1 << SPE) | (1 << MSTR) | (1 << CPOL) | (1 << CPHA);
}

uint8_t SPI_MasterReceive(void) {
    // uint8_t t, x = 0;
    // for(t = 128; t >= 1; t = t / 2) {
    //     PORTB .1 = 1;
    //     delay(100);
    //     PORTB .1 = 0;
    //     if(!PINB .3)
    //         x = x + t;
    //     delay(100);
    // }
    // return x;

    SPI_MasterTransmit(0xFF);
    while(!(SPSR & (1 << SPIF)))
        continue;
    return SPDR;
}

void SPI_MasterTransmit(uint8_t x) {
    // uint8_t t;
    // for(t = 128; t >= 1; t = t / 2) {
    //     PORTB .1 = 1;
    //     delay(200);
    //     if(x & t)
    //         PORTB .2 = 0;
    //     else
    //         PORTB .2 = 1;
    //     delay(200);
    //     PORTB .1 = 0;
    //     delay(200);
    // }
    // PORTB .2 = 1;
    // delay(300);

    SPDR = x;
    while(!(SPSR & (1 << SPIF)))
        continue;
}