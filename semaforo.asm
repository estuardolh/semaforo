LIST	P=16F84A

PORTA			EQU 0x05
PORTB			EQU 0x06
CONTADORCICLO		EQU 0x0C
CONTADORINTER           EQU 0x0D

ORG 0x00
BSF B'00000011',5     ; bank 1
MOVLW	B'00000000'       ; outputs
MOVWF   PORTB             ; para port B
BCF	    B'00000011',5     ; bank 0

BSF	    B'00000011',5     ; bank 1
MOVLW   B'00000001'       ; un input
MOVWF   PORTA
BCF	    B'00000011',5     ; bank 0

LEDROJA BSF PORTB,0         ; pin B0
    BCF PORTB,1
    BCF PORTB,2    
    CALL CICLOROJA          ; ir a ciclo

LEDAMARILLA BCF PORTB,0
    BSF PORTB,1               ; pin B1
    BCF PORTB,2
    CALL CICLOAMARILLA        ; ir a ciclo

LEDVERDE BCF PORTB,0
    BCF PORTB,1
    BSF PORTB,2               ; pin B2
    CALL CICLOVERDE           ; ir a ciclo

CICLOROJA MOVLW B'00001010'         ; diez
    MOVWF CONTADORCICLO       ; inicializar contador
CONTARROJA  BTFSC PORTA,0         ; interrumptor presionado?
    CALL INTERVERDE   ; interrupcion a verde
    
    DECFSZ CONTADORCICLO,1    ; decrementar 1
    GOTO CONTARROJA           ; repetir mientras mayor que cero
    CALL LEDAMARILLA          ; cambiar a amarilla

CICLOAMARILLA MOVLW B'00001010'           ; diez
    MOVWF CONTADORCICLO                   ; inicializar contador
CONTARAMARILLA  DECFSZ CONTADORCICLO,1    ; decrementar 1
    GOTO CONTARAMARILLA                   ; repetir mientras mayor que cero
    CALL LEDVERDE                         ; cambiar a verde

CICLOVERDE MOVLW B'00001010'              ; diez
    MOVWF CONTADORCICLO                   ; inicializar contador
CONTARVERDE  BTFSC PORTA,0                ; interrumptor presionado?
    CALL INTERROJA                        ; interrupcion a verde
    
    DECFSZ CONTADORCICLO,1                ; decrementar 1
    GOTO CONTARVERDE                      ; repetir mientras mayor que cero
    CALL LEDROJA                          ; cambiar a roja
INTERVERDE INCF CONTADORINTER,f
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