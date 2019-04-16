%include "io.inc"

section .data
vetor1 dd 1,2,3,4,5
tam1 dd ($-vetor1)/4
vetor2 dd 5,6,7,8
tam2 dd ($-vetor2)/4

section .bss
vetorF resd 100

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    mov esi, vetor1
    mov ecx, [tam1]
    mov ebp, [tam2]
    mov edi, vetor2
    call reordenando
    mov ecx, [tam1]
    mov ebp, [tam2]
    mov eax, 0
    add eax, ecx
    add eax, ebp
    
    mov ecx, eax
    .GG:
        PRINT_DEC 4, [edx]
        add edx, 4
     dec ecx
     jnz .GG
    
    xor eax, eax
    ret
    
    
    
reordenando:
    mov ebx, 0
    .L1:
       mov eax, [edi]
       cmp DWORD [esi], eax
       jecxz preencV2
       push ecx
       mov ecx, ebp
       jecxz preencV1
       jge .primeiroM
       jle .segundoM
       ret
       
       
       .primeiroM:
       mov [vetorF + ebx], eax
       push eax
       mov eax, vetorF
       add eax, ebx
       mov edx, eax
       pop eax
       add edi, 4
       add ebx, 4
       dec ebp
       jmp .L1
       
       .segundoM:
       push eax
       mov eax, [esi]
       mov [vetorF + ebx], eax
       mov eax, vetorF
       add eax, ebx
       mov edx, eax
       pop eax
       add esi, 4
       add ebx, 4
       dec ecx
       jmp .L1
       
       preencV2:
          push ecx
          push eax 
          mov ecx, ebp
          .while:
             mov eax, [edi]
             mov [vetorF + ebx], eax
             push eax
             mov eax, vetorF
             add eax, ebx
             mov edx, eax
             pop eax
             add ebx, 4
             add edi, 4
          loop .while
          pop ecx
          pop eax
         ret
         
       preencV1:
          pop ecx
          push eax 
          .while1:
             mov eax, [esi]
             mov [vetorF + ebx], eax
             push eax
             mov eax, vetorF
             add eax, ebx
             mov edx, eax
             pop eax
             add ebx, 4
             add esi, 4
          loop .while1
          
          pop eax
         ret

       
       
       
    
   