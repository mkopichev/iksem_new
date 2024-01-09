/*****************************************************
This program was produced by the
CodeWizardAVR V2.03.4 Standard
Automatic Program Generator
© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 15.07.2010
Author  : 
Company : 
Comments: 


Chip type           : ATmega1281
Program type        : Application
Clock frequency     : 11,059200 MHz
Memory model        : Small
External RAM size   : 0
Data Stack size     : 2048
*****************************************************/

#include <mega1281.h>

//#include <delay.h>

#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)



#define ADC_VREF_TYPE 0x40


unsigned char MASSIV[32]={103,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}, flag_mas_ready=0;
unsigned int R_IK=200, R_TK=340;
char ovf_IK=0, ovf_TK=0;
long IK_COUNT[2]={0,0}, TK_COUNT[2]={0,0}, IK_DELTA=0, TK_DELTA=0;
int IK_SPEED_KM_H=0,TK_SPEED_KM_H=0;
unsigned char BYTE_TD[4]={0,0,0,0},tmp_count=0;

unsigned int adc_data=0,flag_td_ready=0;
int TD_COUNTER=0;



unsigned char GPS_zap_counter=0,GPS_sim_counter=0,GPS_flag_ready=0;//1-ustanovlen 0-ne ustanovlen
unsigned char GPS_string_name[3]={0,0,0},GPS_flag_gp=0;//0-no 1-1 bukva posle P, 2-2ya, 3-3ya, 4-GGA
unsigned int GPS_shir[4]={1,1,1,1},GPS_dolg[4]={1,1,1,1};//grad min .xxxx  NSWE


// USART0 Receiver interrupt service routine
interrupt [USART0_RXC] void usart0_rx_isr(void)
{
char simvol;
simvol=UDR0;
    
     if(simvol=='P')
   {
    GPS_flag_gp=1;
    GPS_zap_counter=0;
    goto exit_int;
   }
    if(GPS_flag_gp==1)
   {
    GPS_string_name[0]=simvol;
    GPS_flag_gp=2;
    goto exit_int;
   }
    if(GPS_flag_gp==2)
   {
    GPS_string_name[1]=simvol;
    GPS_flag_gp=3;
    goto exit_int;
   }
    if(GPS_flag_gp==3)
   {
    GPS_string_name[2]=simvol;
    if(GPS_string_name[0]=='G'&&GPS_string_name[1]=='G'&&GPS_string_name[2]=='A')
      {GPS_flag_gp=4;
       GPS_flag_ready=0;}
    else
     GPS_flag_gp=0;   
    goto exit_int;
   }
      
    if(GPS_flag_gp==4&&simvol==',')
    {
     GPS_zap_counter++;
     GPS_sim_counter=0;
     goto exit_int;
    }


   if(GPS_flag_gp==4)
   {
    
    if(GPS_zap_counter==2)//shir
    {
     switch(GPS_sim_counter)
     {
      case 0:
    GPS_shir[0]=(simvol-48)*10;
      break;
      case 1:
    GPS_shir[0]=GPS_shir[0]+(simvol-48);
      break;
      case 2:
       GPS_shir[1]=(simvol-48)*10;
      break;
      case 3:
       GPS_shir[1]=GPS_shir[1]+(simvol-48);
      break;
      case 5:
       GPS_shir[2]=(simvol-48)*1000;
      break;
      case 6:
       GPS_shir[2]=GPS_shir[2]+(simvol-48)*100;
      break;
      case 7:
       GPS_shir[2]=GPS_shir[2]+(simvol-48)*10;
      break;
      case 8:
       GPS_shir[2]=GPS_shir[2]+(simvol-48);
     }
     GPS_sim_counter++;
     goto exit_int;
    }
   if(GPS_zap_counter==3)
    GPS_shir[3]=simvol;
   if(GPS_flag_gp==4&&GPS_zap_counter==4)//shir
    {
     switch(GPS_sim_counter)
     {
      case 0:
    GPS_dolg[0]=(simvol-48)*100;
      break;
      case 1:
    GPS_dolg[0]=GPS_dolg[0]+(simvol-48)*10;
      break;
      case 2:
    GPS_dolg[0]=GPS_dolg[0]+(simvol-48);
      break;
      case 3:
       GPS_dolg[1]=(simvol-48)*10;
      break;
      case 4:
       GPS_dolg[1]=GPS_dolg[1]+(simvol-48);
      break;
      case 6:
       GPS_dolg[2]=(simvol-48)*1000;
      break;
      case 7:
       GPS_dolg[2]=GPS_dolg[2]+(simvol-48)*100;
      break;
      case 8:
       GPS_dolg[2]=GPS_dolg[2]+(simvol-48)*10;
      break;
      case 9:
       GPS_dolg[2]=GPS_dolg[2]+(simvol-48);
     }
     GPS_sim_counter++;
     goto exit_int;
    }
   if(GPS_zap_counter==5)
   {
    GPS_dolg[3]=simvol;
    GPS_flag_ready=1;
     GPS_zap_counter=0;
     GPS_sim_counter=0;
   } 
  }
       
 
 exit_int:
 
}















