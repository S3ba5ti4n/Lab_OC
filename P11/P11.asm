section .data
    ; Buffer para la cadena binaria (64 bits, máximo)
    bin_output: times 64 db 0  
    ; Carácter de nueva línea
    newline:    db 0x0a

section .text
    global pBin8b, pBin16b, pBin32b, pBin64b
    
    ; Define el símbolo de la función de la librería C 'write' para el syscall
    extern write

; -----------------------------------------------------------------------------
; pBin_common: Rutina de impresión binaria.
; Argumentos (System V AMD64 ABI):
;   RDI: El valor de dato (uint64_t, cero-extendido si es menor)
;   RSI: Número de bits a imprimir (8, 16, 32 o 64)
; -----------------------------------------------------------------------------
pBin_common:
    ; Los registros RBX, R12, R13 son callee-saved, los guardamos si se modifican
    push rbx
    push r12
    push r13
    
    ; RDI contiene el dato, RSI contiene el número total de bits (N)
    
    ; Inicializar el índice de bits (RDX) de N-1 a 0
    mov rdx, rsi     ; RDX = N (total bits)
    dec rdx          ; RDX = N - 1 (índice de inicio: MSB)
    
    ; Inicializar el puntero del buffer (R12)
    mov r12, bin_output
    
.loop_msb_to_lsb:
    ; Condición de fin de bucle: RDX < 0
    cmp rdx, -1
    jl .print_result 
    
    ; 1. Crear la máscara: 1 << RDX
    mov rax, 1           ; RAX = 1
    mov cl, dl           ; Mover RDX (índice de bit) a CL para la instrucción SHL
    shl rax, cl          ; RAX = Máscara (1 << RDX)
    
    ; 2. Comprobar el bit: (Dato & Máscara)
    test rdi, rax
    
    ; 3. Almacenar el carácter en el buffer
    mov byte [r12], '0' ; Asumir '0'
    jz .bit_is_zero     ; Si el resultado es cero, saltar
    
    ; Si el resultado no es cero, el bit es 1
    mov byte [r12], '1'
    
.bit_is_zero:
    ; Avanzar el puntero del buffer
    inc r12
    
    ; Decrementar el índice de bit
    dec rdx
    jmp .loop_msb_to_lsb

.print_result:
    ; Imprimir la cadena binaria
    ; Guardamos los registros volátiles que serán usados para la llamada al sistema
    push rdi
    push rsi
    push rdx
    
    ; Syscall write (1)
    mov rax, 1             ; Número de syscall para write
    mov rdi, 1             ; File descriptor 1 (stdout)
    mov rsi, bin_output    ; Dirección del buffer
    ; La longitud es el número de bits original, guardado en la pila ([rsp+8])
    mov rdx, [rsp+8]       ; RDX = Longitud (RSI original)
    syscall
    
    ; Imprimir un carácter de nueva línea
    mov rax, 1             ; Número de syscall para write
    mov rdi, 1             ; File descriptor 1 (stdout)
    mov rsi, newline       ; Dirección del carácter de nueva línea
    mov rdx, 1             ; Longitud 1
    syscall
    
    ; Restaurar registros de la pila (en orden inverso al push)
    pop rdx
    pop rsi
    pop rdi
    
    ; Restaurar registros callee-saved
    pop r13
    pop r12
    pop rbx
    ret

; -----------------------------------------------------------------------------
; void pBin8b(uint8_t dato)
; RDI (low 8 bits) contiene el dato
; -----------------------------------------------------------------------------
pBin8b:
    ; Cero-extender el dato de 8 bits (DIL) a 64 bits (RDI)
    movzx rdi, dil 
    
    ; Establecer el contador de bits a 8
    mov rsi, 8
    
    ; Saltar a la rutina común de impresión
    jmp pBin_common

; -----------------------------------------------------------------------------
; void pBin16b(uint16_t dato)
; RDI (low 16 bits) contiene el dato
; -----------------------------------------------------------------------------
pBin16b:
    ; Cero-extender el dato de 16 bits (DI) a 64 bits (RDI)
    movzx rdi, di
    
    ; Establecer el contador de bits a 16
    mov rsi, 16
    
    ; Saltar a la rutina común de impresión
    jmp pBin_common

; -----------------------------------------------------------------------------
; void pBin32b(uint32_t dato)
; RDI (low 32 bits) contiene el dato (ya cero-extendido por el ABI)
; -----------------------------------------------------------------------------
pBin32b:
    ; El dato de 32 bits ya está en RDI y cero-extendido por el compilador C
    
    ; Establecer el contador de bits a 32
    mov rsi, 32
    
    ; Saltar a la rutina común de impresión
    jmp pBin_common

; -----------------------------------------------------------------------------
; void pBin64b(uint64_t dato)
; RDI contiene el dato de 64 bits
; -----------------------------------------------------------------------------
pBin64b:
    ; RDI ya contiene el dato de 64 bits
    
    ; Establecer el contador de bits a 64
    mov rsi, 64
    
    ; Saltar a la rutina común de impresión
    jmp pBin_common