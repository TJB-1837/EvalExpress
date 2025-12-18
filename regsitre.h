; systeme register

SYSCTL         equ   0x400FE000  ; System Control base address
SYSCTL_RCGC0   equ   0x400FE100
SYSCTL_RCGC1   equ   0x400FE104	 
SYSCTL_RCGC2   equ   0x400FE108 
;;;SYSCTL_RCC     equ   0x400FE060  ;TRES DANGEREUX!!!
SRCR1          equ   0x44     ; Software Reset Control 1 p303
SRCR2          equ   0x44     ; Software Reset Control 2 p306


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GPIO Register MAP page 413-414 du lm3s9b92.pdf
; les adresses :
;
GPIO_PORTA_BASE		EQU	0x40004000  
GPIO_PORTB_BASE		EQU	0x40005000
GPIO_PORTC_BASE		EQU	0x40006000
GPIO_PORTD_BASE		EQU	0x40007000	
GPIO_PORTE_BASE		EQU	0x40024000
GPIO_PORTF_BASE		EQU	0x40025000	
GPIO_PORTG_BASE		EQU	0x40026000
GPIO_PORTH_BASE		EQU   0x40027000
GPIO_PORTJ_BASE		EQU	0x4003D000  

GPIODATA    equ   0x000 ; GPIO Data       p416
GPIODIR     equ   0x400 ; GPIO Direction  p417 

GPIOIS      equ   0x404 ; GPIO Interrupt Sense        p418
GPIOIBE     equ   0x408 ; GPIO Interrupt Both Edges   p419
GPIOIEV     equ   0x40C ; GPIO Interrupt Event        p420

GPIOIM      equ	0x410   ; R/W 0x0000.0000 GPIO Interrupt Mask           p421
GPIORIS     equ 0x414   ; RO  0x0000.0000 GPIO Raw Interrupt Status     p422
GPIOMIS     equ 0x418   ; RO  0x0000.0000 GPIO Masked Interrupt Status  p423
GPIOICR     equ 0x41C   ; W1C 0x0000.0000 GPIO Interrupt Clear          p425

GPIOAFSEL   equ 0x420   ; R/W - GPIO Alternate Function Select          p426

GPIODR2R    equ 0x500   ; R/W 0x0000.00FF GPIO 2-mA Drive Select        p428
GPIODR4R    equ 0x504   ; R/W 0x0000.0000 GPIO 4-mA Drive Select        p429
GPIODR8R    equ 0x508   ; R/W 0x0000.0000 GPIO 8-mA Drive Select        p430

GPIOODR     equ 0x50C   ; R/W 0x0000.0000 GPIO Open Drain Select        p431
GPIOPUR     equ 0x510   ; R/W - GPIO Pull-Up Select                     p432
GPIOPDR     equ 0x514   ; R/W 0x0000.0000 GPIO Pull-Down Select         p434
GPIOSLR     equ 0x518   ; R/W 0x0000.0000 GPIO Slew Rate Control Select p436

GPIODEN     equ 0x51C   ; R/W - GPIO Digital E nable                     p437

GPIOLOCK    equ 0x520   ; R/W 0x0000.0001 GPIO Lock                     p439
GPIOCR      equ 0x524   ; - - GPIO Commit                               p440
GPIOAMSEL   equ 0x528   ; R/W 0x0000.0000 GPIO Analog Mode Select       p442
GPIOPCTL    equ 0x52C   ; R/W - GPIO Port Control                       p444

GPIOPeriphID4 equ  0xFD0  ; RO 0x0000.0000 GPIO Peripheral Identification 4 p446
GPIOPeriphID5 equ  0xFD4  ; RO 0x0000.0000 GPIO Peripheral Identification 5 p447
GPIOPeriphID6 equ  0xFD8  ; RO 0x0000.0000 GPIO Peripheral Identification 6 p448
GPIOPeriphID7 equ  0xFDC  ; RO 0x0000.0000 GPIO Peripheral Identification 7 p449
GPIOPeriphID0 equ  0xFE0  ; RO 0x0000.0061 GPIO Peripheral Identification 0 p450
GPIOPeriphID1 equ  0xFE4  ; RO 0x0000.0000 GPIO Peripheral Identification 1 p451
GPIOPeriphID2 equ  0xFE8  ; RO 0x0000.0018 GPIO Peripheral Identification 2 p452
GPIOPeriphID3 equ  0xFEC  ; RO 0x0000.0001 GPIO Peripheral Identification 3 p453

