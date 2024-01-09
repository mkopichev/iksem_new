#include "include/ad7799.h"
#include "include/neo6m.h"
#include "include/rgbled.h"
#include "include/spiprot.h"
#include "include/utils.h"

// before programming make sure that IKSEM number is right
#define IKS01 // IKSEM number
// this affects on calibration table
#include "include/iksemdefparam.h"

#define DDR_SPI  DDRB
#define PORT_SPI PORTB
#define SS       0

#define ADC_VREF_TYPE ((1 << REFS1) | (1 << REFS0))
#ifndef UDRE
#define UDRE 5
#endif
#define DATA_REGISTER_EMPTY (1 << UDRE)
// #define AD7799_DDRDY        PINB .3

#define AVERAGE_NUMBER 15

#define FIXWEIGHT       // comment and fixed weight will be OFF
#define SPEEDFILTER     // comment and speed median filter will be OFF
#define ADC_FAULT_RESET // comment and IKSEM will not turn off in case of ADC initialisation error

// #define ADC_TO_KG // comment for measurinf, uncomment for testing

// Список необходимых изменений
// 5)АЦП периодически не инициализируется исправить
// 6)Показания аккумулятора фильтрануть ++++++++++++++++++++

// Формула

// В проге мобилы:
// 2)Задание Скольж убрать
// 3)Скорость мерять правильно
// 4)пароль сделать из файла
// 5)выводить код ошибки и саму ошибку

uint8_t EEMEM EEP_SETUP_MAS[8];
uint8_t EEMEM EEP_CALIBR_MAS[10];

unsigned flag_transmission = 255;
unsigned flag_receive = 0, receive_counter = 0;

uint8_t SEND_MAS[26] = {255, 5, 55, 4, 49, 6, 21, 7, 50, 5, 80, 75, 0, 3598 / 60, 3598 % 60, 31, 22, 1819 / 60, 1819 % 60, 55, 24, 'N', 'E', 50, 0, 35};

uint8_t program_cycle_flag = 0, program_cycle_counter = 0;

uint8_t ovf_IK = 0, ovf_TK = 0;
unsigned long IK_COUNT[2] = {0, 0}, TK_COUNT[2] = {0, 0}, IK_DELTA = 0, TK_DELTA = 0;
uint16_t IK_SPEED_KM_H = 0, TK_SPEED_KM_H = 0;
uint16_t IK_SPEED_MAS[3] = {0, 0, 0}, TK_SPEED_MAS[3] = {0, 0, 0};

uint16_t ADC_BAT = 0, ADC_I = 0;
uint16_t BAT_SUM = 0;
long I_NULL = 0;
uint8_t flag_I_NULL = 0;
//  uint16_t A_BAT=0,A_I=0;

uint8_t flag_start = 0;
uint8_t measuring_start_counter = 0;
int load_cell = 0, load_cell_MAS[20];
uint8_t ADC_fault_counter = 0;

int PID_I_S = 800;

ISR(INT7_vect);
ISR(INT6_vect);
void init_all(void);
uint16_t K_BY_KOEFFICIENTS_REAL(uint16_t M);
uint16_t K_BY_KOEFFICIENTS_ASFT(uint16_t M);
void Read_Setup_Calibr(void);
void Control_Sum_Send(void);
void Control_Sum_Calibr(void);
void Control_Sum_Setup(void);
ISR(TIMER1_OVF_vect);
void uart1SendByte(char data);
void uart1SendString(char *str);
void uart1SendArray(uint8_t *array, uint8_t size);
ISR(USART1_RX_vect);
uint16_t read_adc(uint8_t adc_input);
ISR(TIMER2_OVF_vect);
void load_from_eeprom(void);
void save_to_eeprom(void);

uint16_t load_cell_filter(void) {
    uint8_t tmp;
    unsigned long int sum = 0;

    if(measuring_start_counter < 2) {
        for(tmp = (AVERAGE_NUMBER - 1); tmp > 0; tmp--) {
            load_cell_MAS[tmp] = load_cell;
            sum = sum + load_cell;
        }
    } else {
        for(tmp = (AVERAGE_NUMBER - 1); tmp > 0; tmp--) {
            load_cell_MAS[tmp] = load_cell_MAS[tmp - 1];
            sum = sum + load_cell_MAS[tmp];
        }
    }
    load_cell_MAS[0] = load_cell;
    sum = sum + load_cell;
    sum = sum / AVERAGE_NUMBER;
    return (uint16_t)sum;
}

