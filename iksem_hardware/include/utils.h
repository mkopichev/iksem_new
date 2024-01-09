#ifndef UTILS_H
#define UTILS_H

// #define F_CPU 11059200

#include <avr/cpufunc.h>
#include <avr/eeprom.h>
#include <avr/interrupt.h>
#include <avr/io.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <util/delay.h>

void delay(uint16_t d);
uint8_t digit(uint32_t d, uint8_t m);
uint16_t middle(uint16_t d1, uint16_t d2, uint16_t d3);

#endif