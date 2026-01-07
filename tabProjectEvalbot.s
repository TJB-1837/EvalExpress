
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
DUREE   			EQU     0x000FFFFF; Random Value
;DUREE   			EQU     0x1	; Random Value	
DUREEMOTEURS		EQU		0x00000FFF;
;DUREEMOTEURS		EQU		0x1;
DUREEBLINK   		EQU     0x002FFFFF; Random Value
;DUREEBLINK   		EQU     0x1
DUREEVIRAGE			EQU		6000;
;DUREEVIRAGE		EQU		0x3;	
; association de valeurs pour itinéraire
ACTION_AVANCE		EQU 	1
ACTION_RECULE		EQU 	2
ACTION_GAUCHE		EQU 	3
ACTION_DROITE		EQU 	4
ACTION_FIN			EQU 	15
	
; itinéraires dans tes tableaux
;ITIN1				DCB    




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
attente
		ldr r7, = GPIO_PORTD_BASE+(PIN6<<2) ;Sw1
		ldr r8, = GPIO_PORTD_BASE+(PIN7<<2) ;Sw2
		ldr r9, = GPIO_PORTE_BASE+(PIN0<<2) ;BUMPER L
		ldr r10, = GPIO_PORTE_BASE+(PIN1<<2) ;BUMPER R
		
		ldr r0,[r7]
		cmp r0,#0
		BEQ choixItin
		b attente
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
		bl allumeLed1   						
		bl allumeLed2
		ldr r5, = DUREE ;allumage des leds
		bl wait
		
		ldr r7,=tab1
		ldr r8,=tabActions1
		ldr r2,=0
		b doItineraire
		
		
				;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Etat 3B : itin2
itin2	

		bl allumeLed1   						
		bl allumeLed2
		ldr r5, = DUREE ;allumage des leds
		bl wait
		
		ldr r7,=tab2
		ldr r8,=tabActions2
		ldr r2,=0
		b doItineraire

		;CHOIX AVEC DUPLICATION DE CODE
		
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 3B : itin2
		
		
doItineraire
		

		lsl r2,#2
		ldr r3,[r7,r2]
		lsr r2,#2
		ldrb r4,[r8,r2]
		ldr r10,=1
		
		cmp r4,#ACTION_AVANCE
		bleq avance
	
		cmp r4,#ACTION_RECULE
		bleq recule
		
		cmp r4,#ACTION_GAUCHE
		bleq gauche

		cmp r4,#ACTION_DROITE
		bleq droite
		
		cmp r4,#ACTION_FIN
		bne suite
		b attenteConf
suite
		ldr r1,=tabActionsRetour
		add r2,#1
		strb r4,[r1,r2]
		b doItineraire
		
		
loop
		mov r12,lr;push {lr}
		ldr r0,=0
		cmp r10,#0 ; comparaison mode retour ou non r
		beq loopRetour
		b   loopItin
		
loopRetour
		ldr r5,=DUREEMOTEURS
		;ldr r5,=1
		bl wait
		subs r3,#1
		bl detectionBumpers
		cmp r3,#0
		bne loopRetour
		mov lr,r12;pop {pc}
		bx lr
		
loopItin
		ldr r5,=DUREEMOTEURS
		;ldr r5,=1
		bl wait
		subs r3,#1
		bl detectionBumpers
		add r0,#1
		cmp r3,#0
		bne loopItin
		ldr r1,=tabRetour
		lsl r2,#2
		add r2,#4
		str r0,[r1,r2]
		sub r2,#4
		lsr r2,#2
		mov lr,r12;pop {pc}
		bx lr
		
		
			
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 3A : itin1
		
		

		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Etat 4 : detection bumber