// Write a character to the USART1 Transmitter
// #pragma region
void putchar1(char c) {
    while((UCSR1A & DATA_REGISTER_EMPTY) == 0)
        continue;
    UDR1 = c;
}
// #pragma endregion

int main(void) {
    // Declare your local variables here
    uint8_t main_cycle = 0, flag_led_direction = 0, led_cycle = 0;
    uint16_t BAT = 0;
    uint16_t K = 0;
    uint16_t TMP, TMPL;

    int M = 0;
    int I = 0;
    uint16_t TIME_OUT = 10 * 60 * 30;

    Control_Sum_Calibr();
    Control_Sum_Setup();
    load_from_eeprom();
    Read_Setup_Calibr();

    init_all();
    // I2C Port: PORTD
    // I2C SDA bit: 1
    // I2C SCL bit: 0
    // Bit Rate: 100 kHz
    // i2c_init();

    SPI_MasterInit();

    PORTC |= (1 << 0); // iksem - on

    // PORTC.1 = 1;//fonar on

    _delay_ms(100);
    SET_AD7799();
    _delay_ms(100);
    SET_AD7799();
    _delay_ms(100);
    uart1SendString(N_string); // Set BLUETOOTH NAME
    sei();

    while(1) {
        /*
         program_cycle_flag=0;
         while(program_cycle_flag!=1)
         {}
         program_cycle_flag=0;
        */

#ifdef SPEEDFILTER
        TMP = middle(TK_SPEED_MAS[0], TK_SPEED_MAS[1], TK_SPEED_MAS[2]);
        SEND_MAS[1] = TMP / 100;
        SEND_MAS[2] = TMP % 100;
        TMP = middle(IK_SPEED_MAS[0], IK_SPEED_MAS[1], IK_SPEED_MAS[2]);
        SEND_MAS[3] = TMP / 100;
        SEND_MAS[4] = TMP % 100;
#else
        SEND_MAS[1] = TK_SPEED_KM_H / 100;
        SEND_MAS[2] = TK_SPEED_KM_H % 100;
        SEND_MAS[3] = IK_SPEED_KM_H / 100;
        SEND_MAS[4] = IK_SPEED_KM_H % 100;
#endif

        if(flag_start == 1) {
            TIME_OUT = 10 * 60 * 30;

            // measuring_start_counter++;
        } // 30 min
        else {
            if(TIME_OUT == 0)
                PORTC &= ~(1 << 0); // iksem - off
            else
                TIME_OUT--;
        }

        while(!(PINB & (1 << 3))) //! DDRDY
        {
        }

#ifdef ADC_FAULT_RESET
        TMPL = TCNT3L; // read low first
        TMP = TCNT3H;
        TMP = (TMP << 8) + TMPL;
        if((TMP < (1080 - 250)) || (TMP > (1080 + 250))) {
            if(ADC_fault_counter > 5) {
                PORTC &= ~(1 << 0); // iksem - off
            } else {
                ADC_fault_counter++;
            }
        } else {
            ADC_fault_counter = 0;
            PORTC |= (1 << 0); // iksem - on
        }
        TCNT3H = 0; // write high first
        TCNT3L = 0;
#endif

        _delay_ms(1);
        load_cell = READ_AD7799();
        _delay_ms(1);

// M----------------------------------------------
#ifdef ADC_TO_KG
        load_cell = load_cell - ADC_0_KG;
        load_cell = (int)(((long int)load_cell * 10000) / (long int)ADC_100_KG);
        if(load_cell < 0) {
            load_cell = 0;
        }
#endif
        // load_cell=88 - 0kg
        // load_cell=835 - 11,1kg
        //  1 adc = 0,01486 kg

        M = load_cell_filter();
        if(M < 0)
            M = 0;
        if(M > 10000)
            M = 10000;
        if(flag_start == 0) {
            measuring_start_counter = 0;
        } else {
            if(measuring_start_counter < 30) {
                measuring_start_counter++;
            }
        }

        SEND_MAS[7] = M / 100;
        SEND_MAS[8] = M % 100;
        //---------------------------------------------

        // KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
        if(ZADANIE_S == 15)
            K = K_BY_KOEFFICIENTS_ASFT(M);
        else
            K = K_BY_KOEFFICIENTS_REAL(M);

        SEND_MAS[5] = K / 100;
        SEND_MAS[6] = K % 100;
        // KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK

        ADC_BAT = read_adc(0);
        ADC_I = read_adc(1); // 0.021В датчика = 1А = 2.1*4 = 8.4 АЦП (1024 = 2.56в)
        BAT_SUM = (BAT_SUM * 9) / 10 + ADC_BAT;
        ADC_BAT = BAT_SUM / 10;
        if(flag_I_NULL < 10) {
            I_NULL = I_NULL + ADC_I;

            if(flag_I_NULL == 9)
                I_NULL = I_NULL / 10;

            flag_I_NULL++;
        }
        // BATTERY LEVEL--------------------------------------------------------
        BAT = ADC_BAT; // 163*4-100%(12.7) 150*4-0%(11.7)

        // if(ADC_I>=(252*4))
        //  I=0;
        // else

        if(BAT <= 610) {
            SEND_MAS[23] = 0;
        } else {
            if(BAT >= 660)
                SEND_MAS[23] = 100;
            else
                SEND_MAS[23] = (uint8_t)((BAT - 610) * 2);
        }
        //--------------------------------------------------------------------

        I = ADC_I;
        I = (int)(((long)(I_NULL - I) * 100) / 84); // 0.021В датчика = 1А = 2.1*4 = 8.4 АЦП (1024 = 2.56в) 2.52v=0
        if(I < 0)
            I = 0;

        SEND_MAS[9] = I / 100;
        SEND_MAS[10] = I % 100;

        // Контрольная сумма----------------------
        Control_Sum_Send();
        //---------------------------------------
        if(flag_transmission == 255) {
            uart1SendArray(SEND_MAS, 26);
        } else {
            if(flag_transmission == 248) {
                uart1SendArray(SETUP_MAS, 8);
                flag_transmission = 255;
            }
            if(flag_transmission == 249) {
                uart1SendArray(CALIBR_MAS, 10);
                flag_transmission = 255;
            }
        }

        cli();
        lights(252 - led_cycle * 28, led_cycle * 28, 252 - led_cycle * 28);
        sei();

        if(led_cycle == 9)
            flag_led_direction = 1;

        if(led_cycle == 0)
            flag_led_direction = 0;

        if(flag_led_direction == 0)
            led_cycle++;
        else
            led_cycle--;

        if(main_cycle >= 9)
            main_cycle = 0;
        else
            main_cycle++;
    }
}