GPIOPCellID0 equ  0xFF0   ; RO 0x0000.000D GPIO PrimeCell Identification 0 p454
GPIOPCellID1 equ  0xFF4   ; RO 0x0000.00F0 GPIO PrimeCell Identification 1 p455
GPIOPCellID2 equ  0xFF8   ; RO 0x0000.0005 GPIO PrimeCell Identification 2 p456
GPIOPCellID3 equ  0xFFC   ; RO 0x0000.00B1 GPIO PrimeCell Identification 3 p457

PORT0	EQU	0x01	;  
PORT1	EQU	0x02	;
PORT2	EQU	0x04	;
PORT3	EQU	0x08	;
PORT4	EQU	0x10	;
PORT5	EQU	0x20	;
PORT6	EQU	0x40	;
PORT7	EQU	0x80	;

BIT0	EQU	0x01	;  
BIT1	EQU	0x02	;
BIT2	EQU	0x04	;
BIT3	EQU	0x08	;
BIT4	EQU	0x10	;
BIT5	EQU	0x20	;
BIT6	EQU	0x40	;
BIT7	EQU	0x80	;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; les constantes de durée 
; calculés apres mesure sur l'oscillo
;
D1s      equ   0x002FFFFF  ; en réalité 1.2s	
D5ms     equ   26600
D2ms     equ   10640
D150us   equ   800
D75us    equ   400
D50us    equ   266
D15us    equ   80
D10us    equ   53
D500ns   equ   3           ; en réalité 563ns
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UART_0
;
UART_0_BASE	  	   EQU  0x4000C000
UART_0_DR    	   EQU  (UART_0_BASE +0x0)
UART_0_RSR    	   EQU  (UART_0_BASE +0x4)
UART_0_ECR    	   EQU  (UART_0_BASE +0x4)
UART_0_FR     	   EQU  (UART_0_BASE +0x18)
UART_0_IBRD    	   EQU  (UART_0_BASE +0x24)
UART_0_FBRD    	   EQU  (UART_0_BASE +0x28)
UART_0_LCRH        EQU  (UART_0_BASE +0x2C)
UART_0_CTL         EQU  (UART_0_BASE +0x30)

GPIO_A_GPIOAFSEL   EQU   (GPIO_PORTA_BASE + 0x420)
GPIO_A_GPIODEN     EQU   (GPIO_PORTA_BASE + 0x51C)
;;;;;;;;;;;;;;;;;;;
; NVIC Register MAP pages 136-149 du lm3s9b92.pdf
;

NVIC_BASE   equ   0xe000e000  ; adresse de base du NVIC

EN0         equ   0x100    ; Interrupt 0-31 Set Enable   p137
EN1         equ   0x104    ; Interrupt 32-54 Set Enable  p138

DIS0        equ   0x180    ; Interrupt 0-31 Clear Enable   p139
DIS1        equ   0x184    ; Interrupt 32-54 Clear Enable  p140

PEND0       equ   0x200    ; Interrupt 0-31 Set Pending   p141
PEND1       equ   0x204    ; Interrupt 32-54 Set Pending  p142

UNPEND0     equ   0x280    ; Interrupt 0-31 Clear Pending   p143
UNPEND1     equ   0x284    ; Interrupt 32-54 Clear Pending  p144

ACTIV0      equ   0x300    ; Interrupt 0-31 Active Bit   p145
ACTIV1      equ   0x304    ; Interrupt 32-54 Active Bit  p146

PRI0        equ   0x400    ; Interrupt 0-3 Priority  p147
PRI1        equ   0x404    ; Interrupt 4-7 Priority  p147
PRI2        equ   0x408    ; ...
PRI3        equ   0x40C
PRI4        equ   0x410
PRI5        equ   0x414
PRI6        equ   0x418
PRI7        equ   0x41C
PRI8        equ   0x420
PRI9        equ   0x424
PRI10       equ   0x428
PRI11       equ   0x42C
PRI12       equ   0x430
PRI13       equ   0x434

SWTRIG      equ   0xf00    ; Software Trigger Interrupt  p149

