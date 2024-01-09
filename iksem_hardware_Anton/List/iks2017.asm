
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega128A
;Program type           : Application
;Clock frequency        : 11,059200 MHz
;Memory model           : Small
;Optimize for           : Speed
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128A
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _WEIGHT_NULL=R4
	.DEF _WEIGHT_NULL_msb=R5
	.DEF _LOADCELL_NULL=R6
	.DEF _LOADCELL_NULL_msb=R7
	.DEF _DELTA_WEIGHT10KG=R8
	.DEF _DELTA_WEIGHT10KG_msb=R9
	.DEF _DELTA_LOADCELL10KG=R10
	.DEF _DELTA_LOADCELL10KG_msb=R11
	.DEF _R_IK=R12
	.DEF _R_IK_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _ext_int6_isr
	JMP  _ext_int7_isr
	JMP  0x00
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart1_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x60,0x1A,0x29,0x8
	.DB  0x20,0x3,0xDB,0x1
	.DB  0xCA,0x0

_0x3:
	.DB  0x4D,0x1
_0x4:
	.DB  0xF
_0x5:
	.DB  0xF8,0xCA,0x85,0xF,0x1,0x0,0x0,0x3A
_0x6:
	.DB  0xF9,0x43,0x34,0x14,0x59,0x8,0x0,0x4
	.DB  0x4B,0x27
_0x7:
	.DB  0xF4,0x5
_0x8:
	.DB  0x67,0x1A
_0x9:
	.DB  0xFF
_0xA:
	.DB  0xFF,0x5,0x37,0x4,0x31,0x6,0x15,0x7
	.DB  0x32,0x5,0x50,0x4B,0x0,0x3B,0x3A,0x1F
	.DB  0x16,0x1E,0x13,0x37,0x18,0x4E,0x45,0x32
	.DB  0x0,0x23
_0xB:
	.DB  0x1,0x0,0x1,0x0,0x1,0x0,0x1
_0xC:
	.DB  0x1,0x0,0x1,0x0,0x1,0x0,0x1
_0xD:
	.DB  0x20,0x3
_0x23:
	.DB  0x50,0x46,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0
_0x0:
	.DB  0x41,0x54,0x2B,0x4E,0x41,0x4D,0x45,0x49
	.DB  0x4B,0x53,0x45,0x4D,0x23,0x30,0x30,0xD
	.DB  0xA,0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x02
	.DW  _R_TK
	.DW  _0x3*2

	.DW  0x01
	.DW  _ZADANIE_S
	.DW  _0x4*2

	.DW  0x08
	.DW  _DEFAULT_SETUP_MAS
	.DW  _0x5*2

	.DW  0x0A
	.DW  _DEFAULT_CALIBR_MAS
	.DW  _0x6*2

	.DW  0x01
	.DW  _flag_transmission
	.DW  _0x9*2

	.DW  0x1A
	.DW  _SEND_MAS
	.DW  _0xA*2

	.DW  0x07
	.DW  _GPS_shir
	.DW  _0xB*2

	.DW  0x07
	.DW  _GPS_dolg
	.DW  _0xC*2

	.DW  0x02
	.DW  _PID_I_S
	.DW  _0xD*2

	.DW  0x12
	.DW  _0x26
	.DW  _0x0*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*****************************************************
;Chip type               : ATmega128A
;Program type            : Application
;AVR Core Clock frequency: 11,059200 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*****************************************************/
;
;#include <mega128a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;// I2C Bus functions
;#include <i2c.h>
;// Standard Input/Output functions
;#include <stdio.h>
;
;
;#define DDR_SPI DDRB
;#define PORT_SPI PORTB
;#define SS 0
;
;#define ADC_VREF_TYPE 0xC0
;#ifndef UDRE
;#define UDRE 5
;#endif
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define AD7799_DDRDY PINB.3
;
;
;
;
;#define AVERAGE_NUMBER 15
;
;#define FIXWEIGHT //закоментить отрубить фиксированный вес
;#define SPEEDFILTER //закоментить отрубить медианный фильтр скорости
;#define ADC_FAULT_RESET //закоментить отрубить отрубание телеги при неправильной иниц ADC
;
;//#define ADC_TO_KG//Раскометить для поверки Закоментить чтоб измерять
;
;#define IKS00  //номер телеги!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;
;
;//Список необходимых изменений
;//5)АЦП периодически не инициализируется исправить
;//6)Показания аккумулятора фильтрануть ++++++++++++++++++++
;
;//Формула
;
;//В проге мобилы:
;//2)Задание Скольж убрать
;//3)Скорость мерять правильно
;//4)пароль сделать из файла
;//5)выводить код ошибки и саму ошибку
;
;
;eeprom unsigned char EEP_SETUP_MAS[8];
;eeprom unsigned char EEP_CALIBR_MAS[10];
;
;
;
;#ifdef IKS01
;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CALIBR_MAIN_DATA N01
;#define N_string "AT+NAMEIKSEM#01\r\n"
;//unsigned int WEIGHT_NULL=7039, LOADCELL_NULL=1807, DELTA_WEIGHT10KG=842, DELTA_LOADCELL10KG=513;
;//unsigned int WEIGHT_NULL=7023, LOADCELL_NULL=1900, DELTA_WEIGHT10KG=834, DELTA_LOADCELL10KG=508;
;unsigned int WEIGHT_NULL=6752, LOADCELL_NULL=2089, DELTA_WEIGHT10KG=800, DELTA_LOADCELL10KG=475; //march 17 2023 Mishanj ...
;unsigned int R_IK=202, R_TK=333 , ZADANIE_S=15;
;unsigned char SETUP_MAS[8]={0,0,0,0,0,0,0,0};
;unsigned char CALIBR_MAS[10]={0,0,0,0,0,0,0,0,0,0};
;unsigned char DEFAULT_SETUP_MAS[8]={248,202,133,15,1,0,0,(202+133+15+1)/6};
;//unsigned char DEFAULT_CALIBR_MAS[10]={249,70,39,18,7,8,42,5,13,(70+39+18+7+8+42+5+13)/8};
;//unsigned char DEFAULT_CALIBR_MAS[10]={249,70,23,19,0,8,34,5,8,(70+23+19+0+8+34+5+8)/8};
;unsigned char DEFAULT_CALIBR_MAS[10]={249,67,52,20,89,8,0,4,75,(67+52+20+89+8+0+4+75)/8};
;int ADC_0_KG=1524,ADC_100_KG=6759;
;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CALIBR_MAIN_DATA N01
;#endif
;
;#ifdef IKS02
;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CALIBR_MAIN_DATA N02
;#define N_string "AT+NAMEIKSEM#02\r\n"
;//unsigned int WEIGHT_NULL=6846, LOADCELL_NULL=400, DELTA_WEIGHT10KG=835, DELTA_LOADCELL10KG=495;
;//unsigned int WEIGHT_NULL=6914, LOADCELL_NULL=395, DELTA_WEIGHT10KG=863, DELTA_LOADCELL10KG=511;
;unsigned int WEIGHT_NULL=6838, LOADCELL_NULL=364, DELTA_WEIGHT10KG=856, DELTA_LOADCELL10KG=516;
;unsigned int R_IK=202, R_TK=333 , ZADANIE_S=15;
;unsigned char SETUP_MAS[8]={0,0,0,0,0,0,0,0};
;unsigned char CALIBR_MAS[10]={0,0,0,0,0,0,0,0,0,0};
;unsigned char DEFAULT_SETUP_MAS[8]={248,202,133,15,1,0,0,(202+133+15+1)/6};
;//unsigned char DEFAULT_CALIBR_MAS[10]={249,68,46,4,0,8,35,4,95,(68+46+4+0+8+35+4+95)/8};
;//unsigned char DEFAULT_CALIBR_MAS[10]={249,69,14,3,95,8,63,5,11,(69+14+3+95+8+63+5+11)/8};
;unsigned char DEFAULT_CALIBR_MAS[10]={249,68,38,3,64,8,56,5,16,(68+38+3+64+8+56+5+16)/8};
;
;unsigned char ADC_0_KG=88,ADC_100_KG=6759;
;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CALIBR_MAIN_DATA N02
;#endif
;
;#ifdef IKS03
;////!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CALIBR_MAIN_DATA N03
;#define N_string "AT+NAMEIKSEM#03\r\n"
;//unsigned int WEIGHT_NULL=6944, LOADCELL_NULL=313, DELTA_WEIGHT10KG=825, DELTA_LOADCELL10KG=495;
;unsigned int WEIGHT_NULL=7093, LOADCELL_NULL=402, DELTA_WEIGHT10KG=843, DELTA_LOADCELL10KG=500;
;unsigned int R_IK=202, R_TK=333 , ZADANIE_S=15;
;unsigned char SETUP_MAS[8]={0,0,0,0,0,0,0,0};
;unsigned char CALIBR_MAS[10]={0,0,0,0,0,0,0,0,0,0};
;unsigned char DEFAULT_SETUP_MAS[8]={248,202,133,15,1,0,0,(202+133+15+1)/6};
;//unsigned char DEFAULT_CALIBR_MAS[10]={249,69,44,3,13,8,25,4,95,(69+44+3+13+8+25+4+95)/8};
;unsigned char DEFAULT_CALIBR_MAS[10]={249,70,93,4,2,8,43,5,0,(70+93+4+2+8+43+5+0)/8};
;
;unsigned char ADC_0_KG=88,ADC_100_KG=6759;
;////!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!CALIBR_MAIN_DATA N03
;#endif
;
;#ifdef IKS00
;//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!PCS_WITHOUT_TELEGA
;#define N_string "AT+NAMEIKSEM#00\r\n"
;unsigned int WEIGHT_NULL=6752, LOADCELL_NULL=2089, DELTA_WEIGHT10KG=800, DELTA_LOADCELL10KG=475; //march 17 2023 Mishanj ...
;unsigned int R_IK=202, R_TK=333 , ZADANIE_S=15;

	.DSEG
