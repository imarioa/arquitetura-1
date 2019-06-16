%include "io.inc"

section .data
palavra db 'ATACARBASESUL',0
tamp dd ($-palavra)
chave db 'AAA',0
tamc dd ($-chave)

section .bss
encriptada resb 15

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    mov edx, palavra
    mov ebx, chave
    call crip
    PRINT_STRING encriptada
    xor eax,eax
    ret

crip:
    mov esi, 0
    mov edi, 0
    ;mov ecx, [tamp]
    ;sub ecx, 1
    
    L1:
      push ebx
      push edx
      mov cl, [edx + esi]
      cmp cl,0
      jz fim
      mov al, [ebx + edi]
      cmp al, 0
      jz reset
      voltar:
      mov al, [ebx + edi]
      mov bl, [edx + esi]
      movzx ax, al
      movzx dx, bl
      
      ;Calculo da cifra C = ((Palavra + chave) mod 26)+ 65(A)
      add ax,dx
      mov bl, 26
      div bl
      add ah, 65
      movzx eax, ah
      mov [encriptada + esi], eax
      pop edx
      pop ebx
      inc esi
      inc edi
      ;dec ecx
      jmp L1
      fim:
      pop edx
      pop ebx
      ret
      
      reset:
      mov edi, 0
      jmp voltar
             