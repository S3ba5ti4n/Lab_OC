 section .text
    global_start

suma:
 push ebp
 mov ebp, esp

 mov eax, [ebp+8]
 add eax, [ebp+12]
 
 pop ebp
 