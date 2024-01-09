/*****************************************************
Chip type               : ATmega128A
Program type            : Application
AVR Core Clock frequency: 11,059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*****************************************************/

#include <mega128a.h>
#include <delay.h>
// I2C Bus functions
#include <i2c.h>
// Standard Input/Output functions
#include <stdio.h>


#define DDR_SPI DDRB
#define PORT_SPI PORTB
#define SS 0

#define ADC_VREF_TYPE 0xC0
#ifndef UDRE
#define UDRE 5
#endif
#define DATA_REGISTER_EMPTY (1<<UDRE)

#define AD7799_DDRDY PINB.3
/*
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CALIBR_MAIN_DATA N01
#define N_string "AT+NAMEIKSEM#01\r\n"

unsigned long WEIGHT_NULL=6929, LOADCELL_NULL=862, DELTA_WEIGHT10KG=704, DELTA_LOADCELL10KG=863;
unsigned int R_IK=198, R_TK=333, ZADANIE_S=10;
 
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CALIBR_MAIN_DATA N01
*/

//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CALIBR_MAIN_DATA N02
#define N_string "AT+NAMEIKSEM#02\r\n"

unsigned int WEIGHT_NULL=6694, LOADCELL_NULL=709, DELTA_WEIGHT10KG=702, DELTA_LOADCELL10KG=824;
unsigned int R_IK=198, R_TK=333 , ZADANIE_S=10;
 
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CALIBR_MAIN_DATA N02

/*
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CALIBR_MAIN_DATA N03
#define N_string "AT+NAMEIKSEM#03\r\n"
unsigned long WEIGHT_NULL=6885, LOADCELL_NULL=578, DELTA_WEIGHT10KG=751, DELTA_LOADCELL10KG=786;
unsigned int R_IK=198, R_TK=333, ZADANIE_S=10; 
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CALIBR_MAIN_DATA N03
*/
unsigned flag_transmission=255;
unsigned flag_receive=0,receive_counter=0;

unsigned char SEND_MAS[26]={255,5,55,4,49,6,21,7,50,5,80,75,0,3598/60,3598%60,31,22,1819/60,1819%60,55,24,'N','E',50,0,35};

unsigned char CALIBR_MAS[10]={249,66,94,7,9,7,2,8,24,(66+94+7+9+7+2+8+24)/8};
//unsigned int CALIBR_MAS_RESULT[16]={6017,5270,4400,3680,6000,5150,4390,3643,1370,211,2700,3480,1445,2075,2820,3550};
//unsigned int CALIBR_MAS_RESULT[16]={W_up_10,,,W_up_40,W_down_10,,,W_down_40,M_up_10,,,,,,,M_down_40};// ALL in kg*100

unsigned char SETUP_MAS[8]={248,198,130,10,1,0,0,(198+130+10+1)/6};
//eeprom unsigned char EEP_CALIBR_MAS[10];
//eeprom unsigned char EEP_SETUP_MAS[8];

unsigned char program_cycle_flag=0,program_cycle_counter=0;

unsigned char ovf_IK=0, ovf_TK=0;
unsigned long IK_COUNT[2]={0,0}, TK_COUNT[2]={0,0}, IK_DELTA=0, TK_DELTA=0;
unsigned int IK_SPEED_KM_H=0,TK_SPEED_KM_H=0;

unsigned int ADC_BAT=0,ADC_I=0;
long I_NULL=0;
unsigned char flag_I_NULL=0;
//  unsigned int A_BAT=0,A_I=0;

unsigned char GPS_zap_counter=0,GPS_sim_counter=0,GPS_flag_ready=0;//1-ustanovlen 0-ne ustanovlen
unsigned char GPS_string_name[3]={0,0,0},GPS_flag_gp=0;//0-no 1-1 bukva posle P, 2-2ya, 3-3ya, 4-GGA
unsigned int GPS_shir[4]={1,1,1,1},GPS_dolg[4]={1,1,1,1};//grad min .xxxx  NSWE
unsigned char GPS_solve=0;
unsigned char GPS_ON_COUNTER=0;
unsigned char flag_start=0;


int PID_I_S=0;
int K[2]={10,4};//коэффициенты регуляторов


interrupt [EXT_INT7] void ext_int7_isr(void);
interrupt [EXT_INT6] void ext_int6_isr(void);
void init_all(void);
void led_zero(void);
void led_one(void);
void lights(char G, char R, char B);
unsigned int K_BY_KOEFFICIENTS(unsigned int M);

