
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
				
ACTIVE	EQU	H'0C'		;names the register called CODE, this will be the code to compare to
;??????	EQU	H'0D'		;names the register called INPUT, this will be the register we add the code to then compare the register to
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

;PORTA,0 = A
;PORTA,1 = B
;PORTA,2 = C

; CODE SHOULD BE C  B  A

;	MAIN PROGRAM


; Code checker - PORTA will be our inputs then we can use PORTB,0 to indicate success
start	CLRF	PORTB
	CALL	CHECK

;	write your program here. 	



	
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;	SUBROUTINES

AWAIT	BCF	PORTB,7	; We will use this to indicate READY
	; awaits input from any PORTA
	MOVLW	PORTA
	BTFSC	STATUS,2 ; SKIP IF THE WORKING REGISTER IS CLEAR/NO INPUT
	BCF	PORTB,7
	
	BTFSC	STATUS,2
	MOVWF	ACTIVE
	RETURN

CHK1	CALL	AWAIT	; CHECKS FOR C
	BTFSS	ACTIVE,2	; CHECK IF C IS SET.
	GOTO	FAIL	; FAIL SCENARIO
	GOTO	CHK2	; CHECK NEXT BIT 
	


CHK2	CALL	AWAIT	; CHECKS FOR B
	BTFSS	ACTIVE,1	; CHECKS IF B IS SET.
	GOTO 	FAIL	; FAIL SCENARIO
	GOTO	CHK3	; CHECK NEXT BIT

CHK3	CALL	AWAIT ; CHECK FOR A
	BTFSS	ACTIVE,0	; CHECK IF A IS SET
	GOTO 	FAIL	
	GOTO 	PASS	; We have cleared all the codes!

CHECK	CALL CHK1

PASS	BSF	PORTB,0	; DO A THING ON SUCCESS ( WE SHOULD SET THIS TO FUFILL A FUNCTION)
	GOTO PASS	; loop on success until halt	

FAIL	CLRF	PORTB
FLOOP	BSF	PORTB,6
	GOTO FLOOP

; Any subroutines to go in this section. 






	


	END


