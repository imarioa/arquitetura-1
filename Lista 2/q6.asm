%include "io.inc"

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    
    mov esi, 1
    mov ecx, 2
    mov edi, 3
        
    GET_DEC 4, ebx
    
    call triangular
    PRINT_DEC 4, eax
    
    xor eax, eax
    ret
    
    
    
triangular:
    pushad
    L1:
    mov eax, 1
    mul esi
    mul ecx
    mul edi
    cmp eax, ebx
    je fim2
    ja fim
    add esi, 1
    add ecx, 1
    add edi, 1
    jmp L1
    
    fim:
    popad
    mov eax, 0    
    ret
    
    fim2:
    popad
    mov eax, 1  
    ret

    