void Read_Setup(void)
{
 ZADANIE_S=SETUP_MAS[3];  
 R_IK=SETUP_MAS[1];                 
 R_TK=SETUP_MAS[2]+200;   
}

void Control_Sum_Send(void)
{
 unsigned char tmp=0;
 unsigned int S=0;
 
 for(tmp=1;tmp<25;tmp++)
  S=S+SEND_MAS[tmp];
  SEND_MAS[25]=S/24;  
}

void Control_Sum_Calibr(void)
{
 unsigned char tmp=0;
 unsigned int S=0;
 
 for(tmp=1;tmp<9;tmp++)
  S=S+CALIBR_MAS[tmp];
 CALIBR_MAS[9]=S/8;  
}

void Control_Sum_Setup(void)
{
 unsigned char tmp=0;
 unsigned int S=0;
 
 for(tmp=1;tmp<7;tmp++)
  S=S+SETUP_MAS[tmp];
 SETUP_MAS[7]=S/6;  
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




void delay(unsigned int d)
{              
 unsigned int y;
 for(y=0;y<d;y++)
 {}
}



void SPI_MasterInit(void)
{
 PORTB.2=1;
 DDRB.2=1;
 DDRB.1=1;
 PORTB.1=0;
 DDRB.3=0;
}


unsigned char SPI_MasterReceive(void)
{
unsigned char t,x=0;

 for(t=128;t>=1;t=t/2)         
 { 
  PORTB.1=1; 
  delay(50);    
  PORTB.1=0;
  if(!PINB.3)    
    x=x+t; 
  delay(50);                                        
 }       
 return x;
}


void SPI_MasterTransmit(unsigned char x)
{
unsigned char t;

 for(t=128;t>=1;t=t/2)         
 {
 PORTB.1=1; 
 delay(100);
 if(x&t)
  PORTB.2=0; 
 else       
  PORTB.2=1; 
 delay(100);                    
 PORTB.1=0;
 delay(100);                    
 } 
 PORTB.2=1;
 delay(150);
}



void SET_AD7799(void)
{
 delay_ms(100);
 SPI_MasterTransmit(0b11111111);
 SPI_MasterTransmit(0b11111111);
 SPI_MasterTransmit(0b11111111);
 SPI_MasterTransmit(0b11111111); 
 delay_ms(100);
 SPI_MasterTransmit(0x10);    //conf
 delay(10000);
 SPI_MasterTransmit(0b00010111); // *  128
 SPI_MasterTransmit(0b00010000);
 delay(10000);
                
     
 SPI_MasterTransmit(0x08);  //mode
 delay(10000);
 SPI_MasterTransmit(0b00000000);
 //SPI_MasterTransmit(0b00001111);
 
 SPI_MasterTransmit(0b00001100);//10Hz
 //SPI_MasterTransmit(0b00001000);//20Hz
 delay(10000);
 SPI_MasterTransmit(0x5C);
 delay(10000);  
}

 unsigned int READ_AD7799(void)
{
 unsigned char a1,a2;
 unsigned int M;  
        delay(100);
        a1=SPI_MasterReceive();
        a2=SPI_MasterReceive();
        SPI_MasterReceive(); 
        //M=(unsigned long)a1*256*32+(unsigned long)a2*32+(unsigned long)a3/8;
        //M=(unsigned long)a1*256+(unsigned long)a2;
        M=(unsigned int)a1*256+(unsigned int)a2;
        return M;
        //return a2;
}


void uart1SendByte(char data)
{
    while(!( UCSR1A & (1 << UDRE)));
    UDR1 = data;
}

void uart1SendString(char *str)
{
    while(*str)
    {
        uart1SendByte(*str++);
    }
}

void uart1SendArray(unsigned char *array, unsigned char size)
{
   unsigned char i;
    for(i = 0; i < size; ++i)
    {
        uart1SendByte(array[i]);
    }
}

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
       GPS_flag_ready=0;
       }
    else
     GPS_flag_gp=0;   
    goto exit_int;
   }
      
    if((GPS_flag_gp==4)&&(simvol==','))
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
    {GPS_shir[3]=simvol;
     goto exit_int;}
   if(GPS_zap_counter==4)//dolg
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
     goto exit_int;     
    }
    if(GPS_zap_counter==6)
    {
     GPS_solve=simvol;
     GPS_flag_ready=1;
     GPS_flag_gp=0; 
     GPS_zap_counter=0;  
     GPS_ON_COUNTER=0; 
     
      SEND_MAS[12]=1;
     
     SEND_MAS[13]=(unsigned char)GPS_shir[0];
     SEND_MAS[14]=(unsigned char)GPS_shir[1];
     SEND_MAS[15]=(unsigned char)(GPS_shir[2]/100);
     SEND_MAS[16]=(unsigned char)(GPS_shir[2]%100);
     
     SEND_MAS[17]=(unsigned char)GPS_dolg[0];
     SEND_MAS[18]=(unsigned char)GPS_dolg[1];
     SEND_MAS[19]=(unsigned char)(GPS_dolg[2]/100);
     SEND_MAS[20]=(unsigned char)(GPS_dolg[2]%100);
     
     SEND_MAS[21]=(unsigned char)GPS_shir[3];
     SEND_MAS[22]=(unsigned char)GPS_dolg[3];
        
    }
  }
       
 
 exit_int:
 
}

     
// USART1 Receiver interrupt service routine
interrupt [USART1_RXC] void usart1_rx_isr(void)
{
 char data;
  data=UDR1;
 if((receive_counter==0)||(data>245))
 {                     
  receive_counter=0;
  switch(data)
  {          
   //setup request
   case 246:
   flag_transmission=248;
   break;   
   
   //calibr request
   case 247:
   flag_transmission=249;   
   break;
   
   //setup table
   case 248:
   flag_receive=248;
   receive_counter=7;
   break;
      
   //calibr table
   case 249:
   flag_receive=249;
   receive_counter=9;
   break;       
   
    //system on   
   case 250:      
    if(flag_I_NULL<10)//If the current null calibration has not finished
     break;
    flag_start=1;       
   break;      
   
   //system off
   case 251:
   flag_start=0;  
   break; 
    
   case 252:
   PORTC.1 = 1;//fonar on   
   break;
   
   case 253:
   PORTC.1 = 0;//fonar off 
   break;
  }
 }
 else
 {                     
   if(flag_receive==248)
   {
    SETUP_MAS[8-receive_counter]=data;
  //  EEP_SETUP_MAS[receive_counter-1]=data;
    if(receive_counter==1)
     Read_Setup();
   }  
   
    if(flag_receive==249)
    {
     CALIBR_MAS[10-receive_counter]=data;
  //  EEP_CALIBR_MAS[receive_counter-1]=data;
    }      
     
  // if(receive_counter==1)
  // {flag_receive=0;}          
   receive_counter--;
 } 
}


