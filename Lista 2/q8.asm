%include "io.inc"

section .text
global CMAIN
CMAIN:
    GET_DEC 4, ecx
    call fibonacci
    
    PRINT_DEC 4, eax
    
    xor eax, eax
    ret

fibonacci:
    mov edx,1; segundo
    mov ebx,0; primeiro
    mov eax,1; resultado
    
    
    L1:
      mov edx, eax
      add eax, ebx
      mov ebx, edx
    loop L1
    ret
    
    