;unsigned char SETUP_MAS[8]={0,0,0,0,0,0,0,0};
;unsigned char CALIBR_MAS[10]={0,0,0,0,0,0,0,0,0,0};
;unsigned char DEFAULT_SETUP_MAS[8]={248,202,133,15,1,0,0,(202+133+15+1)/6};
;unsigned char DEFAULT_CALIBR_MAS[10]={249,67,52,20,89,8,0,4,75,(67+52+20+89+8+0+4+75)/8};
;int ADC_0_KG=1524,ADC_100_KG=6759;
;#endif
;
;
;unsigned flag_transmission=255;
;unsigned flag_receive=0,receive_counter=0;
;
;unsigned char SEND_MAS[26]={255,5,55,4,49,6,21,7,50,5,80,75,0,3598/60,3598%60,31,22,1819/60,1819%60,55,24,'N','E',50,0,3 ...
;
;
;unsigned char program_cycle_flag=0,program_cycle_counter=0;
;
;unsigned char ovf_IK=0, ovf_TK=0;
;unsigned long IK_COUNT[2]={0,0}, TK_COUNT[2]={0,0}, IK_DELTA=0, TK_DELTA=0;
;unsigned int IK_SPEED_KM_H=0,TK_SPEED_KM_H=0;
;unsigned int IK_SPEED_MAS[3]={0,0,0},TK_SPEED_MAS[3]={0,0,0};
;
;unsigned int ADC_BAT=0,ADC_I=0;
;unsigned int BAT_SUM=0;
;long I_NULL=0;
;unsigned char flag_I_NULL=0;
;//  unsigned int A_BAT=0,A_I=0;
;
;unsigned char GPS_zap_counter=0,GPS_sim_counter=0,GPS_flag_ready=0;//1-ustanovlen 0-ne ustanovlen
;unsigned char GPS_string_name[3]={0,0,0},GPS_flag_gp=0;//0-no 1-1 bukva posle P, 2-2ya, 3-3ya, 4-GGA
;unsigned int GPS_shir[4]={1,1,1,1},GPS_dolg[4]={1,1,1,1};//grad min .xxxx  NSWE
;unsigned char GPS_solve=0;
;unsigned char GPS_ON_COUNTER=0;
;unsigned char flag_start=0;
;unsigned char measuring_start_counter=0;
;int load_cell=0,load_cell_MAS[20];
;unsigned char ADC_fault_counter=0;
;
;
;int PID_I_S=800;
;
;
;interrupt [EXT_INT7] void ext_int7_isr(void);
;interrupt [EXT_INT6] void ext_int6_isr(void);
;void init_all(void);
;void led_zero(void);
;void led_one(void);
;void lights(char G, char R, char B);
;unsigned int K_BY_KOEFFICIENTS_REAL(unsigned int M);
;unsigned int K_BY_KOEFFICIENTS_ASFT(unsigned int M);
;void Read_Setup_Calibr(void);
;void Control_Sum_Send(void);
;void Control_Sum_Calibr(void);
;void Control_Sum_Setup(void);
;interrupt [TIM1_OVF] void timer1_ovf_isr(void);
;void delay(unsigned int d);
;void SPI_MasterInit(void);
;unsigned char SPI_MasterReceive(void);
;void SPI_MasterTransmit(unsigned char x);
;void SET_AD7799(void);
;unsigned int READ_AD7799(void);
;void uart1SendByte(char data);
;void uart1SendString(char *str);
;void uart1SendArray(unsigned char *array, unsigned char size);
;interrupt [USART0_RXC] void usart0_rx_isr(void);
;interrupt [USART1_RXC] void usart1_rx_isr(void);
;unsigned int read_adc(unsigned char adc_input);
;interrupt [TIM2_OVF] void timer2_ovf_isr(void);
;
;void load_from_eeprom(void);
;void save_to_eeprom(void);
;
;unsigned int load_cell_filter(void)
; 0000 00BD {

	.CSEG
_load_cell_filter:
; .FSTART _load_cell_filter
; 0000 00BE  unsigned char tmp;
; 0000 00BF  unsigned long int sum=0;
; 0000 00C0 
; 0000 00C1  if(measuring_start_counter<2)
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	ST   -Y,R17
;	tmp -> R17
;	sum -> Y+1
	LDS  R26,_measuring_start_counter
	CPI  R26,LOW(0x2)
	BRSH _0xE
; 0000 00C2  {
; 0000 00C3   for(tmp=(AVERAGE_NUMBER-1);tmp>0;tmp--)
	LDI  R17,LOW(14)
_0x10:
	CPI  R17,1
	BRLO _0x11
; 0000 00C4   {
; 0000 00C5     load_cell_MAS[tmp]=load_cell;
	MOV  R30,R17
	LDI  R26,LOW(_load_cell_MAS)
	LDI  R27,HIGH(_load_cell_MAS)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	LDS  R26,_load_cell
	LDS  R27,_load_cell+1
	STD  Z+0,R26
	STD  Z+1,R27
; 0000 00C6     sum=sum+load_cell;
	LDS  R30,_load_cell
	LDS  R31,_load_cell+1
	__GETD2S 1
	CALL __CWD1
	CALL __ADDD12
	__PUTD1S 1
; 0000 00C7   }
	SUBI R17,1
	RJMP _0x10
_0x11:
; 0000 00C8  }
; 0000 00C9  else
	RJMP _0x12
_0xE:
; 0000 00CA  {
; 0000 00CB   for(tmp=(AVERAGE_NUMBER-1);tmp>0;tmp--)
	LDI  R17,LOW(14)
_0x14:
	CPI  R17,1
	BRLO _0x15
; 0000 00CC   {
; 0000 00CD     load_cell_MAS[tmp]=load_cell_MAS[tmp-1];
	MOV  R30,R17
	LDI  R26,LOW(_load_cell_MAS)
	LDI  R27,HIGH(_load_cell_MAS)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,1
	LDI  R26,LOW(_load_cell_MAS)
	LDI  R27,HIGH(_load_cell_MAS)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
; 0000 00CE     sum=sum+load_cell_MAS[tmp];
	MOV  R30,R17
	LDI  R26,LOW(_load_cell_MAS)
	LDI  R27,HIGH(_load_cell_MAS)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	__GETD2S 1
	CALL __CWD1
	CALL __ADDD12
	__PUTD1S 1
; 0000 00CF   }
	SUBI R17,1
	RJMP _0x14
_0x15:
; 0000 00D0  }
_0x12:
; 0000 00D1  load_cell_MAS[0]=load_cell;
	LDS  R30,_load_cell
	LDS  R31,_load_cell+1
	STS  _load_cell_MAS,R30
	STS  _load_cell_MAS+1,R31
; 0000 00D2  sum=sum+load_cell;
	LDS  R30,_load_cell
	LDS  R31,_load_cell+1
	__GETD2S 1
	CALL __CWD1
	CALL __ADDD12
	__PUTD1S 1
; 0000 00D3  sum=sum/AVERAGE_NUMBER;
	__GETD2S 1
	__GETD1N 0xF
	CALL __DIVD21U
	__PUTD1S 1
; 0000 00D4  return (unsigned int)sum;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R17,Y+0
	ADIW R28,5
	RET
; 0000 00D5 }
; .FEND
;
;// Write a character to the USART1 Transmitter
;#pragma used+
;void putchar1(char c)
; 0000 00DA {
; 0000 00DB  while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
; 0000 00DC   UDR1=c;
; 0000 00DD }
;#pragma used-
;
;//
;unsigned int middle(unsigned int d1, unsigned int d2, unsigned int d3)
; 0000 00E2 {
_middle:
; .FSTART _middle
; 0000 00E3  if(d1>=d2)
	ST   -Y,R27
	ST   -Y,R26
;	d1 -> Y+4
;	d2 -> Y+2
;	d3 -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x19
; 0000 00E4  {
; 0000 00E5   if(d1<=d3) return d1;
	LD   R30,Y
	LDD  R31,Y+1
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x1A
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP _0x2060006
; 0000 00E6   else
_0x1A:
; 0000 00E7   {
; 0000 00E8    if(d2>=d3)
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x1C
; 0000 00E9     return d2;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RJMP _0x2060006
; 0000 00EA    else
_0x1C:
; 0000 00EB     return d3;
	LD   R30,Y
	LDD  R31,Y+1
	RJMP _0x2060006
; 0000 00EC   }
; 0000 00ED  }
; 0000 00EE  else
_0x19:
; 0000 00EF  {
; 0000 00F0   if(d2<=d3) return d2;
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x1F
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RJMP _0x2060006
; 0000 00F1   else
_0x1F:
; 0000 00F2   {
; 0000 00F3    if(d1>=d3)
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x21
; 0000 00F4     return d1;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RJMP _0x2060006
; 0000 00F5    else
_0x21:
; 0000 00F6     return d3;
	LD   R30,Y
	LDD  R31,Y+1
; 0000 00F7   }
; 0000 00F8  }
; 0000 00F9 }
_0x2060006:
	ADIW R28,6
	RET
; .FEND
;
;void main(void)
; 0000 00FC {
_main:
; .FSTART _main
; 0000 00FD // Declare your local variables here
; 0000 00FE unsigned char main_cycle=0,flag_led_direction=0,led_cycle=0;
; 0000 00FF unsigned int BAT=0;
; 0000 0100 unsigned int K=0;
; 0000 0101 unsigned int TMP,TMPL;
; 0000 0102 
; 0000 0103 int M=0;
; 0000 0104 int I=0;
; 0000 0105 unsigned int TIME_OUT=10*60*30;
; 0000 0106 
; 0000 0107 Control_Sum_Calibr();
	SBIW R28,12
	LDI  R24,12
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x23*2)
	LDI  R31,HIGH(_0x23*2)
	CALL __INITLOCB
;	main_cycle -> R17
;	flag_led_direction -> R16
;	led_cycle -> R19
;	BAT -> R20,R21
;	K -> Y+10
;	TMP -> Y+8
;	TMPL -> Y+6
;	M -> Y+4
;	I -> Y+2
;	TIME_OUT -> Y+0
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	__GETWRN 20,21,0
	CALL _Control_Sum_Calibr
; 0000 0108 Control_Sum_Setup();
	CALL _Control_Sum_Setup
; 0000 0109 load_from_eeprom();
	CALL _load_from_eeprom
; 0000 010A Read_Setup_Calibr();
	CALL _Read_Setup_Calibr
; 0000 010B 
; 0000 010C 
; 0000 010D 
; 0000 010E 
; 0000 010F init_all();
	RCALL _init_all
; 0000 0110 // I2C Port: PORTD
; 0000 0111 // I2C SDA bit: 1
; 0000 0112 // I2C SCL bit: 0
; 0000 0113 // Bit Rate: 100 kHz
; 0000 0114 i2c_init();
	CALL _i2c_init
; 0000 0115 
; 0000 0116 SPI_MasterInit();
	CALL _SPI_MasterInit
; 0000 0117 
; 0000 0118 // Global enable interrupts
; 0000 0119 
; 0000 011A 
; 0000 011B PORTC.0 = 1;//iksem - on
	SBI  0x15,0
; 0000 011C 
; 0000 011D //PORTC.1 = 1;//fonar on
; 0000 011E 
; 0000 011F 
; 0000 0120 delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0121 SET_AD7799();
	CALL _SET_AD7799
; 0000 0122 delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0123 SET_AD7799();
	CALL _SET_AD7799
; 0000 0124 delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0125 uart1SendString(N_string);//Set BLUETOOTH NAME
	__POINTW2MN _0x26,0
	CALL _uart1SendString
; 0000 0126 #asm("sei");
	sei
; 0000 0127 
; 0000 0128 while (1)
_0x27:
; 0000 0129     {
; 0000 012A      /*
; 0000 012B       program_cycle_flag=0;
; 0000 012C       while(program_cycle_flag!=1)
; 0000 012D       {}
; 0000 012E       program_cycle_flag=0;
; 0000 012F      */
; 0000 0130 
; 0000 0131       #ifdef SPEEDFILTER
; 0000 0132       TMP=middle(TK_SPEED_MAS[0],TK_SPEED_MAS[1],TK_SPEED_MAS[2]);
	LDS  R30,_TK_SPEED_MAS
	LDS  R31,_TK_SPEED_MAS+1
	ST   -Y,R31
	ST   -Y,R30
	__GETW1MN _TK_SPEED_MAS,2
	ST   -Y,R31
	ST   -Y,R30
	__GETW2MN _TK_SPEED_MAS,4
	RCALL _middle
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 0133       SEND_MAS[1]= TMP/100;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	__PUTB1MN _SEND_MAS,1
; 0000 0134       SEND_MAS[2]= TMP%100;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	__PUTB1MN _SEND_MAS,2
; 0000 0135       TMP=middle(IK_SPEED_MAS[0],IK_SPEED_MAS[1],IK_SPEED_MAS[2]);
	LDS  R30,_IK_SPEED_MAS
	LDS  R31,_IK_SPEED_MAS+1
	ST   -Y,R31
	ST   -Y,R30
	__GETW1MN _IK_SPEED_MAS,2
	ST   -Y,R31
	ST   -Y,R30
	__GETW2MN _IK_SPEED_MAS,4
	RCALL _middle
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 0136       SEND_MAS[3]= TMP/100;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	__PUTB1MN _SEND_MAS,3
; 0000 0137       SEND_MAS[4]= TMP%100;
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	__PUTB1MN _SEND_MAS,4
; 0000 0138       #else
; 0000 0139       SEND_MAS[1]= TK_SPEED_KM_H/100;
; 0000 013A       SEND_MAS[2]= TK_SPEED_KM_H%100;
; 0000 013B       SEND_MAS[3]= IK_SPEED_KM_H/100;
; 0000 013C       SEND_MAS[4]= IK_SPEED_KM_H%100;
; 0000 013D       #endif
; 0000 013E 
; 0000 013F        if(flag_start==1)
	LDS  R26,_flag_start
	CPI  R26,LOW(0x1)
	BRNE _0x2A
; 0000 0140        {
; 0000 0141         TIME_OUT=10*60*30;
	LDI  R30,LOW(18000)
	LDI  R31,HIGH(18000)
	RJMP _0x11C
; 0000 0142 
; 0000 0143        // measuring_start_counter++;
; 0000 0144        }//30 min
; 0000 0145        else
_0x2A:
; 0000 0146        {
; 0000 0147         if(TIME_OUT==0)
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x2C
; 0000 0148          PORTC.0 = 0;//iksem - off
	CBI  0x15,0
; 0000 0149         else
	RJMP _0x2F
_0x2C:
; 0000 014A          TIME_OUT--;
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,1
_0x11C:
	ST   Y,R30
	STD  Y+1,R31
; 0000 014B        }
_0x2F:
; 0000 014C 
; 0000 014D 
; 0000 014E       while(AD7799_DDRDY==0) //!DDRDY
_0x30:
	SBIS 0x16,3
; 0000 014F       {}
	RJMP _0x30
; 0000 0150 
; 0000 0151       #ifdef ADC_FAULT_RESET
; 0000 0152        TMPL=TCNT3L;//read low first
	LDS  R30,136
	LDI  R31,0
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 0153        TMP=TCNT3H;
	LDS  R30,137
	LDI  R31,0
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 0154        TMP=(TMP<<8)+TMPL;
	LDD  R31,Y+8
	LDI  R30,LOW(0)
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 0155        if((TMP<(1080-250))||(TMP>(1080+250)))
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CPI  R26,LOW(0x33E)
	LDI  R30,HIGH(0x33E)
	CPC  R27,R30
	BRLO _0x34
	CPI  R26,LOW(0x533)
	LDI  R30,HIGH(0x533)
	CPC  R27,R30
	BRLO _0x33
_0x34:
; 0000 0156        {
; 0000 0157         if(ADC_fault_counter>5)
	LDS  R26,_ADC_fault_counter
	CPI  R26,LOW(0x6)
	BRLO _0x36
; 0000 0158         {
; 0000 0159          PORTC.0 = 0;//iksem - off
	CBI  0x15,0
; 0000 015A         }
; 0000 015B         else
	RJMP _0x39
_0x36:
; 0000 015C         {
; 0000 015D          ADC_fault_counter++;
	LDS  R30,_ADC_fault_counter
	SUBI R30,-LOW(1)
	STS  _ADC_fault_counter,R30
; 0000 015E         }
_0x39:
; 0000 015F        }
; 0000 0160        else
	RJMP _0x3A
_0x33:
; 0000 0161        {
; 0000 0162         ADC_fault_counter=0;
	LDI  R30,LOW(0)
	STS  _ADC_fault_counter,R30
; 0000 0163         PORTC.0 = 1;//iksem - on
	SBI  0x15,0
; 0000 0164        }
_0x3A:
; 0000 0165        TCNT3H=0;//write high first
	LDI  R30,LOW(0)
	STS  137,R30
; 0000 0166        TCNT3L=0;
	STS  136,R30
; 0000 0167       #endif
; 0000 0168 
; 0000 0169       delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0000 016A       load_cell=READ_AD7799();
	CALL _READ_AD7799
	STS  _load_cell,R30
	STS  _load_cell+1,R31
; 0000 016B       delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0000 016C 
; 0000 016D      //M----------------------------------------------
; 0000 016E      #ifdef ADC_TO_KG
; 0000 016F      load_cell=load_cell-ADC_0_KG;
; 0000 0170      load_cell=(int)(((long int)load_cell*10000)/(long int)ADC_100_KG);
; 0000 0171      if(load_cell<0)
; 0000 0172      {load_cell=0;}
; 0000 0173      #endif
; 0000 0174      //load_cell=88 - 0kg
; 0000 0175      //load_cell=835 - 11,1kg
; 0000 0176      // 1 adc = 0,01486 kg
; 0000 0177 
; 0000 0178 
; 0000 0179       M=load_cell_filter();
	RCALL _load_cell_filter
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 017A       if(M<0)
	LDD  R26,Y+5
	TST  R26
	BRPL _0x3D
; 0000 017B       M=0;
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 017C       if(M>10000)
_0x3D:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CPI  R26,LOW(0x2711)
	LDI  R30,HIGH(0x2711)
	CPC  R27,R30
	BRLT _0x3E
; 0000 017D       M=10000;
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 017E       if(flag_start==0)
_0x3E:
	LDS  R30,_flag_start
	CPI  R30,0
	BRNE _0x3F
; 0000 017F       {
; 0000 0180        measuring_start_counter=0;
	LDI  R30,LOW(0)
	RJMP _0x11D
; 0000 0181       }
; 0000 0182       else
_0x3F:
; 0000 0183       {
; 0000 0184        if(measuring_start_counter<30)
	LDS  R26,_measuring_start_counter
	CPI  R26,LOW(0x1E)
	BRSH _0x41
; 0000 0185         {measuring_start_counter++;}
	LDS  R30,_measuring_start_counter
	SUBI R30,-LOW(1)
_0x11D:
	STS  _measuring_start_counter,R30
; 0000 0186       }
_0x41:
; 0000 0187 
; 0000 0188       SEND_MAS[7]=M/100;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	__PUTB1MN _SEND_MAS,7
; 0000 0189       SEND_MAS[8]=M%100;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	__PUTB1MN _SEND_MAS,8
; 0000 018A       //---------------------------------------------
; 0000 018B 
; 0000 018C 
; 0000 018D      //KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
; 0000 018E       if(ZADANIE_S==15)
	LDS  R26,_ZADANIE_S
	LDS  R27,_ZADANIE_S+1
	SBIW R26,15
	BRNE _0x42
; 0000 018F        K=K_BY_KOEFFICIENTS_ASFT(M);
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL _K_BY_KOEFFICIENTS_ASFT
	RJMP _0x11E
; 0000 0190       else
_0x42:
; 0000 0191        K=K_BY_KOEFFICIENTS_REAL(M);
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL _K_BY_KOEFFICIENTS_REAL
_0x11E:
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 0192 
; 0000 0193       SEND_MAS[5]=K/100;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	__PUTB1MN _SEND_MAS,5
; 0000 0194       SEND_MAS[6]=K%100;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	__PUTB1MN _SEND_MAS,6
; 0000 0195 
; 0000 0196      //KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK
; 0000 0197 
; 0000 0198      ADC_BAT=read_adc(0);
	LDI  R26,LOW(0)
	CALL _read_adc
	STS  _ADC_BAT,R30
	STS  _ADC_BAT+1,R31
; 0000 0199      ADC_I=read_adc(1);//0.021В датчика = 1А = 2.1*4 = 8.4 АЦП (1024 = 2.56в)
	LDI  R26,LOW(1)
	CALL _read_adc
	STS  _ADC_I,R30
	STS  _ADC_I+1,R31
; 0000 019A      BAT_SUM=(BAT_SUM*9)/10+ADC_BAT;
	LDS  R26,_BAT_SUM
	LDS  R27,_BAT_SUM+1
	LDI  R30,LOW(9)
	CALL __MULB1W2U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	LDS  R26,_ADC_BAT
	LDS  R27,_ADC_BAT+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _BAT_SUM,R30
	STS  _BAT_SUM+1,R31
; 0000 019B      ADC_BAT=BAT_SUM/10;
	LDS  R26,_BAT_SUM
	LDS  R27,_BAT_SUM+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STS  _ADC_BAT,R30
	STS  _ADC_BAT+1,R31
; 0000 019C      if(flag_I_NULL<10)
	LDS  R26,_flag_I_NULL
	CPI  R26,LOW(0xA)
	BRSH _0x44
; 0000 019D      {
; 0000 019E       I_NULL=I_NULL+ADC_I;
	LDS  R30,_ADC_I
	LDS  R31,_ADC_I+1
	LDS  R26,_I_NULL
	LDS  R27,_I_NULL+1
	LDS  R24,_I_NULL+2
	LDS  R25,_I_NULL+3
	CLR  R22
	CLR  R23
	CALL __ADDD12
	STS  _I_NULL,R30
	STS  _I_NULL+1,R31
	STS  _I_NULL+2,R22
	STS  _I_NULL+3,R23
; 0000 019F 
; 0000 01A0       if(flag_I_NULL==9)
	LDS  R26,_flag_I_NULL
	CPI  R26,LOW(0x9)
	BRNE _0x45
; 0000 01A1       I_NULL=I_NULL/10;
	LDS  R26,_I_NULL
	LDS  R27,_I_NULL+1
	LDS  R24,_I_NULL+2
	LDS  R25,_I_NULL+3
	__GETD1N 0xA
	CALL __DIVD21
	STS  _I_NULL,R30
	STS  _I_NULL+1,R31
	STS  _I_NULL+2,R22
	STS  _I_NULL+3,R23
; 0000 01A2 
; 0000 01A3       flag_I_NULL++;
_0x45:
	LDS  R30,_flag_I_NULL
	SUBI R30,-LOW(1)
	STS  _flag_I_NULL,R30
; 0000 01A4      }
; 0000 01A5      //BATTERY LEVEL--------------------------------------------------------
; 0000 01A6       BAT=ADC_BAT;//163*4-100%(12.7) 150*4-0%(11.7)
_0x44:
	__GETWRMN 20,21,0,_ADC_BAT
; 0000 01A7 
; 0000 01A8      // if(ADC_I>=(252*4))
; 0000 01A9      //  I=0;
; 0000 01AA      // else
; 0000 01AB 
; 0000 01AC 
; 0000 01AD 
; 0000 01AE       if(BAT<=610)
	__CPWRN 20,21,611
	BRSH _0x46
; 0000 01AF        {
; 0000 01B0         SEND_MAS[23]=0;
	LDI  R30,LOW(0)
	RJMP _0x11F
; 0000 01B1        }
; 0000 01B2        else
_0x46:
; 0000 01B3        {
; 0000 01B4         if(BAT>=660)
	__CPWRN 20,21,660
	BRLO _0x48
; 0000 01B5          SEND_MAS[23]=100;
	LDI  R30,LOW(100)
	RJMP _0x11F
; 0000 01B6         else
_0x48:
; 0000 01B7          SEND_MAS[23]=(unsigned char)((BAT-610)*2);
	MOV  R30,R20
	SUBI R30,LOW(98)
	LSL  R30
_0x11F:
	__PUTB1MN _SEND_MAS,23
; 0000 01B8        }
; 0000 01B9      //--------------------------------------------------------------------
; 0000 01BA 
; 0000 01BB      I=ADC_I;
	LDS  R30,_ADC_I
	LDS  R31,_ADC_I+1
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 01BC      I=(int)(((long)(I_NULL-I)*100)/84);//0.021В датчика = 1А = 2.1*4 = 8.4 АЦП (1024 = 2.56в) 2.52v=0
	LDS  R26,_I_NULL
	LDS  R27,_I_NULL+1
	LDS  R24,_I_NULL+2
	LDS  R25,_I_NULL+3
	CALL __CWD1
	CALL __SUBD21
	__GETD1N 0x64
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x54
	CALL __DIVD21
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 01BD      if(I<0)
	LDD  R26,Y+3
	TST  R26
	BRPL _0x4A
; 0000 01BE      I=0;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 01BF 
; 0000 01C0 
; 0000 01C1       SEND_MAS[9]=I/100;
_0x4A:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	__PUTB1MN _SEND_MAS,9
; 0000 01C2       SEND_MAS[10]=I%100;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	__PUTB1MN _SEND_MAS,10
; 0000 01C3 
; 0000 01C4 
; 0000 01C5     //Контрольная сумма----------------------
; 0000 01C6      Control_Sum_Send();
	RCALL _Control_Sum_Send
; 0000 01C7     //---------------------------------------
; 0000 01C8       if(flag_transmission==255)
	LDS  R26,_flag_transmission
	LDS  R27,_flag_transmission+1
	CPI  R26,LOW(0xFF)
	LDI  R30,HIGH(0xFF)
	CPC  R27,R30
	BRNE _0x4B
; 0000 01C9       {
; 0000 01CA        uart1SendArray(SEND_MAS,26);
	LDI  R30,LOW(_SEND_MAS)
	LDI  R31,HIGH(_SEND_MAS)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(26)
	CALL _uart1SendArray
; 0000 01CB       }
; 0000 01CC       else
	RJMP _0x4C
_0x4B:
; 0000 01CD       {
; 0000 01CE        if(flag_transmission==248)
	LDS  R26,_flag_transmission
	LDS  R27,_flag_transmission+1
	CPI  R26,LOW(0xF8)
	LDI  R30,HIGH(0xF8)
	CPC  R27,R30
	BRNE _0x4D
; 0000 01CF        {
; 0000 01D0         uart1SendArray(SETUP_MAS,8);
	LDI  R30,LOW(_SETUP_MAS)
	LDI  R31,HIGH(_SETUP_MAS)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(8)
	CALL _uart1SendArray
; 0000 01D1         flag_transmission=255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STS  _flag_transmission,R30
	STS  _flag_transmission+1,R31
; 0000 01D2        }
; 0000 01D3        if(flag_transmission==249)
_0x4D:
	LDS  R26,_flag_transmission
	LDS  R27,_flag_transmission+1
	CPI  R26,LOW(0xF9)
	LDI  R30,HIGH(0xF9)
	CPC  R27,R30
	BRNE _0x4E
; 0000 01D4        {
; 0000 01D5         uart1SendArray(CALIBR_MAS,10);
	LDI  R30,LOW(_CALIBR_MAS)
	LDI  R31,HIGH(_CALIBR_MAS)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(10)
	CALL _uart1SendArray
; 0000 01D6         flag_transmission=255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STS  _flag_transmission,R30
	STS  _flag_transmission+1,R31
; 0000 01D7        }
; 0000 01D8       }
_0x4E:
_0x4C:
; 0000 01D9 
; 0000 01DA 
; 0000 01DB       #asm("cli")
	cli
; 0000 01DC       lights(252-led_cycle*28,led_cycle*28,252-led_cycle*28);
	LDI  R26,LOW(28)
	MULS R19,R26
	MOVW R30,R0
	LDI  R26,LOW(252)
	SUB  R26,R30
	ST   -Y,R26
	LDI  R26,LOW(28)
	MULS R19,R26
	ST   -Y,R0
	MULS R19,R26
	MOVW R30,R0
	LDI  R26,LOW(252)
	SUB  R26,R30
	RCALL _lights
; 0000 01DD       #asm("sei")
	sei
; 0000 01DE 
; 0000 01DF       if(led_cycle==9)
	CPI  R19,9
	BRNE _0x4F
; 0000 01E0       flag_led_direction=1;
	LDI  R16,LOW(1)
; 0000 01E1 
; 0000 01E2       if(led_cycle==0)
_0x4F:
	CPI  R19,0
	BRNE _0x50
; 0000 01E3       flag_led_direction=0;
	LDI  R16,LOW(0)
; 0000 01E4 
; 0000 01E5       if(flag_led_direction==0)
_0x50:
	CPI  R16,0
	BRNE _0x51
; 0000 01E6       led_cycle++;
	SUBI R19,-1
; 0000 01E7       else
	RJMP _0x52
_0x51:
; 0000 01E8       led_cycle--;
	SUBI R19,1
; 0000 01E9 
; 0000 01EA       if(main_cycle>=9)
_0x52:
	CPI  R17,9
	BRLO _0x53
; 0000 01EB       main_cycle=0;
	LDI  R17,LOW(0)
; 0000 01EC       else
	RJMP _0x54
_0x53:
; 0000 01ED       main_cycle++;
	SUBI R17,-1
; 0000 01EE 
; 0000 01EF 
; 0000 01F0     }
_0x54:
	RJMP _0x27
; 0000 01F1 }
_0x55:
	RJMP _0x55