//SPEED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//SPEED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//SPEED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// External Interrupt 4 service routine
interrupt [INT4] void ext_int4_isr(void) //IK_SPEED
{
 char H,L;
 IK_COUNT[0]=IK_COUNT[1];
 L=TCNT1L;
 H=TCNT1H;
 IK_COUNT[1]=(long)H*256+(long)L;
 if(ovf_IK>0)
 {
  if(ovf_IK==2)
  {
   IK_DELTA=0;
   IK_COUNT[0]=0;
   IK_COUNT[1]=0;
  }
  else
  {
   IK_DELTA=(65536-IK_COUNT[0])+IK_COUNT[1];
  } 
  ovf_IK=0;
 }
 else
 {
  IK_DELTA=IK_COUNT[1]-IK_COUNT[0];
 }
}

// External Interrupt 5 service routine
interrupt [INT5] void ext_int5_isr(void) //TK_SPEED
{
 char H,L;
 TK_COUNT[0]=TK_COUNT[1];
 L=TCNT1L;
 H=TCNT1H;
 TK_COUNT[1]=(long)H*256+(long)L;
 if(ovf_TK>0)
 {
  if(ovf_TK==2)
  {
   TK_DELTA=0;
   TK_COUNT[0]=0;
   TK_COUNT[1]=0;
  }
  else
  {
   TK_DELTA=(65536-TK_COUNT[0])+TK_COUNT[1];
  } 
  ovf_TK=0;
 }
 else
 {
  TK_DELTA=TK_COUNT[1]-TK_COUNT[0];
 }
}


// Timer 1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
if(ovf_IK<2)
 {
  ovf_IK++;  
 }
if(ovf_TK<2)
 {
  ovf_TK++; 
 }
}
//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************





// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
 int N_BYTE,N_BIT;
 char tmp,x; 
 TCNT0=0xC0;//192 частота приемника в 4 раза юольше чем у передатчика
 
 if(TD_COUNTER==0)
 {
  if(PINC.0==1)
  TD_COUNTER++;
 }
 else
 {
  if(TD_COUNTER<35)
  {
   if(PINC.0==0)
    {
     TD_COUNTER=0;
     goto end;
    }
    goto end2;  
  }
 
  if((TD_COUNTER==37||TD_COUNTER==38)&&PINC.0==1)
  {
   TD_COUNTER=0;
   goto end;
  }
  
  if(TD_COUNTER==41)
  {
   flag_td_ready=0;
    BYTE_TD[0]=0;
    BYTE_TD[1]=0;
    BYTE_TD[2]=0;
    BYTE_TD[3]=0;
    tmp_count=0;
  }
  if(TD_COUNTER>=41)
  {
    if(tmp_count==0)
   {
    N_BYTE=((TD_COUNTER-41)/4)/8;
    N_BIT=((TD_COUNTER-41)/4)-N_BYTE*8;
    tmp=128;
     for(x=0;x<N_BIT;x++)
      tmp=tmp/2;
     if(PINC.0==1) 
      BYTE_TD[N_BYTE]=BYTE_TD[N_BYTE]+tmp;
   }
   tmp_count++;
   if(tmp_count==4)
    tmp_count=0;
   if(TD_COUNTER>=166)
    {
     flag_td_ready=1;
     TD_COUNTER=0;
     goto end;
    }
    
  }
  end2:
  TD_COUNTER++; 
 }
 end:
 
 
}