// SPEED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// SPEED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
// SPEED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//  External Interrupt 6 service routine
ISR(INT6_vect) // TK_SPEED
{
    uint8_t H, L;
    TK_COUNT[0] = TK_COUNT[1];
    L = TCNT1L;
    H = TCNT1H;
    TK_COUNT[1] = (unsigned long)H * 256 + (unsigned long)L;
    if(ovf_TK > 0) {
        if(ovf_TK == 2) {
            TK_DELTA = 0;
            TK_COUNT[0] = 0;
            TK_COUNT[1] = 0;
        } else {
            TK_DELTA = (65536 - TK_COUNT[0]) + TK_COUNT[1];
        }
        ovf_TK = 0;
    } else {
        TK_DELTA = TK_COUNT[1] - TK_COUNT[0];
    }
}

// External Interrupt 7 service routine
ISR(INT7_vect) // IK_SPEED
{
    uint8_t H, L;
    IK_COUNT[0] = IK_COUNT[1];
    L = TCNT1L;
    H = TCNT1H;
    IK_COUNT[1] = (unsigned long)H * 256 + (unsigned long)L;
    if(ovf_IK > 0) {
        if(ovf_IK == 2) {
            IK_DELTA = 0;
            IK_COUNT[0] = 0;
            IK_COUNT[1] = 0;
        } else {
            IK_DELTA = (65536 - IK_COUNT[0]) + IK_COUNT[1];
        }
        ovf_IK = 0;
    } else {
        IK_DELTA = IK_COUNT[1] - IK_COUNT[0];
    }
}

