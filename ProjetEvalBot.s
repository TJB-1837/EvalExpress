
	;; RK - Evalbot (Cortex M3 de Texas Instrument)
	;; fait clignoter une seule LED connectée au port GPIOF
   	
		AREA    |.text|, CODE, READONLY
 
; This register controls the clock gating logic in normal Run mode
SYSCTL_PERIPH_GPIO EQU		0x400FE108	; SYSCTL_RCGC2_R (p291 datasheet de lm3s9b92.pdf)

; The GPIODATA register is the data register
GPIO_PORTD_BASE		EQU		0x40007000	; GPIO Port D
GPIO_PORTF_BASE		EQU		0x40025000	; GPIO Port F (APB) base: 0x4002.5000 (p416 datasheet de lm3s9B92.pdf)
GPIO_PORTE_BASE 	EQU 	0x40024000	; GPIO Port E
GPIO_PORTJ_BASE		EQU		0x4003D000  ; Port J

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
DUREE   			EQU     0x000FFFFF	; Random Value
DUREEBLINK   		EQU     0x002FFFFF	; Random Value

	  	ENTRY
		EXPORT	__main
		
		;; The IMPORT command specifies that a symbol is defined in a shared object at runtime.
		IMPORT	MOTEUR_INIT					; initialise les moteurs (configure les pwms + GPIO)
		
		IMPORT	MOTEUR_DROIT_ON				; activer le moteur droit
		IMPORT  MOTEUR_DROIT_OFF			; déactiver le moteur droit
		IMPORT  MOTEUR_DROIT_AVANT			; moteur droit tourne vers l'avant
		IMPORT  MOTEUR_DROIT_ARRIERE		; moteur droit tourne vers l'arrière
		IMPORT  MOTEUR_DROIT_INVERSE		; inverse le sens de rotation du moteur droit
		
		IMPORT	MOTEUR_GAUCHE_ON			; activer le moteur gauche
		IMPORT  MOTEUR_GAUCHE_OFF			; déactiver le moteur gauche
		IMPORT  MOTEUR_GAUCHE_AVANT			; moteur gauche tourne vers l'avant
		IMPORT  MOTEUR_GAUCHE_ARRIERE		; moteur gauche tourne vers l'arrière
		IMPORT  MOTEUR_GAUCHE_INVERSE		; inverse le sens de rotation du moteur gauche
			
			
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
		ldr r11, = GPIO_PORTF_BASE + (PIN4<<2)  ;; @data Register = @base + (mask<<2) ==> LED1
		; allumer la led broche 5 (PIN5)
		mov r4, #PIN5
		ldr r12, = GPIO_PORTF_BASE + (PIN5<<2)

		;vvvvvvvvvvvvvvvvvvvvvvvFin configuration LED 
		
		;^^^^^^^^^^^^^^^^^^^^^^^^Configuration bumpers
		
        ldr r7, = GPIO_PORTE_BASE+GPIO_O_DEN	;; Enable Digital Function 
        ldr r0, = PIN0 + PIN1		
        str r0, [r7]
		
		ldr r7, = GPIO_PORTE_BASE+GPIO_O_PUR
		ldr r0, = PIN0 + PIN1		
        str r0, [r7]
		
		ldr r9, = GPIO_PORTE_BASE+(PIN0<<2) ;BUMPER L
		ldr r10, = GPIO_PORTE_BASE+(PIN1<<2) ;BUMPER R
			
		;vvvvvvvvvvvvvvvvvvvvvvvFin configuration bumpers
		
		
		;^^^^^^^^^^^^^^^^^^^^^^^^Configuration siwtch
		
        ldr r7, = GPIO_PORTD_BASE+GPIO_O_DEN	;; Enable Digital Function 
        ldr r0, = PIN6 + PIN7		
        str r0, [r7]
		
		ldr r7, = GPIO_PORTD_BASE+GPIO_O_PUR
		ldr r0, = PIN6 + PIN7		
        str r0, [r7]
		
		ldr r7, = GPIO_PORTD_BASE+(PIN6<<2) ;Sw1
		ldr r8, = GPIO_PORTD_BASE+(PIN7<<2) ;Sw2
			
		;vvvvvvvvvvvvvvvvvvvvvvvFin configuration siwtch

		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Config moteurs
		
		BL	MOTEUR_INIT
		
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin config moteurs
		
		
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Etat 1 : attente 
attente1
		ldr r0,[r7]
		cmp r0,#0
		BEQ choixItin
		b attente1
		;vvvvvvvvvvvvvvvvvvvvvvvFin Etat 1  
			
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Etat 2 : choixItin 
choixItin
		ldr r0,[r9]
		cmp r0,#0
		BEQ attenteConfItin1
		
		ldr r0,[r10]
		cmp r0,#0
		BEQ attenteConfItin2
		b choixItin
		
attenteConfItin1
		bl allumeLed1
		bl eteintLed2
		ldr r5, = DUREE
		bl wait
		ldr r0,[r10]
		cmp r0,#0
		BEQ attenteConfItin2
		ldr r0,[r8]
		cmp r0,#0
		BEQ itin1
		
		b attenteConfItin1
		
