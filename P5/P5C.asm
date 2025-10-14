%include "../LIB/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

section .text
	global _start       ;referencia para inicio de programa
	
_start:
	; Imprimir cadena original
	mov edx, msg		; edx = dirección de la cadena msg
	call puts			; imprime cadena original

	; Reemplazar '0' con '@' usando direccionamiento relativo a registro
	mov dl, '@'
	lea ebx, [msg]        ; ebx = base
	mov [ebx + 26], dl    ; relativo a registro: posición 26 = '0'

	; Imprimir cadena modificada
	mov edx, msg
	call puts

	; Finalizar programa
	mov	eax, 1	    	    ; seleccionar llamada al sistema para fin de programa
	int	0x80               ; llamada al sistema - fin de programa

section .data
msg	db  'abcdefghijklmnopqrstuvwxyz0123456789', 10, 0