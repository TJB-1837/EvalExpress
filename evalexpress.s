
	;; RK - Evalbot (Cortex M3 de Texas Instrument)
	;; fait clignoter une seule LED connect�e au port GPIOF
   	
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
PIN4				EQU		0x10		
PIN5				EQU		0x20
PIN6				EQU		0x40
PIN7				EQU		0x80

; blinking frequency
DUREE   			EQU     0x000FFFFF; Random Value
DUREEMOTEURS		EQU		0x00000FFF;
DUREEBLINK   		EQU     0x002FFFFF; Random Value
DUREEVIRAGE			EQU		6000;

; association de valeurs pour itineraire
ACTION_AVANCE		EQU 	1
ACTION_RECULE		EQU 	2
ACTION_GAUCHE		EQU 	3
ACTION_DROITE		EQU 	4
ACTION_FIN			EQU 	15
 

	  	ENTRY
		EXPORT	__main
		
		;; The IMPORT command specifies that a symbol is defined in a shared object at runtime.
		IMPORT	MOTEUR_INIT					; initialise les moteurs (configure les pwms + GPIO)
		
		IMPORT	MOTEUR_DROIT_ON				; activer le moteur droit
		IMPORT  MOTEUR_DROIT_OFF			; desactiver le moteur droit
		IMPORT  MOTEUR_DROIT_AVANT			; moteur droit tourne vers l'avant
		IMPORT  MOTEUR_DROIT_ARRIERE		; moteur droit tourne vers l'arriere
		IMPORT  MOTEUR_DROIT_INVERSE		; inverse le sens de rotation du moteur droit
		
		IMPORT	MOTEUR_GAUCHE_ON			; activer le moteur gauche
		IMPORT  MOTEUR_GAUCHE_OFF			; desactiver le moteur gauche
		IMPORT  MOTEUR_GAUCHE_AVANT			; moteur gauche tourne vers l'avant
		IMPORT  MOTEUR_GAUCHE_ARRIERE		; moteur gauche tourne vers l'arriere
		IMPORT  MOTEUR_GAUCHE_INVERSE		; inverse le sens de rotation du moteur gauche
			
			
__main	
		; Activation des ports D, E et F  (0x20 == 0b00111000)		
		;   									(GPIO::FEDCBA)
		ldr r6, = SYSCTL_PERIPH_GPIO  			; RCGC2
        mov r0, #0x00000038  					; Charge la valeur 0x38 dans r0
        str r0, [r6]
		
		; ;; "There must be a delay of 3 system clocks before any GPIO reg. access  (p413 datasheet de lm3s9B92.pdf)
		nop	   									
		nop	   
		nop	   									;; pas necessaire en simu ou en debbug step by step...
	
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^CONFIGURATION LED

        ldr r6, = GPIO_PORTF_BASE+GPIO_O_DIR    ;;  Pin 4 et 5 du port F (leds avant) en sortie (00011000)
        ldr r0, = PIN4 + PIN5	
        str r0, [r6]
		
        ldr r6, = GPIO_PORTF_BASE+GPIO_O_DEN	;; Enable Digital Function 
        ldr r0, = PIN4 + PIN5		
        str r0, [r6]
 
		ldr r6, = GPIO_PORTF_BASE+GPIO_O_DR2R	;; Choix de l'intensite de sortie (2mA)
        ldr r0, = PIN4 + PIN5			
        str r0, [r6]

        mov r2, #0x000       					;; pour eteindre LED
     
		; allumer la led broche 4 (PIN4)
		mov r3, #PIN4      					;; Allume portF broche 4 : 00010000
		ldr r11, = GPIO_PORTF_BASE + (PIN4<<2)  ;; @data Register = @base + (mask<<2) ==> LED1
		; allumer la led broche 5 (PIN5)
		mov r4, #PIN5
		ldr r12, = GPIO_PORTF_BASE + (PIN5<<2)

		;vvvvvvvvvvvvvvvvvvvvvvvvFin configuration LED 
		
		;^^^^^^^^^^^^^^^^^^^^^^^^Configuration bumpers
		
        ldr r7, = GPIO_PORTE_BASE+GPIO_O_DEN	;; Enable Digital Function 
        ldr r0, = PIN0 + PIN1		
        str r0, [r7]
		
		ldr r7, = GPIO_PORTE_BASE+GPIO_O_PUR	;; Activation des résistances Pull-Up  
		ldr r0, = PIN0 + PIN1		
        str r0, [r7]
		
		ldr r9, = GPIO_PORTE_BASE+(PIN0<<2) ; BUMPER L
		ldr r10, = GPIO_PORTE_BASE+(PIN1<<2) ; BUMPER R
			
		;vvvvvvvvvvvvvvvvvvvvvvvFin configuration bumpers
		
		
		;^^^^^^^^^^^^^^^^^^^^^^^^Configuration siwtch
		
        ldr r7, = GPIO_PORTD_BASE+GPIO_O_DEN	;; Enable Digital Function 
        ldr r0, = PIN6 + PIN7		
        str r0, [r7]
		
		ldr r7, = GPIO_PORTD_BASE+GPIO_O_PUR	;; Activation des résistances Pull-Up  
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
		;rechargement des adresses des data registers ; @data Register = @base + (mask<<2)
		ldr r7, = GPIO_PORTD_BASE+(PIN6<<2) ;Sw1 
		ldr r8, = GPIO_PORTD_BASE+(PIN7<<2) ;Sw2 
		ldr r9, = GPIO_PORTE_BASE+(PIN0<<2) ;BUMPER L 
		ldr r10, = GPIO_PORTE_BASE+(PIN1<<2) ;BUMPER R
		;fin rechargement des adresses des data registers
		
		ldr r0,[r7]										;lecture de l'état du Sw1 à l'adresse stockée dans le registre r7
		cmp r0,#0										;Le bouton est il pressé ? (comparé à 0 car actif à l'état bas)
		BEQ choixItin									;Si pressé alors on passe au choix des itinéraires
		b attente										;Si toujours pas pressé, rebouclage 
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 1   : attente
			
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Etat 2 : choixItin 
choixItin
		ldr r0,[r9]										;lecture de l'état du BP1
		cmp r0,#0										 
		BEQ attenteConfItin1							;Si pressé, on attend la confirmation de l'itinéraire 1
		
		ldr r0,[r10]									;lecture de l'état du BP2
		cmp r0,#0										
		BEQ attenteConfItin2							;Si pressé, on attend la confirmation de l'itinéraire 2
		b choixItin										;Sinon rebouclage
		
