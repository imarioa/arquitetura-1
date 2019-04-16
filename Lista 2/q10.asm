%include "io.inc"

section .text
global CMAIN
CMAIN:
    GET_DEC 4, ecx
    call somaN
    PRINT_DEC 4, eax
    xor eax, eax
    ret

somaN:
    mov eax, 0
    .L1:
    add eax, ecx
    loop .L1
 ret
    