%include "io.inc"

section .data
string db 'ABCDE'
tam dd ($-string)

section .text
global CMAIN
CMAIN:
    mov esi, string
    mov ecx, [tam]
    call convertendo
    PRINT_STRING string
    
    xor eax, eax
    ret
    
    
convertendo:
    L1:
     or BYTE [esi], 100000b
     inc esi
   loop L1