; .FEND

	.DSEG
_0x26:
	.BYTE 0x12
;
;
;//SPEED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;//SPEED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;//SPEED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;// External Interrupt 6 service routine
;interrupt [EXT_INT6] void ext_int6_isr(void) //TK_SPEED
; 0000 01F9 {

	.CSEG
_ext_int6_isr:
; .FSTART _ext_int6_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 01FA  unsigned char H,L;
; 0000 01FB  TK_COUNT[0]=TK_COUNT[1];
	ST   -Y,R17
	ST   -Y,R16
;	H -> R17
;	L -> R16
	__GETD1MN _TK_COUNT,4
	STS  _TK_COUNT,R30
	STS  _TK_COUNT+1,R31
	STS  _TK_COUNT+2,R22
	STS  _TK_COUNT+3,R23
; 0000 01FC  L=TCNT1L;
	IN   R16,44
; 0000 01FD  H=TCNT1H;
	IN   R17,45
; 0000 01FE  TK_COUNT[1]=(unsigned long)H*256+(unsigned long)L;
	MOV  R30,R17
	LDI  R31,0
	CALL __CWD1
	__GETD2N 0x100
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	MOV  R30,R16
	LDI  R31,0
	CALL __CWD1
	CALL __ADDD12
	__PUTD1MN _TK_COUNT,4
; 0000 01FF  if(ovf_TK>0)
	LDS  R26,_ovf_TK
	CPI  R26,LOW(0x1)
	BRSH PC+2
	RJMP _0x56
; 0000 0200  {
; 0000 0201   if(ovf_TK==2)
	CPI  R26,LOW(0x2)
	BRNE _0x57
; 0000 0202   {
; 0000 0203    TK_DELTA=0;
	LDI  R30,LOW(0)
	STS  _TK_DELTA,R30
	STS  _TK_DELTA+1,R30
	STS  _TK_DELTA+2,R30
	STS  _TK_DELTA+3,R30
; 0000 0204    TK_COUNT[0]=0;
	STS  _TK_COUNT,R30
	STS  _TK_COUNT+1,R30
	STS  _TK_COUNT+2,R30
	STS  _TK_COUNT+3,R30
; 0000 0205    TK_COUNT[1]=0;
	__POINTW1MN _TK_COUNT,4
	__GETD2N 0x0
	CALL __PUTDZ20
; 0000 0206   }
; 0000 0207   else
	RJMP _0x58
_0x57:
; 0000 0208   {
; 0000 0209    TK_DELTA=(65536-TK_COUNT[0])+TK_COUNT[1];
	LDS  R26,_TK_COUNT
	LDS  R27,_TK_COUNT+1
	LDS  R24,_TK_COUNT+2
	LDS  R25,_TK_COUNT+3
	__GETD1N 0x10000
	CALL __SUBD12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1MN _TK_COUNT,4
	CALL __ADDD12
	STS  _TK_DELTA,R30
	STS  _TK_DELTA+1,R31
	STS  _TK_DELTA+2,R22
	STS  _TK_DELTA+3,R23
; 0000 020A   }
_0x58:
; 0000 020B   ovf_TK=0;
	LDI  R30,LOW(0)
	STS  _ovf_TK,R30
; 0000 020C  }
; 0000 020D  else
	RJMP _0x59
_0x56:
; 0000 020E  {
; 0000 020F   TK_DELTA=TK_COUNT[1]-TK_COUNT[0];
	__GETD1MN _TK_COUNT,4
	LDS  R26,_TK_COUNT
	LDS  R27,_TK_COUNT+1
	LDS  R24,_TK_COUNT+2
	LDS  R25,_TK_COUNT+3
	CALL __SUBD12
	STS  _TK_DELTA,R30
	STS  _TK_DELTA+1,R31
	STS  _TK_DELTA+2,R22
	STS  _TK_DELTA+3,R23
; 0000 0210  }
_0x59:
; 0000 0211 }
	RJMP _0x126
