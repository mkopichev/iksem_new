#include <mega128a.h>
#include <delay.h>

#define none lights(0, 0, 0)

void zeros(void);
void ones(void);
void clearall(void);
void lights(char G, char R, char B);

void main(void)
{
    DDRC = (1 << 0) | (1 << 1);
    DDRB = (1 << 6);
    PORTC = 1;                     
    clearall();
    
    while(1)
    { 
        delay_ms(3000);
        PORTC |= (1 << 1);
        lights(0, 255, 0);
        delay_ms(3000);
        PORTC &= ~(1 << 1);
        lights(0, 0, 255);       
    }
}

void zeros(void)
{
    PORTB = (1 << 6);
    #asm("nop");
    PORTB &= ~(1 << 6);
    #asm("nop");
    #asm("nop");
    #asm("nop");
}

void ones(void)
{
    PORTB = (1 << 6);
    #asm("nop");
    #asm("nop");
    #asm("nop");
    #asm("nop");
    PORTB &= ~(1 << 6); 
}

void lights(char G, char R, char B)
{
    unsigned char i;
    for(i = 0b10000000; i >= 0b00000001; i = i >> 1)
    {
        if((G & i) > 0)
            ones();
        else
            zeros();            
    } 
     
    for(i = 0b10000000; i >= 0b00000001; i = i >> 1)
    {
        if((R & i) > 0)
            ones();
        else
            zeros();            
    }  
    
    for(i = 0b10000000; i >= 0b00000001; i = i >> 1)
    {
        if((B & i) > 0)
            ones();
        else
            zeros();            
    }
}

void clearall(void)
{
    unsigned char i;
    for(i = 0; i < 9; i++)
    {
        none;
    }
    delay_ms(10);
}