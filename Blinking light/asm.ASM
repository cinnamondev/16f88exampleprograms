
; Version 2 board settings: J14 links: Digital 
;::::::::::::::::::::::::::::::::::::::::::::::::::::::: 
;
; The following lines embed configuration data into the PICmicro
	LIST P=16F88
	__CONFIG H'2007', H'3F7A'       ; RC mode
	__CONFIG H'2008', H'3FFC'       ; Clock Fail-Safe disabled

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 

				
#DEFINE	PAGE0	BCF 	STATUS,5	
#DEFINE	PAGE1	BSF 	STATUS,5	
				
OPSHUN	EQU	H'81'		;
STATUS	EQU	H'03'		;defines status register
TRISA	EQU	H'5'		;defines trisA register
PORTA	EQU	H'05'		;defines portA register
TRISB	EQU	H'6'		;defines TrisB register
PORTB	EQU	H'06'		;defines portB register
PCL	EQU	H'02'		;Names the register called program counter
W	EQU	0		;Sets up the name used for the working register
F	EQU	1		;Sets up the name used for file
Z	EQU	2		;Sets up the name used for the zero flag
C      	EQU 	0          	;Sets up the name used for the carry flag


;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;       NAME YOUR REGISTERS HERE
				
count	EQU	H'0C'		;names the register called ????????
;??????	EQU	H'0D'		;names the register called ????????
;??????	EQU	H'0E'		;names the register called ????????      DELETE THIS SECTION IF NOT USING REGISTERS

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;       VECTORS
				
	ORG	00		; Reset vector
	GOTO	XYZ		; Goto start of program 
	ORG	04		; Interrupt vector address
	GOTO	05		; Goto start of program
	ORG	05		; Start of program memory
		
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;       THIS SECTION IS USED TO SET THE DIRECTION OF THE OUTPUT PORTS.

;ENTER the binary number for the Data Direction in the TRIS registers.
;Use 0 if you would like an output or 1 if you would like an input.

XYZ	BSF	STATUS,5	;Bank 1 operation
	CLRF	H'1B'		;Makes the ANSEL (analogue) inputs digital
	MOVLW	B'00011111'	;
	MOVWF	TRISA		;This sets portA data direction to #######
	MOVLW	B'00000000'	;
	MOVWF	TRISB		;This sets portB data direction to #######
	BCF	STATUS,5	;Back to bank 0

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;	MAIN PROGRAM

start	CLRF	PORTA
	CLRF	PORTB
	MOVLW	H'04'	
	MOVWF 	count
;	write your program here. 	



	
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;	SUBROUTINES

; Any subroutines to go in this section. 

input	BTFSS	PORTA,0 	; await input
	GOTO	input
wait	BTFSS	PORTA,0 	; await input release
	GOTO	wait
counter	DECF	count,F 	; decrease count register until count is 0
	BTFSS	STATUS,2 	; checks if count is 0
	GOTO	input
flash	COMF	PORTB,F	; flip portb over and over
	GOTO	flash


	END


