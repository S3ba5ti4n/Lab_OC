section .data
    
    bin_output: times 64 db 0  
    
    newline:    db 0x0a

section .text
    global pBin8b, pBin16b, pBin32b, pBin64b
    
    
    extern write


pBin_common:
   
    push rbx
    push r12
    push r13
    
   
    mov rdx, rsi     ; RDX = N (total bits)
    dec rdx          ; RDX = N - 1 (índice de inicio: MSB)
    
   
    mov r12, bin_output
    
.loop_msb_to_lsb:
   
    cmp rdx, -1
    jl .print_result 
    
   
    mov rax, 1           ; RAX = 1
    mov cl, dl           ; Mover RDX (índice de bit) a CL para la instrucción SHL
    shl rax, cl          ; RAX = Máscara (1 << RDX)
    
   
    test rdi, rax
    
    
    mov byte [r12], '0' ; Asumir '0'
    jz .bit_is_zero     ; Si el resultado es cero, saltar
    
   
    mov byte [r12], '1'
    
.bit_is_zero:
    
    inc r12
    
    
    dec rdx
    jmp .loop_msb_to_lsb

.print_result:
    
    push rdi
    push rsi
    push rdx
    
    ; Syscall write (1)
    mov rax, 1             
    mov rdi, 1             
    mov rsi, bin_output   
    
    mov rdx, [rsp+8]      
    syscall
    
   
    mov rax, 1             
    mov rdi, 1             
    mov rsi, newline       
    mov rdx, 1             
    syscall
    
    
    pop rdx
    pop rsi
    pop rdi
    
  
    pop r13
    pop r12
    pop rbx
    ret


pBin8b:
    ; Cero-extender el dato de 8 bits (DIL) a 64 bits (RDI)
    movzx rdi, dil 
    
    ; Establecer el contador de bits a 8
    mov rsi, 8
    
    ; Saltar a la rutina común de impresión
    jmp pBin_common


pBin16b:
    ; Cero-extender el dato de 16 bits (DI) a 64 bits (RDI)
    movzx rdi, di
    
    ; Establecer el contador de bits a 16
    mov rsi, 16
    
    ; Saltar a la rutina común de impresión
    jmp pBin_common


pBin32b:
    
    
   
    mov rsi, 32
    
   
    jmp pBin_common



pBin64b:
    
   
    mov rsi, 64
    
   
    jmp pBin_common