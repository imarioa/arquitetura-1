%include "io.inc"

section .data
vetor dd 1,2,3,4,5,6
tam dd  ($-vetor)/2
section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    mov ecx, [tam]
    mov ebx, vetor
    GET_DEC 4, esi
    GET_DEC 4, edi
    call somaI
    PRINT_DEC 4, eax
    
    xor eax, eax
    ret
    
    
somaI:
    
    mov eax, 4 ;movendo 2 para eax, para fazer a multiplicação dos indices por 2
    mul esi ; multiplicando esi(primeiro indice do intervalo) por 2, porque o vetor é de DW
    mov esi, eax 
    mov eax, 4 
    mul edi ; multiplicando edi(segundo indice do intervalo) por 2, porque o vetor é de DW
    mov edi, eax

    mov eax, 0
    mov edx, 0
    
    .L1:
        add ebx, esi ;somando esi em ebx para o vetor começar do primeiro indice do intervalo
        mov  edx, [ebx]
        ;movzx ecx, ax
        add  eax, edx
        add esi, 4
        cmp esi, edi
        jbe .L1
        
       ;movzx eax, ax
    ret
    