LIST	P=16F84A

PORTA			EQU 0x05
PORTB			EQU 0x06
CONTADORCICLO		EQU 0x0C
CONTADORINTER           EQU 0x0D

ORG 0x00
BSF B'00000011',5           ; bank 1
MOVLW	B'00000000'         ; outputs
MOVWF   PORTB               ; para port B
BCF	    B'00000011',5   ; bank 0

BSF	    B'00000011',5   ; bank 1
MOVLW   B'00000001'         ; un input
MOVWF   PORTA
BCF	    B'00000011',5   ; bank 0

LEDROJA BSF PORTB,0                       ; turn on pin B0
    BCF PORTB,1
    BCF PORTB,2    
    CALL CICLOROJA                        ; go to cycle

LEDAMARILLA BCF PORTB,0
    BSF PORTB,1                           ; turn on pin B1
    BCF PORTB,2
    CALL CICLOAMARILLA                    ; go to cycle

LEDVERDE BCF PORTB,0
    BCF PORTB,1
    BSF PORTB,2                           ; turn on pin B2
    CALL CICLOVERDE                       ; go to cycle

CICLOROJA MOVLW B'00001010'               ; ten
    MOVWF CONTADORCICLO                   ; init counter
CONTARROJA  BTFSC PORTA,0                 ; push button pressed? then skip next
    CALL INTERVERDE                       ; interrupt to green
    
    DECFSZ CONTADORCICLO,1                ; zero reached? then skip next
    GOTO CONTARROJA                       ; while greater than cero
    CALL LEDAMARILLA                      ; change to yellow

CICLOAMARILLA MOVLW B'00001010'           ; ten
    MOVWF CONTADORCICLO                   ; init counter
CONTARAMARILLA  DECFSZ CONTADORCICLO,1    ; zero reached? then skip next
    GOTO CONTARAMARILLA                   ; while greater than cero
    CALL LEDVERDE                         ; change to green

CICLOVERDE MOVLW B'00001010'              ; diez
    MOVWF CONTADORCICLO                   ; init counter
CONTARVERDE  BTFSC PORTA,0                ; push button pressed? then skip next
    CALL INTERROJA                        ; interrupt to red
    
    DECFSZ CONTADORCICLO,1                ; zero reached? then skip
    GOTO CONTARVERDE                      ; while greater than cero
    CALL LEDROJA                          ; change to red
INTERVERDE INCF CONTADORINTER,f           ; increase counter
    BTFSC CONTADORINTER,0                 ; bit one is clear? then skip next
    BSF PORTB,3                           ; turn on bit one
    NOP                                   ; no operation
    BTFSS CONTADORINTER,0                 ; bit one is set? then skip next
    BCF PORTB,3                           ; turn off bit one
    NOP                                   ; no operation
    
    BTFSC CONTADORINTER,1
    BSF PORTB,4
    NOP
    BTFSS CONTADORINTER,1
    BCF PORTB,4
    NOP
    
    BTFSC CONTADORINTER,2
    BSF PORTB,5
    NOP
    BTFSS CONTADORINTER,2
    BCF PORTB,5
    NOP
    
    BTFSC CONTADORINTER,3
    BSF PORTB,6
    NOP
    BTFSS CONTADORINTER,3
    BCF PORTB,6
    NOP
    CALL LEDVERDE
INTERROJA INCF CONTADORINTER,f
    BTFSC CONTADORINTER,0
    BSF PORTB,3
    NOP
    BTFSS CONTADORINTER,0
    BCF PORTB,3
    NOP
    
    BTFSC CONTADORINTER,1
    BSF PORTB,4
    NOP
    BTFSS CONTADORINTER,1
    BCF PORTB,4
    NOP
    
    BTFSC CONTADORINTER,2
    BSF PORTB,5
    NOP
    BTFSS CONTADORINTER,2
    BCF PORTB,5
    NOP
    
    BTFSC CONTADORINTER,3
    BSF PORTB,6
    NOP
    BTFSS CONTADORINTER,3
    BCF PORTB,6
    NOP
    CALL LEDROJA
END