void init_all(void) {

    // Port B initialization
    DDRB |= (1 << 4);
    DDRB |= (1 << 6);

    // Port C initialization
    // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out
    // State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=0
    PORTC = 0x00;
    DDRC = 0x03;
    PORTC &= ~(1 << 2); // GPS on
    DDRC |= (1 << 2);

    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: 1382,400 kHz
    // Mode: Phase correct PWM top=0xFF
    // OC0 output: Inverted PWM
    ASSR = 0x00;
    TCCR0 = 0x72;
    TCNT0 = 0x00;
    OCR0 = 255;

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
    TCCR1A = 0x00;
    TCCR1B = 0x03;
    TCNT1H = 0x00;
    TCNT1L = 0x00;
    ICR1H = 0x00;
    ICR1L = 0x00;
    OCR1AH = 0x00;
    OCR1AL = 0x00;
    OCR1BH = 0x00;
    OCR1BL = 0x00;
    OCR1CH = 0x00;
    OCR1CL = 0x00;

    // Timer/Counter 2 initialization
    // Clock source: System Clock
    // Clock value: 10,800 kHz
    // Mode: Normal top=0xFF
    // OC2 output: Disconnected
    TCCR2 = 0x05;
    TCNT2 = 0x00;
    OCR2 = 0x00;

    // Timer/Counter 3 initialization
    // Clock source: System Clock
    // Clock value: 10,800 kHz
    // Mode: Normal top=0xFFFF
    // OC3A output: Discon.
    // OC3B output: Discon.
    // OC3C output: Discon.
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer3 Overflow Interrupt: Off
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    // Compare C Match Interrupt: Off
    TCCR3A = 0x00;
    TCCR3B = 0x05;
    TCNT3H = 0x00;
    TCNT3L = 0x00;
    ICR3H = 0x00;
    ICR3L = 0x00;
    OCR3AH = 0x00;
    OCR3AL = 0x00;
    OCR3BH = 0x00;
    OCR3BL = 0x00;
    OCR3CH = 0x00;
    OCR3CL = 0x00;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK = 0x44;

    ETIMSK = 0x00;

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
    EICRA = 0x00;
    EICRB = 0xF0;
    EIMSK = 0xC0;
    EIFR = 0xC0;

    // USART0 initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART0 Receiver: On
    // USART0 Transmitter: On
    // USART0 Mode: Asynchronous
    // USART0 Baud Rate: 9600
    UCSR0A = 0x00;
    UCSR0B = 0x98;
    UCSR0C = 0x06;
    UBRR0H = 0x00;
    UBRR0L = 0x47;

    // USART1 initialization
    // Communication Parameters: 8 Data, 1 Stop, No Parity
    // USART1 Receiver: On
    // USART1 Transmitter: On
    // USART1 Mode: Asynchronous
    // USART1 Baud Rate: 9600
    UCSR1A = 0x00;
    UCSR1B = 0x98;
    UCSR1C = 0x06;
    UBRR1H = 0x00;
    UBRR1L = 0x47;

    // Analog Comparator initialization
    // Analog Comparator: Off
    // Analog Comparator Input Capture by Timer/Counter 1: Off
    ACSR = 0x80;
    SFIOR = 0x00;

    // ADC initialization
    // ADC Clock frequency: 86,400 kHz
    // ADC Voltage Reference: Int., cap. on AREF
    ADMUX = ADC_VREF_TYPE & 0xff;
    ADCSRA = 0x87;
}

