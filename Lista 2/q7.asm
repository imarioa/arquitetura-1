%include "io.inc"

section .data
vetor dd 5,6,3
tam dd ($-vetor)/4

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    mov esi, vetor
    mov ecx, [tam]
   
    call somaPAR
    PRINT_DEC 4, eax
    xor eax, eax
    ret
    
    
somaPAR:
    mov eax, 0
    L1:
        test DWORD [esi], 1b
        jz soma
        add esi,4 
        loop L1
        ret
   soma:
   add eax, [esi]
   add esi, 4
   loop L1
   ret
        
   
  