; .FEND
;
;
;// External Interrupt 7 service routine
;interrupt [EXT_INT7] void ext_int7_isr(void) //IK_SPEED
; 0000 0216 {
_ext_int7_isr:
; .FSTART _ext_int7_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0217  unsigned char H,L;
; 0000 0218  IK_COUNT[0]=IK_COUNT[1];
	ST   -Y,R17
	ST   -Y,R16
;	H -> R17
;	L -> R16
	__GETD1MN _IK_COUNT,4
	STS  _IK_COUNT,R30
	STS  _IK_COUNT+1,R31
	STS  _IK_COUNT+2,R22
	STS  _IK_COUNT+3,R23
; 0000 0219  L=TCNT1L;
	IN   R16,44
; 0000 021A  H=TCNT1H;
	IN   R17,45
; 0000 021B  IK_COUNT[1]=(unsigned long)H*256+(unsigned long)L;
	MOV  R30,R17
	LDI  R31,0
	CALL __CWD1
	__GETD2N 0x100
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	MOV  R30,R16
	LDI  R31,0
	CALL __CWD1
	CALL __ADDD12
	__PUTD1MN _IK_COUNT,4
; 0000 021C  if(ovf_IK>0)
	LDS  R26,_ovf_IK
	CPI  R26,LOW(0x1)
	BRSH PC+2
	RJMP _0x5A
; 0000 021D  {
; 0000 021E   if(ovf_IK==2)
	CPI  R26,LOW(0x2)
	BRNE _0x5B
; 0000 021F   {
; 0000 0220    IK_DELTA=0;
	LDI  R30,LOW(0)
	STS  _IK_DELTA,R30
	STS  _IK_DELTA+1,R30
	STS  _IK_DELTA+2,R30
	STS  _IK_DELTA+3,R30
; 0000 0221    IK_COUNT[0]=0;
	STS  _IK_COUNT,R30
	STS  _IK_COUNT+1,R30
	STS  _IK_COUNT+2,R30
	STS  _IK_COUNT+3,R30
; 0000 0222    IK_COUNT[1]=0;
	__POINTW1MN _IK_COUNT,4
	__GETD2N 0x0
	CALL __PUTDZ20
; 0000 0223   }
; 0000 0224   else
	RJMP _0x5C
_0x5B:
; 0000 0225   {
; 0000 0226    IK_DELTA=(65536-IK_COUNT[0])+IK_COUNT[1];
	LDS  R26,_IK_COUNT
	LDS  R27,_IK_COUNT+1
	LDS  R24,_IK_COUNT+2
	LDS  R25,_IK_COUNT+3
	__GETD1N 0x10000
	CALL __SUBD12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1MN _IK_COUNT,4
	CALL __ADDD12
	STS  _IK_DELTA,R30
	STS  _IK_DELTA+1,R31
	STS  _IK_DELTA+2,R22
	STS  _IK_DELTA+3,R23
; 0000 0227   }
_0x5C:
; 0000 0228   ovf_IK=0;
	LDI  R30,LOW(0)
	STS  _ovf_IK,R30
; 0000 0229  }
; 0000 022A  else
	RJMP _0x5D
_0x5A:
; 0000 022B  {
; 0000 022C   IK_DELTA=IK_COUNT[1]-IK_COUNT[0];
	__GETD1MN _IK_COUNT,4
	LDS  R26,_IK_COUNT
	LDS  R27,_IK_COUNT+1
	LDS  R24,_IK_COUNT+2
	LDS  R25,_IK_COUNT+3
	CALL __SUBD12
	STS  _IK_DELTA,R30
	STS  _IK_DELTA+1,R31
	STS  _IK_DELTA+2,R22
	STS  _IK_DELTA+3,R23
; 0000 022D  }
_0x5D:
; 0000 022E }
_0x126:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;
;
;
;void init_all(void)
; 0000 0235 {
_init_all:
; .FSTART _init_all
; 0000 0236 
; 0000 0237  // Port B initialization
; 0000 0238  DDRB.4=1;
	SBI  0x17,4
; 0000 0239  DDRB.6=1;
	SBI  0x17,6
; 0000 023A 
; 0000 023B  // Port C initialization
; 0000 023C  // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=Out
; 0000 023D  // State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=0
; 0000 023E  PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 023F  DDRC=0x03;
	LDI  R30,LOW(3)
	OUT  0x14,R30
; 0000 0240  PORTC.2=0;//GPS on
	CBI  0x15,2
; 0000 0241  DDRC.2=1;
	SBI  0x14,2
; 0000 0242 
; 0000 0243 
; 0000 0244  // Timer/Counter 0 initialization
; 0000 0245  // Clock source: System Clock
; 0000 0246  // Clock value: 1382,400 kHz
; 0000 0247  // Mode: Phase correct PWM top=0xFF
; 0000 0248  // OC0 output: Inverted PWM
; 0000 0249  ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 024A  TCCR0=0x72;
	LDI  R30,LOW(114)
	OUT  0x33,R30
; 0000 024B  TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 024C  OCR0=255;
	LDI  R30,LOW(255)
	OUT  0x31,R30
; 0000 024D 
; 0000 024E  // Timer/Counter 1 initialization
; 0000 024F // Clock source: System Clock
; 0000 0250 // Clock value: 172,800 kHz
; 0000 0251 // Mode: Normal top=FFFFh
; 0000 0252 // OC1A output: Discon.
; 0000 0253 // OC1B output: Discon.
; 0000 0254 // OC1C output: Discon.
; 0000 0255 // Noise Canceler: Off
; 0000 0256 // Input Capture on Falling Edge
; 0000 0257 // Timer 1 Overflow Interrupt: On
; 0000 0258 // Input Capture Interrupt: Off
; 0000 0259 // Compare A Match Interrupt: Off
; 0000 025A // Compare B Match Interrupt: Off
; 0000 025B // Compare C Match Interrupt: Off
; 0000 025C TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 025D TCCR1B=0x03;
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 025E TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 025F TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0260 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0261 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0262 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0263 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0264 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0265 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0266 OCR1CH=0x00;
	STS  121,R30
; 0000 0267 OCR1CL=0x00;
	STS  120,R30
; 0000 0268 
; 0000 0269 
; 0000 026A 
; 0000 026B  // Timer/Counter 2 initialization
; 0000 026C  // Clock source: System Clock
; 0000 026D  // Clock value: 10,800 kHz
; 0000 026E  // Mode: Normal top=0xFF
; 0000 026F  // OC2 output: Disconnected
; 0000 0270  TCCR2=0x05;
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0000 0271  TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0272  OCR2=0x00;
	OUT  0x23,R30
; 0000 0273 
; 0000 0274 
; 0000 0275 // Timer/Counter 3 initialization
; 0000 0276 // Clock source: System Clock
; 0000 0277 // Clock value: 10,800 kHz
; 0000 0278 // Mode: Normal top=0xFFFF
; 0000 0279 // OC3A output: Discon.
; 0000 027A // OC3B output: Discon.
; 0000 027B // OC3C output: Discon.
; 0000 027C // Noise Canceler: Off
; 0000 027D // Input Capture on Falling Edge
; 0000 027E // Timer3 Overflow Interrupt: Off
; 0000 027F // Input Capture Interrupt: Off
; 0000 0280 // Compare A Match Interrupt: Off
; 0000 0281 // Compare B Match Interrupt: Off
; 0000 0282 // Compare C Match Interrupt: Off
; 0000 0283 TCCR3A=0x00;
	STS  139,R30
; 0000 0284 TCCR3B=0x05;
	LDI  R30,LOW(5)
	STS  138,R30
; 0000 0285 TCNT3H=0x00;
	LDI  R30,LOW(0)
	STS  137,R30
; 0000 0286 TCNT3L=0x00;
	STS  136,R30
; 0000 0287 ICR3H=0x00;
	STS  129,R30
; 0000 0288 ICR3L=0x00;
	STS  128,R30
; 0000 0289 OCR3AH=0x00;
	STS  135,R30
; 0000 028A OCR3AL=0x00;
	STS  134,R30
; 0000 028B OCR3BH=0x00;
	STS  133,R30
; 0000 028C OCR3BL=0x00;
	STS  132,R30
; 0000 028D OCR3CH=0x00;
	STS  131,R30
; 0000 028E OCR3CL=0x00;
	STS  130,R30
; 0000 028F 
; 0000 0290 
; 0000 0291  // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0292  TIMSK=0x44;
	LDI  R30,LOW(68)
	OUT  0x37,R30
; 0000 0293 
; 0000 0294  ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 0295 
; 0000 0296  // External Interrupt(s) initialization
; 0000 0297  // INT0: Off
; 0000 0298  // INT1: Off
; 0000 0299  // INT2: Off
; 0000 029A  // INT3: Off
; 0000 029B  // INT4: Off
; 0000 029C  // INT5: Off
; 0000 029D  // INT6: On
; 0000 029E  // INT6 Mode: Rising Edge
; 0000 029F  // INT7: On
; 0000 02A0  // INT7 Mode: Rising Edge
; 0000 02A1  EICRA=0x00;
	STS  106,R30
; 0000 02A2  EICRB=0xF0;
	LDI  R30,LOW(240)
	OUT  0x3A,R30
; 0000 02A3  EIMSK=0xC0;
	LDI  R30,LOW(192)
	OUT  0x39,R30
; 0000 02A4  EIFR=0xC0;
	OUT  0x38,R30
; 0000 02A5 
; 0000 02A6  // USART0 initialization
; 0000 02A7  // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 02A8  // USART0 Receiver: On
; 0000 02A9  // USART0 Transmitter: On
; 0000 02AA  // USART0 Mode: Asynchronous
; 0000 02AB  // USART0 Baud Rate: 9600
; 0000 02AC  UCSR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 02AD  UCSR0B=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 02AE  UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 02AF  UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 02B0  UBRR0L=0x47;
	LDI  R30,LOW(71)
	OUT  0x9,R30
; 0000 02B1 
; 0000 02B2  // USART1 initialization
; 0000 02B3  // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 02B4  // USART1 Receiver: On
; 0000 02B5  // USART1 Transmitter: On
; 0000 02B6  // USART1 Mode: Asynchronous
; 0000 02B7  // USART1 Baud Rate: 9600
; 0000 02B8  UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
; 0000 02B9  UCSR1B=0x98;
	LDI  R30,LOW(152)
	STS  154,R30
; 0000 02BA  UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 02BB  UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 02BC  UBRR1L=0x47;
	LDI  R30,LOW(71)
	STS  153,R30
; 0000 02BD 
; 0000 02BE  // Analog Comparator initialization
; 0000 02BF  // Analog Comparator: Off
; 0000 02C0  // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 02C1  ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02C2  SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 02C3 
; 0000 02C4  // ADC initialization
; 0000 02C5  // ADC Clock frequency: 86,400 kHz
; 0000 02C6  // ADC Voltage Reference: Int., cap. on AREF
; 0000 02C7  ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(192)
	OUT  0x7,R30
; 0000 02C8  ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 02C9 }
	RET
; .FEND
;
;unsigned int K_BY_KOEFFICIENTS_REAL(unsigned int M)
; 0000 02CC {
_K_BY_KOEFFICIENTS_REAL:
; .FSTART _K_BY_KOEFFICIENTS_REAL
; 0000 02CD unsigned long F,W,K;
; 0000 02CE //WEIGHT_NULL=6679, LOADCELL_NULL=618, DELTA_WEIGHT10KG=748, DELTA_LOADCELL10KG=772
; 0000 02CF if(M<LOADCELL_NULL)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,12
;	M -> Y+12
;	F -> Y+8
;	W -> Y+4
;	K -> Y+0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CP   R26,R6
	CPC  R27,R7
	BRSH _0x66
; 0000 02D0  return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2060005
; 0000 02D1 
; 0000 02D2 F=((M-(unsigned long)LOADCELL_NULL)*1000)/((unsigned long)DELTA_LOADCELL10KG);
_0x66:
	MOVW R30,R6
	CLR  R22
	CLR  R23
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CLR  R24
	CLR  R25
	CALL __SUBD21
	__GETD1N 0x3E8
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R10
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	__PUTD1S 8
; 0000 02D3 W=(unsigned long)WEIGHT_NULL-((unsigned long)DELTA_WEIGHT10KG*F)/1000;
	MOVW R30,R4
	CLR  R22
	CLR  R23
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R8
	CLR  R22
	CLR  R23
	__GETD2S 8
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3E8
	CALL __DIVD21U
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __SUBD21
	__PUTD2S 4
; 0000 02D4 if(W>0)
	__GETD2S 4
	CALL __CPD02
	BRSH _0x67
; 0000 02D5  K=((F*1000)/W) - 28; //frCoef -
	__GETD1S 8
	__GETD2N 0x3E8
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 4
	CALL __DIVD21U
	__SUBD1N 28
	RJMP _0x120
; 0000 02D6 else
_0x67:
; 0000 02D7  K=1800;
	__GETD1N 0x708
_0x120:
	CALL __PUTD1S0
; 0000 02D8 
; 0000 02D9 if(K>1800)
	CALL __GETD2S0
	__CPD2N 0x709
	BRLO _0x69
; 0000 02DA  K=1800;
	__GETD1N 0x708
	CALL __PUTD1S0
; 0000 02DB return K;
_0x69:
	RJMP _0x2060004
; 0000 02DC }
; .FEND
;
;unsigned int K_BY_KOEFFICIENTS_ASFT(unsigned int M)
; 0000 02DF {
_K_BY_KOEFFICIENTS_ASFT:
; .FSTART _K_BY_KOEFFICIENTS_ASFT
; 0000 02E0  long F,W,K;
; 0000 02E1 //WEIGHT_NULL=6679, LOADCELL_NULL=618, DELTA_WEIGHT10KG=748, DELTA_LOADCELL10KG=772
; 0000 02E2 
; 0000 02E3  F=(long)M-LOADCELL_NULL;
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,12
;	M -> Y+12
;	F -> Y+8
;	W -> Y+4
;	K -> Y+0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CLR  R24
	CLR  R25
	MOVW R30,R6
	CLR  R22
	CLR  R23
	CALL __SUBD21
	__PUTD2S 8
; 0000 02E4  if(F<0)
	LDD  R26,Y+11
	TST  R26
	BRPL _0x6A
; 0000 02E5   F=0;
	LDI  R30,LOW(0)
	__CLRD1S 8
; 0000 02E6   F=(F*1000)/DELTA_LOADCELL10KG;
_0x6A:
	__GETD1S 8
	__GETD2N 0x3E8
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R10
	CLR  R22
	CLR  R23
	CALL __DIVD21
	__PUTD1S 8
; 0000 02E7  W=WEIGHT_NULL;
	MOVW R30,R4
	CLR  R22
	CLR  R23
	__PUTD1S 4
; 0000 02E8  K=(F*1000)/W;
	__GETD1S 8
	__GETD2N 0x3E8
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1S 4
	CALL __DIVD21
	CALL __PUTD1S0
; 0000 02E9 
; 0000 02EA if(K>3000)
	CALL __GETD2S0
	__CPD2N 0xBB9
	BRLT _0x6B
; 0000 02EB  K=3000;
	__GETD1N 0xBB8
	CALL __PUTD1S0
; 0000 02EC 
; 0000 02ED  if(K>100)
_0x6B:
	CALL __GETD2S0
	__CPD2N 0x65
	BRLT _0x6C
; 0000 02EE   K=1000000/(1000000/(unsigned long)K+430-637);
	CALL __GETD1S0
	__GETD2N 0xF4240
	CALL __DIVD21U
	__SUBD1N 207
	__GETD2N 0xF4240
	CALL __DIVD21U
	CALL __PUTD1S0
; 0000 02EF  return K;
_0x6C:
_0x2060004:
	LD   R30,Y
	LDD  R31,Y+1
_0x2060005:
	ADIW R28,14
	RET
; 0000 02F0 }
; .FEND
;
;
;
;void led_zero(void)
; 0000 02F5 {
_led_zero:
; .FSTART _led_zero
; 0000 02F6     PORTB.6 = 1;
	SBI  0x18,6
; 0000 02F7     #asm("nop");
	nop
; 0000 02F8     PORTB.6 = 0;
	CBI  0x18,6
; 0000 02F9     #asm("nop");
	nop
; 0000 02FA     #asm("nop");
	nop
; 0000 02FB     #asm("nop");
	nop
; 0000 02FC }
	RET
; .FEND
;
;void led_one(void)
; 0000 02FF {
_led_one:
; .FSTART _led_one
; 0000 0300     PORTB.6 = 1;
	SBI  0x18,6
; 0000 0301     #asm("nop");
	nop
; 0000 0302     #asm("nop");
	nop
; 0000 0303     #asm("nop");
	nop
; 0000 0304     #asm("nop");
	nop
; 0000 0305     PORTB.6 = 0;
	CBI  0x18,6
; 0000 0306 }
	RET
; .FEND
;
;void lights(char G, char R, char B)
; 0000 0309 {
_lights:
; .FSTART _lights
; 0000 030A     unsigned char i;
; 0000 030B     for(i = 0b10000000; i >= 0b00000001; i = i >> 1)
	ST   -Y,R26
	ST   -Y,R17
;	G -> Y+3
;	R -> Y+2
;	B -> Y+1
;	i -> R17
	LDI  R17,LOW(128)
_0x76:
	CPI  R17,1
	BRLO _0x77
; 0000 030C     {
; 0000 030D         if((G & i) > 0)
	MOV  R30,R17
	LDD  R26,Y+3
	AND  R30,R26
	CPI  R30,LOW(0x1)
	BRLO _0x78
; 0000 030E             led_one();
	RCALL _led_one
; 0000 030F         else
	RJMP _0x79
_0x78:
; 0000 0310             led_zero();
	RCALL _led_zero
; 0000 0311     }
_0x79:
	LSR  R17
	RJMP _0x76
_0x77:
; 0000 0312 
; 0000 0313     for(i = 0b10000000; i >= 0b00000001; i = i >> 1)
	LDI  R17,LOW(128)
_0x7B:
	CPI  R17,1
	BRLO _0x7C
; 0000 0314     {
; 0000 0315         if((R & i) > 0)
	MOV  R30,R17
	LDD  R26,Y+2
	AND  R30,R26
	CPI  R30,LOW(0x1)
	BRLO _0x7D
; 0000 0316             led_one();
	RCALL _led_one
; 0000 0317         else
	RJMP _0x7E
_0x7D:
; 0000 0318             led_zero();
	RCALL _led_zero
; 0000 0319     }
_0x7E:
	LSR  R17
	RJMP _0x7B
_0x7C:
; 0000 031A 
; 0000 031B     for(i = 0b10000000; i >= 0b00000001; i = i >> 1)
	LDI  R17,LOW(128)
_0x80:
	CPI  R17,1
	BRLO _0x81
; 0000 031C     {
; 0000 031D         if((B & i) > 0)
	MOV  R30,R17
	LDD  R26,Y+1
	AND  R30,R26
	CPI  R30,LOW(0x1)
	BRLO _0x82
; 0000 031E             led_one();
	RCALL _led_one
; 0000 031F         else
	RJMP _0x83
_0x82:
; 0000 0320             led_zero();
	RCALL _led_zero
; 0000 0321     }
_0x83:
	LSR  R17
	RJMP _0x80
_0x81:
; 0000 0322 }
	LDD  R17,Y+0
	RJMP _0x2060001
