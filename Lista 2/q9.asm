%include "io.inc"
section .data
vetor dd 10,20,40,60
tam dd ($-vetor)/4
section .text
global CMAIN
CMAIN:
    mov ecx, [tam]
    mov edx, vetor
    call somaVetor
    PRINT_DEC 4, eax
    
    
    xor eax, eax
    ret
    
somaVetor:
    mov eax, 0
    .L1:
    add eax, [edx]
    add edx, 4
    loop .L1
    ret

    