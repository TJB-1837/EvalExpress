
	;; RK - Evalbot (Cortex M3 de Texas Instrument)
	;; fait clignoter une seule LED connectée au port GPIOF
   	
		AREA    |.text|, CODE, READONLY
 
; This register controls the clock gating logic in normal Run mode
SYSCTL_PERIPH_GPIO EQU		0x400FE108	; SYSCTL_RCGC2_R (p291 datasheet de lm3s9b92.pdf)

; The GPIODATA register is the data register
GPIO_PORTD_BASE		EQU		0x40007000	; GPIO Port F
GPIO_PORTF_BASE		EQU		0x40025000	; GPIO Port F (APB) base: 0x4002.5000 (p416 datasheet de lm3s9B92.pdf)
GPIO_PORTE_BASE 	EQU 	0x40024000	; GPIO Port E

; configure the corresponding pin to be an output
; all GPIO pins are inputs by default
GPIO_O_DIR   		EQU 	0x00000400  ; GPIO Direction (p417 datasheet de lm3s9B92.pdf)

; The GPIODR2R register is the 2-mA drive control register
; By default, all GPIO pins have 2-mA drive.
GPIO_O_DR2R   		EQU 	0x00000500  ; GPIO 2-mA Drive Select (p428 datasheet de lm3s9B92.pdf)
	
; GPIO_Pur pull up config
GPIO_O_PUR			EQU 	0x00000510

; Digital enable register
; To use the pin as a digital input or output, the corresponding GPIODEN bit must be set.
GPIO_O_DEN   		EQU 	0x0000051C  ; GPIO Digital Enable (p437 datasheet de lm3s9B92.pdf)

; PIN select
PIN0  				EQU		0x01
PIN1				EQU     0x02
PIN2				EQU		0x04
PIN3				EQU 	0x08
PIN4				EQU		0x10		; led1 sur broche 4
PIN5				EQU		0x20
PIN6				EQU		0x40
PIN7				EQU		0x80

; blinking frequency
DUREE   			EQU     0x002FFFFF	; Random Value

	  	ENTRY
		EXPORT	__main
__main	

		; ;; Enable the Port F peripheral clock by setting bit 5 (0x20 == 0b100000)		(p291 datasheet de lm3s9B96.pdf)
		; ;;														 (GPIO::FEDCBA)
		ldr r6, = SYSCTL_PERIPH_GPIO  			;; RCGC2
        mov r0, #0x00000038  					;; Enable clock sur GPIO F et E où sont branchés les leds (0x20 == 0b100000)
		; ;;														 									 (GPIO::FEDCBA)
        str r0, [r6]
		
		
		
		; ;; "There must be a delay of 3 system clocks before any GPIO reg. access  (p413 datasheet de lm3s9B92.pdf)
		nop	   									;; tres tres important....
		nop	   
		nop	   									;; pas necessaire en simu ou en debbug step by step...
	
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^CONFIGURATION LED

        ldr r6, = GPIO_PORTF_BASE+GPIO_O_DIR    ;; 1 Pin du portF en sortie (broche 4 : 00010000)
        ldr r0, = PIN4 + PIN5	
        str r0, [r6]
		
        ldr r6, = GPIO_PORTF_BASE+GPIO_O_DEN	;; Enable Digital Function 
        ldr r0, = PIN4 + PIN5		
        str r0, [r6]
 
		ldr r6, = GPIO_PORTF_BASE+GPIO_O_DR2R	;; Choix de l'intensité de sortie (2mA)
        ldr r0, = PIN4 + PIN5			
        str r0, [r6]

        mov r2, #0x000       					;; pour eteindre LED
     
		; allumer la led broche 4 (PIN4)
		mov r3, #PIN4      					;; Allume portF broche 4 : 00010000
		ldr r6, = GPIO_PORTF_BASE + (PIN4<<2)  ;; @data Register = @base + (mask<<2) ==> LED1
		; allumer la led broche 5 (PIN5)
		mov r4, #PIN5
		ldr r5, = GPIO_PORTF_BASE + (PIN5<<2)

		;vvvvvvvvvvvvvvvvvvvvvvvFin configuration LED 
		
		;^^^^^^^^^^^^^^^^^^^^^^^^Configuration bumpers
		
        ldr r7, = GPIO_PORTD_BASE+GPIO_O_DEN	;; Enable Digital Function 
        ldr r0, = PIN6 + PIN7		
        str r0, [r7]
		
		ldr r7, = GPIO_PORTD_BASE+GPIO_O_PUR
		ldr r0, = PIN6 + PIN7		
        str r0, [r7]
		
		ldr r8, = GPIO_PORTD_BASE+(PIN6<<2) ;Sw1
		ldr r9, = GPIO_PORTD_BASE+(PIN7<<2) ;Sw2
			
		;vvvvvvvvvvvvvvvvvvvvvvvFin configuration bumpers
		
		
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^BUMPER ETEINT LED

loop
		
		;; allume les led 1 et 2 
        str r3, [r6]    						
		str r4, [r5]
		
		ldr r7,=0
		
		
Switch
		ldr r0,[r8]
		ldr r1,[r9]
		cmp r0,#0
		BEQ suite1
		
		cmp r1,#0
		BEQ suite2
		B Switch
		
		
suite1  ;Cas où c'est le bumper droit qui est enfoncé
		str r7,[r6] 
		ldr r0,[r8]
		cmp r0,#0
		BEQ suite1
		b loop

suite2  ;Cas où c'est le bumper gauche qui est enfoncé
		str r7,[r5]
		ldr r1,[r9]
		cmp r1,#0
		BEQ suite2
        b loop       
		
		nop		
        END 