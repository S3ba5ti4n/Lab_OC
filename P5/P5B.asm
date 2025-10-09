%include "../LIB/pc_io.inc"  	; incluir declaraciones de procedimiento externos
								; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       ; referencia para inicio de programa
	
_start:
	; Imprimir cadena original
	mov edx, msg		; edx = dirección de la cadena msg
	call puts			; imprime cadena original

	; Reemplazar la letra 'x' (posición 23) con 'X' usando direccionamiento indirecto
	mov dl, 'X'
	mov ebx, msg + 23   ; ebx apunta al carácter 'x'
	mov byte [ebx], dl  ; almacena 'X' en la posición apuntada por ebx

	; Imprimir cadena modificada
	mov edx, msg
	call puts

	; Terminar programa
	mov	eax, 1	    	; seleccionar llamada al sistema para fin de programa
	int	0x80        	; llamada al sistema - fin de programa

section	.data
msg	db  'abcdefghijklmnopqrstuvwxyz0123456789', 10, 0