; .FEND
;
;void Read_Setup_Calibr(void)
; 0000 0325 {
_Read_Setup_Calibr:
; .FSTART _Read_Setup_Calibr
; 0000 0326 
; 0000 0327 //unsigned char CALIBR_MAS[10]={249,66,94,7,9,7,2,8,24,(66+94+7+9+7+2+8+24)/8};
; 0000 0328  //unsigned int WEIGHT_NULL=6694, LOADCELL_NULL=709, DELTA_WEIGHT10KG=702, DELTA_LOADCELL10KG=824;
; 0000 0329  ZADANIE_S=SETUP_MAS[3];
	__GETB1MN _SETUP_MAS,3
	LDI  R31,0
	STS  _ZADANIE_S,R30
	STS  _ZADANIE_S+1,R31
; 0000 032A  R_IK=SETUP_MAS[1];
	__GETBRMN 12,_SETUP_MAS,1
	CLR  R13
; 0000 032B  R_TK=SETUP_MAS[2]+200;
	__GETB1MN _SETUP_MAS,2
	LDI  R31,0
	SUBI R30,LOW(-200)
	SBCI R31,HIGH(-200)
	STS  _R_TK,R30
	STS  _R_TK+1,R31
; 0000 032C 
; 0000 032D  #ifdef FIXWEIGHT
; 0000 032E  WEIGHT_NULL=(unsigned int)DEFAULT_CALIBR_MAS[1]*100+(unsigned int)DEFAULT_CALIBR_MAS[2];
	__GETB2MN _DEFAULT_CALIBR_MAS,1
	LDI  R30,LOW(100)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	__GETB1MN _DEFAULT_CALIBR_MAS,2
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R4,R30
; 0000 032F  #else
; 0000 0330  WEIGHT_NULL=(unsigned int)CALIBR_MAS[1]*100+(unsigned int)CALIBR_MAS[2];
; 0000 0331  #endif
; 0000 0332 
; 0000 0333  LOADCELL_NULL=(unsigned int)CALIBR_MAS[3]*100+(unsigned int)CALIBR_MAS[4];
	__GETB2MN _CALIBR_MAS,3
	LDI  R30,LOW(100)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	__GETB1MN _CALIBR_MAS,4
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R6,R30
; 0000 0334  DELTA_WEIGHT10KG=(unsigned int)CALIBR_MAS[5]*100+(unsigned int)CALIBR_MAS[6];
	__GETB2MN _CALIBR_MAS,5
	LDI  R30,LOW(100)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	__GETB1MN _CALIBR_MAS,6
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R8,R30
; 0000 0335  DELTA_LOADCELL10KG=(unsigned int)CALIBR_MAS[7]*100+(unsigned int)CALIBR_MAS[8];
	__GETB2MN _CALIBR_MAS,7
	LDI  R30,LOW(100)
	MUL  R30,R26
	MOVW R30,R0
	MOVW R26,R30
	__GETB1MN _CALIBR_MAS,8
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R10,R30
; 0000 0336 }
	RET
; .FEND
;
;void Control_Sum_Send(void)
; 0000 0339 {
_Control_Sum_Send:
; .FSTART _Control_Sum_Send
; 0000 033A  unsigned char tmp=0;
; 0000 033B  unsigned int S=0;
; 0000 033C 
; 0000 033D  for(tmp=1;tmp<25;tmp++)
	CALL __SAVELOCR4
;	tmp -> R17
;	S -> R18,R19
	LDI  R17,0
	__GETWRN 18,19,0
	LDI  R17,LOW(1)
_0x85:
	CPI  R17,25
	BRSH _0x86
; 0000 033E   S=S+SEND_MAS[tmp];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_SEND_MAS)
	SBCI R31,HIGH(-_SEND_MAS)
	LD   R30,Z
	LDI  R31,0
	__ADDWRR 18,19,30,31
	SUBI R17,-1
	RJMP _0x85
_0x86:
; 0000 033F SEND_MAS[25]=S/24;
	MOVW R26,R18
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CALL __DIVW21U
	__PUTB1MN _SEND_MAS,25
; 0000 0340 }
	RJMP _0x2060002
; .FEND
;
;void Control_Sum_Calibr(void)
; 0000 0343 {
_Control_Sum_Calibr:
; .FSTART _Control_Sum_Calibr
; 0000 0344  unsigned char tmp=0;
; 0000 0345  unsigned int S=0;
; 0000 0346 
; 0000 0347  for(tmp=1;tmp<9;tmp++)
	CALL __SAVELOCR4
;	tmp -> R17
;	S -> R18,R19
	LDI  R17,0
	__GETWRN 18,19,0
	LDI  R17,LOW(1)
_0x88:
	CPI  R17,9
	BRSH _0x89
; 0000 0348   S=S+CALIBR_MAS[tmp];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_CALIBR_MAS)
	SBCI R31,HIGH(-_CALIBR_MAS)
	LD   R30,Z
	LDI  R31,0
	__ADDWRR 18,19,30,31
	SUBI R17,-1
	RJMP _0x88
_0x89:
; 0000 0349 CALIBR_MAS[9]=S/8;
	MOVW R30,R18
	CALL __LSRW3
	__PUTB1MN _CALIBR_MAS,9
; 0000 034A }
	RJMP _0x2060002
; .FEND
;
;
;void Control_Sum_Setup(void)
; 0000 034E {
_Control_Sum_Setup:
; .FSTART _Control_Sum_Setup
; 0000 034F  unsigned char tmp=0;
; 0000 0350  unsigned int S=0;
; 0000 0351 
; 0000 0352  for(tmp=1;tmp<7;tmp++)
	CALL __SAVELOCR4
;	tmp -> R17
;	S -> R18,R19
	LDI  R17,0
	__GETWRN 18,19,0
	LDI  R17,LOW(1)
_0x8B:
	CPI  R17,7
	BRSH _0x8C
; 0000 0353   S=S+SETUP_MAS[tmp];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_SETUP_MAS)
	SBCI R31,HIGH(-_SETUP_MAS)
	LD   R30,Z
	LDI  R31,0
	__ADDWRR 18,19,30,31
	SUBI R17,-1
	RJMP _0x8B
_0x8C:
; 0000 0354 SETUP_MAS[7]=S/6;
	MOVW R26,R18
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL __DIVW21U
	__PUTB1MN _SETUP_MAS,7
; 0000 0355 }
	RJMP _0x2060002
; .FEND
;
;// Timer 1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0359 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 035A if(ovf_IK<2)
	LDS  R26,_ovf_IK
	CPI  R26,LOW(0x2)
	BRSH _0x8D
; 0000 035B  {
; 0000 035C   ovf_IK++;
	LDS  R30,_ovf_IK
	SUBI R30,-LOW(1)
	STS  _ovf_IK,R30
; 0000 035D  }
; 0000 035E if(ovf_TK<2)
_0x8D:
	LDS  R26,_ovf_TK
	CPI  R26,LOW(0x2)
	BRSH _0x8E
; 0000 035F  {
; 0000 0360   ovf_TK++;
	LDS  R30,_ovf_TK
	SUBI R30,-LOW(1)
	STS  _ovf_TK,R30
; 0000 0361  }
; 0000 0362 }
_0x8E:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;//***********************************************************************************************************
;//***********************************************************************************************************
;//***********************************************************************************************************
;
;
;
;
;void delay(unsigned int d)
; 0000 036B {
_delay:
; .FSTART _delay
; 0000 036C  unsigned int y;
; 0000 036D  for(y=0;y<d;y++)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	d -> Y+2
;	y -> R16,R17
	__GETWRN 16,17,0
_0x90:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x91
; 0000 036E  {}
	__ADDWRN 16,17,1
	RJMP _0x90
_0x91:
; 0000 036F }
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2060001
; .FEND
;
;
;
;void SPI_MasterInit(void)
; 0000 0374 {
_SPI_MasterInit:
; .FSTART _SPI_MasterInit
; 0000 0375 // DDRB.1=1; //SCK
; 0000 0376 // PORTB.1=0;
; 0000 0377 // DDRB.2=1; //MOSI
; 0000 0378 // PORTB.2=1;
; 0000 0379 // DDRB.3=0; //MISO
; 0000 037A // PORTB.3=0;
; 0000 037B 
; 0000 037C  DDRB |= (1 << 0) | (1 << 1) | (1 << 2); //SS, SCK, MOSI - out
	IN   R30,0x17
	ORI  R30,LOW(0x7)
	OUT  0x17,R30
; 0000 037D  DDRB &= ~(1 << 3); //MISO - in
	CBI  0x17,3
; 0000 037E  SPCR = (1<<SPE) | (1<<MSTR) | (1<<CPOL) | (1<<CPHA);
	LDI  R30,LOW(92)
	OUT  0xD,R30
; 0000 037F }
	RET
; .FEND
;
;
;unsigned char SPI_MasterReceive(void)
; 0000 0383 {
_SPI_MasterReceive:
; .FSTART _SPI_MasterReceive
; 0000 0384 //unsigned char t,x=0;
; 0000 0385 //
; 0000 0386 // for(t=128;t>=1;t=t/2)
; 0000 0387 // {
; 0000 0388 //  PORTB.1=1;
; 0000 0389 //  delay(100);
; 0000 038A //  PORTB.1=0;
; 0000 038B //  if(!PINB.3)
; 0000 038C //    x=x+t;
; 0000 038D //  delay(100);
; 0000 038E // }
; 0000 038F // return x;
; 0000 0390 
; 0000 0391  SPI_MasterTransmit(0xFF);
	LDI  R26,LOW(255)
	RCALL _SPI_MasterTransmit
; 0000 0392  while(!(SPSR & (1<<SPIF)))
_0x92:
	SBIS 0xE,7
; 0000 0393   continue;
	RJMP _0x92
; 0000 0394  return SPDR;
	IN   R30,0xF
	RET
; 0000 0395 }
; .FEND
;
;
;void SPI_MasterTransmit(unsigned char x)
; 0000 0399 {
_SPI_MasterTransmit:
; .FSTART _SPI_MasterTransmit
; 0000 039A //unsigned char t;
; 0000 039B //
; 0000 039C // for(t=128;t>=1;t=t/2)
; 0000 039D // {
; 0000 039E // PORTB.1=1;
; 0000 039F // delay(200);
; 0000 03A0 // if(x&t)
; 0000 03A1 //  PORTB.2=0;
; 0000 03A2 // else
; 0000 03A3 //  PORTB.2=1;
; 0000 03A4 // delay(200);
; 0000 03A5 // PORTB.1=0;
; 0000 03A6 // delay(200);
; 0000 03A7 // }
; 0000 03A8 // PORTB.2=1;
; 0000 03A9 // delay(300);
; 0000 03AA 
; 0000 03AB  SPDR = x;
	ST   -Y,R26
;	x -> Y+0
	LD   R30,Y
	OUT  0xF,R30
; 0000 03AC  while(!(SPSR & (1<<SPIF)))
_0x95:
	SBIS 0xE,7
; 0000 03AD   continue;
	RJMP _0x95
; 0000 03AE }
	RJMP _0x2060003
; .FEND
;
;
;
;void SET_AD7799(void)
; 0000 03B3 {
_SET_AD7799:
; .FSTART _SET_AD7799
; 0000 03B4  delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 03B5  SPI_MasterTransmit(0b11111111);
	LDI  R26,LOW(255)
	RCALL _SPI_MasterTransmit
; 0000 03B6  SPI_MasterTransmit(0b11111111);
	LDI  R26,LOW(255)
	RCALL _SPI_MasterTransmit
; 0000 03B7  SPI_MasterTransmit(0b11111111);
	LDI  R26,LOW(255)
	RCALL _SPI_MasterTransmit
; 0000 03B8  SPI_MasterTransmit(0b11111111);
	LDI  R26,LOW(255)
	RCALL _SPI_MasterTransmit
; 0000 03B9  delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 03BA  SPI_MasterTransmit(0x10);    //conf
	LDI  R26,LOW(16)
	RCALL _SPI_MasterTransmit
; 0000 03BB  delay(10000);
	LDI  R26,LOW(10000)
	LDI  R27,HIGH(10000)
	RCALL _delay
; 0000 03BC  //#ifdef ADC_TO_KG
; 0000 03BD  //SPI_MasterTransmit(0b00000111); //bipolar and *128
; 0000 03BE  //#else
; 0000 03BF  SPI_MasterTransmit(0b00010111); //unipolar and *128
	LDI  R26,LOW(23)
	RCALL _SPI_MasterTransmit
; 0000 03C0  //#endif
; 0000 03C1  SPI_MasterTransmit(0b00010000);
	LDI  R26,LOW(16)
	RCALL _SPI_MasterTransmit
; 0000 03C2  delay(10000);
	LDI  R26,LOW(10000)
	LDI  R27,HIGH(10000)
	RCALL _delay
; 0000 03C3 
; 0000 03C4 
; 0000 03C5  SPI_MasterTransmit(0x08);  //mode
	LDI  R26,LOW(8)
	RCALL _SPI_MasterTransmit
; 0000 03C6  delay(10000);
	LDI  R26,LOW(10000)
	LDI  R27,HIGH(10000)
	RCALL _delay
; 0000 03C7  SPI_MasterTransmit(0b00000000);
	LDI  R26,LOW(0)
	RCALL _SPI_MasterTransmit
; 0000 03C8  //SPI_MasterTransmit(0b00001111);
; 0000 03C9 
; 0000 03CA  SPI_MasterTransmit(0b00001100);//10Hz
	LDI  R26,LOW(12)
	RCALL _SPI_MasterTransmit
; 0000 03CB  //SPI_MasterTransmit(0b00001000);//20Hz
; 0000 03CC  delay(10000);
	LDI  R26,LOW(10000)
	LDI  R27,HIGH(10000)
	RCALL _delay
; 0000 03CD  SPI_MasterTransmit(0x5C);
	LDI  R26,LOW(92)
	RCALL _SPI_MasterTransmit
; 0000 03CE  delay(10000);
	LDI  R26,LOW(10000)
	LDI  R27,HIGH(10000)
	RCALL _delay
; 0000 03CF }
	RET
; .FEND
;
; unsigned int READ_AD7799(void)
; 0000 03D2 {
_READ_AD7799:
; .FSTART _READ_AD7799
; 0000 03D3  unsigned char a1,a2;
; 0000 03D4  unsigned int M;
; 0000 03D5         delay(100);
	CALL __SAVELOCR4
;	a1 -> R17
;	a2 -> R16
;	M -> R18,R19
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay
; 0000 03D6         a1=SPI_MasterReceive();
	RCALL _SPI_MasterReceive
	MOV  R17,R30
; 0000 03D7         a2=SPI_MasterReceive();
	RCALL _SPI_MasterReceive
	MOV  R16,R30
; 0000 03D8         SPI_MasterReceive();
	RCALL _SPI_MasterReceive
; 0000 03D9         M=(unsigned int)a1*256+(unsigned int)a2;
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R18,R30
; 0000 03DA         return M;
	RJMP _0x2060002
; 0000 03DB         //return a2;
; 0000 03DC }
; .FEND
;
;
;void uart1SendByte(char data)
; 0000 03E0 {
_uart1SendByte:
; .FSTART _uart1SendByte
; 0000 03E1     while(!( UCSR1A & (1 << UDRE)));
	ST   -Y,R26
;	data -> Y+0
_0x98:
	LDS  R30,155
	ANDI R30,LOW(0x20)
	BREQ _0x98
; 0000 03E2     UDR1 = data;
	LD   R30,Y
	STS  156,R30
; 0000 03E3 }
	RJMP _0x2060003
; .FEND
;
;void uart1SendString(char *str)
; 0000 03E6 {
_uart1SendString:
; .FSTART _uart1SendString
; 0000 03E7     while(*str)
	ST   -Y,R27
	ST   -Y,R26
;	*str -> Y+0
_0x9B:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x9D
; 0000 03E8     {
; 0000 03E9         uart1SendByte(*str++);
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
	MOV  R26,R30
	RCALL _uart1SendByte
; 0000 03EA     }
	RJMP _0x9B
_0x9D:
; 0000 03EB }
	ADIW R28,2
	RET
; .FEND
;
;void uart1SendArray(unsigned char *array, unsigned char size)
; 0000 03EE {
_uart1SendArray:
; .FSTART _uart1SendArray
; 0000 03EF    unsigned char i;
; 0000 03F0     for(i = 0; i < size; ++i)
	ST   -Y,R26
	ST   -Y,R17
;	*array -> Y+2
;	size -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x9F:
	LDD  R30,Y+1
	CP   R17,R30
	BRSH _0xA0
; 0000 03F1     {
; 0000 03F2         uart1SendByte(array[i]);
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RCALL _uart1SendByte
; 0000 03F3     }
	SUBI R17,-LOW(1)
	RJMP _0x9F
_0xA0:
; 0000 03F4 }
	LDD  R17,Y+0
	RJMP _0x2060001