void delay(unsigned int d)
{              
 unsigned int y;
 for(y=0;y<d;y++)
 {
 }
}

void start_I2C (void) 
 {           
  DDRA.2=0;//(1)
  delay(20);
  PORTA.3=1;
  delay(20);
  DDRA.2=1;//(0)   
  delay(20);
  PORTA.3=0;
  delay(20);
 }          
        
  void stop_I2C (void) 
 {         
  DDRA.2=1;
  delay(20);
  PORTA.3=1;
  delay(20);
  DDRA.2=0;//(1)   
  delay(20);
 } 
        
 
 void write_I2C(char x)
 {
  char t;
  for(t=128;t>=1;t=t/2)         
 {
 if(x&t)
  DDRA.2=0; 
 else       
  DDRA.2=1; 
 delay(20);                    
 PORTA.3=1;
 delay(20);
 PORTA.3=0;
 delay(20);
 }          
 DDRA.2=0; 
 delay(20);
 PORTA.3=1;
 delay(20);  
 PORTA.3=0;
 delay(20); 
 }             
 
 char read_I2C(void)
 {   
   char t,x=0;
 
  for(t=128;t>=1;t=t/2)         
  {      
   PORTA.3=1;
   delay(20);
  if(PINA.2==1)    
   x=x+t;
   PORTA.3=0;
   delay(20);                              
  }        
   DDRA.2=0;
   delay(20);
   PORTA.3=1;
   delay(20);
   PORTA.3=0;
   delay(20);
   return x;
 }
 
 
  
void SET_DS1631(void)
{
   start_I2C();
   write_I2C(0x9E);
   write_I2C(0xAC);
   write_I2C(0xF3);
   stop_I2C();     
   delay(10000);
}

void START_DS1631(void)
{
 start_I2C();
 write_I2C(0x9E);  
 write_I2C(0x51);
 stop_I2C();
}

int READ_TEMP_DS1631(void)
{
   int a;
   start_I2C();
   write_I2C(0x9E);
   write_I2C(0xAA);  
   start_I2C(); 
   write_I2C(0x9F);
   a=read_I2C();
   read_I2C();
   stop_I2C();
   if(a>=128)
    a=a-256;
   return a;
}   



















// USART1 Receiver interrupt service routine
interrupt [USART1_RXC] void usart1_rx_isr(void)
{
char data;
data=UDR1;
}


// Write a character to the USART1 Transmitter
void TRANSMIT1(char c)
{
while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
UDR1=c;
}