attenteConfItin2
		bl allumeLed2
		bl eteintLed1
		ldr r5, = DUREE
		bl wait
		ldr r0,[r9]
		cmp r0,#0
		BEQ attenteConfItin1
		ldr r0,[r8]
		cmp r0,#0
		BEQ itin2
		
		b attenteConfItin2
		

		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Fin Etat 2 : choix itit
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Etat 3A : itin1
itin1		
		BL	MOTEUR_DROIT_ON
		BL	MOTEUR_GAUCHE_ON
		bl allumeLed1   						
		bl allumeLed2
		ldr r5, = DUREE ;allumage des leds
		bl wait
		

		; Evalbot avance droit devant
		BL	MOTEUR_DROIT_AVANT	   
		BL	MOTEUR_GAUCHE_AVANT
		ldr r2, =3000
		
loopAvant
		ldr r5,=0x0000FFF
		bl wait
		subs r2,#1
		bl detectionBumpers
		cmp r2,#0
		beq suite
		b loopAvant
suite 
		BL	MOTEUR_DROIT_OFF
		BL	MOTEUR_GAUCHE_OFF
		b attenteConf1
			
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 3A : itin1
		
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Etat 3B : itin2
itin2		
		BL	MOTEUR_DROIT_ON
		BL	MOTEUR_GAUCHE_ON
		bl allumeLed1   						
		bl allumeLed2
		ldr r5, = DUREE ;allumage des leds
		bl wait
		
		
		; Evalbot avance droit devant
		BL	MOTEUR_DROIT_ARRIERE	   
		BL	MOTEUR_GAUCHE_ARRIERE
		
		; Avancement pendant une période (deux WAIT)
		ldr r5,=0x2FFFFF
		BL	wait	; BL (Branchement vers le lien WAIT); possibilité de retour à la suite avec (BX LR)
		
	

		
		bl detectionBumpers
		
		;moteurs
		
		BL	MOTEUR_DROIT_OFF
		BL	MOTEUR_GAUCHE_OFF
		b attenteConf2
		
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 3B : itin2
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Etat 4 : detection bumber
detectionBumpers
		ldr r0,[r9]
		cmp r0,#0
		; arret des 2 moteurs
		BEQ accident
		
		ldr r0,[r10]
		cmp r0,#0 
		; arret des 2 moteurs
		BEQ accident
		bx lr
		
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 4 : detection bumper
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Etat 4.5 : accident
accident
		BL	MOTEUR_DROIT_OFF
		BL	MOTEUR_GAUCHE_OFF
		
accidentLoop
		ldr r0,[r8] 
		cmp r0,#0
		beq attente1
		
		bl allumeLed1    						
		bl allumeLed2
		ldr r5,= DUREEBLINK
		bl wait
		
		bl eteintLed1    						
		bl eteintLed2
		ldr r5,= DUREEBLINK
		bl wait
	
		b accidentLoop
		
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 4.5 : accident

		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Etat 5 : attente de confirmation
attenteConf1
		ldr r0,[r8]
		cmp r0,#0
		beq itinRetour1
	
        bl eteintLed1    						     
		bl allumeLed2  
        ldr r5, = DUREEBLINK						
		bl wait
		
        bl allumeLed1  							
		bl eteintLed2  
        ldr r5, = DUREEBLINK							
		bl wait
		
		b attenteConf1
		
attenteConf2
		ldr r0,[r8]
		cmp r0,#0
		beq itinRetour2
	
        bl eteintLed1    						     
		bl allumeLed2    						;; Eteint LED car r2 = 0x00      
        ldr r5, = DUREEBLINK 						;; pour la duree de la boucle d'attente1 (wait1)
		bl wait
		
        bl allumeLed1   							
		bl eteintLed2  							;; Allume LED1&2 portF broche 4&5 : 00110000 (contenu de r3)
        ldr r5, = DUREEBLINK							;; pour la duree de la boucle d'attente2 (wait2)
		bl wait
		
		b attenteConf2
	
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 5 : attente de confirmation
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Etat 6A : itinRetour1
itinRetour1		
		bl eteintLed1    						
		bl eteintLed2
		ldr r5, = DUREE 
		bl wait
		bl detectionBumpers
		
		;moteurs
		
		b attente1
		
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 6A : itinRetour1
		
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Etat 6B : itinRetour2
itinRetour2
		bl eteintLed1    						
		bl eteintLed2
		ldr r5, = DUREE 
		bl wait
		bl detectionBumpers
		
		;moteurs
		
		b attente1	
		
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 6B : itinRetour2		
		

		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Etat 2 : choix itin
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 2 : choix itin
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Utils
wait	subs r5, #1
        bne wait
		bx lr
		
		
allumeLed1
		ldr r0,=PIN4
		str r0, [r11]
		bx lr

allumeLed2
		ldr r0,=PIN5
		str r0, [r12]
		bx lr

eteintLed1
		ldr r0,=0
		str r0, [r11]
		bx lr

eteintLed2
		ldr r0,=0
		str r0, [r12]
		bx lr
		
;avance
	
		
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin utils
		
		nop
		nop
		nop		
        END 