; .FEND
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 03F8 {
_usart0_rx_isr:
; .FSTART _usart0_rx_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 03F9 char simvol;
; 0000 03FA simvol=UDR0;
	ST   -Y,R17
;	simvol -> R17
	IN   R17,12
; 0000 03FB 
; 0000 03FC      if(simvol=='P')
	CPI  R17,80
	BRNE _0xA1
; 0000 03FD    {
; 0000 03FE     GPS_flag_gp=1;
	LDI  R30,LOW(1)
	STS  _GPS_flag_gp,R30
; 0000 03FF     GPS_zap_counter=0;
	LDI  R30,LOW(0)
	STS  _GPS_zap_counter,R30
; 0000 0400     goto exit_int;
	RJMP _0xA2
; 0000 0401    }
; 0000 0402     if(GPS_flag_gp==1)
_0xA1:
	LDS  R26,_GPS_flag_gp
	CPI  R26,LOW(0x1)
	BRNE _0xA3
; 0000 0403    {
; 0000 0404     GPS_string_name[0]=simvol;
	STS  _GPS_string_name,R17
; 0000 0405     GPS_flag_gp=2;
	LDI  R30,LOW(2)
	STS  _GPS_flag_gp,R30
; 0000 0406     goto exit_int;
	RJMP _0xA2
; 0000 0407    }
; 0000 0408     if(GPS_flag_gp==2)
_0xA3:
	LDS  R26,_GPS_flag_gp
	CPI  R26,LOW(0x2)
	BRNE _0xA4
; 0000 0409    {
; 0000 040A     GPS_string_name[1]=simvol;
	__PUTBMRN _GPS_string_name,1,17
; 0000 040B     GPS_flag_gp=3;
	LDI  R30,LOW(3)
	STS  _GPS_flag_gp,R30
; 0000 040C     goto exit_int;
	RJMP _0xA2
; 0000 040D    }
; 0000 040E     if(GPS_flag_gp==3)
_0xA4:
	LDS  R26,_GPS_flag_gp
	CPI  R26,LOW(0x3)
	BRNE _0xA5
; 0000 040F    {
; 0000 0410     GPS_string_name[2]=simvol;
	__PUTBMRN _GPS_string_name,2,17
; 0000 0411     if(GPS_string_name[0]=='G'&&GPS_string_name[1]=='G'&&GPS_string_name[2]=='A')
	LDS  R26,_GPS_string_name
	CPI  R26,LOW(0x47)
	BRNE _0xA7
	__GETB2MN _GPS_string_name,1
	CPI  R26,LOW(0x47)
	BRNE _0xA7
	__GETB2MN _GPS_string_name,2
	CPI  R26,LOW(0x41)
	BREQ _0xA8
_0xA7:
	RJMP _0xA6
_0xA8:
; 0000 0412       {GPS_flag_gp=4;
	LDI  R30,LOW(4)
	STS  _GPS_flag_gp,R30
; 0000 0413        GPS_flag_ready=0;
	LDI  R30,LOW(0)
	STS  _GPS_flag_ready,R30
; 0000 0414        }
; 0000 0415     else
	RJMP _0xA9
_0xA6:
; 0000 0416      GPS_flag_gp=0;
	LDI  R30,LOW(0)
	STS  _GPS_flag_gp,R30
; 0000 0417     goto exit_int;
_0xA9:
	RJMP _0xA2
; 0000 0418    }
; 0000 0419 
; 0000 041A     if((GPS_flag_gp==4)&&(simvol==','))
_0xA5:
	LDS  R26,_GPS_flag_gp
	CPI  R26,LOW(0x4)
	BRNE _0xAB
	CPI  R17,44
	BREQ _0xAC
_0xAB:
	RJMP _0xAA
_0xAC:
; 0000 041B     {
; 0000 041C      GPS_zap_counter++;
	LDS  R30,_GPS_zap_counter
	SUBI R30,-LOW(1)
	STS  _GPS_zap_counter,R30
; 0000 041D      GPS_sim_counter=0;
	LDI  R30,LOW(0)
	STS  _GPS_sim_counter,R30
; 0000 041E      goto exit_int;
	RJMP _0xA2
; 0000 041F     }
; 0000 0420 
; 0000 0421 
; 0000 0422    if(GPS_flag_gp==4)
_0xAA:
	LDS  R26,_GPS_flag_gp
	CPI  R26,LOW(0x4)
	BREQ PC+2
	RJMP _0xAD
; 0000 0423    {
; 0000 0424 
; 0000 0425     if(GPS_zap_counter==2)//shir
	LDS  R26,_GPS_zap_counter
	CPI  R26,LOW(0x2)
	BREQ PC+2
	RJMP _0xAE
; 0000 0426     {
; 0000 0427      switch(GPS_sim_counter)
	LDS  R30,_GPS_sim_counter
	LDI  R31,0
; 0000 0428      {
; 0000 0429       case 0:
	SBIW R30,0
	BRNE _0xB2
; 0000 042A        GPS_shir[0]=(simvol-48)*10;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	STS  _GPS_shir,R30
	STS  _GPS_shir+1,R31
; 0000 042B       break;
	RJMP _0xB1
; 0000 042C       case 1:
_0xB2:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xB3
; 0000 042D        GPS_shir[0]=GPS_shir[0]+(simvol-48);
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	LDS  R26,_GPS_shir
	LDS  R27,_GPS_shir+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _GPS_shir,R30
	STS  _GPS_shir+1,R31
; 0000 042E       break;
	RJMP _0xB1
; 0000 042F       case 2:
_0xB3:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xB4
; 0000 0430        GPS_shir[1]=(simvol-48)*10;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	__PUTW1MN _GPS_shir,2
; 0000 0431       break;
	RJMP _0xB1
; 0000 0432       case 3:
_0xB4:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xB5
; 0000 0433        GPS_shir[1]=GPS_shir[1]+(simvol-48);
	__GETW2MN _GPS_shir,2
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _GPS_shir,2
; 0000 0434       break;
	RJMP _0xB1
; 0000 0435       case 5:
_0xB5:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xB6
; 0000 0436        GPS_shir[2]=(simvol-48)*1000;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12
	RJMP _0x121
; 0000 0437       break;
; 0000 0438       case 6:
_0xB6:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xB7
; 0000 0439        GPS_shir[2]=GPS_shir[2]+(simvol-48)*100;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	__GETW2MN _GPS_shir,4
	RJMP _0x122
; 0000 043A       break;
; 0000 043B       case 7:
_0xB7:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xB8
; 0000 043C        GPS_shir[2]=GPS_shir[2]+(simvol-48)*10;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	__GETW2MN _GPS_shir,4
	RJMP _0x122
; 0000 043D       break;
; 0000 043E       case 8:
_0xB8:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xB1
; 0000 043F        GPS_shir[2]=GPS_shir[2]+(simvol-48);
	__GETW2MN _GPS_shir,4
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
_0x122:
	ADD  R30,R26
	ADC  R31,R27
_0x121:
	__PUTW1MN _GPS_shir,4
; 0000 0440      }
_0xB1:
; 0000 0441      GPS_sim_counter++;
	LDS  R30,_GPS_sim_counter
	SUBI R30,-LOW(1)
	STS  _GPS_sim_counter,R30
; 0000 0442 
; 0000 0443      goto exit_int;
	RJMP _0xA2
; 0000 0444     }
; 0000 0445    if(GPS_zap_counter==3)
_0xAE:
	LDS  R26,_GPS_zap_counter
	CPI  R26,LOW(0x3)
	BRNE _0xBA
; 0000 0446     {GPS_shir[3]=simvol;
	__POINTW2MN _GPS_shir,6
	MOV  R30,R17
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0447      goto exit_int;}
	RJMP _0xA2
; 0000 0448    if(GPS_zap_counter==4)//dolg
_0xBA:
	LDS  R26,_GPS_zap_counter
	CPI  R26,LOW(0x4)
	BREQ PC+2
	RJMP _0xBB
; 0000 0449     {
; 0000 044A      switch(GPS_sim_counter)
	LDS  R30,_GPS_sim_counter
	LDI  R31,0
; 0000 044B      {
; 0000 044C       case 0:
	SBIW R30,0
	BRNE _0xBF
; 0000 044D     GPS_dolg[0]=(simvol-48)*100;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	STS  _GPS_dolg,R30
	STS  _GPS_dolg+1,R31
; 0000 044E       break;
	RJMP _0xBE
; 0000 044F       case 1:
_0xBF:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xC0
; 0000 0450     GPS_dolg[0]=GPS_dolg[0]+(simvol-48)*10;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	LDS  R26,_GPS_dolg
	LDS  R27,_GPS_dolg+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _GPS_dolg,R30
	STS  _GPS_dolg+1,R31
; 0000 0451       break;
	RJMP _0xBE
; 0000 0452       case 2:
_0xC0:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xC1
; 0000 0453     GPS_dolg[0]=GPS_dolg[0]+(simvol-48);
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	LDS  R26,_GPS_dolg
	LDS  R27,_GPS_dolg+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _GPS_dolg,R30
	STS  _GPS_dolg+1,R31
; 0000 0454       break;
	RJMP _0xBE
; 0000 0455       case 3:
_0xC1:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xC2
; 0000 0456        GPS_dolg[1]=(simvol-48)*10;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	__PUTW1MN _GPS_dolg,2
; 0000 0457       break;
	RJMP _0xBE
; 0000 0458       case 4:
_0xC2:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xC3
; 0000 0459        GPS_dolg[1]=GPS_dolg[1]+(simvol-48);
	__GETW2MN _GPS_dolg,2
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1MN _GPS_dolg,2
; 0000 045A       break;
	RJMP _0xBE
; 0000 045B       case 6:
_0xC3:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xC4
; 0000 045C        GPS_dolg[2]=(simvol-48)*1000;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12
	RJMP _0x123
; 0000 045D       break;
; 0000 045E       case 7:
_0xC4:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0xC5
; 0000 045F        GPS_dolg[2]=GPS_dolg[2]+(simvol-48)*100;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	__GETW2MN _GPS_dolg,4
	RJMP _0x124
; 0000 0460       break;
; 0000 0461       case 8:
_0xC5:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0xC6
; 0000 0462        GPS_dolg[2]=GPS_dolg[2]+(simvol-48)*10;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	__GETW2MN _GPS_dolg,4
	RJMP _0x124
; 0000 0463       break;
; 0000 0464       case 9:
_0xC6:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xBE
; 0000 0465        GPS_dolg[2]=GPS_dolg[2]+(simvol-48);
	__GETW2MN _GPS_dolg,4
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,48
_0x124:
	ADD  R30,R26
	ADC  R31,R27
_0x123:
	__PUTW1MN _GPS_dolg,4
; 0000 0466      }
_0xBE:
; 0000 0467      GPS_sim_counter++;
	LDS  R30,_GPS_sim_counter
	SUBI R30,-LOW(1)
	STS  _GPS_sim_counter,R30
; 0000 0468      goto exit_int;
	RJMP _0xA2
; 0000 0469     }
; 0000 046A    if(GPS_zap_counter==5)
_0xBB:
	LDS  R26,_GPS_zap_counter
	CPI  R26,LOW(0x5)
	BRNE _0xC8
; 0000 046B     {
; 0000 046C      GPS_dolg[3]=simvol;
	__POINTW2MN _GPS_dolg,6
	MOV  R30,R17
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 046D      goto exit_int;
	RJMP _0xA2
; 0000 046E     }
; 0000 046F     if(GPS_zap_counter==6)
_0xC8:
	LDS  R26,_GPS_zap_counter
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0xC9
; 0000 0470     {
; 0000 0471      GPS_solve=simvol;
	STS  _GPS_solve,R17
; 0000 0472      GPS_flag_ready=1;
	LDI  R30,LOW(1)
	STS  _GPS_flag_ready,R30
; 0000 0473      GPS_flag_gp=0;
	LDI  R30,LOW(0)
	STS  _GPS_flag_gp,R30
; 0000 0474      GPS_zap_counter=0;
	STS  _GPS_zap_counter,R30
; 0000 0475      GPS_ON_COUNTER=0;
	STS  _GPS_ON_COUNTER,R30
; 0000 0476 
; 0000 0477       SEND_MAS[12]=1;
	LDI  R30,LOW(1)
	__PUTB1MN _SEND_MAS,12
; 0000 0478 
; 0000 0479      SEND_MAS[13]=(unsigned char)GPS_shir[0];
	LDS  R30,_GPS_shir
	__PUTB1MN _SEND_MAS,13
; 0000 047A      SEND_MAS[14]=(unsigned char)GPS_shir[1];
	__GETB1MN _GPS_shir,2
	__PUTB1MN _SEND_MAS,14
; 0000 047B      SEND_MAS[15]=(unsigned char)(GPS_shir[2]/100);
	__GETW2MN _GPS_shir,4
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	__PUTB1MN _SEND_MAS,15
; 0000 047C      SEND_MAS[16]=(unsigned char)(GPS_shir[2]%100);
	__GETW2MN _GPS_shir,4
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	__PUTB1MN _SEND_MAS,16
; 0000 047D 
; 0000 047E      SEND_MAS[17]=(unsigned char)GPS_dolg[0];
	LDS  R30,_GPS_dolg
	__PUTB1MN _SEND_MAS,17
; 0000 047F      SEND_MAS[18]=(unsigned char)GPS_dolg[1];
	__GETB1MN _GPS_dolg,2
	__PUTB1MN _SEND_MAS,18
; 0000 0480      SEND_MAS[19]=(unsigned char)(GPS_dolg[2]/100);
	__GETW2MN _GPS_dolg,4
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	__PUTB1MN _SEND_MAS,19
; 0000 0481      SEND_MAS[20]=(unsigned char)(GPS_dolg[2]%100);
	__GETW2MN _GPS_dolg,4
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	__PUTB1MN _SEND_MAS,20
; 0000 0482 
; 0000 0483      SEND_MAS[21]=(unsigned char)GPS_shir[3];
	__GETB1MN _GPS_shir,6
	__PUTB1MN _SEND_MAS,21
; 0000 0484      SEND_MAS[22]=(unsigned char)GPS_dolg[3];
	__GETB1MN _GPS_dolg,6
	__PUTB1MN _SEND_MAS,22
; 0000 0485 
; 0000 0486     }
; 0000 0487   }
_0xC9:
; 0000 0488 
; 0000 0489 
; 0000 048A  exit_int:
_0xAD:
_0xA2:
; 0000 048B }
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;// USART1 Receiver interrupt service routine
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0000 0490 {
_usart1_rx_isr:
; .FSTART _usart1_rx_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0491  char data;
; 0000 0492   data=UDR1;
	ST   -Y,R17
;	data -> R17
	LDS  R17,156
; 0000 0493  if((receive_counter==0)||(data>245))
	LDS  R26,_receive_counter
	LDS  R27,_receive_counter+1
	SBIW R26,0
	BREQ _0xCB
	CPI  R17,246
	BRSH _0xCB
	RJMP _0xCA
_0xCB:
; 0000 0494  {
; 0000 0495   receive_counter=0;
	LDI  R30,LOW(0)
	STS  _receive_counter,R30
	STS  _receive_counter+1,R30
; 0000 0496   switch(data)
	MOV  R30,R17
	LDI  R31,0
; 0000 0497   {
; 0000 0498    //setup request
; 0000 0499    case 246:
	CPI  R30,LOW(0xF6)
	LDI  R26,HIGH(0xF6)
	CPC  R31,R26
	BRNE _0xD0
; 0000 049A    flag_transmission=248;
	LDI  R30,LOW(248)
	LDI  R31,HIGH(248)
	STS  _flag_transmission,R30
	STS  _flag_transmission+1,R31
; 0000 049B    break;
	RJMP _0xCF
; 0000 049C 
; 0000 049D    //calibr request
; 0000 049E    case 247:
_0xD0:
	CPI  R30,LOW(0xF7)
	LDI  R26,HIGH(0xF7)
	CPC  R31,R26
	BRNE _0xD1
; 0000 049F    flag_transmission=249;
	LDI  R30,LOW(249)
	LDI  R31,HIGH(249)
	STS  _flag_transmission,R30
	STS  _flag_transmission+1,R31
; 0000 04A0    break;
	RJMP _0xCF
; 0000 04A1 
; 0000 04A2    //setup table
; 0000 04A3    case 248:
_0xD1:
	CPI  R30,LOW(0xF8)
	LDI  R26,HIGH(0xF8)
	CPC  R31,R26
	BRNE _0xD2
; 0000 04A4    flag_receive=248;
	LDI  R30,LOW(248)
	LDI  R31,HIGH(248)
	STS  _flag_receive,R30
	STS  _flag_receive+1,R31
; 0000 04A5    receive_counter=7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	STS  _receive_counter,R30
	STS  _receive_counter+1,R31
; 0000 04A6    break;
	RJMP _0xCF
; 0000 04A7 
; 0000 04A8    //calibr table
; 0000 04A9    case 249:
_0xD2:
	CPI  R30,LOW(0xF9)
	LDI  R26,HIGH(0xF9)
	CPC  R31,R26
	BRNE _0xD3
; 0000 04AA    flag_receive=249;
	LDI  R30,LOW(249)
	LDI  R31,HIGH(249)
	STS  _flag_receive,R30
	STS  _flag_receive+1,R31
; 0000 04AB    receive_counter=9;
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	STS  _receive_counter,R30
	STS  _receive_counter+1,R31
; 0000 04AC    break;
	RJMP _0xCF
; 0000 04AD 
; 0000 04AE     //system on
; 0000 04AF    case 250:
_0xD3:
	CPI  R30,LOW(0xFA)
	LDI  R26,HIGH(0xFA)
	CPC  R31,R26
	BRNE _0xD4
; 0000 04B0     if(flag_I_NULL<10)//If the current null calibration has not finished
	LDS  R26,_flag_I_NULL
	CPI  R26,LOW(0xA)
	BRLO _0xCF
; 0000 04B1      break;
; 0000 04B2     flag_start=1;
	LDI  R30,LOW(1)
	STS  _flag_start,R30
; 0000 04B3    break;
	RJMP _0xCF
; 0000 04B4 
; 0000 04B5    //system off
; 0000 04B6    case 251:
_0xD4:
	CPI  R30,LOW(0xFB)
	LDI  R26,HIGH(0xFB)
	CPC  R31,R26
	BRNE _0xD6
; 0000 04B7    flag_start=0;
	LDI  R30,LOW(0)
	STS  _flag_start,R30
; 0000 04B8    break;
	RJMP _0xCF
; 0000 04B9 
; 0000 04BA    case 252:
_0xD6:
	CPI  R30,LOW(0xFC)
	LDI  R26,HIGH(0xFC)
	CPC  R31,R26
	BRNE _0xD7
; 0000 04BB    PORTC.1 = 1;//fonar on
	SBI  0x15,1
; 0000 04BC    break;
	RJMP _0xCF
; 0000 04BD 
; 0000 04BE    case 253:
_0xD7:
	CPI  R30,LOW(0xFD)
	LDI  R26,HIGH(0xFD)
	CPC  R31,R26
	BRNE _0xCF
; 0000 04BF    PORTC.1 = 0;//fonar off
	CBI  0x15,1
; 0000 04C0    break;
; 0000 04C1   }
_0xCF:
; 0000 04C2  }
; 0000 04C3  else
	RJMP _0xDD
_0xCA:
; 0000 04C4  {
; 0000 04C5    if(flag_receive==248)
	LDS  R26,_flag_receive
	LDS  R27,_flag_receive+1
	CPI  R26,LOW(0xF8)
	LDI  R30,HIGH(0xF8)
	CPC  R27,R30
	BRNE _0xDE
; 0000 04C6    {
; 0000 04C7     SETUP_MAS[8-receive_counter]=data;
	LDS  R26,_receive_counter
	LDS  R27,_receive_counter+1
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	SUB  R30,R26
	SBC  R31,R27
	SUBI R30,LOW(-_SETUP_MAS)
	SBCI R31,HIGH(-_SETUP_MAS)
	ST   Z,R17
; 0000 04C8     if(receive_counter==1)
	SBIW R26,1
	BRNE _0xDF
; 0000 04C9     {
; 0000 04CA      save_to_eeprom();
	RCALL _save_to_eeprom
; 0000 04CB      Read_Setup_Calibr();
	RCALL _Read_Setup_Calibr
; 0000 04CC     }
; 0000 04CD    }
_0xDF:
; 0000 04CE 
; 0000 04CF     if(flag_receive==249)
_0xDE:
	LDS  R26,_flag_receive
	LDS  R27,_flag_receive+1
	CPI  R26,LOW(0xF9)
	LDI  R30,HIGH(0xF9)
	CPC  R27,R30
	BRNE _0xE0
; 0000 04D0     {
; 0000 04D1      CALIBR_MAS[10-receive_counter]=data;
	LDS  R26,_receive_counter
	LDS  R27,_receive_counter+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	SUB  R30,R26
	SBC  R31,R27
	SUBI R30,LOW(-_CALIBR_MAS)
	SBCI R31,HIGH(-_CALIBR_MAS)
	ST   Z,R17
; 0000 04D2      if(receive_counter==1)
	SBIW R26,1
	BRNE _0xE1
; 0000 04D3      {
; 0000 04D4       save_to_eeprom();
	RCALL _save_to_eeprom
; 0000 04D5       Read_Setup_Calibr();
	RCALL _Read_Setup_Calibr
; 0000 04D6      }
; 0000 04D7     }
_0xE1:
; 0000 04D8 
; 0000 04D9    receive_counter--;
_0xE0:
	LDI  R26,LOW(_receive_counter)
	LDI  R27,HIGH(_receive_counter)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 04DA  }
_0xDD:
; 0000 04DB }
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;
;
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 04E3 {
_read_adc:
; .FSTART _read_adc
; 0000 04E4  ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0xC0)
	OUT  0x7,R30
