%include "../LIB/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

section .text
	global _start       ; referencia para inicio de programa
	
_start:                   
	mov edx, msg		; edx = dirección de la cadena msg
	call puts			; imprime cadena msg terminada en valor nulo (0)

    ; Cambio solicitado: reemplazar la primera letra por 'Z' usando direccionamiento directo

    mov al, 'Z'            ; cargar carácter 'Z' en AL
    mov [msg], al          ; almacenar en la primera posición de la cadena (modo indirecto)

    mov byte [msg], 'Z'    ; esta es la forma directa, deja ambas si estás mostrando diferencias

    mov edx, msg           ; volver a cargar la dirección de la cadena
    call puts              ; imprimir cadena modificada

	mov	eax, 1	    	   ; seleccionar llamada al sistema para fin de programa
	int	0x80               ; llamada al sistema - fin de programa

section .data
msg	db  'abcdefghijklmnopqrstuvwxyz0123456789', 0xa, 0
