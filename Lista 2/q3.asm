%include "io.inc"
section .data
string dw 'bcde'
tam dd ($-string)
vogais dw 'aeiouAEIOU'

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
   
    .L1:
    mov ebx, tam
    mov esi, string
    mov ecx, [esi]
    mov eax, [esi]
    mov ecx, 1
    cmp ecx, 1
    jc .L1
   ; PRINT_CHAR ecx
    
    
    ;call contaVogais
;    PRINT_DEC 4, eax
    xor eax, eax
    ret
    
contaVogais:
    mov edx, 0
    mov eax, 0
    mov ecx, [ebx]
    
    .L1:
        mov edi, [esi]
        .L2:
            cmp edi, [vogais + edx]
            jnc .L3
            inc edx
            cmp edx, 11
            jc .L2
       
    inc esi
    loop .L1
    jmp fim  
    .L3:
     inc eax
     dec ecx
     jmp .L1
    fim:
    ret  