; 0000 04E5  // Delay needed for the stabilization of the ADC input voltage
; 0000 04E6  delay_us(7);
	__DELAY_USB 26
; 0000 04E7  // Start the AD conversion
; 0000 04E8  ADCSRA|=0x40;
	SBI  0x6,6
; 0000 04E9  // Wait for the AD conversion to complete
; 0000 04EA  while ((ADCSRA & 0x10)==0);
_0xE2:
	SBIS 0x6,4
	RJMP _0xE2
; 0000 04EB   ADCSRA|=0x10;
	SBI  0x6,4
; 0000 04EC  return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
_0x2060003:
	ADIW R28,1
	RET
; 0000 04ED }
; .FEND
;
;
;
; unsigned char NEW_REGULATOR(unsigned int Z,unsigned int S)//s 1000=1
; 0000 04F2  {
_NEW_REGULATOR:
; .FSTART _NEW_REGULATOR
; 0000 04F3   int U,E;
; 0000 04F4 
; 0000 04F5   E=150-S;//z always 150
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	Z -> Y+6
;	S -> Y+4
;	U -> R16,R17
;	E -> R18,R19
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	SUB  R30,R26
	SBC  R31,R27
	MOVW R18,R30
; 0000 04F6   PID_I_S=PID_I_S+E;
	LDS  R26,_PID_I_S
	LDS  R27,_PID_I_S+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _PID_I_S,R30
	STS  _PID_I_S+1,R31
; 0000 04F7   if(PID_I_S>1000)
	LDS  R26,_PID_I_S
	LDS  R27,_PID_I_S+1
	CPI  R26,LOW(0x3E9)
	LDI  R30,HIGH(0x3E9)
	CPC  R27,R30
	BRLT _0xE5
; 0000 04F8    PID_I_S=1000;
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	STS  _PID_I_S,R30
	STS  _PID_I_S+1,R31
; 0000 04F9   if(PID_I_S<0)
_0xE5:
	LDS  R26,_PID_I_S+1
	TST  R26
	BRPL _0xE6
; 0000 04FA    PID_I_S=0;
	LDI  R30,LOW(0)
	STS  _PID_I_S,R30
	STS  _PID_I_S+1,R30
; 0000 04FB 
; 0000 04FC    if(S<30)
_0xE6:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	SBIW R26,30
	BRSH _0xE7
; 0000 04FD     PID_I_S=800;
	LDI  R30,LOW(800)
	LDI  R31,HIGH(800)
	STS  _PID_I_S,R30
	STS  _PID_I_S+1,R31
; 0000 04FE 
; 0000 04FF    U=PID_I_S;
_0xE7:
	__GETWRMN 16,17,0,_PID_I_S
; 0000 0500 
; 0000 0501 
; 0000 0502  U=U/4;
	MOVW R26,R16
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __DIVW21
	MOVW R16,R30
; 0000 0503   if(U<0)
	TST  R17
	BRPL _0xE8
; 0000 0504    U=0;
	__GETWRN 16,17,0
; 0000 0505   if(U>255)
_0xE8:
	__CPWRN 16,17,256
	BRLT _0xE9
; 0000 0506    U=255;
	__GETWRN 16,17,255
; 0000 0507   return (unsigned char)U;
_0xE9:
	MOV  R30,R16
	CALL __LOADLOCR4
	ADIW R28,8
	RET
; 0000 0508  }
; .FEND
;
;
;// Timer2 overflow interrupt service routine
;////100HZ Program cycle
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 050E {
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 050F  int SCOLGENIE=0;
; 0000 0510  unsigned char PWM=0;
; 0000 0511 
; 0000 0512  TCNT2=148;//100HZ
	CALL __SAVELOCR4
;	SCOLGENIE -> R16,R17
;	PWM -> R19
	__GETWRN 16,17,0
	LDI  R19,0
	LDI  R30,LOW(148)
	OUT  0x24,R30
; 0000 0513  //Speed---------------------------------------------------------------------------
; 0000 0514   if((IK_DELTA>400)&&(ovf_IK<2))   //   ~~160km/h             172,800 kHz
	LDS  R26,_IK_DELTA
	LDS  R27,_IK_DELTA+1
	LDS  R24,_IK_DELTA+2
	LDS  R25,_IK_DELTA+3
	__CPD2N 0x191
	BRLO _0xEB
	LDS  R26,_ovf_IK
	CPI  R26,LOW(0x2)
	BRLO _0xEC
_0xEB:
	RJMP _0xEA
_0xEC:
; 0000 0515           {
; 0000 0516            IK_SPEED_KM_H=(unsigned int)(((unsigned long)R_IK*2255)/IK_DELTA);
	MOVW R26,R12
	CLR  R24
	CLR  R25
	__GETD1N 0x8CF
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_IK_DELTA
	LDS  R31,_IK_DELTA+1
	LDS  R22,_IK_DELTA+2
	LDS  R23,_IK_DELTA+3
	CALL __DIVD21U
	STS  _IK_SPEED_KM_H,R30
	STS  _IK_SPEED_KM_H+1,R31
; 0000 0517           }
; 0000 0518   else
	RJMP _0xED
_0xEA:
; 0000 0519           {
; 0000 051A            IK_SPEED_KM_H=0;
	LDI  R30,LOW(0)
	STS  _IK_SPEED_KM_H,R30
	STS  _IK_SPEED_KM_H+1,R30
; 0000 051B           }
_0xED:
; 0000 051C           IK_SPEED_MAS[0]=IK_SPEED_MAS[1];
	__GETW1MN _IK_SPEED_MAS,2
	STS  _IK_SPEED_MAS,R30
	STS  _IK_SPEED_MAS+1,R31
; 0000 051D           IK_SPEED_MAS[1]=IK_SPEED_MAS[2];
	__GETW1MN _IK_SPEED_MAS,4
	__PUTW1MN _IK_SPEED_MAS,2
; 0000 051E           IK_SPEED_MAS[2]=IK_SPEED_KM_H;
	LDS  R30,_IK_SPEED_KM_H
	LDS  R31,_IK_SPEED_KM_H+1
	__PUTW1MN _IK_SPEED_MAS,4
; 0000 051F 
; 0000 0520   if((TK_DELTA>400)&&(ovf_TK<2))   //   ~~160            172,800 kHz
	LDS  R26,_TK_DELTA
	LDS  R27,_TK_DELTA+1
	LDS  R24,_TK_DELTA+2
	LDS  R25,_TK_DELTA+3
	__CPD2N 0x191
	BRLO _0xEF
	LDS  R26,_ovf_TK
	CPI  R26,LOW(0x2)
	BRLO _0xF0
_0xEF:
	RJMP _0xEE
_0xF0:
; 0000 0521           {
; 0000 0522            TK_SPEED_KM_H=(unsigned int)(((unsigned long)R_TK*2171)/TK_DELTA);
	LDS  R26,_R_TK
	LDS  R27,_R_TK+1
	CLR  R24
	CLR  R25
	__GETD1N 0x87B
	CALL __MULD12U
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_TK_DELTA
	LDS  R31,_TK_DELTA+1
	LDS  R22,_TK_DELTA+2
	LDS  R23,_TK_DELTA+3
	CALL __DIVD21U
	STS  _TK_SPEED_KM_H,R30
	STS  _TK_SPEED_KM_H+1,R31
; 0000 0523           }
; 0000 0524   else
	RJMP _0xF1
_0xEE:
; 0000 0525           {
; 0000 0526            TK_SPEED_KM_H=0;
	LDI  R30,LOW(0)
	STS  _TK_SPEED_KM_H,R30
	STS  _TK_SPEED_KM_H+1,R30
; 0000 0527           }
_0xF1:
; 0000 0528           TK_SPEED_MAS[0]=TK_SPEED_MAS[1];
	__GETW1MN _TK_SPEED_MAS,2
	STS  _TK_SPEED_MAS,R30
	STS  _TK_SPEED_MAS+1,R31
; 0000 0529           TK_SPEED_MAS[1]=TK_SPEED_MAS[2];
	__GETW1MN _TK_SPEED_MAS,4
	__PUTW1MN _TK_SPEED_MAS,2
; 0000 052A           TK_SPEED_MAS[2]=TK_SPEED_KM_H;
	LDS  R30,_TK_SPEED_KM_H
	LDS  R31,_TK_SPEED_KM_H+1
	__PUTW1MN _TK_SPEED_MAS,4
; 0000 052B   //Speed---------------------------------------------------------------------------
; 0000 052C 
; 0000 052D 
; 0000 052E         //Proverka u vichiclenie skolgenia---------------------------------------------------------------
; 0000 052F           if((IK_SPEED_KM_H>=TK_SPEED_KM_H)||(TK_SPEED_KM_H<100))// 10kmh
	LDS  R26,_IK_SPEED_KM_H
	LDS  R27,_IK_SPEED_KM_H+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0xF3
	LDS  R26,_TK_SPEED_KM_H
	LDS  R27,_TK_SPEED_KM_H+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRSH _0xF2
_0xF3:
; 0000 0530             SCOLGENIE=0;
	__GETWRN 16,17,0
; 0000 0531           else
	RJMP _0xF5
_0xF2:
; 0000 0532             SCOLGENIE=(int)((((long int)(TK_SPEED_KM_H-IK_SPEED_KM_H))*1000)/((long int)TK_SPEED_KM_H));
	LDS  R26,_IK_SPEED_KM_H
	LDS  R27,_IK_SPEED_KM_H+1
	LDS  R30,_TK_SPEED_KM_H
	LDS  R31,_TK_SPEED_KM_H+1
	SUB  R30,R26
	SBC  R31,R27
	CLR  R22
	CLR  R23
	__GETD2N 0x3E8
	CALL __MULD12
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_TK_SPEED_KM_H
	LDS  R31,_TK_SPEED_KM_H+1
	CLR  R22
	CLR  R23
	CALL __DIVD21
	MOVW R16,R30
; 0000 0533         //-----------------------------------------------------------------------------------------------
; 0000 0534 
; 0000 0535 
; 0000 0536         if(flag_start==1)
_0xF5:
	LDS  R26,_flag_start
	CPI  R26,LOW(0x1)
	BRNE _0xF6
; 0000 0537           {
; 0000 0538            if(TK_SPEED_KM_H<750)
	LDS  R26,_TK_SPEED_KM_H
	LDS  R27,_TK_SPEED_KM_H+1
	CPI  R26,LOW(0x2EE)
	LDI  R30,HIGH(0x2EE)
	CPC  R27,R30
	BRSH _0xF7
; 0000 0539            {
; 0000 053A               PWM=NEW_REGULATOR(ZADANIE_S*10,(unsigned int)SCOLGENIE);
	LDS  R26,_ZADANIE_S
	LDS  R27,_ZADANIE_S+1
	LDI  R30,LOW(10)
	CALL __MULB1W2U
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	RCALL _NEW_REGULATOR
	MOV  R19,R30
; 0000 053B            }
; 0000 053C            else
	RJMP _0xF8
_0xF7:
; 0000 053D            {
; 0000 053E             PWM=255;
	LDI  R19,LOW(255)
; 0000 053F             //PID_I_S=800;
; 0000 0540            }
_0xF8:
; 0000 0541           }
; 0000 0542           else
	RJMP _0xF9
_0xF6:
; 0000 0543           {
; 0000 0544            PWM=0;
	LDI  R19,LOW(0)
; 0000 0545           }
_0xF9:
; 0000 0546            OCR0=255-PWM;
	LDI  R30,LOW(255)
	SUB  R30,R19
	OUT  0x31,R30
; 0000 0547 
; 0000 0548  if(program_cycle_counter<9)
	LDS  R26,_program_cycle_counter
	CPI  R26,LOW(0x9)
	BRSH _0xFA
; 0000 0549   {program_cycle_counter++;}
	LDS  R30,_program_cycle_counter
	SUBI R30,-LOW(1)
	RJMP _0x125
; 0000 054A  else
_0xFA:
; 0000 054B   {
; 0000 054C    program_cycle_flag=1;
	LDI  R30,LOW(1)
	STS  _program_cycle_flag,R30
; 0000 054D    program_cycle_counter=0;
	LDI  R30,LOW(0)
_0x125:
	STS  _program_cycle_counter,R30
; 0000 054E   }
; 0000 054F }
	CALL __LOADLOCR4
	ADIW R28,4
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;
;//eeprom unsigned char EEP_CALIBR_MAS[10];
;//eeprom unsigned char EEP_SETUP_MAS[8];
;
;//unsigned char CALIBR_MAS[10]={249,66,94,7,9,7,2,8,24,(66+94+7+9+7+2+8+24)/8};
;//unsigned char SETUP_MAS[8]={248,198,130,10,1,0,0,(198+130+10+1)/6};
;void load_from_eeprom(void)
; 0000 0558 {
_load_from_eeprom:
; .FSTART _load_from_eeprom
; 0000 0559  unsigned char tmp;
; 0000 055A  unsigned int cal_sum=0,setup_sum=0;
; 0000 055B 
; 0000 055C  CALIBR_MAS[0]=EEP_CALIBR_MAS[0];
	CALL __SAVELOCR6
;	tmp -> R17
;	cal_sum -> R18,R19
;	setup_sum -> R20,R21
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	LDI  R26,LOW(_EEP_CALIBR_MAS)
	LDI  R27,HIGH(_EEP_CALIBR_MAS)
	CALL __EEPROMRDB
	STS  _CALIBR_MAS,R30
; 0000 055D  CALIBR_MAS[9]=EEP_CALIBR_MAS[9];
	__POINTW2MN _EEP_CALIBR_MAS,9
	CALL __EEPROMRDB
	__PUTB1MN _CALIBR_MAS,9
; 0000 055E   for(tmp=1;tmp<=8;tmp++)
	LDI  R17,LOW(1)
_0xFD:
	CPI  R17,9
	BRSH _0xFE
; 0000 055F  {
; 0000 0560    CALIBR_MAS[tmp]=EEP_CALIBR_MAS[tmp];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_CALIBR_MAS)
	SBCI R31,HIGH(-_CALIBR_MAS)
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_EEP_CALIBR_MAS)
	SBCI R27,HIGH(-_EEP_CALIBR_MAS)
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
; 0000 0561    cal_sum=cal_sum+CALIBR_MAS[tmp];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_CALIBR_MAS)
	SBCI R31,HIGH(-_CALIBR_MAS)
	LD   R30,Z
	LDI  R31,0
	__ADDWRR 18,19,30,31