uint16_t K_BY_KOEFFICIENTS_REAL(uint16_t M) {
    unsigned long F, W, K;
    // WEIGHT_NULL=6679, LOADCELL_NULL=618, DELTA_WEIGHT10KG=748, DELTA_LOADCELL10KG=772
    if(M < LOADCELL_NULL)
        return 0;

    F = ((M - (unsigned long)LOADCELL_NULL) * 1000) / ((unsigned long)DELTA_LOADCELL10KG);
    W = (unsigned long)WEIGHT_NULL - ((unsigned long)DELTA_WEIGHT10KG * F) / 1000;
    if(W > 0)
        K = ((F * 1000) / W) - 28; // frCoef -
    else
        K = 1800;

    if(K > 1800)
        K = 1800;
    return K;
}

uint16_t K_BY_KOEFFICIENTS_ASFT(uint16_t M) {
    long F, W, K;
    // WEIGHT_NULL=6679, LOADCELL_NULL=618, DELTA_WEIGHT10KG=748, DELTA_LOADCELL10KG=772

    F = (long)M - LOADCELL_NULL;
    if(F < 0)
        F = 0;
    F = (F * 1000) / DELTA_LOADCELL10KG;
    W = WEIGHT_NULL;
    K = (F * 1000) / W;

    if(K > 3000)
        K = 3000;

    if(K > 100)
        K = 1000000 / (1000000 / (unsigned long)K + 430 - 637);
    return K;
}

void Read_Setup_Calibr(void) {
    // uint8_t CALIBR_MAS[10]={249,66,94,7,9,7,2,8,24,(66+94+7+9+7+2+8+24)/8};
    // uint16_t WEIGHT_NULL=6694, LOADCELL_NULL=709, DELTA_WEIGHT10KG=702, DELTA_LOADCELL10KG=824;
    ZADANIE_S = SETUP_MAS[3];
    R_IK = SETUP_MAS[1];
    R_TK = SETUP_MAS[2] + 200;

#ifdef FIXWEIGHT
    WEIGHT_NULL = (uint16_t)DEFAULT_CALIBR_MAS[1] * 100 + (uint16_t)DEFAULT_CALIBR_MAS[2];
#else
    WEIGHT_NULL = (uint16_t)CALIBR_MAS[1] * 100 + (uint16_t)CALIBR_MAS[2];
#endif

    LOADCELL_NULL = (uint16_t)CALIBR_MAS[3] * 100 + (uint16_t)CALIBR_MAS[4];
    DELTA_WEIGHT10KG = (uint16_t)CALIBR_MAS[5] * 100 + (uint16_t)CALIBR_MAS[6];
    DELTA_LOADCELL10KG = (uint16_t)CALIBR_MAS[7] * 100 + (uint16_t)CALIBR_MAS[8];
}

void Control_Sum_Send(void) {
    uint8_t tmp = 0;
    uint16_t S = 0;

    for(tmp = 1; tmp < 25; tmp++)
        S = S + SEND_MAS[tmp];
    SEND_MAS[25] = S / 24;
}

void Control_Sum_Calibr(void) {
    uint8_t tmp = 0;
    uint16_t S = 0;

    for(tmp = 1; tmp < 9; tmp++)
        S = S + CALIBR_MAS[tmp];
    CALIBR_MAS[9] = S / 8;
}

void Control_Sum_Setup(void) {
    uint8_t tmp = 0;
    uint16_t S = 0;

    for(tmp = 1; tmp < 7; tmp++)
        S = S + SETUP_MAS[tmp];
    SETUP_MAS[7] = S / 6;
}

// Timer 1 overflow interrupt service routine
ISR(TIMER1_OVF_vect) {
    if(ovf_IK < 2) {
        ovf_IK++;
    }
    if(ovf_TK < 2) {
        ovf_TK++;
    }
}
//***********************************************************************************************************
//***********************************************************************************************************
//***********************************************************************************************************

void uart1SendByte(char data) {
    while(!(UCSR1A & (1 << UDRE)))
        continue;
    UDR1 = data;
}

void uart1SendString(char *str) {
    while(*str) {
        uart1SendByte(*str++);
    }
}

void uart1SendArray(uint8_t *array, uint8_t size) {
    uint8_t i;
    for(i = 0; i < size; ++i) {
        uart1SendByte(array[i]);
    }
}