attenteConfItin1
		bl allumeLed1									;Led 1 s'allume en guise de témoin 
		bl eteintLed2									;Led 2 s'éteint (si jamais elle était précédemment allumée)
		ldr r5, = DUREE
		bl wait
		ldr r0,[r10]									;lecture de l'état du BP2
		cmp r0,#0
		BEQ attenteConfItin2							;Si pressé, on a donc voulu changé d'itinéraire, le 2 est sélectionné et on attend la confirmation de l'itinéraire 2
		ldr r0,[r8]										;lecture de l'état du Sw2
		cmp r0,#0
		BEQ itin1										;Si pressé, le choix est confirmé et l'itinéraire 1 peut débuter
		
		b attenteConfItin1
		
attenteConfItin2
		bl allumeLed2									;Led 2 s'allume en guise de témoin 
		bl eteintLed1									;Led 1 s'éteint (si jamais elle était précédemment allumée)
		ldr r5, = DUREE
		bl wait
		ldr r0,[r9]										;lecture de l'état du BP1
		cmp r0,#0
		BEQ attenteConfItin1							;Si pressé, on a donc voulu changé d'itinéraire, le 1 est sélectionné et on attend la confirmation de l'itinéraire 1
		ldr r0,[r8]										;lecture de l'état du Sw2
		cmp r0,#0
		BEQ itin2										;Si pressé, le choix est confirmé et l'itinéraire 2 peut débuter
		
		b attenteConfItin2
		

		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 2 : choix itit
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Etat 3A : itin1
itin1		
		bl allumeLed1   								;Le robot roule avec les "phares allumées"
		bl allumeLed2
		ldr r5, = DUREE 
		bl wait
		
		ldr r7,=tab1									;Chargement du "tableau des durées de l'itinéraire 1" 
		ldr r8,=tabActions1								;Chargement du "tableau des actions de l'itinéraire 1" 
		ldr r2,=0										;Initialisation du compteur
		b doItineraire									;Maintenant que les données propre à l'itinéraire sont chargées, l'itinéraire peut débuter
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Etat 3B : itin2