// Write a character to the USART1 Transmitter
#pragma used+
void putchar1(char c)
{
 while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
  UDR1=c;
}
#pragma used-


// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
 // Delay needed for the stabilization of the ADC input voltage
 delay_us(7); 
 // Start the AD conversion
 ADCSRA|=0x40;
 // Wait for the AD conversion to complete
 while ((ADCSRA & 0x10)==0);
  ADCSRA|=0x10;
 return ADCW;
}


unsigned char PID_S(unsigned int Z,unsigned int S)
 {
  int U,E;
   
  E=Z-S;
  PID_I_S=PID_I_S+(E*K[1])/2;
  if(PID_I_S>1000)
   PID_I_S=1000;
  if(PID_I_S<-1000)
   PID_I_S=-1000;
  U=E*K[0]+PID_I_S;
/*   
 if(TK_SPEED_KM_H>300)
   U=(U*6)/(IK_SPEED_KM_H/100);
*/   
   
 U=U/4; 
  if(U<0)
   U=0;
  if(U>255)
   U=255;
  return (unsigned char)U;
 }
  
 
// Timer2 overflow interrupt service routine
////100HZ Program cycle
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
 int SCOLGENIE=0;
 unsigned char PWM=0;             

 TCNT2=148;//100HZ
 //Speed---------------------------------------------------------------------------
  if((IK_DELTA>400)&&(ovf_IK<2))   //   ~~160km/h             172,800 kHz
          {
           IK_SPEED_KM_H=(unsigned int)(((unsigned long)R_IK*2255)/IK_DELTA);
           
          }
  else
          {
           IK_SPEED_KM_H=0;
          }
          
  if((TK_DELTA>400)&&(ovf_TK<2))   //   ~~160            172,800 kHz
          {
           TK_SPEED_KM_H=(unsigned int)(((unsigned long)R_TK*2171)/TK_DELTA);
          }
  else
          {
           TK_SPEED_KM_H=0;
          }
  //Speed---------------------------------------------------------------------------
  
  
        //Proverka u vichiclenie skolgenia---------------------------------------------------------------
          if((IK_SPEED_KM_H>=TK_SPEED_KM_H)||(TK_SPEED_KM_H<100))// 10kmh
            SCOLGENIE=0;
          else
            SCOLGENIE=(int)((((long int)(TK_SPEED_KM_H-IK_SPEED_KM_H))*1000)/((long int)TK_SPEED_KM_H));
        //-----------------------------------------------------------------------------------------------
          
        
        if(flag_start==1)
          {
           PWM=PID_S((unsigned int)ZADANIE_S*10,(unsigned int)SCOLGENIE);
          }
          else
          {
           PWM=0;
          }              
           OCR0=255-PWM;       
   
 if(program_cycle_counter<9)
  {program_cycle_counter++;}   
 else                  
  {
   program_cycle_flag=1;
   program_cycle_counter=0;
  }
}