// USART1 Receiver interrupt service routine
ISR(USART1_RX_vect) {
    uint8_t data;
    data = UDR1;
    if((receive_counter == 0) || (data > 245)) {
        receive_counter = 0;
        switch(data) {
        // setup request
        case 246:
            flag_transmission = 248;
            break;

        // calibr request
        case 247:
            flag_transmission = 249;
            break;

        // setup table
        case 248:
            flag_receive = 248;
            receive_counter = 7;
            break;

        // calibr table
        case 249:
            flag_receive = 249;
            receive_counter = 9;
            break;

            // system on
        case 250:
            if(flag_I_NULL < 10) // If the current null calibration has not finished
                break;
            flag_start = 1;
            break;

        // system off
        case 251:
            flag_start = 0;
            break;

        case 252:
            PORTC |= (1 << 1); // fonar on
            break;

        case 253:
            PORTC &= ~(1 << 1); // fonar off
            break;
        }
    } else {
        if(flag_receive == 248) {
            SETUP_MAS[8 - receive_counter] = data;
            if(receive_counter == 1) {
                save_to_eeprom();
                Read_Setup_Calibr();
            }
        }

        if(flag_receive == 249) {
            CALIBR_MAS[10 - receive_counter] = data;
            if(receive_counter == 1) {
                save_to_eeprom();
                Read_Setup_Calibr();
            }
        }

        receive_counter--;
    }
}

// Read the AD conversion result
uint16_t read_adc(uint8_t adc_input) {
    ADMUX = adc_input | (ADC_VREF_TYPE & 0xff);
    // Delay needed for the stabilization of the ADC input voltage
    _delay_us(7);
    // Start the AD conversion
    ADCSRA |= 0x40;
    // Wait for the AD conversion to complete
    while((ADCSRA & 0x10) == 0)
        continue;
    ADCSRA |= 0x10;
    return ADCW;
}

uint8_t NEW_REGULATOR(/*uint16_t Z,*/ uint16_t S) // s 1000=1
{
    int U, E;

    E = 150 - S; // z always 150
    PID_I_S = PID_I_S + E;
    if(PID_I_S > 1000)
        PID_I_S = 1000;
    if(PID_I_S < 0)
        PID_I_S = 0;

    if(S < 30)
        PID_I_S = 800;

    U = PID_I_S;

    U = U / 4;
    if(U < 0)
        U = 0;
    if(U > 255)
        U = 255;
    return (uint8_t)U;
}

// Timer2 overflow interrupt service routine
////100HZ Program cycle
ISR(TIMER2_OVF_vect) {
    int SCOLGENIE = 0;
    uint8_t PWM = 0;

    TCNT2 = 148; // 100HZ
    // Speed---------------------------------------------------------------------------
    if((IK_DELTA > 400) && (ovf_IK < 2)) //   ~~160km/h             172,800 kHz
    {
        IK_SPEED_KM_H = (uint16_t)(((unsigned long)R_IK * 2255) / IK_DELTA);
    } else {
        IK_SPEED_KM_H = 0;
    }
    IK_SPEED_MAS[0] = IK_SPEED_MAS[1];
    IK_SPEED_MAS[1] = IK_SPEED_MAS[2];
    IK_SPEED_MAS[2] = IK_SPEED_KM_H;

    if((TK_DELTA > 400) && (ovf_TK < 2)) //   ~~160            172,800 kHz
    {
        TK_SPEED_KM_H = (uint16_t)(((unsigned long)R_TK * 2171) / TK_DELTA);
    } else {
        TK_SPEED_KM_H = 0;
    }
    TK_SPEED_MAS[0] = TK_SPEED_MAS[1];
    TK_SPEED_MAS[1] = TK_SPEED_MAS[2];
    TK_SPEED_MAS[2] = TK_SPEED_KM_H;
    // Speed---------------------------------------------------------------------------

    // Proverka u vichiclenie skolgenia---------------------------------------------------------------
    if((IK_SPEED_KM_H >= TK_SPEED_KM_H) || (TK_SPEED_KM_H < 100)) // 10kmh
        SCOLGENIE = 0;
    else
        SCOLGENIE = (int)((((long int)(TK_SPEED_KM_H - IK_SPEED_KM_H)) * 1000) / ((long int)TK_SPEED_KM_H));
    //-----------------------------------------------------------------------------------------------

    if(flag_start == 1) {
        if(TK_SPEED_KM_H < 750) {
            PWM = NEW_REGULATOR(/*ZADANIE_S * 10,*/ (uint16_t)SCOLGENIE);
        } else {
            PWM = 255;
            // PID_I_S=800;
        }
    } else {
        PWM = 0;
    }
    OCR0 = 255 - PWM;

    if(program_cycle_counter < 9) {
        program_cycle_counter++;
    } else {
        program_cycle_flag = 1;
        program_cycle_counter = 0;
    }
}