SCB         equ   0x008    ; Auxiliary Control p150
INCTRL      equ   0xD04    ; Interrupt Control and State  p153
STRELOAD		equ	0x014	   ; SysTick Reload Value Register  p134
STCTRL		equ	0x010    ; SysTick Control and Status Register  p132
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Timers register MAP p546 du lm3s9b92.pdf
;
TIMER0   equ   0x40030000
TIMER1   equ   0x40031000
TIMER2   equ   0x40032000
TIMER3   equ   0x40033000

GPTMCFG        equ   0x000 ; R/W 0x0000.0000 GPTM Configuration            p548

GPTMTAMR       equ   0x004 ; R/W 0x0000.0000 GPTM Timer A Mode             p549
GPTMTBMR       equ   0x008 ; R/W 0x0000.0000 GPTM Timer B Mode             p551

GPTMCTL        equ   0x00C ; R/W 0x0000.0000 GPTM Control                  p553
GPTMIMR        equ   0x018 ; R/W 0x0000.0000 GPTM Interrupt Mask           p556
GPTMRIS        equ   0x01C ; RO  0x0000.0000 GPTM Raw Interrupt Status     p558
GPTMMIS        equ   0x020 ; RO  0x0000.0000 GPTM Masked Interrupt Status  p561
GPTMICR        equ   0x024 ; W1C 0x0000.0000 GPTM Interrupt Clear          p564

GPTMTAILR      equ   0x028 ; R/W 0xFFFF.FFFF GPTM Timer A Interval Load    p566
GPTMTBILR      equ   0x02C ; R/W 0x0000.FFFF GPTM Timer B Interval Load    p567

GPTMTAMATCHR   equ   0x030 ; R/W 0xFFFF.FFFF GPTM Timer A Match            p568
GPTMTBMATCHR   equ   0x034 ; R/W 0x0000.FFFF GPTM Timer B Match            p569

GPTMTAPR       equ   0x038 ; R/W 0x0000.0000 GPTM Timer A Prescale         p570
GPTMTBPR       equ   0x03C ; R/W 0x0000.0000 GPTM Timer B Prescale         p571

GPTMTAPMR      equ   0x040 ; R/W 0x0000.0000 GPTM TimerA Prescale Match    p572
GPTMTBPMR      equ   0x044 ; R/W 0x0000.0000 GPTM TimerB Prescale Match    p573

GPTMTAR        equ   0x048 ; RO 0xFFFF.FFFF GPTM Timer A                   p574
GPTMTBR        equ   0x04C ; RO 0x0000.FFFF GPTM Timer B                   p575

GPTMTAV        equ   0x050 ; RW 0xFFFF.FFFF GPTM Timer A Value             p576
GPTMTBV        equ   0x054 ; RW 0x0000.FFFF GPTM Timer B Value             p577
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PWM Register MAP pages 136-149 du lm3s9b92.pdf
;