itin2	

		bl allumeLed1   								;Le robot roule avec les "phares allumées"
		bl allumeLed2
		ldr r5, = DUREE 
		bl wait
		
		ldr r7,=tab2									;Chargement du "tableau des durées de l'itinéraire 2" 
		ldr r8,=tabActions2								;Chargement du "tableau des actions de l'itinéraire 2" 
		ldr r2,=0										;Initialisation du compteur
		b doItineraire									;Maintenant que les données propre à l'itinéraire sont chargées, l'itinéraire peut débuter
		
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 3B : itin2
		
		
doItineraire				
		

		lsl r2,#2										;multiplication de l'index par 4 
		ldr r3,[r7,r2]									;pour pouvoir utiliser un offset sur le "tableau des durées" dont les valeurs sont sur 4octets
		lsr r2,#2										;division de l'index par 4
		ldrb r4,[r8,r2]									;pour pouvoir utiliser un offset sur le tableau des actions stockées sur un octet
		ldr r10,=1										;valeur arbitraire servant dans loop, pour savoir s'il s'agit d'un itinéraire retour ou non
		
		cmp r4,#ACTION_AVANCE
		bleq avance										;Si l'action à effectuée d'avancer, alors le robot avance
	
		cmp r4,#ACTION_RECULE
		bleq recule										;Si l'action à effectuée de reculer, alors le robot recule
		
		cmp r4,#ACTION_GAUCHE
		bleq gauche										;Si l'action à effectuée de pivoter sur la gauche, alors le robot pivote sur la gauche

		cmp r4,#ACTION_DROITE
		bleq droite										;Si l'action à effectuée de pivoter sur la droite, alors le robot de pivoter sur la droite
		
		cmp r4,#ACTION_FIN
		bne suite										;Si l'itinéraire n'est pas terminé, alors on continue
		b attenteConf									;Sinon on passe à l'état d'attente de confirmation de "bonne réception du colis"
suite
		ldr r1,=tabActionsRetour						;Chargement de l'adresse du tableau d'actions Retour
		add r2,#1										
		strb r4,[r1,r2]									;écriture dans la case index+1 de l'action qui vient d'être effectuée avec succès
		b doItineraire									;Rebouclage sur l'exécution de l'itinéraire, toujours pas fini
		
		