/*
unsigned int filter(unsigned int a1,unsigned int a2)
{
 if((a1<(a2+200))&&((a1+200)>a2))
 {      
   return (a1+a2)/2;
 }       
 return 0;
}
*/


void main(void)
{
// Declare your local variables here
unsigned char main_cycle=0,flag_led_direction=0,led_cycle=0;
unsigned int BAT=0;
unsigned int load_cell_b=0,load_cell=0,K=0;

int M=0;
int I=0;
unsigned int TIME_OUT=10*60*30;

Control_Sum_Calibr();
Control_Sum_Setup();
Read_Setup();

init_all();
// I2C Port: PORTD
// I2C SDA bit: 1
// I2C SCL bit: 0
// Bit Rate: 100 kHz
i2c_init();

SPI_MasterInit();

// Global enable interrupts
#asm("sei")

PORTC.0 = 1;//iksem - on

//PORTC.1 = 1;//fonar on


delay_ms(100);

SET_AD7799();

uart1SendString(N_string);//Set BLUETOOTH NAME


/*
//Default eeprom writing----------
if(EEP_CALIBR_MAS[0]!=249)
{
 for(tmp=0;tmp<34;tmp++)
  EEP_CALIBR_MAS[tmp]=CALIBR_MAS[tmp];   
 for(tmp=0;tmp<8;tmp++)
  EEP_SETUP_MAS[tmp]=SETUP_MAS[tmp];
}
else
{
 for(tmp=0;tmp<34;tmp++)
  CALIBR_MAS[tmp]=EEP_CALIBR_MAS[tmp];   
 for(tmp=0;tmp<8;tmp++)
  SETUP_MAS[tmp]=EEP_SETUP_MAS[tmp];
}
//--------------------------------
*/ 

while (1)
    { 
     /*  
      program_cycle_flag=0;
      while(program_cycle_flag!=1)
      {}
      program_cycle_flag=0;
     */   
      SEND_MAS[1]= TK_SPEED_KM_H/100;
      SEND_MAS[2]= TK_SPEED_KM_H%100; 
      SEND_MAS[3]= IK_SPEED_KM_H/100;
      SEND_MAS[4]= IK_SPEED_KM_H%100;
                                           
       if(flag_start==1)
       {TIME_OUT=10*60*30;}//30 min
       else
       {    
        if(TIME_OUT==0)
         PORTC.0 = 0;//iksem - off
        else
         TIME_OUT--;
       }                             
       
      load_cell_b=load_cell;
      
      while(AD7799_DDRDY==0) //!DDRDY
      {}          
      delay_ms(1);
      load_cell=READ_AD7799();
      delay_ms(1);
      
     
      /*
      while(AD7799_DDRDY==0) //!DDRDY
      {}          
      delay_ms(1);
      lc[2]=READ_AD7799();
      */ 
      //load_cell=filter(lc[0],lc[1]);
       
     // if(((load_cell+500)>load_cell_b)&&(load_cell<(load_cell_b+500)))
     //  {} 
     //  else
     //  {load_cell=load_cell_b;}                       
     //M----------------------------------------------
     //load_cell=88 - 0kg
     //load_cell=835 - 11,1kg 
     // 1 adc = 0,01486 kg               
      M=(long)load_cell*1486/1000;// kg*100 
      if(M<0)
      M=0;
      if(M>10000)
      M=10000;
      SEND_MAS[7]=M/100;
      SEND_MAS[8]=M%100;
      //---------------------------------------------
      
          
     //KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
      K=K_BY_KOEFFICIENTS(M);
      //if(flag_start==1)
      //{
       //K=(K*15)/18;          //Подгон К если система включена 
     // }                                              
      SEND_MAS[5]=K/100;
      SEND_MAS[6]=K%100;
     //KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
      
     ADC_BAT=read_adc(0);
     ADC_I=read_adc(1);//0.021В датчика = 1А = 2.1*4 = 8.4 АЦП (1024 = 2.56в)
 
     if(flag_I_NULL<10)
     {
      I_NULL=I_NULL+ADC_I;
           
      if(flag_I_NULL==9)
      I_NULL=I_NULL/10;
    
      flag_I_NULL++;
     }  
     //BATTERY LEVEL--------------------------------------------------------  
      BAT=ADC_BAT;//163*4-100%(12.7) 150*4-0%(11.7)
             
     // if(ADC_I>=(252*4))
     //  I=0;
     // else                                                                                              
       
      
      
      if(BAT<=610)
       {
        SEND_MAS[23]=0;
       } 
       else
       {
        if(BAT>=660)
         SEND_MAS[23]=100;
        else
         SEND_MAS[23]=(unsigned char)((BAT-610)*2);
       }        
     //--------------------------------------------------------------------
     
     I=ADC_I;                   
     I=(int)(((long)(I_NULL-I)*100)/84);//0.021В датчика = 1А = 2.1*4 = 8.4 АЦП (1024 = 2.56в) 2.52v=0   
     if(I<0)
     I=0;
     
        
      SEND_MAS[9]=I/100;
      SEND_MAS[10]=I%100;        
      
     
    //Контрольная сумма----------------------
     Control_Sum_Send();              
    //---------------------------------------
      if(flag_transmission==255)
      {  
       uart1SendArray(SEND_MAS,26);
      }                    
      else
      {                     
       if(flag_transmission==248)
       {
        uart1SendArray(SETUP_MAS,8);
        flag_transmission=255;
       } 
       if(flag_transmission==249)
       {  
        uart1SendArray(CALIBR_MAS,10);
        flag_transmission=255;
       }
      }
                     
      
      #asm("cli")
      lights(led_cycle*20,0,180-led_cycle*20);  
      #asm("sei")
      
      if(led_cycle==9)
      flag_led_direction=1;
      
      if(led_cycle==0)
      flag_led_direction=0;
      
      if(flag_led_direction==0)      
      led_cycle++;
      else
      led_cycle--;
      
      if(main_cycle>=9)
      main_cycle=0;
      else
      main_cycle++;   
      
                                                
    }
}