void init(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

DDRA.2=1; //ds1631 sda
DDRA.3=1; //ds1631 scl
PORTA.3=1;


DDRA.1=1;//ON
DDRA.4=1;//LAMP

// Port B initialization
// Func7=In Func6=In Func5=In Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=0 State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x90;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// Port E initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTE=0x00;
DDRE=0x00;

// Port F initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTF=0x00;
DDRF=0x00;

// Port G initialization
// Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State5=T State4=T State3=T State2=T State1=T State0=T 
PORTG=0x00;
DDRG=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 172,800 kHz
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x03;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 172,800 kHz
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// OC1C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x03;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
OCR1CH=0x00;
OCR1CL=0x00;



// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 1382,400 kHz
// Mode: Fast PWM top=FFh
// OC2A output: Inverted PWM
// OC2B output: Disconnected
ASSR=0x00;
TCCR2A=0xC3;
TCCR2B=0x02;
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;

// Timer/Counter 3 initialization
// Clock source: System Clock
// Clock value: Timer 3 Stopped
// Mode: Normal top=FFFFh
// Noise Canceler: Off
// Input Capture on Falling Edge
// OC3A output: Discon.
// OC3B output: Discon.
// OC3C output: Discon.
// Timer 3 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR3A=0x00;
TCCR3B=0x00;
TCNT3H=0x00;
TCNT3L=0x00;
ICR3H=0x00;
ICR3L=0x00;
OCR3AH=0x00;
OCR3AL=0x00;
OCR3BH=0x00;
OCR3BL=0x00;
OCR3CH=0x00;
OCR3CL=0x00;

// Timer/Counter 4 initialization
// Clock source: System Clock
// Clock value: Timer 4 Stopped
// Mode: Normal top=FFFFh
// OC4A output: Discon.
// OC4B output: Discon.
// OC4C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 4 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR4A=0x00;
TCCR4B=0x00;
TCNT4H=0x00;
TCNT4L=0x00;
ICR4H=0x00;
ICR4L=0x00;
OCR4AH=0x00;
OCR4AL=0x00;
OCR4BH=0x00;
OCR4BL=0x00;
OCR4CH=0x00;
OCR4CL=0x00;

// Timer/Counter 5 initialization
// Clock source: System Clock
// Clock value: Timer 5 Stopped
// Mode: Normal top=FFFFh
// OC5A output: Discon.
// OC5B output: Discon.
// OC5C output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 5 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare C Match Interrupt: Off
TCCR5A=0x00;
TCCR5B=0x00;
TCNT5H=0x00;
TCNT5L=0x00;
ICR5H=0x00;
ICR5L=0x00;
OCR5AH=0x00;
OCR5AL=0x00;
OCR5BH=0x00;
OCR5BL=0x00;
OCR5CH=0x00;
OCR5CL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
// INT3: Off
// INT4: On
// INT4 Mode: Rising Edge
// INT5: On
// INT5 Mode: Rising Edge
// INT6: Off
// INT7: Off
EICRA=0x00;
EICRB=0x0F;
EIMSK=0x30;
EIFR=0x30;
// PCINT0 interrupt: Off
// PCINT1 interrupt: Off
// PCINT2 interrupt: Off
// PCINT3 interrupt: Off
// PCINT4 interrupt: Off
// PCINT5 interrupt: Off
// PCINT6 interrupt: Off
// PCINT7 interrupt: Off
// PCINT8 interrupt: Off
// PCINT9 interrupt: Off
// PCINT10 interrupt: Off
// PCINT11 interrupt: Off
// PCINT12 interrupt: Off
// PCINT13 interrupt: Off
// PCINT14 interrupt: Off
// PCINT15 interrupt: Off
// PCINT16 interrupt: Off
// PCINT17 interrupt: Off
// PCINT18 interrupt: Off
// PCINT19 interrupt: Off
// PCINT20 interrupt: Off
// PCINT21 interrupt: Off
// PCINT22 interrupt: Off
// PCINT23 interrupt: Off
PCMSK0=0x00;
PCMSK1=0x00;
PCMSK2=0x00;
PCICR=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=0x01;
// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=0x01;
// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=0x00;
// Timer/Counter 3 Interrupt(s) initialization
TIMSK3=0x00;
// Timer/Counter 4 Interrupt(s) initialization
TIMSK4=0x00;
// Timer/Counter 5 Interrupt(s) initialization
TIMSK5=0x00;

// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: Off
// USART0 Mode: Asynchronous
// USART0 Baud Rate: 4800
UCSR0A=0x00;
UCSR0B=0x90;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x8F;

// USART1 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART1 Receiver: On
// USART1 Transmitter: On
// USART1 Mode: Asynchronous
// USART1 Baud Rate: 9600
UCSR1A=0x00;
UCSR1B=0x98;
UCSR1C=0x06;
UBRR1H=0x00;
UBRR1L=0x47;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
ADCSRB=0x00;



// ADC initialization
// ADC Clock frequency: 172,800 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: None
// Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
// ADC4: On, ADC5: On, ADC6: On, ADC7: On
DIDR0=0x00;
// Digital input buffers on ADC8: On, ADC9: On, ADC10: On, ADC11: On
// ADC12: On, ADC13: On, ADC14: On, ADC15: On
DIDR2=0x00;
ADMUX=ADC_VREF_TYPE & 0xff;
ADMUX=(0x01 & 0x07) | (ADC_VREF_TYPE & 0xff);
ADCSRA=0x86;
ADCSRB &= 0xf7;



#asm("sei")
}



