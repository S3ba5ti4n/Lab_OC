%include "../LIB/pc_iox.inc""

nasm -f elf64 P7.asm -o P7.o
	ld	-m	elf_i386	P7.o	../LIB/pbin.o	-o	P7.asm
./P7

extern pBin_n
extern pBin_b
extern pBin_w
extern pBin_dw

nasm -f elf64 P7.asm

section	.text

	global _start 
    
_start:
--------------------------------------------------------------
; Programa: P7.asm
; Autor: Sebastian Diaz Lopez
; Descripción:
; Uso de instrucciones lógicas y de manipulación de bits.
--------------------------------------------------------------

.MODEL SMALL
.STACK 100h
.DATA
    msgEAX db "EAX = ", 0
    msgCX  db "CX  = ", 0
    msgESI db "ESI = ", 0
    msgCH  db "CH  = ", 0
    msgBP  db "BP  = ", 0
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX


; a) EAX = 0x22446688 -> rotaciones -> 0x82244668

    MOV EAX, 022446688h
    ROR EAX, 7                


; b) CX = 0x3F48 -> corrimientos -> 0xFA40

    MOV CX, 03F48h
    SHL CX, 2                 ; Corrimiento a la izquierda 2 bits = 0xFA40


; c) ESI = 0x20D685F3 -> invertir bits 0,5,13,18,30

    MOV ESI, 020D685F3h
    MOV EBX, 0                 ; EBX será la máscara
    OR  EBX, (1 SHL 0)
    OR  EBX, (1 SHL 5)
    OR  EBX, (1 SHL 13)
    OR  EBX, (1 SHL 18)
    OR  EBX, (1 SHL 30)
    XOR ESI, EBX               ; Invertir esos bits


; d) Guardar ESI en la pila

    PUSH ESI


; e) CH = 0xA7 -> activar bits 3 y 6

    MOV CH, 0A7h
    OR  CH, 0100b              ; Activar bit 2 (posición 3)
    OR  CH, 01000000b          ; Activar bit 6


; f) BP = 0x67DA -> desactivar bits 1,4,6,10,14

    MOV BP, 067DAh
    MOV BX, 0FFFFh
    AND BX, NOT ((1 SHL 1) OR (1 SHL 4) OR (1 SHL 6) OR (1 SHL 10) OR (1 SHL 14))
    AND BP, BX


; g) Dividir BP entre 8 -> usar SHR

    SHR BP, 3


; h) Dividir EBX entre 32 -> usar SHR

    SHR EBX, 5


; i) Multiplicar CX por 8 -> usar SHL

    SHL CX, 3


; j) Sacar valor de la pila y guardarlo en ESI

    POP ESI


; k) Multiplicar ESI por 10 usando operaciones de bits
;     (x*10 = x*8 + x*2)

    MOV EDX, ESI
    SHL ESI, 3                 ; ESI = ESI * 8
    SHL EDX, 1                 ; EDX = EDX * 2
    ADD ESI, EDX               ; ESI = ESI * 10

; Fin del programa

    MOV AX, 4C00h
    INT 21h

MAIN ENDP
END MAIN