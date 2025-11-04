%include "../LIB/libpc_iox.a"

;nasm -f elf64 P9.asm -o P9.o
	;ld	-m	elf_i386	P9.o	../LIB/libpc_iox.a	-o	P9.asm
;./P9
section	.text

	global _start       ;must be declared for using gcc

_start:

 Capturar_Vector:
 call getche

 cmp al, '10'
 jl, es_menor


es_menor:
 mov EBX, no_registrto_N

Despliegue_de_vector:

 mov ebx,
 mov ecx 
 mov, cx

Calc_Sum_Vectores:
 
 mov vector, 
 mov edx

 ecx sum, vector




Prog_lee_almacena_vectores:
es_letra prgo 
q alcna, ecx
sto, ecx
(c+ 1) (c+2)


.loop_presentacion:
    ; Cargar el caracter desde el arreglo
    mov al, [esi]
    call putc           ; Imprimir el caracter

 call putc
 inc esi

 loop .loop_presentacion 

    
    ; FIN del programa
    
    call exit 
