P5E:%include "../LIB/pc_io.inc"   ; incluir declaraciones de procedimiento externos
                                ; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       ; referencia para inicio de programa
	
_start:                   
	mov edx, msg		; edx = dirección de la cadena msg
	call puts			; imprime cadena msg terminada en valor nulo (0)

    mov dl, '!'         ; primer carácter a colocar
    mov ebx, msg+5      ; posición 5
    mov byte [ebx], dl  ; reemplaza carácter en msg[5]

    mov dl, '?'         ; segundo carácter a colocar
    mov ebx, msg+15     ; posición 15
    mov byte [ebx], dl  ; reemplaza carácter en msg[15]

    mov edx, msg        ; edx = dirección de la cadena msg
    call puts           ; imprime cadena msg modificada

	mov	eax, 1	    	; seleccionar llamada al sistema para fin de programa
	int	0x80        	; llamada al sistema - fin de programa

section	.data
msg	db  'abcdefghijklmnopqrstuvwxyz0123456789',10,0  ; cadena + salto de línea + terminador