detectionBumpers
		ldr r9, = GPIO_PORTE_BASE+(PIN0<<2) ;BUMPER L
		ldr r10, = GPIO_PORTE_BASE+(PIN1<<2) ;BUMPER R
		
		ldr r1,[r9]
		cmp r1,#0
		; arret des 2 moteurs
		BEQ accident
		
		ldr r1,[r10]
		cmp r1,#0 
		; arret des 2 moteurs
		BEQ accident
		bx lr
		
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 4 : detection bumper
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Etat 4.5 : accident
ecritureDebutItinRetour
		ldr r1,=tabRetour
		add r2,#1
		lsl r2,#2
		ldr r0,=12000
		add r2,#4
		str r0,[r1,r2]
		ldr r0,=1000
		add r2,#4
		str r0,[r1,r2]
		sub r2,#8
		lsr r2,#2


		ldr r1,=tabActionsRetour
		strb r4,[r1,r2]
		ldr r0,=ACTION_DROITE
		add r2,#1
		strb r0,[r1,r2]
		ldr r0,=ACTION_RECULE
		add r2,#1
		strb r0,[r1,r2]
		sub r2,#2
		sub r2,#1
		b itinRetour
		
accident		
		add r2,#1
		lsl r2,#2
		ldr r1,=tabRetour
		str r0,[r1,r2]
		lsr r2,#2
		
		ldr r1,=tabActionsRetour
		strb r4,[r1,r2]
		sub r2,#1
		
		BL	MOTEUR_DROIT_OFF
		BL	MOTEUR_GAUCHE_OFF
		
		
accidentLoop
		ldr r7, = GPIO_PORTD_BASE+(PIN6<<2) ;Sw1
		ldr r8, = GPIO_PORTD_BASE+(PIN7<<2) ;Sw2
		ldr r0,[r8] 
		cmp r0,#0
		beq ecritureDebutItinRetour
		
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
attenteConf
		ldr r7, = GPIO_PORTD_BASE+(PIN6<<2) ;Sw1
		ldr r8, = GPIO_PORTD_BASE+(PIN7<<2) ;Sw2
		
		ldr r0,[r8]
		cmp r0,#0
		beq ecritureDebutItinRetour
	
        bl eteintLed1    						     
		bl allumeLed2  
        ldr r5, = DUREEBLINK						
		bl wait
		
		ldr r0,[r8]
		cmp r0,#0
		beq ecritureDebutItinRetour
		
        bl allumeLed1  							
		bl eteintLed2  
        ldr r5, = DUREEBLINK							
		bl wait
		
		b attenteConf
	
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 5 : attente de confirmation
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Etat 6A : itinRetour1
itinRetour		
		bl eteintLed1    						
		bl eteintLed2
		ldr r5, = DUREE 
		bl wait
		ldr r7,=tabRetour
		ldr r8,=tabActionsRetour
		ldr r0,=ACTION_FIN
		strb r0,[r8]
		ldr r0,=0
		
loopIndex		
		ldrb r1,[r8,r0]
		cmp r1,#ACTION_RECULE
		beq findR2
		add r0,#1
		b loopIndex
		
findR2
		mov r2,r0
		b doItineraireRetour
		
doItineraireRetour
		
		lsl r2,#2
		ldr r3,[r7,r2]
		lsr r2,#2
		ldrb r4,[r8,r2]
		ldr r10,=0
		
		cmp r4,#ACTION_AVANCE
		bleq avance

		cmp r4,#ACTION_RECULE
		bleq recule
		
		cmp r4,#ACTION_GAUCHE
		bleq droite

		cmp r4,#ACTION_DROITE
		bleq gauche
		
		cmp r4,#ACTION_FIN
		beq attente
		
		sub r2,#1
		b doItineraireRetour		
		
		
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 6A : itinRetour1
				

		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Etat 2 : choix itin
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 2 : choix itin
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Utils
wait	subs r5, #1
        bne wait
		bx lr
		
		
allumeLed1
		ldr r11, = GPIO_PORTF_BASE + (PIN4<<2)  ;; @data Register = @base + (mask<<2) ==> LED1
		ldr r0,=PIN4
		str r0, [r11]
		bx lr

allumeLed2
		ldr r12, = GPIO_PORTF_BASE + (PIN5<<2)
		ldr r0,=PIN5
		str r0, [r12]
		bx lr

