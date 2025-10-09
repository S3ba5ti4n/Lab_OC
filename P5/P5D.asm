P5D:%include "../LIB/pc_io.inc"   ; incluir declaraciones de procedimiento externos
                                ; que se encuentran en la biblioteca libpc_io.a

section	.text
	global _start       ;referencia para inicio de programa
	
_start:                   
	mov edx, msg		; edx = dirección de la cadena msg
	call puts			; imprime cadena msg terminada en valor nulo (0)

    mov dl,'#'          ; nuevo carácter a colocar
    mov ebx, msg+10     ; posición 10 (puedes cambiar el índice)
    mov byte [ebx], dl  ; reemplaza el carácter en msg[10]

    mov edx, msg        ; edx = dirección de la cadena msg
    call puts           ; imprime cadena msg modificada

	mov	eax, 1	    	; seleccionar llamada al sistema para fin de programa
	int	0x80        	; llamada al sistema - fin de programa

section	.data
msg	db  'abcdefghijklmnopqrstuvwxyz0123456789',10,0  ; cadena + salto de línea + terminador