//SPEED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//SPEED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//SPEED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// External Interrupt 6 service routine
interrupt [EXT_INT6] void ext_int6_isr(void) //TK_SPEED
{
 unsigned char H,L;
 TK_COUNT[0]=TK_COUNT[1];
 L=TCNT1L;
 H=TCNT1H;
 TK_COUNT[1]=(unsigned long)H*256+(unsigned long)L;
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


// External Interrupt 7 service routine
interrupt [EXT_INT7] void ext_int7_isr(void) //IK_SPEED
{
 unsigned char H,L;
 IK_COUNT[0]=IK_COUNT[1];
 L=TCNT1L;
 H=TCNT1H;
 IK_COUNT[1]=(unsigned long)H*256+(unsigned long)L;
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





void init_all(void)
{

 // Port B initialization
 DDRB.4=1;
 DDRB.6=1;    
 
 // Port C initialization
 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out 
 // State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=0 
 PORTC=0x00;
 DDRC=0x03;
 PORTC.2=0;//GPS on 
 DDRC.2=1;
 
 
 // Timer/Counter 0 initialization
 // Clock source: System Clock
 // Clock value: 1382,400 kHz
 // Mode: Phase correct PWM top=0xFF
 // OC0 output: Inverted PWM
 ASSR=0x00;
 TCCR0=0x72;
 TCNT0=0x00;
 OCR0=255;
 
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
 // Clock value: 10,800 kHz
 // Mode: Normal top=0xFF
 // OC2 output: Disconnected
 TCCR2=0x05;
 TCNT2=0x00;
 OCR2=0x00;

 // Timer(s)/Counter(s) Interrupt(s) initialization
 TIMSK=0x44;

 ETIMSK=0x00;

 // External Interrupt(s) initialization
 // INT0: Off
 // INT1: Off
 // INT2: Off
 // INT3: Off
 // INT4: Off
 // INT5: Off
 // INT6: On
 // INT6 Mode: Rising Edge
 // INT7: On
 // INT7 Mode: Rising Edge
 EICRA=0x00;
 EICRB=0xF0;
 EIMSK=0xC0;
 EIFR=0xC0;

 // USART0 initialization
 // Communication Parameters: 8 Data, 1 Stop, No Parity
 // USART0 Receiver: On
 // USART0 Transmitter: On
 // USART0 Mode: Asynchronous
 // USART0 Baud Rate: 9600
 UCSR0A=0x00;
 UCSR0B=0x98;
 UCSR0C=0x06;
 UBRR0H=0x00;
 UBRR0L=0x47;
 
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
 SFIOR=0x00;

 // ADC initialization
 // ADC Clock frequency: 86,400 kHz
 // ADC Voltage Reference: Int., cap. on AREF
 ADMUX=ADC_VREF_TYPE & 0xff;
 ADCSRA=0x87; 
}

unsigned int K_BY_KOEFFICIENTS(unsigned int M)
{
unsigned long F,W,K;
//WEIGHT_NULL=6679, LOADCELL_NULL=618, DELTA_WEIGHT10KG=748, DELTA_LOADCELL10KG=772
if(M<LOADCELL_NULL)
 return 0;

F=((M-(unsigned long)LOADCELL_NULL)*1000)/((unsigned long)DELTA_LOADCELL10KG);
W=(unsigned long)WEIGHT_NULL-((unsigned long)DELTA_WEIGHT10KG*F)/1000;
if(W>0)
 K=(F*1000)/W;
else
 K=1800;

if(K>1800)
 K=1800; 
return K; 
}
/*
unsigned int K_BY_TABLE(unsigned int M)
{
 unsigned char x;
 unsigned int K;
 unsigned int ZERO;

 unsigned int W_A[4];
 unsigned int M_A[4];
 unsigned int K_A[4];
  
 //CALIBR_MAS_RESULT[16]={6017,5270,4400,3680,6000,5150,4390,3643,1370,2113,2700,3480,1445,2075,2820,3550}//TELEGA N01
 //unsigned int CALIBR_MAS_RESULT[16]={W_up_10,,,W_up_40,W_down_10,,,W_down_40,M_up_10,,,,,,,M_down_40};// ALL in kg*100
             
 for(x=0;x<4;x++)
 {
  W_A[x]=(CALIBR_MAS_RESULT[x]+CALIBR_MAS_RESULT[x+4])/2;
  M_A[x]=(CALIBR_MAS_RESULT[x+8]+CALIBR_MAS_RESULT[x+4+8])/2;
 }
                     
 ZERO=M_A[0]-(M_A[3]-M_A[0])/3;
 
 for(x=0;x<4;x++)
 {
 K_A[x]=(1000000*((long)x+1))/(long)W_A[x];
 }                       
 
 if(M<=ZERO)
  return 0;

 for(x=0;x<4;x++)
 {                
   if((M<M_A[x])||(x==3))
  {              
    if(x==0)
   {
    K=((long)K_A[0]*((long)(M-ZERO)))/((long)(M_A[0]-ZERO));
     return K;
   }
   else
   {
     K=K_A[x-1]+(((long)(K_A[x]-K_A[x-1]))*((long)(M-M_A[x-1])))/((long)(M_A[x]-M_A[x-1]));
     return K;
   }
  } 
 }   
}
*/



void led_zero(void)
{
    PORTB.6 = 1;
    #asm("nop");
    PORTB.6 = 0;
    #asm("nop");
    #asm("nop");
    #asm("nop");
}

void led_one(void)
{
    PORTB.6 = 1;
    #asm("nop");
    #asm("nop");
    #asm("nop");
    #asm("nop");
    PORTB.6 = 0; 
}

void lights(char G, char R, char B)
{
    unsigned char i;
    for(i = 0b10000000; i >= 0b00000001; i = i >> 1)
    {
        if((G & i) > 0)
            led_one();
        else
            led_zero();            
    } 
     
    for(i = 0b10000000; i >= 0b00000001; i = i >> 1)
    {
        if((R & i) > 0)
            led_one();
        else
            led_zero();            
    }  
    
    for(i = 0b10000000; i >= 0b00000001; i = i >> 1)
    {
        if((B & i) > 0)
            led_one();
        else
            led_zero();            
    }
}