PWM0_BASE	equ	0x40028000
PWMCTL		equ	0x000	 ; R/W 0x0000.0000 PWM Master Control 1143
PWMSYNC 	equ 0x004	 ; R/W 0x0000.0000 PWM Time Base Sync 1145
PWMENABLE	equ	0x008	  ;R/W 0x0000.0000 PWM Output Enable 
PWMINVERT	equ	0x00C  	 ;R/W 0x0000.0000 PWM Output Inversion 1148
PWMFAULT 	equ	0x010	 ;R/W 0x0000.0000 PWM Output Fault 1150
PWMINTEN	equ	0x014  	; R/W 0x0000.0000 PWM Interrupt Enable 1152
PWMRIS	 	equ	0x018	;RO 0x0000.0000 PWM Raw Interrupt Status 1154
PWMISC		equ	0x01C	; R/W1C 0x0000.0000 PWM Interrupt Status and Clear 1157
PWMSTATUS	equ	0x020	; RO 0x0000.0000 PWM Status 1160
PWMFAULTVAL	equ	0x024	; R/W 0x0000.0000 PWM Fault Condition Value 1162
PWMENUPD 	equ	0x028	;R/W 0x0000.0000 PWM Enable Update 1164
PWM0CTL	equ	0x040	; R/W 0x0000.0000 PWM0 Control 1168
PWM0INTEN	equ	0x044	; R/W 0x0000.0000 PWM0 Interrupt and Trigger Enable 1173
PWM0RIS	equ	0x048	; RO 0x0000.0000 PWM0 Raw Interrupt Status 1176
PWM0ISC	equ	0x04C	; R/W1C 0x0000.0000 PWM0 Interrupt Status and Clear 1178
PWM0LOAD 	equ	0x050	;R/W 0x0000.0000 PWM0 Load 1180
PWM0COUNT	equ	0x054	; RO 0x0000.0000 PWM0 Counter 1181
PWM0CMPA	equ	0x058	; R/W 0x0000.0000 PWM0 Compare A 1182
PWM0CMPB	equ	0x05C	; R/W 0x0000.0000 PWM0 Compare B 1183
PWM0GENA	equ	0x060	; R/W 0x0000.0000 PWM0 Generator A Control 1184
PWM0GENB 	equ	0x064	;R/W 0x0000.0000 PWM0 Generator B Control 1187
PWM0DBCTL	equ	0x068	; R/W 0x0000.0000 PWM0 Dead-Band Control 1190
PWM0DBRISE	equ	0x06C	; R/W 0x0000.0000 PWM0 Dead-Band Rising-Edge Delay 1191
PWM0DBFALL	equ	0x070	; R/W 0x0000.0000 PWM0 Dead-Band Falling-Edge-Delay 1192
PWM0FLTSRC0	equ	0x074	; R/W 0x0000.0000 PWM0 Fault Source 0 1193
PWM0FLTSRC1	equ	0x078	; R/W 0x0000.0000 PWM0 Fault Source 1 1195
PWM0MINFLTPER equ	 0x07C	; R/W 0x0000.0000 PWM0 Minimum Fault Period 1198
PWM1CTL	equ	0x080	; R/W 0x0000.0000 PWM1 Control 1168
PWM1INTEN	equ	0x084	; R/W 0x0000.0000 PWM1 Interrupt and Trigger Enable 1173
PWM1RIS	equ	0x088	; RO 0x0000.0000 PWM1 Raw Interrupt Status 1176
PWM1ISC	equ	0x08C	; R/W1C 0x0000.0000 PWM1 Interrupt Status and Clear 1178
PWM1LOAD	equ	0x090	; R/W 0x0000.0000 PWM1 Load 1180
PWM1COUNT	equ	0x094	; RO 0x0000.0000 PWM1 Counter 1181
PWM1CMPA 	equ	0x098	;R/W 0x0000.0000 PWM1 Compare A 1182
PWM1CMPB 	equ	0x09C 	;R/W 0x0000.0000 PWM1 Compare B 1183
PWM1GENA	equ	0x0A0	; R/W 0x0000.0000 PWM1 Generator A Control 1184
PWM1GENB	equ	0x0A4	; R/W 0x0000.0000 PWM1 Generator B Control 1187
PWM1DBCTL	equ	0x0A8	; R/W 0x0000.0000 PWM1 Dead-Band Control 1190
PWM1DBRISE	equ	0x0AC	; R/W 0x0000.0000 PWM1 Dead-Band Rising-Edge Delay 1191
PWM1DBFALL	equ	0x0B0	; R/W 0x0000.0000 PWM1 Dead-Band Falling-Edge-Delay 1192
PWM1FLTSRC0	equ	0x0B4	;R/W 0x0000.0000 PWM1 Fault Source 0 1193
PWM1FLTSRC1	equ	0x0B8	; R/W 0x0000.0000 PWM1 Fault Source 1 1195
PWM1MINFLTPER equ	0x0BC	; R/W 0x0000.0000 PWM1 Minimum Fault Period 1198
PWM2CTL 	equ	0x0C0	;R/W 0x0000.0000 PWM2 Control 1168
PWM2INTEN	equ	0x0C4	; R/W 0x0000.0000 PWM2 Interrupt and Trigger Enable 1173
PWM2RIS 	equ	0x0C8	;RO 0x0000.0000 PWM2 Raw Interrupt Status 1176
PWM2ISC 	equ	0x0CC 	;R/W1C 0x0000.0000 PWM2 Interrupt Status and Clear 1178
PWM2LOAD	equ	0x0D0	; R/W 0x0000.0000 PWM2 Load 1180
PWM2COUNT	equ	0x0D4	; RO 0x0000.0000 PWM2 Counter 1181
PWM2CMPA	equ	0x0D8	; R/W 0x0000.0000 PWM2 Compare A 1182
PWM2CMPB 	equ	0x0DC 	;R/W 0x0000.0000 PWM2 Compare B 1183
PWM2GENA	equ	0x0E0	; R/W 0x0000.0000 PWM2 Generator A Control 1184
PWM2GENB	equ	0x0E4	; R/W 0x0000.0000 PWM2 Generator B Control 1187
PWM2DBCTL 	equ	0x0E8 	;R/W 0x0000.0000 PWM2 Dead-Band Control 1190
PWM2DBRISE	equ	0x0EC	; R/W 0x0000.0000 PWM2 Dead-Band Rising-Edge Delay 1191
PWM2DBFALL	equ	0x0F0	; R/W 0x0000.0000 PWM2 Dead-Band Falling-Edge-Delay 1192
PWM2FLTSRC0	equ	0x0F4	; R/W 0x0000.0000 PWM2 Fault Source 0 1193
PWM2FLTSRC1	equ	0x0F8	; R/W 0x0000.0000 PWM2 Fault Source 1 1195
PWM2MINFLTPER equ	0x0FC	; R/W 0x0000.0000 PWM2 Minimum Fault Period 1198
PWM3CTL 	equ	0x100	;R/W 0x0000.0000 PWM3 Control 1168
PWM3INTEN 	equ	0x104	;R/W 0x0000.0000 PWM3 Interrupt and Trigger Enable 1173
PWM3RIS	equ	0x108	; RO 0x0000.0000 PWM3 Raw Interrupt Status 1176
PWM3ISC 	equ	0x10C	; R/W1C 0x0000.0000 PWM3 Interrupt Status and Clear 1178
PWM3LOAD 	equ	0x110	;R/W 0x0000.0000 PWM3 Load 1180
PWM3COUNT	equ	0x114	; RO 0x0000.0000 PWM3 Counter 1181
PWM3CMPA	equ	0x118	; R/W 0x0000.0000 PWM3 Compare A 1182
PWM3CMPB	equ	0x11C	; R/W 0x0000.0000 PWM3 Compare B 1183
PWM3GENA 	equ	0x120	;R/W 0x0000.0000 PWM3 Generator A Control 1184
PWM3GENB	equ	0x124	; R/W 0x0000.0000 PWM3 Generator B Control 1187
PWM3DBCTL 	equ	0x128	;R/W 0x0000.0000 PWM3 Dead-Band Control 1190
PWM3DBRISE	equ	0x12C 	;R/W 0x0000.0000 PWM3 Dead-Band Rising-Edge Delay 1191
PWM3DBFALL	equ	0x130	;R/W 0x0000.0000 PWM3 Dead-Band Falling-Edge-Delay 1192
PWM3FLTSRC0	equ	0x134	; R/W 0x0000.0000 PWM3 Fault Source 0 1193
PWM3FLTSRC1	equ	0x138	; R/W 0x0000.0000 PWM3 Fault Source 1 1195
PWM3MINFLTPER equ	0x13C	; R/W 0x0000.0000 PWM3 Minimum Fault Period 1198
PWM0FLTSEN 	equ	0x800	;R/W 0x0000.0000 PWM0 Fault Pin Logic Sense 1199
PWM0FLTSTAT0	equ	0x804	; - 0x0000.0000 PWM0 Fault Status 0 1200
PWM0FLTSTAT1	equ	0x808	; - 0x0000.0000 PWM0 Fault Status 1 1202
PWM1FLTSEN 	equ	0x880	;R/W 0x0000.0000 PWM1 Fault Pin Logic Sense 1199
PWM1FLTSTAT0 	equ	0x884	;- 0x0000.0000 PWM1 Fault Status 0 1200
PWM1FLTSTAT1	equ	0x888	; - 0x0000.0000 PWM1 Fault Status 1 1202
PWM2FLTSEN	equ	0x900	; R/W 0x0000.0000 PWM2 Fault Pin Logic Sense 1199
PWM2FLTSTAT0	equ	0x904	; - 0x0000.0000 PWM2 Fault Status 0 1200
PWM2FLTSTAT1	equ	0x908	; - 0x0000.0000 PWM2 Fault Status 1 1202
PWM3FLTSEN 	equ	0x980	;R/W 0x0000.0000 PWM3 Fault Pin Logic Sense 1199
PWM3FLTSTAT0	equ	0x984	; - 0x0000.0000 PWM3 Fault Status 0 1200
PWM3FLTSTAT1	equ	0x988	; - 0x0000.0000 PWM3 Fault Status 1 1202	


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

		;ADC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ADC0	equ	 0x40038000
