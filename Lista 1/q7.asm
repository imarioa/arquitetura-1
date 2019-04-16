%include "io.inc"
section .data
arrayW dw 1,2,3,4,5

section .bss
arrayDW resd 6
  
section .text
global CMAIN
CMAIN:
    mov ebx, 0
    mov esi, 0
    mov ecx, 5
    .L1:
    mov eax, [arrayW + ebx]
    mov [arrayDW + esi], eax
    add esi, 4
    add ebx, 2
    loop .L1
    
    PRINT_DEC 2, [arrayDW + 4]
    
    
    
    xor eax, eax
    ret