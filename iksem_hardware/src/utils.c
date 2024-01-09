#include "../include/utils.h"

void delay(uint16_t d) {
    uint16_t y;
    for(y = 0; y < d; y++)
        continue;
}

uint8_t digit(uint32_t d, uint8_t m) {
    uint8_t i = 6, a;
    while(i) {      // digit-by-digit loop
        a = d % 10; // getting another digit
        // if the digit has number m (is desired) - leaving
        if(i-- == m)
            break;
        d /= 10; // decrementing value 10 times
    }
    return (a);
}

uint16_t middle(uint16_t d1, uint16_t d2, uint16_t d3) {
    if(d1 >= d2) {
        if(d1 <= d3)
            return d1;
        else {
            if(d2 >= d3)
                return d2;
            else
                return d3;
        }
    } else {
        if(d2 <= d3)
            return d2;
        else {
            if(d1 >= d3)
                return d1;
            else
                return d3;
        }
    }
}