ADC1	equ	0x40039000

ADCACTSS	equ	 0x000   	 ;R/W 0x0000.0000 ADC Active Sample Sequencer 627
ADCRIS		equ	0x004 	; RO 0x0000.0000 ADC Raw Interrupt Status 628
ADCIM 	 	equ	0x008 	;R/W 0x0000.0000 ADC Interrupt Mask 630
ADCISC		equ 	0x00C 	;R/W1C 0x0000.0000 ADC Interrupt Status and Clear 632
ADCOSTAT 	equ	0x010	;R/W1C 0x0000.0000 ADC Overflow Status 635
ADCEMUX	equ	0x014	; R/W 0x0000.0000 ADC Event Multiplexer Select 637
ADCUSTAT	equ	0x018 	 ;R/W1C 0x0000.0000 ADC Underflow Status 642
ADCSSPRI 	equ	0x020 	;R/W 0x0000.3210 ADC Sample Sequencer Priority 643
ADCSPC		equ	0x024 	 ;R/W 0x0000.0000 ADC Sample Phase Control 645
ADCPSSI 		equ	0x028	;R/W - ADC Processor Sample Sequence Initiate 647
ADCSAC		equ	0x030  	;R/W 0x0000.0000 ADC Sample Averaging Control 649
ADCDCISC	equ	0x034 	;R/W1C 0x0000.0000 ADC Digital Comparator Interrupt Status and Clear 650
ADCCTL		equ	0x038  	;R/W 0x0000.0000 ADC Control 652
ADCSSMUX	equ	0x040 	; R/W 0x0000.0000 ADC Sample Sequence Input Multiplexer Select 0 653
ADCSSCTL0	equ	0x044 	; R/W 0x0000.0000 ADC Sample Sequence Control 0 655
ADCSSFIFO0	equ	0x048  	;RO - ADC Sample Sequence Result FIFO 0 658
ADCSSFSTAT0	 equ	0x04C 	;RO 0x0000.0100 ADC Sample Sequence FIFO 0 Status 659
ADCSSOP0	equ	0x050 	;R/W 0x0000.0000 ADC Sample Sequence 0 Operation 661
ADCSSDC0	equ	0x054 	;R/W 0x0000.0000 ADC Sample Sequence 0 Digital Comparator Select 663
ADCSSMUX1	 equ	0x060	; R/W0x0000.0000 ADC Sample Sequence Input Multiplexer Select 1 665
ADCSSCTL1	equ	0x064 	; R/W 0x0000.0000 ADC Sample Sequence Control 1 666
ADCSSFIFO1	equ	0x068 	; RO - ADC Sample Sequence Result FIFO 1 658
ADCSSFSTAT1	 equ	0x06C 	 ;RO 0x0000.0100 ADC Sample Sequence FIFO 1 Status 659
ADCSSOP1	equ	0x070  	;R/W 0x0000.0000 ADC Sample Sequence 1 Operation 668
ADCSSDC1	equ	0x074 	 ;R/W 0x0000.0000 ADC Sample Sequence 1 Digital Comparator Select 669
ADCSSMUX2	 equ	0x080 	 ;R/W 0x0000.0000 ADC Sample Sequence Input Multiplexer Select 2 665
ADCSSCTL2	equ	0x084 	;R/W 0x0000.0000 ADC Sample Sequence Control 2 666
ADCSSFIFO2	equ	0x088  	;RO - ADC Sample Sequence Result FIFO 2 658
ADCSSFSTAT2 	equ	0x08C  	;RO 0x0000.0100 ADC Sample Sequence FIFO 2 Status 659
ADCSSOP2	equ	0x090  	;R/W 0x0000.0000 ADC Sample Sequence 2 Operation 668
ADCSSDC2 	equ	0x094 	;R/W 0x0000.0000 ADC Sample Sequence 2 Digital Comparator Select 669
ADCSSMUX3	 equ	0x0A0 	;R/W 0x0000.0000 ADC Sample Sequence Input Multiplexer Select 3 671
ADCSSCTL3	equ 	0x0A4 	;R/W 0x0000.0002 ADC Sample Sequence Control 3 672
ADCSSFIFO3	equ	0x0A8 	;RO - ADC Sample Sequence Result FIFO 3 658
ADCSSFSTAT3 	equ	0x0AC   	;RO 0x0000.0100 ADC Sample Sequence FIFO 3 Status 659
ADCSSOP3	equ 	0x0B0 	;R/W 0x0000.0000 ADC Sample Sequence 3 Operation 673
ADCSSDC3 	equ	0x0B4 	;R/W 0x0000.0000 ADC Sample Sequence 3 Digital Comparator Select 674
ADCDCRIC 	equ	0xD00 	;R/W 0x0000.0000 ADC Digital Comparator Reset Initial Conditions 675
ADCDCCTL0	equ	0xE00 	; R/W 0x0000.0000 ADC Digital Comparator Control 0 680
ADCDCCTL1	equ	0xE04 	; R/W 0x0000.0000 ADC Digital Comparator Control 1 680
ADCDCCTL2	equ	0xE08 	; R/W 0x0000.0000 ADC Digital Comparator Control 2 680
ADCDCCTL3	equ	0xE0C  	;R/W 0x0000.0000 ADC Digital Comparator Control 3 680
ADCDCCTL4	equ	0xE10 	; R/W 0x0000.0000 ADC Digital Comparator Control 4 680
ADCDCCTL5	equ	0xE14 	; R/W 0x0000.0000 ADC Digital Comparator Control 5 680
ADCDCCTL6 	equ	0xE18 	;R/W 0x0000.0000 ADC Digital Comparator Control 6 680
ADCDCCTL7	equ	0xE1C  	;R/W 0x0000.0000 ADC Digital Comparator Control 7 680
ADCDCCMP0	equ	0xE40  	;R/W 0x0000.0000 ADC Digital Comparator Range 0 683
ADCDCCMP1	equ	0xE44 	; R/W 0x0000.0000 ADC Digital Comparator Range 1 683
ADCDCCMP2 	equ	0xE48 	;R/W 0x0000.0000 ADC Digital Comparator Range 2 683
ADCDCCMP3	equ	0xE4C 	;R/W 0x0000.0000 ADC Digital Comparator Range 3 683
ADCDCCMP4 	equ	0xE50 	;R/W 0x0000.0000 ADC Digital Comparator Range 4 683
ADCDCCMP5 	equ	0xE54 	;R/W 0x0000.0000 ADC Digital Comparator Range 5 683
ADCDCCMP6	equ	0xE58 	; R/W 0x0000.0000 ADC Digital Comparator Range 6 683
ADCDCCMP7	equ	0xE5C 	; R/W 0x0000.0000 ADC Digital Comparator Range 7 683

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;QEI

QEI0_BASE	equ	0x4002C000
QEI1_BASE	equ	0x4002D000
QEICTL		equ	0x000	; R/W 0x0000.0000 QEI Control 1212
QEISTAT		equ	0x004	; RO 0x0000.0000 QEI Status 1215
QEIPOS 		equ	0x008	;R/W 0x0000.0000 QEI Position 1216
QEIMAXPOS	equ	0x00C	; R/W 0x0000.0000 QEI Maximum Position 1217
QEILOAD  	equ	0x010	;R/W0x0000.0000 QEI Timer Load 1218
QEITIME		equ	0x014	; RO 0x0000.0000 QEI Timer 1219
QEICOUNT 	equ	0x018	;RO 0x0000.0000 QEI Velocity Counter 1220
QEISPEED	equ	0x01C	; RO 0x0000.0000 QEI Velocity 1221
QEIINTEN	equ	0x020	;R/W 0x0000.0000 QEI Interrupt Enable 1222
QEIRIS 		equ	0x024	;RO 0x0000.0000 QEI Raw Interrupt Status 1224
QEIISC 		equ	0x028	;R/W1C 0x0000.0000 QEI Interrupt Status and Clear 1226
						END



					end