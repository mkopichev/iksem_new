#ifndef SPIPROT_H
#define SPIPROT_H

#include <avr/io.h>
#include <stdint.h>

void SPI_MasterInit(void);
uint8_t SPI_MasterReceive(void);
void SPI_MasterTransmit(uint8_t x);

#endif