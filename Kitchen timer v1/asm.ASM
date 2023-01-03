	LIST P=16F88
	__CONFIG H'2007', H'3FFA'       ; EXTRCIO, WTDEN disabled, PWRTE disabled,
	; RA5 is MCLR, BOR enabled, LVP enable, CPD Code prot off,
	; Write prot off, ICDB disabled, CCP1 on RB0, CP flash prot off.
	__CONFIG H'2008', H'3FFC'       ; Clock Fail-Safe disabled, 
	; int.ext switchover disabled.

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::: 

				
#DEFINE	PAGE0	BCF 	STATUS,5	
#DEFINE	PAGE1	BSF 	STATUS,5	

	; define SFRs
	
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

;       VECTORS
	; vectors are placed in memory not part of program memory,
	; at these memory locations instructions can be inserted.
	; FOR EXAMPLE:
	; ORG 04    ; Interrupt vector
	; GOTO ISR  ; Interrupt subroutine
	; Interrupts can be configured to come from various sources, using 
	; the INTCON register.
	ORG	00		; Reset vector
	GOTO	XYZ		; Goto start of program 
	ORG	04		; Interrupt vector address
	GOTO	05		; Goto start of program
	ORG	05		; Start of program memory
		
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;       NAME YOUR REGISTERS HERE
				
TIME	EQU	H'2C'		;	TIME REGISTER - Causes delays!!

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;       VECTORS
				
	ORG	00		; Reset vector
	GOTO	XYZ		; Goto start of program 
	ORG	04		; Interrupt vector address
	GOTO	05		; Goto start of program
	ORG	05		; Start of program memory
		
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;       THIS SECTION IS USED TO SET THE DIRECTION OF THE OUTPUT PORTS.

XYZ	BSF	STATUS,5	;Bank 1 operation
	CLRF	H'1B'		;Makes the ANSEL (analogue) inputs digital
	MOVLW	B'00000111'	;
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
	MOVLW	B'00000111'
	BSF	PORTB,1
	ANDWF	PORTB

	GOTO	start

	
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;	SUBROUTINES

; Any subroutines to go in this section. 
INPUT	MOVLW B'00111' ; we want to check for anything in portA resembling the literal
	ANDWF	PORTA	
	RETURN

DELAY	CALL RREG ; quick long delay  function
	CALL DEL
	RETURN

MDELAY	CALL MREG ; quick  medium delay function
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

MREG	MOVLW	H'1C' ; time register for MEDIUM delays
	MOVWF	TIME
	RETURN

SREG	MOVWF	B'00100000' ; set up our time register for SHORTER delays
	MOVWF	TIME
	RETURN


	END


