	AREA    |.text|, CODE, READONLY

	ENTRY
	EXPORT __main

__main

	ldr r1,=tab
	ldr r10,=tab2
	
	ldrb r2,[r1]
	ldrb r3,[r1,#1]
	ldrb r4,[r1,#2]
	ldrb r5,[r1,#3]
	
	ldr r0,=s
	
	strb r2,[r0]
	strb r3,[r0,#1]
	strb r4,[r0,#2]
	strb r5,[r0,#3]
	
	nop
	
	AREA constantes,DATA,READONLY
tab DCB 13,26,0xc,2_1010
tab2 DCB	1,2

	AREA variables, DATA, READWRITE
s SPACE 4

	END