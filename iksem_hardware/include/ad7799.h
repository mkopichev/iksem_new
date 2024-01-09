#ifndef AD7799_H
#define AD7799_H

#include "spiprot.h"
#include "utils.h"
#include <avr/io.h>
#include <stdint.h>
#include <util/delay.h>

void SET_AD7799(void);
uint16_t READ_AD7799(void);

#endif