void main(void)
{
unsigned char tmp,tmp2,start_counter=0,PWM=0;
int I=0;
unsigned int I_0=0;
int t=0;
init();
PORTA.1=1;
OCR2A=0xFF;

while (1)
      {
       for(tmp=0;tmp<15;tmp++)
       {
        for(tmp2=0;tmp2<32;tmp2++)
        {
         //MAIN LOOP*************************************************************************************************
         //MAIN LOOP*************************************************************************************************
         //MAIN LOOP*************************************************************************************************
         if(IK_DELTA>400)   //   ~~160km/h             172,800 kHz
          {
           IK_SPEED_KM_H=(int)(((long)R_IK*2850)/IK_DELTA);
          }
          else
          {
           IK_SPEED_KM_H=0;
          }
          
          if(TK_DELTA>400)   //   ~~160km/h             172,800 kHz
          {
           TK_SPEED_KM_H=(int)(((long)R_TK*2171)/TK_DELTA);
          }
          else
          {
           TK_SPEED_KM_H=0;
          }
          adc_data=ADCW;
          ADCSRA|=0x40;//start adc
          
          if(start_counter<100)
          {
           start_counter++;
           if(start_counter>50)
           {
            I_0=I_0+adc_data;
           }           
           if(start_counter==100)
           {I_0=I_0/50;}
          } 
           else
          {
           I=(((long)(adc_data-I_0)*153)/1000);
           if(I<0)
            I=-I;
          }     
          
          OCR2A=0xFF-PWM;
          
          
               
         TRANSMIT1(MASSIV[tmp2]);
        //*********************************************************************************************************
        //*********************************************************************************************************
        //*********************************************************************************************************
        }
        
       MASSIV[1]=(unsigned char)(IK_SPEED_KM_H/100);
       MASSIV[2]=(unsigned char)(IK_SPEED_KM_H-(int)MASSIV[1]*100);
       MASSIV[3]=(unsigned char)(TK_SPEED_KM_H/100);
       MASSIV[4]=(unsigned char)(TK_SPEED_KM_H-(int)MASSIV[3]*100);
        
        
        MASSIV[8]=(unsigned char)t;//0-100    -50c
       
        MASSIV[10]=I;
        if(flag_td_ready==1)
         {
          MASSIV[5]=BYTE_TD[0];
          MASSIV[6]=BYTE_TD[1];
          MASSIV[7]=BYTE_TD[2];
          MASSIV[9]=BYTE_TD[3];
         }
       
        MASSIV[12]=(unsigned char)GPS_shir[0];
        MASSIV[13]=(unsigned char)GPS_shir[1];
        MASSIV[14]=(unsigned char)(GPS_shir[2]/100);
        MASSIV[15]=(unsigned char)(GPS_shir[2]-MASSIV[14]*100);
        MASSIV[16]=(unsigned char)GPS_shir[3];
       }       
       if(PINA.4==1)
        {
         PORTA.4=0;
         t=READ_TEMP_DS1631();
         t=t+50;
         if(t<0)
         t=0;
         if(t>100)
         t=100;
         
        }
       else
        {
         SET_DS1631();
         START_DS1631();
         PORTA.4=1;
        } 
        
      };
}
