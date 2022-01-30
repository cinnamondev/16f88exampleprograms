; SET VPIC TO WASHING MACHINE ADDON TO WORK WITH

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
				
TDELAY	EQU	H'0F'	;names the register called ????????
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
	MOVLW	B'11111'	; adjust as neccesary, port a will be all input.
	MOVWF	TRISA		;This sets portA data direction to #######

	MOVLW	B'00000000'	; adjust as needed, port b will be all output
	MOVWF	TRISB		;This sets portB data direction to #######
	BCF	STATUS,5	;Back to bank 0



;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;	MAIN PROGRAM



start	CLRF	PORTA
	CLRF	PORTB
	CALL 	RREG

	CALL	INPUT	; await push button to begin cycle
	;if button press begin cycle.
	CALL	WATER
	CALL	WASH
	CALL	DRAIN
	CALL	SPIN

	GOTO start

;	write your program here. 	



	
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;	SUBROUTINES

; Any subroutines to go in this section. 

;notes:
;PORTA,4 is BEGIN CYCLE BUTTON
;PORTA,0 is input for WASHER IS FULL (1 is full)
;PORTA,1 IS INPUT FOR WASHER IS EMPTY (1 if empty)

;PORTB,0 IS TELL TO FILL
;PORTB,1 IS TO TELL TO EMPTY
;PORTB,2 IS TO TELL TO WASH
;PORTB,3 IS TO TELL TO SPIN

INPUT	BTFSS	PORTA,4 ; WAIT FOR INPUT TO BEGIN WASHING
	GOTO INPUT


; note: do not call it fill it will hate you
WATER	CLRF	PORTB ;clear all current commands
	BSF	PORTB,0 ; BEGIN FILL

	BTFSS	PORTA,0 ; LOOP UNTIL DEFINETE FULL
	GOTO 	WATER
	
	BTFSS	PORTA,0
	BCF	PORTB,0 ; END FILL

	RETURN


DRAIN	CLRF	PORTB
	
	BSF	PORTB,1 ; BEGIN EMPTY
	
	BTFSS	PORTA,1 ; LOOP UNTIL DEFINITE EMPTY
	GOTO DRAIN

	BTFSS	PORTA,1
	BCF	PORTB,0 ; END EMPTY
	RETURN

WASH	CLRF	PORTB 

	BTFSC	PORTA,0 ;DO NOT CONTINUE IF WASHER IS NOT DEFINETELY FULL

	CALL	RREG ; reset our register to be full so we can time our thing
	BSF	PORTB,2
	CALL	DELAY
	BCF	PORTB,2
	RETURN


SPIN	CLRF	PORTB

	BTFSC	PORTA,1	; DO NOT CONTINUE IF THE WASHER IS NOT DEFINETELY EMPTY
	
	CALL	RREG
	BSF	PORTB,3

	BCF	PORTB,3
	
	RETURN

RREG	MOVLW   H'0F'
	MOVWF	TDELAY	; INITIALISE OUR REGISTER TO BEGIN ON FULL
	RETURN

DELAY	DECFSZ	1
	GOTO DELAY
	RETURN


	END






