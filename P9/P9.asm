%include "../LIB/libpc_iox.a"

;nasm -f elf64 P9.asm -o P9.o
	;ld	-m	elf_i386	P9.o	../LIB/libpc_iox.a	-o	P9.asm
;./P9
global _start
 extern read_char, print_char, print_hex_byte, print_nl, print_string
 section .data
 msgA db "Ingrese vector A:",0
 msgB db "Ingrese vector B:",0  
 msgS db "Suma de vectores (hex):",0
 msgP db "Producto escalar (hex):",0
 N equ 5
 vecA times N db 0
 vecB times N db 0

 section .text

captura_vector:
    push eax
    push ecx
    push ebx
leer_dato:
    call read_char
    sub al, '0'
    cmp al, 9
    jae leer_dato
    mov [ebx], al
    inc ebx
    loop leer_dato
    pop ebx
    pop ecx
    pop eax
    ret

desplegar_vector_hex:
    push eax
    push ebx
    push ecx
mostrar:
    mov al, [ebx]
    call print_hex_byte
    mov al, ' '
    call print_char
    inc ebx
    loop mostrar
    call print_nl
    pop ecx
    pop ebx
    pop eax
    ret

sumar_vectores:
    push eax
    push ebx
    push edx
    push ecx
sumar:
    mov al, [ebx]
    add al, [edx]
    mov [ebx], al
    inc ebx
    inc edx
    loop sumar
    pop ecx
    pop edx
    pop ebx
    pop eax
    ret

_start:
    mov ebx, msgA
    call print_string
    mov ebx, vecA
    mov ecx, N
    call captura_vector

    mov ebx, msgB
    call print_string
    mov ebx, vecB
    mov ecx, N
    call captura_vector

    mov ebx, vecA
    mov edx, vecB
    mov ecx, N
    call sumar_vectores

    mov ebx, msgS
    call print_string
    mov ebx, vecA
    mov ecx, N
    call desplegar_vector_hex

    mov ebx, vecA
    mov edx, vecB
    mov ecx, N
    xor esi, esi
producto:
    mov al, [ebx]
    mov bl, [edx]
    imul bl
    add esi, eax
    inc ebx
    inc edx
    loop producto

    mov ebx, msgP
    call print_string
    mov al, sil
    call print_hex_byte
    call print_nl

    mov eax, 1
    xor ebx, ebx
    int 0x80