; 0000 0562  }
	SUBI R17,-1
	RJMP _0xFD
_0xFE:
; 0000 0563  cal_sum=cal_sum/8;
	MOVW R30,R18
	CALL __LSRW3
	MOVW R18,R30
; 0000 0564 
; 0000 0565    if((CALIBR_MAS[0]!=249)||(CALIBR_MAS[9]!=cal_sum))
	LDS  R26,_CALIBR_MAS
	CPI  R26,LOW(0xF9)
	BRNE _0x100
	__GETB2MN _CALIBR_MAS,9
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0xFF
_0x100:
; 0000 0566  {
; 0000 0567   for(tmp=0;tmp<=9;tmp++)
	LDI  R17,LOW(0)
_0x103:
	CPI  R17,10
	BRSH _0x104
; 0000 0568   {
; 0000 0569    CALIBR_MAS[tmp]=DEFAULT_CALIBR_MAS[tmp];
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_CALIBR_MAS)
	SBCI R27,HIGH(-_CALIBR_MAS)
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_DEFAULT_CALIBR_MAS)
	SBCI R31,HIGH(-_DEFAULT_CALIBR_MAS)
	LD   R30,Z
	ST   X,R30
; 0000 056A   }
	SUBI R17,-1
	RJMP _0x103
_0x104:
; 0000 056B  }
; 0000 056C 
; 0000 056D  SETUP_MAS[0]=EEP_SETUP_MAS[0];
_0xFF:
	LDI  R26,LOW(_EEP_SETUP_MAS)
	LDI  R27,HIGH(_EEP_SETUP_MAS)
	CALL __EEPROMRDB
	STS  _SETUP_MAS,R30
; 0000 056E  SETUP_MAS[7]=EEP_SETUP_MAS[7];
	__POINTW2MN _EEP_SETUP_MAS,7
	CALL __EEPROMRDB
	__PUTB1MN _SETUP_MAS,7
; 0000 056F   for(tmp=1;tmp<=6;tmp++)
	LDI  R17,LOW(1)
_0x106:
	CPI  R17,7
	BRSH _0x107
; 0000 0570  {
; 0000 0571   SETUP_MAS[tmp]=EEP_SETUP_MAS[tmp];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_SETUP_MAS)
	SBCI R31,HIGH(-_SETUP_MAS)
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_EEP_SETUP_MAS)
	SBCI R27,HIGH(-_EEP_SETUP_MAS)
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
; 0000 0572   setup_sum=setup_sum+SETUP_MAS[tmp];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_SETUP_MAS)
	SBCI R31,HIGH(-_SETUP_MAS)
	LD   R30,Z
	LDI  R31,0
	__ADDWRR 20,21,30,31
; 0000 0573  }
	SUBI R17,-1
	RJMP _0x106
_0x107:
; 0000 0574    setup_sum=setup_sum/6;
	MOVW R26,R20
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL __DIVW21U
	MOVW R20,R30
; 0000 0575    if((SETUP_MAS[0]!=248)||(SETUP_MAS[7]!=setup_sum))
	LDS  R26,_SETUP_MAS
	CPI  R26,LOW(0xF8)
	BRNE _0x109
	__GETB2MN _SETUP_MAS,7
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x108
_0x109:
; 0000 0576   {
; 0000 0577     for(tmp=0;tmp<=7;tmp++)
	LDI  R17,LOW(0)
_0x10C:
	CPI  R17,8
	BRSH _0x10D
; 0000 0578    {
; 0000 0579     SETUP_MAS[tmp]=DEFAULT_SETUP_MAS[tmp];
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_SETUP_MAS)
	SBCI R27,HIGH(-_SETUP_MAS)
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_DEFAULT_SETUP_MAS)
	SBCI R31,HIGH(-_DEFAULT_SETUP_MAS)
	LD   R30,Z
	ST   X,R30
; 0000 057A    }
	SUBI R17,-1
	RJMP _0x10C
_0x10D:
; 0000 057B  }
; 0000 057C }
_0x108:
	CALL __LOADLOCR6
	ADIW R28,6
	RET
; .FEND
;
;void save_to_eeprom(void)
; 0000 057F {
_save_to_eeprom:
; .FSTART _save_to_eeprom
; 0000 0580  unsigned char tmp;
; 0000 0581  unsigned int sum;
; 0000 0582 
; 0000 0583   sum=0;
	CALL __SAVELOCR4
;	tmp -> R17
;	sum -> R18,R19
	__GETWRN 18,19,0
; 0000 0584   for(tmp=1;tmp<=8;tmp++)
	LDI  R17,LOW(1)
_0x10F:
	CPI  R17,9
	BRSH _0x110
; 0000 0585   {
; 0000 0586    sum=sum+CALIBR_MAS[tmp];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_CALIBR_MAS)
	SBCI R31,HIGH(-_CALIBR_MAS)
	LD   R30,Z
	LDI  R31,0
	__ADDWRR 18,19,30,31
; 0000 0587   }
	SUBI R17,-1
	RJMP _0x10F
_0x110:
; 0000 0588   sum=sum/8;
	MOVW R30,R18
	CALL __LSRW3
	MOVW R18,R30
; 0000 0589 
; 0000 058A   if(sum==CALIBR_MAS[9])
	__GETB1MN _CALIBR_MAS,9
	MOVW R26,R18
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x111
; 0000 058B   {
; 0000 058C    for(tmp=0;tmp<=9;tmp++)
	LDI  R17,LOW(0)
_0x113:
	CPI  R17,10
	BRSH _0x114
; 0000 058D    {
; 0000 058E     EEP_CALIBR_MAS[tmp]=CALIBR_MAS[tmp];
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_EEP_CALIBR_MAS)
	SBCI R27,HIGH(-_EEP_CALIBR_MAS)
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_CALIBR_MAS)
	SBCI R31,HIGH(-_CALIBR_MAS)
	LD   R30,Z
	CALL __EEPROMWRB
; 0000 058F    }
	SUBI R17,-1
	RJMP _0x113
_0x114:
; 0000 0590   }
; 0000 0591 
; 0000 0592   sum=0;
_0x111:
	__GETWRN 18,19,0
; 0000 0593   for(tmp=1;tmp<=6;tmp++)
	LDI  R17,LOW(1)
_0x116:
	CPI  R17,7
	BRSH _0x117
; 0000 0594   {
; 0000 0595    sum=sum+SETUP_MAS[tmp];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_SETUP_MAS)
	SBCI R31,HIGH(-_SETUP_MAS)
	LD   R30,Z
	LDI  R31,0
	__ADDWRR 18,19,30,31
; 0000 0596   }
	SUBI R17,-1
	RJMP _0x116
_0x117:
; 0000 0597   sum=sum/6;
	MOVW R26,R18
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL __DIVW21U
	MOVW R18,R30
; 0000 0598   if(sum==SETUP_MAS[7])
	__GETB1MN _SETUP_MAS,7
	MOVW R26,R18
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x118
; 0000 0599   {
; 0000 059A    for(tmp=0;tmp<=7;tmp++)
	LDI  R17,LOW(0)
_0x11A:
	CPI  R17,8
	BRSH _0x11B
; 0000 059B    {
; 0000 059C     EEP_SETUP_MAS[tmp]=SETUP_MAS[tmp];
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_EEP_SETUP_MAS)
	SBCI R27,HIGH(-_EEP_SETUP_MAS)
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_SETUP_MAS)
	SBCI R31,HIGH(-_SETUP_MAS)
	LD   R30,Z
	CALL __EEPROMWRB
; 0000 059D    }
	SUBI R17,-1
	RJMP _0x11A
_0x11B:
; 0000 059E   }
; 0000 059F 
; 0000 05A0 }
_0x118:
_0x2060002:
	CALL __LOADLOCR4
_0x2060001:
	ADIW R28,4
	RET
; .FEND
;
;
;//unsigned int K_BY_KOEFFICIENTS_OLD(unsigned int M)
;//{
;//unsigned long F,W,K;
;////WEIGHT_NULL=6679, LOADCELL_NULL=618, DELTA_WEIGHT10KG=748, DELTA_LOADCELL10KG=772
;//if(M<LOADCELL_NULL)
;// return 0;
;//
;//F=((M-(unsigned long)LOADCELL_NULL)*1000)/((unsigned long)DELTA_LOADCELL10KG);
;//W=(unsigned long)WEIGHT_NULL-((unsigned long)DELTA_WEIGHT10KG*F)/1000;
;//if(W>0)
;// K=(F*1000)/W;
;//else
;// K=3000;
;//
;//if(K>3000)
;// K=3000;
;//return K;
;//}
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.ESEG
_EEP_SETUP_MAS:
	.BYTE 0x8
_EEP_CALIBR_MAS:
	.BYTE 0xA

	.DSEG
_R_TK:
	.BYTE 0x2
_ZADANIE_S:
	.BYTE 0x2
_SETUP_MAS:
	.BYTE 0x8
_CALIBR_MAS:
	.BYTE 0xA
_DEFAULT_SETUP_MAS:
	.BYTE 0x8
_DEFAULT_CALIBR_MAS:
	.BYTE 0xA
_flag_transmission:
	.BYTE 0x2
_flag_receive:
	.BYTE 0x2
_receive_counter:
	.BYTE 0x2
_SEND_MAS:
	.BYTE 0x1A
_program_cycle_flag:
	.BYTE 0x1
_program_cycle_counter:
	.BYTE 0x1
_ovf_IK:
	.BYTE 0x1
_ovf_TK:
	.BYTE 0x1
_IK_COUNT:
	.BYTE 0x8
_TK_COUNT:
	.BYTE 0x8
_IK_DELTA:
	.BYTE 0x4
_TK_DELTA:
	.BYTE 0x4
_IK_SPEED_KM_H:
	.BYTE 0x2
_TK_SPEED_KM_H:
	.BYTE 0x2
_IK_SPEED_MAS:
	.BYTE 0x6
_TK_SPEED_MAS:
	.BYTE 0x6
_ADC_BAT:
	.BYTE 0x2
_ADC_I:
	.BYTE 0x2
_BAT_SUM:
	.BYTE 0x2
_I_NULL:
	.BYTE 0x4
_flag_I_NULL:
	.BYTE 0x1
_GPS_zap_counter:
	.BYTE 0x1
_GPS_sim_counter:
	.BYTE 0x1
_GPS_flag_ready:
	.BYTE 0x1
_GPS_string_name:
	.BYTE 0x3
_GPS_flag_gp:
	.BYTE 0x1
_GPS_shir:
	.BYTE 0x8
_GPS_dolg:
	.BYTE 0x8
_GPS_solve:
	.BYTE 0x1
_GPS_ON_COUNTER:
	.BYTE 0x1
_flag_start:
	.BYTE 0x1
_measuring_start_counter:
	.BYTE 0x1
_load_cell:
	.BYTE 0x2
_load_cell_MAS:
	.BYTE 0x28
_ADC_fault_counter:
	.BYTE 0x1
_PID_I_S:
	.BYTE 0x2

	.CSEG

	.CSEG
	.equ __sda_bit=1
	.equ __scl_bit=0
	.equ __i2c_port=0x12 ;PORTD
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,18
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,37
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__SUBD21:
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULB1W2U:
	MOV  R22,R30
	MUL  R22,R26
	MOVW R30,R0
	MUL  R22,R27
	ADD  R31,R0
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTDZ20:
	ST   Z,R26
	STD  Z+1,R27
	STD  Z+2,R24
	STD  Z+3,R25
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