// eeprom uint8_t EEP_CALIBR_MAS[10];
// eeprom uint8_t EEP_SETUP_MAS[8];

// uint8_t CALIBR_MAS[10]={249,66,94,7,9,7,2,8,24,(66+94+7+9+7+2+8+24)/8};
// uint8_t SETUP_MAS[8]={248,198,130,10,1,0,0,(198+130+10+1)/6};
void load_from_eeprom(void) {
    uint8_t tmp;
    uint16_t cal_sum = 0, setup_sum = 0;

    CALIBR_MAS[0] = EEP_CALIBR_MAS[0];
    CALIBR_MAS[9] = EEP_CALIBR_MAS[9];
    for(tmp = 1; tmp <= 8; tmp++) {
        CALIBR_MAS[tmp] = EEP_CALIBR_MAS[tmp];
        cal_sum = cal_sum + CALIBR_MAS[tmp];
    }
    cal_sum = cal_sum / 8;

    if((CALIBR_MAS[0] != 249) || (CALIBR_MAS[9] != cal_sum)) {
        for(tmp = 0; tmp <= 9; tmp++) {
            CALIBR_MAS[tmp] = DEFAULT_CALIBR_MAS[tmp];
        }
    }

    SETUP_MAS[0] = EEP_SETUP_MAS[0];
    SETUP_MAS[7] = EEP_SETUP_MAS[7];
    for(tmp = 1; tmp <= 6; tmp++) {
        SETUP_MAS[tmp] = EEP_SETUP_MAS[tmp];
        setup_sum = setup_sum + SETUP_MAS[tmp];
    }
    setup_sum = setup_sum / 6;
    if((SETUP_MAS[0] != 248) || (SETUP_MAS[7] != setup_sum)) {
        for(tmp = 0; tmp <= 7; tmp++) {
            SETUP_MAS[tmp] = DEFAULT_SETUP_MAS[tmp];
        }
    }
}

void save_to_eeprom(void) {
    uint8_t tmp;
    uint16_t sum;

    sum = 0;
    for(tmp = 1; tmp <= 8; tmp++) {
        sum = sum + CALIBR_MAS[tmp];
    }
    sum = sum / 8;

    if(sum == CALIBR_MAS[9]) {
        for(tmp = 0; tmp <= 9; tmp++) {
            EEP_CALIBR_MAS[tmp] = CALIBR_MAS[tmp];
        }
    }

    sum = 0;
    for(tmp = 1; tmp <= 6; tmp++) {
        sum = sum + SETUP_MAS[tmp];
    }
    sum = sum / 6;
    if(sum == SETUP_MAS[7]) {
        for(tmp = 0; tmp <= 7; tmp++) {
            EEP_SETUP_MAS[tmp] = SETUP_MAS[tmp];
        }
    }
}

// uint16_t K_BY_KOEFFICIENTS_OLD(uint16_t M)
//{
// unsigned long F,W,K;
////WEIGHT_NULL=6679, LOADCELL_NULL=618, DELTA_WEIGHT10KG=748, DELTA_LOADCELL10KG=772
// if(M<LOADCELL_NULL)
//  return 0;
//
// F=((M-(unsigned long)LOADCELL_NULL)*1000)/((unsigned long)DELTA_LOADCELL10KG);
// W=(unsigned long)WEIGHT_NULL-((unsigned long)DELTA_WEIGHT10KG*F)/1000;
// if(W>0)
//  K=(F*1000)/W;
// else
//  K=3000;
//
// if(K>3000)
//  K=3000;
// return K;
// }