loop
		mov r12,lr;push {lr}							;Sauvegarde de lr dans r12 (pour le retour de fonction)
		ldr r0,=0
		cmp r10,#0 										;Comparaison mode retour ou non 
		beq loopRetour									;Si oui, effectuer le loop retour ( pas d'écriture dans les tableaux de retour)
		b   loopItin									;Sinon, effectuer le loop itineraire ( avec ecriture dans les tableaux de retour)	
		
loopRetour
		ldr r5,=DUREEMOTEURS
		bl wait
		subs r3,#1										;Decrémentation du compteur de durée 
		bl detectionBumpers								;Vérification des bumpers (A VERIFIER SI NECESSAIRE DE LE FAIRE ICI)
		cmp r3,#0										;Action terminée ?
		bne loopRetour									;Sinon, rebouclage
		mov lr,r12;pop {pc}								;Restauration de lr
		bx lr
		
loopItin
		ldr r5,=DUREEMOTEURS
		bl wait
		subs r3,#1										;Decrémentation du compteur de durée				
		bl detectionBumpers								;Vérification des bumpers (Accident ?)
		add r0,#1										;Incrémentation du compteur d'actions effectuées
		cmp r3,#0										;Action terminée ?
		bne loopItin									;Sinon, rebouclage
		ldr r1,=tabRetour								;Chargement de l'adresse du tableau de retour
		lsl r2,#2										;Multiplication de l'index par 4
		add r2,#4										;Décalage de 4 octets pour écrire dans la case suivante	
		str r0,[r1,r2]									;Ecriture dans la case index+1 de la durée qui vient d'être effectuée avec succès
		sub r2,#4										;Remise de l'index à sa valeur initiale
		lsr r2,#2										;Division de l'index par 4	
		mov lr,r12;pop {pc}								
		bx lr
			
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 3A : itin1
		
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Etat 4 : detection bumber
detectionBumpers
		ldr r9, = GPIO_PORTE_BASE+(PIN0<<2) 			;Rechargement de l'adresse du data register du BUMPER L
		ldr r10, = GPIO_PORTE_BASE+(PIN1<<2) 			;Rechargement de l'adresse du data register du BUMPER R
		
		ldr r1,[r9]										;lecture de l'état du Bumper gauche
		cmp r1,#0										;Bumper gauche pressé ?
		BEQ accident									;Si oui, alors accident	
		
		ldr r1,[r10]									;Même chose pour le bumper droit
		cmp r1,#0 
		BEQ accident
		bx lr
		
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 4 : detection bumper
		

		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Etat 4.5 : accident
ecritureDebutItinRetour
		ldr r1,=tabRetour								;Chargement de l'adresse du tableau de retour (durées)
		add r2,#1										;Incrémentation de l'index pour écrire dans la case suivante
		lsl r2,#2										;Multiplication de l'index par 4
		ldr r0,=12000									;Chargement de la durée arbitraire du demi-tour
		add r2,#4										;ATTENTION JE SUIS PAS SUR DE CETTE LIGNE Décalage de 4 octets pour écrire dans la case suivante 
		str r0,[r1,r2]									;Ecriture dans la case index+1 de la durée du demi-tour
		ldr r0,=1000									;Chargement de la durée arbitraire du recul après le demi-tour	
		add r2,#4										;Décalage de 4 octets pour écrire dans la case suivante
		str r0,[r1,r2]									;Ecriture dans la case index+1 de la durée du recul
		sub r2,#8										;Remise de l'index à sa valeur initiale
		lsr r2,#2										;Division de l'index par 4


		ldr r1,=tabActionsRetour						;Chargement de l'adresse du tableau de retour (actions)
		strb r4,[r1,r2]									;écriture dans la case index de l'action au cours de laquelle est arrivé l'accident
		ldr r0,=ACTION_DROITE	
		add r2,#1								        ;Même procédé que pour les tableaux des durées
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
		ldr r1,=tabRetour								;REPETITION ? 
		str r0,[r1,r2]
		lsr r2,#2
		
		ldr r1,=tabActionsRetour						;REPETITION ? (imo c est ici qu il faut faire l ecriture)
		strb r4,[r1,r2]
		sub r2,#1
		
		BL	MOTEUR_DROIT_OFF
		BL	MOTEUR_GAUCHE_OFF
		
		
accidentLoop
		ldr r7, = GPIO_PORTD_BASE+(PIN6<<2) 			;Rechargement de l'adresse du data register du Sw1 (pas optimisé mais plus clair)
		ldr r8, = GPIO_PORTD_BASE+(PIN7<<2) 			;Rechargement de l'adresse du data register du Sw2
		
		ldr r0,[r8] 									;lecture de l'état du Sw2
		cmp r0,#0										;Sw2 pressé ?
		beq ecritureDebutItinRetour						;Si oui, on écrit le "début" de l'itinéraire retour
		
		bl allumeLed1    								;Les leds du robot clignotent type "warning" pour signaler l'accident
		bl allumeLed2
		ldr r5,= DUREEBLINK
		bl wait
														; RELIRE SW2 COMME DANS ATTENTE CONF ? 
		bl eteintLed1    						
		bl eteintLed2
		ldr r5,= DUREEBLINK
		bl wait
	
		b accidentLoop
		
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 4.5 : accident


		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Etat 5 : attente de confirmation
attenteConf
		ldr r7, = GPIO_PORTD_BASE+(PIN6<<2) 			;Rechargement de l'adresse du data register du Sw1 (pas optimisé mais plus clair)
		ldr r8, = GPIO_PORTD_BASE+(PIN7<<2) 			;Rechargement de l'adresse du data register du Sw2
		
		ldr r0,[r8]										;lecture de l'état du Sw2
		cmp r0,#0										;Sw2 pressé ?
		beq ecritureDebutItinRetour						;Si oui, on écrit le "début" de l'itinéraire retour
	
        bl eteintLed1    						     	;Les leds du robot clignotent par alternance pour signaler l'attente de confirmation
		bl allumeLed2  
        ldr r5, = DUREEBLINK						
		bl wait
		
		ldr r0,[r8]
		cmp r0,#0										;Revérification de la pression de Sw2 pour limiter le délai 
		beq ecritureDebutItinRetour
		
        bl allumeLed1  							
		bl eteintLed2  
        ldr r5, = DUREEBLINK							
		bl wait
		
		b attenteConf
	
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 5 : attente de confirmation
		

		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Etat 6 : Retour à la base
itinRetour		
		bl eteintLed1    								;Le robot rentre les phares éteintes
		bl eteintLed2
		ldr r5, = DUREE 
		bl wait
		ldr r7,=tabRetour								;Chargement du "tableau des durées de l'itinéraire retour"
		ldr r8,=tabActionsRetour						;Chargement du "tableau des actions de l'itinéraire retour"
		ldr r0,=ACTION_FIN
		strb r0,[r8]									;Ajout de l'action FIN à la "fin" du tableau des actions de l'itinéraire retour
		ldr r0,=0										;Initialisation de l'index à 0 pour la recherche de l'action RECULE (début de l'itinéraire retour)
		
loopIndex		
		ldrb r1,[r8,r0]									;Lecture de l'action à l'index courant
		cmp r1,#ACTION_RECULE							;ACTION_RECULE trouvée ?
		beq findR2										;Si oui, on peut passer à l'itinéraire retour
		add r0,#1										;Sinon, on incrémente l'index
		b loopIndex										;et on reboucle
		
findR2
		mov r2,r0										;Stockage de l'index de l'action RECULE (début de l'itinéraire) dans r2
		b doItineraireRetour
		
doItineraireRetour
		
		lsl r2,#2									;multiplication de l'index par 4 
		ldr r3,[r7,r2]								;pour pouvoir utiliser un offset sur le "tableau des durées" dont les valeurs sont sur 4octets
		lsr r2,#2									;division de l'index par 4
		ldrb r4,[r8,r2]								;pour pouvoir utiliser un offset sur le tableau des actions stockées sur un octet
		ldr r10,=0									;valeur arbitraire servant dans loop, pour savoir s'il s'agit d'un itinéraire retour ou non

		cmp r4,#ACTION_AVANCE						;Même procédé que pour l'itinéraire aller, mais en utilisant les tableaux de retour
		bleq avance

		cmp r4,#ACTION_RECULE
		bleq recule
		
		cmp r4,#ACTION_GAUCHE						;Nous avons écrit "gauche" lorsque le robot allait a gauche, il doit donc faire l'inverse au retour
		bleq droite									;Inversion des actions gauche/droite pour le retour

		cmp r4,#ACTION_DROITE
		bleq gauche									;Idem pour la droite
		
		cmp r4,#ACTION_FIN
		beq attente
		
		sub r2,#1
		b doItineraireRetour		
		
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin Etat 6 : Retour à la base
				
		
		;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^Utils
wait	subs r5, #1
        bne wait
		bx lr
		
allumeLed1
		ldr r11, = GPIO_PORTF_BASE + (PIN4<<2)  ;rechargement de l'adresse du data register ; @data Register = @base + (mask<<2) ==> LED1 ; UTILISATION DE 3 NOP ???
		ldr r0,=PIN4							
		str r0, [r11]
		bx lr

allumeLed2
		ldr r12, = GPIO_PORTF_BASE + (PIN5<<2) ;rechargement de l'adresse du data register ; @data Register = @base + (mask<<2) ==> LED2
		ldr r0,=PIN5
		str r0, [r12]
		bx lr

eteintLed1
		ldr r11, = GPIO_PORTF_BASE + (PIN4<<2)  ;rechargement de l'adresse du data register ; @data Register = @base + (mask<<2) ==> LED1
		ldr r0,=0
		str r0, [r11]
		bx lr

eteintLed2
		ldr r12, = GPIO_PORTF_BASE + (PIN5<<2) ;rechargement de l'adresse du data register ; @data Register = @base + (mask<<2) ==> LED2
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

; Déclaration des tableaux d'itinéraires
tab1      DCD 9000,DUREEVIRAGE,9000,DUREEVIRAGE,12000,DUREEVIRAGE,6000,DUREEVIRAGE,3000,DUREEVIRAGE,3000,DUREEVIRAGE,3000,DUREEVIRAGE,3000,DUREEVIRAGE,3000,DUREEVIRAGE,6000 ; Tableau des durées de l'itinéraire 1
tab2 	  DCD 3000,DUREEVIRAGE,9000,DUREEVIRAGE,18000,DUREEVIRAGE,3000,DUREEVIRAGE,6000,DUREEVIRAGE,3000,DUREEVIRAGE,12000,DUREEVIRAGE,6000,DUREEVIRAGE,6000 ; Tableau des durées de l'itinéraire 2

tabActions1 DCB ACTION_AVANCE,ACTION_GAUCHE,ACTION_AVANCE,ACTION_DROITE,ACTION_AVANCE,ACTION_DROITE,ACTION_AVANCE,ACTION_GAUCHE,ACTION_AVANCE,ACTION_DROITE,ACTION_AVANCE,ACTION_GAUCHE,ACTION_AVANCE,ACTION_DROITE,ACTION_AVANCE,ACTION_GAUCHE,ACTION_AVANCE,ACTION_FIN ; Tableau des actions de l'itinéraire 2
tabActions2 DCB	1,4,1,3,1,3,1,3,1,4,1,4,1,4,1,3,1,15 ; Tableau des actions de l'itinéraire 2

		AREA variables, DATA, READWRITE
tabRetour 		SPACE 100					;Réservation de place pour le tableau des durées de l'itinéraire retour
tabActionsRetour SPACE 50					;Réservation de place pour le tableau des actions de l'itinéraire retour
		
		;vvvvvvvvvvvvvvvvvvvvvvvvvvvvvFin utils
		
		;nop
		;nop
		;nop		
        END 