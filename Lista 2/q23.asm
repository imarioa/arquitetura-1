%include "io.inc"

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    mov al, 10b
    and al, 11001111b
    PRINT_DEC 1, al
    xor eax, eax
    ret