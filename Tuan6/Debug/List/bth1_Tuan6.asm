
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
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

	#pragma AVRPART ADMIN PART_NAME ATmega128
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
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x1,0x0,0x2,0x0,0x3,0x0,0x4,0x0
	.DB  0x5,0x0,0x6,0x0,0x7,0x0,0x8,0x0
	.DB  0x9
_0x26:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0x38,0x38,0x38,0x0,0x4E,0x48,0x41,0x50
	.DB  0x20,0x4D,0x4B,0x20,0x4D,0x4F,0x49,0x3A
	.DB  0x0,0x58,0x41,0x43,0x20,0x4E,0x48,0x41
	.DB  0x4E,0x20,0x4D,0x4B,0x20,0x4D,0x4F,0x49
	.DB  0x3A,0x0,0x54,0x48,0x41,0x4E,0x48,0x20
	.DB  0x43,0x4F,0x4E,0x47,0x21,0x0,0x44,0x41
	.DB  0x20,0x4C,0x55,0x55,0x20,0x45,0x45,0x50
	.DB  0x52,0x4F,0x4D,0x0,0x4D,0x4B,0x20,0x4B
	.DB  0x48,0x4F,0x4E,0x47,0x20,0x4B,0x48,0x4F
	.DB  0x50,0x21,0x0,0x4E,0x48,0x41,0x50,0x20
	.DB  0x4C,0x41,0x49,0x20,0x54,0x55,0x20,0x44
	.DB  0x41,0x55,0x0,0x4E,0x48,0x41,0x50,0x20
	.DB  0x4D,0x41,0x54,0x20,0x4B,0x48,0x41,0x55
	.DB  0x3A,0x0,0x44,0x41,0x4E,0x47,0x20,0x4E
	.DB  0x48,0x41,0x50,0x20,0x4F,0x4B,0x21,0x0
	.DB  0x31,0x3A,0x44,0x55,0x4E,0x47,0x20,0x4D
	.DB  0x4B,0x20,0x43,0x55,0x0,0x32,0x3A,0x44
	.DB  0x4F,0x49,0x20,0x4D,0x4B,0x20,0x4D,0x4F
	.DB  0x49,0x0,0x54,0x49,0x45,0x50,0x20,0x54
	.DB  0x55,0x43,0x20,0x53,0x55,0x20,0x44,0x55
	.DB  0x4E,0x47,0x0,0x53,0x41,0x49,0x20,0x4D
	.DB  0x41,0x54,0x20,0x4B,0x48,0x41,0x55,0x21
	.DB  0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x11
	.DW  _keypad
	.DW  _0x3*2

	.DW  0x04
	.DW  _0x1F
	.DW  _0x0*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
;#include <io.h>
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
;#include <alcd.h>
;#include <delay.h>
;#include <stdio.h>
;#include <string.h>
;
;#define RELAY1 PORTC.0
;#define LCD_BL PORTD.7
;
;int keypad[3][3] = {
;    {1, 2, 3},
;    {4, 5, 6},
;    {7, 8, 9}
;};

	.DSEG
;
;eeprom char EE_PASS[5];
;char CURRENT_PASS[5];
;
;// Quét 1 phím t? bàn phím ma tr?n 3x3
;char scan_digit(void) {
; 0000 0014 char scan_digit(void) {

	.CSEG
_scan_digit:
; .FSTART _scan_digit
; 0000 0015     unsigned char r;
; 0000 0016     int key;
; 0000 0017 
; 0000 0018     for (r = 0; r < 3; r++) {
	CALL __SAVELOCR4
;	r -> R17
;	key -> R18,R19
	LDI  R17,LOW(0)
_0x5:
	CPI  R17,3
	BRLO PC+2
	RJMP _0x6
; 0000 0019         if (r == 0) { PORTC = (PORTC & 0x0F) | 0x30; PORTE = 0x03; PORTD = 0x81; }
	CPI  R17,0
	BRNE _0x7
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0x30)
	OUT  0x15,R30
	LDI  R30,LOW(3)
	OUT  0x3,R30
	LDI  R30,LOW(129)
	OUT  0x12,R30
; 0000 001A         if (r == 1) { PORTC = (PORTC & 0x0F) | 0x70; PORTE = 0x01; PORTD = 0x81; }
_0x7:
	CPI  R17,1
	BRNE _0x8
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0x70)
	OUT  0x15,R30
	LDI  R30,LOW(1)
	OUT  0x3,R30
	LDI  R30,LOW(129)
	OUT  0x12,R30
; 0000 001B         if (r == 2) { PORTC = (PORTC & 0x0F) | 0x70; PORTE = 0x03; PORTD = 0x80; }
_0x8:
	CPI  R17,2
	BRNE _0x9
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0x70)
	OUT  0x15,R30
	LDI  R30,LOW(3)
	OUT  0x3,R30
	LDI  R30,LOW(128)
	OUT  0x12,R30
