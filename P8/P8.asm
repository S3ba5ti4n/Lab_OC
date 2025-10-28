%include "../LIB/libpc_iox.a"

;nasm -f elf64 P8.asm -o P8.o
	;ld	-m	elf_i386	P8.o	../LIB/libpc_iox.a	-o	P8.asm
;./P8
section	.text

	global _start       ;must be declared for using gcc

_start:  

  



    ; a) Caracter '0' a '9', indicar si es menor que '5'
    
    ; Usar 'getche' para leer el caracter
    call getche         ; AL = caracter capturado

    ; Compara con '5'
    cmp al, '5'
    jl  .es_menor_5     ; Saltar si AL < '5' (Jump Less)

    ;si no salta (AL >= '5')
    mov eax, msg_no_menor_5 mov eax,
    call puts 
    jmp .secuencia_b

.es_menor_5: 
    ; Si AL < '5'
    mov eax, msg_menor_5
    call puts

.secuencia_b:
    
    ; b) Caracter en ['0'..'9'] o ['A'..'Z'], indicar si es letra o numero
    
    
    call getche         ; AL = nuevo caracter capturado
    
    
    cmp al, '0'
    jl .es_letra_o_fuera     ; AL < '0' 

    cmp al, '9'
    jle .es_numero          ; AL <= '9' es num o letra

.es_letra_o_fuera:
    
    cmp al, 'A'
    jl .fuera_de_rango       ; AL < 'A'

    cmp al, 'Z'
    jle .es_letra           ; AL <= 'Z'


.fuera_de_rango: 
    ; AL esta fuera de ambos rangos
    mov eax, msg_fuera_rango
    call puts
    jmp .secuencia_c

.es_numero:
    mov eax, msg_es_numero
    call puts
    jmp .secuencia_c

.es_letra:
    mov eax, msg_es_letra
    call puts
    jmp .secuencia_c

.secuencia_c:
    
    ; c) Triangulo de asteriscos, tamaño dado por CX (0-10)
    
    ; ASUME que el valor inicial de CX (n) se establece fuera o antes de _start.
    ; Por ejemplo, si se establece a 5: mov cx, 5
    ; Usaremos EAX como contador para la fila, ECX (o CX) es el tamaño maximo
    ; Si no se especifica, usaremos un valor de ejemplo para CX:
    mov cx, 5  ; Ejemplo de tamaño de triangulo (cambiar segun necesidad)

    mov ebx, 1          ; EBX = Contador de asteriscos por fila (i), empieza en 1

.loop_filas:
    cmp ebx, ecx        ; Comparar i con n (CX es el tamaño maximo)
    jg .secuencia_d      ; Si i > n, se termino el triangulo (Jump Greater)

    push ecx            ; Guardar el tamaño maximo (n)
    mov ecx, ebx        ; CX = i (numero de asteriscos a imprimir en esta fila)

.loop_asteriscos:
    ; Imprimir un asterisco
    mov al, byte [asterisco]
    call putc

    loop .loop_asteriscos  ; Decrementa CX, salta si CX != 0

    pop ecx             ; Restaurar el tamaño maximo (n)
    ; Imprimir nueva linea
    mov al, byte [nueva_linea]
    call putc

    inc ebx             ; i++ (Siguiente fila)
    jmp .loop_filas     ; Repetir para la siguiente fila

.secuencia_d:
    ; d) Capturar 10 caracteres y presentarlos en formato columna
    ; ----------------------------------------------------
    mov ecx, 10         ; ECX = Contador de 10 iteraciones

    ; Puntero al inicio del arreglo de datos
    mov edi, buffer_datos

.loop_captura:
    ; Capturar el caracter
    call getche         ; AL = caracter capturado

    ; Almacenar en el arreglo
    mov [edi], al       ; Almacena el caracter en el byte apuntado por EDI
    inc edi             ; Mueve el puntero al siguiente byte

    loop .loop_captura  ; Decrementa ECX, salta si ECX != 0

    ; Presentar mensaje "Datos capturados"
    mov eax, msg_captura_datos
    call puts

    ; Presentar los 10 caracteres en columna
    mov ecx, 10         ; ECX = Contador de 10 iteraciones
    mov esi, buffer_datos ; ESI = Puntero al inicio del arreglo

.loop_presentacion:
    ; Cargar el caracter desde el arreglo
    mov al, [esi]
    call putc           ; Imprimir el caracter

    ; Imprimir nueva linea para formato columna
    mov al, byte [nueva_linea]
    call putc

    inc esi             ; Siguiente caracter en el arreglo

    loop .loop_presentacion ; Decrementa ECX, salta si ECX != 0

    ; ----------------------------------------------------
    ; FIN del programa
    ; ----------------------------------------------------
    call exit           ; Llama a la funcion de salida del sistema (ej. sys_exit)