eteintLed1
		ldr r11, = GPIO_PORTF_BASE + (PIN4<<2)  ;; @data Register = @base + (mask<<2) ==> LED1
		ldr r0,=0
		str r0, [r11]
		bx lr

eteintLed2
		ldr r12, = GPIO_PORTF_BASE + (PIN5<<2)
		ldr r0,=0
		str r0, [r12]
		bx lr
		
avance
		mov r11,lr;push {lr}
		BL	MOTEUR_DROIT_ON
		BL	MOTEUR_GAUCHE_ON
		BL	MOTEUR_DROIT_AVANT	   
		BL	MOTEUR_GAUCHE_AVANT
		bl loop
		BL	MOTEUR_DROIT_OFF
		BL	MOTEUR_GAUCHE_OFF
		;pop {pc}
		mov lr,r11
		bx lr
		
recule
		mov r11,lr
		BL	MOTEUR_DROIT_ON
		BL	MOTEUR_GAUCHE_ON
		BL	MOTEUR_DROIT_ARRIERE	   
		BL	MOTEUR_GAUCHE_ARRIERE
		bl loop
		BL	MOTEUR_DROIT_OFF	
		BL	MOTEUR_GAUCHE_OFF
		mov lr,r11
		bx lr		
		
		
gauche
		mov r11,lr
		BL	MOTEUR_DROIT_ON
		BL	MOTEUR_GAUCHE_ON   
		BL	MOTEUR_DROIT_AVANT
		BL	MOTEUR_GAUCHE_INVERSE
		bl loop
		BL	MOTEUR_DROIT_OFF
		BL	MOTEUR_GAUCHE_OFF
		mov lr,r11
		bx lr


droite
		mov r11,lr
		BL	MOTEUR_DROIT_ON
		BL	MOTEUR_GAUCHE_ON   
		BL	MOTEUR_GAUCHE_AVANT
		BL	MOTEUR_DROIT_INVERSE
		
		bl loop
		BL	MOTEUR_DROIT_OFF
		BL	MOTEUR_GAUCHE_OFF
		mov lr,r11
		bx lr
		
		nop
		nop
		nop

		AREA constantes,DATA,READONLY
;tab1 DCD 9000,DUREEVIRAGE,9000,DUREEVIRAGE,12000,DUREEVIRAGE,6000,DUREEVIRAGE,3000,DUREEVIRAGE,3000,DUREEVIRAGE,3000,DUREEVIRAGE,3000,DUREEVIRAGE,3000,DUREEVIRAGE,6000

tab1      DCD 9000,DUREEVIRAGE,9000,DUREEVIRAGE,12000,DUREEVIRAGE,6000,DUREEVIRAGE,3000,DUREEVIRAGE,3000,DUREEVIRAGE,3000,DUREEVIRAGE,3000,DUREEVIRAGE,3000,DUREEVIRAGE,6000
tab2 	  DCD 3000,DUREEVIRAGE,9000,DUREEVIRAGE,18000,DUREEVIRAGE,3000,DUREEVIRAGE,6000,DUREEVIRAGE,3000,DUREEVIRAGE,12000,DUREEVIRAGE,6000,DUREEVIRAGE,6000

tabActions1 DCB ACTION_AVANCE,ACTION_GAUCHE,ACTION_AVANCE,ACTION_DROITE,ACTION_AVANCE,ACTION_DROITE,ACTION_AVANCE,ACTION_GAUCHE,ACTION_AVANCE,ACTION_DROITE,ACTION_AVANCE,ACTION_GAUCHE,ACTION_AVANCE,ACTION_DROITE,ACTION_AVANCE,ACTION_GAUCHE,ACTION_AVANCE,ACTION_FIN
tabActions2 DCB	1,4,1,3,1,3,1,3,1,4,1,4,1,4,1,3,1,15

		AREA variables, DATA, READWRITE
tabRetour 		SPACE 100
tabActionsRetour SPACE 50
		
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin utils
		
		;nop
		;nop
		;nop		
        END 