; 0000 001C 
; 0000 001D         delay_us(10);
_0x9:
	__DELAY_USB 27
; 0000 001E 
; 0000 001F         if ((PINC & 0x10) == 0) {
	SBIC 0x13,4
	RJMP _0xA
; 0000 0020             delay_ms(20);
	CALL SUBOPT_0x0
; 0000 0021             if ((PINC & 0x10) == 0) {
	SBIC 0x13,4
	RJMP _0xB
; 0000 0022                 key = keypad[r][0];
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	SUBI R30,LOW(-_keypad)
	SBCI R31,HIGH(-_keypad)
	LD   R18,Z
	LDD  R19,Z+1
; 0000 0023                 while ((PINC & 0x10) == 0) delay_ms(10);
_0xC:
	SBIC 0x13,4
	RJMP _0xE
	CALL SUBOPT_0x1
	RJMP _0xC
_0xE:
; 0000 0024 return (char)('0' + key);
	MOV  R30,R18
	SUBI R30,-LOW(48)
	RJMP _0x2080003
; 0000 0025             }
; 0000 0026         }
_0xB:
; 0000 0027         if ((PINC & 0x20) == 0) {
_0xA:
	SBIC 0x13,5
	RJMP _0xF
; 0000 0028             delay_ms(20);
	CALL SUBOPT_0x0
; 0000 0029             if ((PINC & 0x20) == 0) {
	SBIC 0x13,5
	RJMP _0x10
; 0000 002A                 key = keypad[r][1];
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _keypad,2
	LD   R18,Z
	LDD  R19,Z+1
; 0000 002B                 while ((PINC & 0x20) == 0) delay_ms(10);
_0x11:
	SBIC 0x13,5
	RJMP _0x13
	CALL SUBOPT_0x1
	RJMP _0x11
_0x13:
; 0000 002C return (char)('0' + key);
	MOV  R30,R18
	SUBI R30,-LOW(48)
	RJMP _0x2080003
; 0000 002D             }
; 0000 002E         }
_0x10:
; 0000 002F         if ((PINE & 0x01) == 0) {
_0xF:
	SBIC 0x1,0
	RJMP _0x14
; 0000 0030             delay_ms(20);
	CALL SUBOPT_0x0
; 0000 0031             if ((PINE & 0x01) == 0) {
	SBIC 0x1,0
	RJMP _0x15
; 0000 0032                 key = keypad[r][2];
	LDI  R26,LOW(6)
	MUL  R17,R26
	MOVW R30,R0
	__ADDW1MN _keypad,4
	LD   R18,Z
	LDD  R19,Z+1
; 0000 0033                 while ((PINE & 0x01) == 0) delay_ms(10);
_0x16:
	SBIC 0x1,0
	RJMP _0x18
	CALL SUBOPT_0x1
	RJMP _0x16
_0x18:
; 0000 0034 return (char)('0' + key);
	MOV  R30,R18
	SUBI R30,-LOW(48)
	RJMP _0x2080003
; 0000 0035             }
; 0000 0036         }
_0x15:
; 0000 0037     }
_0x14:
	SUBI R17,-1
	RJMP _0x5
_0x6:
; 0000 0038     return 0;
	LDI  R30,LOW(0)
_0x2080003:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; 0000 0039 }
; .FEND
;
;// T?i m?t kh?u t? EEPROM, n?u chua có thì n?p "888"
;void load_pass(void) {
; 0000 003C void load_pass(void) {
_load_pass:
; .FSTART _load_pass
; 0000 003D     unsigned char i;
; 0000 003E     for (i = 0; i < 5; i++) CURRENT_PASS[i] = EE_PASS[i];
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x1A:
	CPI  R17,5
	BRSH _0x1B
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_CURRENT_PASS)
	SBCI R31,HIGH(-_CURRENT_PASS)
	MOVW R0,R30
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_EE_PASS)
	SBCI R27,HIGH(-_EE_PASS)
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
	SUBI R17,-1
	RJMP _0x1A
