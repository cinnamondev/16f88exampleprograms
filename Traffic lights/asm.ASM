
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
				
TIME	EQU	H'2C'		;	TIME REGISTER - Causes delays!!
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
; PORTB,0 IS GREEN
; PORTB,1 IS AMBER
; PORTB,2 IS RED

;	MAIN PROGRAM

start	CLRF	PORTB
	BSF	PORTB,0	; ASSUME GREEN AT THE START

	CALL	DELAY ; sequence stop
	CALL	SS

	CALL	DELAY ; sequence start
	CALL	SG

	GOTO	start
;	write your program here. 	



	
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;	SUBROUTINES

; Any subroutines to go in this section. 
SS	CLRF	PORTB	; SEQUENCE STOP (red)
	BSF	PORTB,1 ; set amber, red
	
	CALL	SDELAY ; short delay
	MOVLW	B'00000100' ; final state
	MOVWF	PORTB
	RETURN

SG	BSF	PORTB,1	; SEQUENCE START (green)
	; assume we are on red at this point, we will not be clearing PORTB as we would like to preserve the thing

	CALL	SDELAY	; short delay
	MOVLW	B'00000001' ; final state
	MOVWF	PORTB
	RETURN

DELAY	CALL RREG ; quick long delay  function
	CALL DEL
	RETURN


SDELAY	CALL SREG ; quick short delay function
	CALL DEL
	RETURN




DEL	DECFSZ	TIME,F ; do our delay for the TIME register (doesn't care for duration
	GOTO DEL
	RETURN

RREG	MOVLW	H'2C' ; set up our time register for LONG delays
	MOVWF	TIME
	RETURN

SREG	MOVWF	B'00100000' ; set up our time register for SHORTER delays
	MOVWF	TIME
	RETURN


	END


