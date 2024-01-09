#include  "../include/rgbled.h"

void led_zero(void) {
    PORTB |= (1 << 6);
    _NOP();
    PORTB &= ~(1 << 6);
    _NOP();
    _NOP();
    _NOP();
}

void led_one(void) {
    PORTB |= (1 << 6);
    _NOP();
    _NOP();
    _NOP();
    _NOP();
    PORTB &= ~(1 << 6);
}

void lights(char G, char R, char B) {
    uint8_t i;
    for(i = 0b10000000; i >= 0b00000001; i = i >> 1) {
        if((G & i) > 0)
            led_one();
        else
            led_zero();
    }

    for(i = 0b10000000; i >= 0b00000001; i = i >> 1) {
        if((R & i) > 0)
            led_one();
        else
            led_zero();
    }

    for(i = 0b10000000; i >= 0b00000001; i = i >> 1) {
        if((B & i) > 0)
            led_one();
        else
            led_zero();
    }
}