_0x1B:
; 0000 0041 if (CURRENT_PASS[0] < '0' || CURRENT_PASS[0] > '9') {
	LDS  R26,_CURRENT_PASS
	CPI  R26,LOW(0x30)
	BRLO _0x1D
	CPI  R26,LOW(0x3A)
	BRLO _0x1C
_0x1D:
; 0000 0042         strcpy(CURRENT_PASS, "888");
	LDI  R30,LOW(_CURRENT_PASS)
	LDI  R31,HIGH(_CURRENT_PASS)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x1F,0
	CALL _strcpy
; 0000 0043         for (i = 0; i < 4; i++) EE_PASS[i] = CURRENT_PASS[i];
	LDI  R17,LOW(0)
_0x21:
	CPI  R17,4
	BRSH _0x22
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_EE_PASS)
	SBCI R27,HIGH(-_EE_PASS)
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_CURRENT_PASS)
	SBCI R31,HIGH(-_CURRENT_PASS)
	LD   R30,Z
	CALL __EEPROMWRB
	SUBI R17,-1
	RJMP _0x21
_0x22:
; 0000 0044 }
; 0000 0045 }
_0x1C:
	LD   R17,Y+
	RET
; .FEND

	.DSEG
_0x1F:
	.BYTE 0x4
;
;// Luu m?t kh?u m?i vào EEPROM
;void save_pass(char *new_pass) {
; 0000 0048 void save_pass(char *new_pass) {

	.CSEG
_save_pass:
; .FSTART _save_pass
; 0000 0049     unsigned char i;
; 0000 004A     strcpy(CURRENT_PASS, new_pass);
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*new_pass -> Y+1
;	i -> R17
	LDI  R30,LOW(_CURRENT_PASS)
	LDI  R31,HIGH(_CURRENT_PASS)
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CALL _strcpy
; 0000 004B     for (i = 0; i < 5; i++) {
	LDI  R17,LOW(0)
_0x24:
	CPI  R17,5
	BRSH _0x25
; 0000 004C         EE_PASS[i] = new_pass[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_EE_PASS)
	SBCI R31,HIGH(-_EE_PASS)
	MOVW R0,R30
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	MOVW R26,R0
	CALL __EEPROMWRB
; 0000 004D     }
	SUBI R17,-1
	RJMP _0x24
_0x25:
; 0000 004E }
	RJMP _0x2080002
; .FEND
;
;// Hàm nh?p chu?i m?t kh?u v?i hi?u ?ng che d?u *
;// Ðã s?a: flash char *title
;void input_password(char *out_buf, char max_len, flash char *title) {
; 0000 0052 void input_password(char *out_buf, char max_len, flash char *title) {
_input_password:
; .FSTART _input_password
; 0000 0053     char idx = 0;
; 0000 0054     char d;
; 0000 0055     char disp[16] = "";
; 0000 0056 
; 0000 0057     lcd_clear();
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,16
	LDI  R24,16
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x26*2)
	LDI  R31,HIGH(_0x26*2)
	CALL __INITLOCB
	ST   -Y,R17
	ST   -Y,R16
;	*out_buf -> Y+21
;	max_len -> Y+20
;	*title -> Y+18
;	idx -> R17
;	d -> R16
;	disp -> Y+2
	LDI  R17,0
	RCALL _lcd_clear
; 0000 0058     lcd_gotoxy(0, 0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 0059     lcd_putsf(title);
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	RCALL _lcd_putsf
; 0000 005A 
; 0000 005B     while (idx < max_len) {
_0x27:
	LDD  R30,Y+20
	CP   R17,R30
	BRSH _0x29
; 0000 005C         d = scan_digit();
	RCALL _scan_digit
	MOV  R16,R30
; 0000 005D         if (d) {
	CPI  R16,0
	BREQ _0x2A
; 0000 005E             out_buf[idx] = d;
	MOV  R30,R17
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R16
; 0000 005F 
; 0000 0060             // Hi?n th? ký t? th?c trong 800ms
; 0000 0061             disp[idx] = d;
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R16
; 0000 0062             lcd_gotoxy(0, 1);
	CALL SUBOPT_0x2
; 0000 0063             lcd_puts(disp);
; 0000 0064             delay_ms(800);
	LDI  R26,LOW(800)
	LDI  R27,HIGH(800)
	CALL _delay_ms
; 0000 0065 
; 0000 0066             // Chuy?n thành d?u *
; 0000 0067             disp[idx] = '*';
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(42)
	ST   X,R30
; 0000 0068             lcd_gotoxy(0, 1);
	CALL SUBOPT_0x2
; 0000 0069             lcd_puts(disp);
; 0000 006A 
; 0000 006B             idx++;
	SUBI R17,-1
; 0000 006C         }
; 0000 006D     }
_0x2A:
	RJMP _0x27
_0x29:
; 0000 006E     out_buf[idx] = '\0';
	LDD  R26,Y+21
	LDD  R27,Y+21+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	ST   X,R30
; 0000 006F }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,23
	RET
; .FEND
;
;// Quy trình d?i m?t kh?u
;void change_password_flow(void) {
; 0000 0072 void change_password_flow(void) {
_change_password_flow:
; .FSTART _change_password_flow
; 0000 0073     char pass1[5], pass2[5];
; 0000 0074 
; 0000 0075     while (1) {
	SBIW R28,10
;	pass1 -> Y+5
;	pass2 -> Y+0
_0x2B:
; 0000 0076         input_password(pass1, 3, "NHAP MK MOI:");
	MOVW R30,R28
	ADIW R30,5
	CALL SUBOPT_0x3
	__POINTW2FN _0x0,4
	RCALL _input_password
; 0000 0077         input_password(pass2, 3, "XAC NHAN MK MOI:");
	MOVW R30,R28
	CALL SUBOPT_0x3
	__POINTW2FN _0x0,17
	RCALL _input_password
; 0000 0078 
; 0000 0079         if (strcmp(pass1, pass2) == 0) {
	MOVW R30,R28
	ADIW R30,5
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	CALL _strcmp
	CPI  R30,0
	BRNE _0x2E
; 0000 007A             save_pass(pass1);
	MOVW R26,R28
	ADIW R26,5
	RCALL _save_pass
; 0000 007B             lcd_clear();
	RCALL _lcd_clear
; 0000 007C             lcd_putsf("THANH CONG!");
	__POINTW2FN _0x0,34
	CALL SUBOPT_0x4
; 0000 007D             lcd_gotoxy(0, 1);
; 0000 007E             lcd_putsf("DA LUU EEPROM");
	__POINTW2FN _0x0,46
	CALL SUBOPT_0x5
; 0000 007F             delay_ms(1500);
; 0000 0080             break;
	RJMP _0x2D
; 0000 0081         } else {
_0x2E:
; 0000 0082             lcd_clear();
	RCALL _lcd_clear
; 0000 0083             lcd_putsf("MK KHONG KHOP!");
	__POINTW2FN _0x0,60
	CALL SUBOPT_0x4
; 0000 0084             lcd_gotoxy(0, 1);
; 0000 0085             lcd_putsf("NHAP LAI TU DAU");
	__POINTW2FN _0x0,75
	CALL SUBOPT_0x5
; 0000 0086             delay_ms(1500);
; 0000 0087         }
; 0000 0088     }
	RJMP _0x2B
_0x2D:
; 0000 0089 }
	ADIW R28,10
	RET
; .FEND
;
;void main(void) {
; 0000 008B void main(void) {
_main:
; .FSTART _main
; 0000 008C     char entered_pass[5];
; 0000 008D     char choice;
; 0000 008E 
; 0000 008F     lcd_init(16);
	SBIW R28,5
;	entered_pass -> Y+0
;	choice -> R17
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0090     DDRC = 0x4F;  PORTC = 0x70;
	LDI  R30,LOW(79)
	OUT  0x14,R30
	LDI  R30,LOW(112)
	OUT  0x15,R30
; 0000 0091     DDRE = 0x02;  PORTE = 0x03;
	LDI  R30,LOW(2)
	OUT  0x2,R30
	LDI  R30,LOW(3)
	OUT  0x3,R30
; 0000 0092     DDRD = 0x81;  PORTD = 0x81;
	LDI  R30,LOW(129)
	OUT  0x11,R30
	OUT  0x12,R30
; 0000 0093     LCD_BL = 1;
	SBI  0x12,7
; 0000 0094 
; 0000 0095     load_pass();
	RCALL _load_pass
; 0000 0096 
; 0000 0097     while (1) {
_0x32:
; 0000 0098         input_password(entered_pass, 3, "NHAP MAT KHAU:");
	MOVW R30,R28
	CALL SUBOPT_0x3
	__POINTW2FN _0x0,91
	RCALL _input_password
; 0000 0099 
; 0000 009A         if (strcmp(entered_pass, CURRENT_PASS) == 0) {
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_CURRENT_PASS)
	LDI  R27,HIGH(_CURRENT_PASS)
	CALL _strcmp
	CPI  R30,0
	BRNE _0x35
; 0000 009B             lcd_clear();
	RCALL _lcd_clear
; 0000 009C             lcd_putsf("DANG NHAP OK!");
	__POINTW2FN _0x0,106
	RCALL _lcd_putsf
; 0000 009D             delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 009E 
; 0000 009F             // Menu l?a ch?n
; 0000 00A0             lcd_clear();
	RCALL _lcd_clear
; 0000 00A1             lcd_putsf("1:DUNG MK CU");
	__POINTW2FN _0x0,120
	CALL SUBOPT_0x4
; 0000 00A2             lcd_gotoxy(0, 1);
; 0000 00A3             lcd_putsf("2:DOI MK MOI");
	__POINTW2FN _0x0,133
	RCALL _lcd_putsf
; 0000 00A4 
; 0000 00A5             choice = 0;
	LDI  R17,LOW(0)
; 0000 00A6             while (choice != '1' && choice != '2') {
_0x36:
	CPI  R17,49
	BREQ _0x39
	CPI  R17,50
	BRNE _0x3A
_0x39:
	RJMP _0x38
_0x3A:
; 0000 00A7                 choice = scan_digit();
	RCALL _scan_digit
	MOV  R17,R30
; 0000 00A8             }
	RJMP _0x36
_0x38:
; 0000 00A9 
; 0000 00AA             if (choice == '2') {
	CPI  R17,50
	BRNE _0x3B
; 0000 00AB                 change_password_flow();
	RCALL _change_password_flow
; 0000 00AC             } else {
	RJMP _0x3C
_0x3B:
; 0000 00AD                 lcd_clear();
	RCALL _lcd_clear
; 0000 00AE                 lcd_putsf("TIEP TUC SU DUNG");
	__POINTW2FN _0x0,146
	CALL SUBOPT_0x5
; 0000 00AF                 delay_ms(1500);
; 0000 00B0             }
_0x3C:
; 0000 00B1         } else {
	RJMP _0x3D
_0x35:
; 0000 00B2             lcd_clear();
	RCALL _lcd_clear
; 0000 00B3             lcd_putsf("SAI MAT KHAU!");
	__POINTW2FN _0x0,163
	CALL SUBOPT_0x5
; 0000 00B4             delay_ms(1500);
; 0000 00B5         }
_0x3D:
; 0000 00B6     }
	RJMP _0x32
; 0000 00B7 }
_0x3E:
	RJMP _0x3E
; .FEND
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

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x1B,3
	RJMP _0x2000005
_0x2000004:
	CBI  0x1B,3
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x1B,4
	RJMP _0x2000007
_0x2000006:
	CBI  0x1B,4
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x1B,5
	RJMP _0x2000009
_0x2000008:
	CBI  0x1B,5
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x1B,6
	RJMP _0x200000B
_0x200000A:
	CBI  0x1B,6
_0x200000B:
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2080001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	CALL SUBOPT_0x6
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x6
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	CP   R5,R7
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x2080001
_0x2000013:
_0x2000010:
	INC  R5
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2080001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
	RJMP _0x2080002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000019
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000017
_0x2000019:
_0x2080002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	SBI  0x1A,3
	SBI  0x1A,4
	SBI  0x1A,5
	SBI  0x1A,6
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	CALL SUBOPT_0x0
	CALL SUBOPT_0x7
	CALL SUBOPT_0x7
	CALL SUBOPT_0x7
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	ADIW R28,1
	RET
; .FEND
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
_strcmp:
; .FSTART _strcmp
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
; .FEND
_strcpy:
; .FSTART _strcpy
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
; .FEND

	.CSEG

	.DSEG
_keypad:
	.BYTE 0x12

	.ESEG
_EE_PASS:
	.BYTE 0x5

	.DSEG
_CURRENT_PASS:
	.BYTE 0x5
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(20)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(10)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	MOVW R26,R28
	ADIW R26,2
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	CALL _lcd_putsf
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	CALL _lcd_putsf
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

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

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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
