%include "io.inc"

section .text
global CMAIN
CMAIN:
    ;if( ebx > ecx  AND  ebx > edx) OR ( edx > eax )
    ;X = 1
    ;else
    ;X = 2
    mov ebx, 9
    mov ecx, 4
    mov edx, 11
    mov eax, 12
    
    cmp ebx, ecx
    jbe .or
    cmp ebx, edx
    jbe .or
    jmp .teste
    .or:
    cmp edx, eax
    jbe .else
    .teste:
    mov eax, 1
    jmp fim
    
    .else:
    mov eax, 2
    fim:
    PRINT_DEC 4,eax
    xor eax, eax
    ret