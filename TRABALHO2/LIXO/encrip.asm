%include "io.inc"

section .text
global CMAIN
CMAIN:
    ;write your code here
    xor eax, eax
    ret
    
    
    encriptar:
    
    mov esi, 0
    mov edi, 0
    mov ecx, [lenmsg]
    dec ecx
    L1: 
      push ecx
      mov ecx, [lenkey]
      sub ecx, 2
      cmp edi,ecx
      jge reset
      pop ecx
      voltar:
      push ecx
      
      
      mov al, [ebx + edi]
      push ebx
      mov bl, [edx + esi]
      movzx ax, al
      movzx cx, bl
      
      ;Calculo da cifra C = ((Palavra + chave) mod 26)+ 65(A)
      add ax,cx
      mov bl, 26
      div bl
      add ah, 65
      movzx eax, ah
      mov [teste + esi], eax
      
      
      pop ebx
      pop ecx
      inc esi
      inc edi
      dec ecx
      jnz L1
      
      ret
      reset:
      mov edi, 0
      jmp voltar
      
    