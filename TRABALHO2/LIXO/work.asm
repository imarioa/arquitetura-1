%include "io.inc"

%define BUF_SIZE 1024

section .data
chave db '/home/Imario/Documentos/UFC/ARQ.I/TRABALHO2/chave.txt', 0
encriptado db '/home/Imario/Documentos/UFC/ARQ.I/TRABALHO2/encriptado.txt', 0
mensagem db '/home/Imario/Documentos/UFC/ARQ.I/TRABALHO2/mensagem.txt', 0

section .bss
crip resb BUF_SIZE
chave_in resd 1
chave_out resd 1
msg_in resd 1
msg_out resd 1
crip_in resd 1
msg resb BUF_SIZE
key resb BUF_SIZE
teste resb BUF_SIZE
lenmsg resd 1
lenkey resd 1

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ;-----------------Abrindo arquivo mensagem.txt------------------------------;
    mov eax, 5
    mov ebx, mensagem
    mov ecx, 0
    mov edx, 0777
    int 0x80
    ;FALTANDO TRATAR ERROS;
    mov [msg_in], eax
    ;---------------------------------------------------------------------------;
    ;----------Movendo o conteúdo de mensagem.txt na variavel msg---------------;
    mov eax, 3
    mov ebx, [msg_in]
    mov ecx, msg
    mov edx, BUF_SIZE
    int 0x80
    
    ;--------------Movendo o tamanho da mensagem para a variavel lenmsg---------;
    mov [lenmsg], eax
    ;---------------------------------------------------------------------------;
    ;----------------------Abrindo o arquivo chave.txt--------------------------;
    mov eax, 5
    mov ebx, chave
    mov ecx, 0
    mov edx, 0777
    int 0x80
    
    mov [chave_in], eax
    ;---------------------------------------------------------------------------;
    ;-----------Movendo o conteúdo de chave.txt para a variavel key-------------;
    mov eax, 3
    mov ebx, [chave_in]
    mov ecx, key
    mov edx, BUF_SIZE
    int 0x80
    ;-----------------Movendo o tamanho da key para lenkey-----------------------;
    mov [lenkey], eax
    ;----------------------------------------------------------------------------;
    ;-------------------------------Encriptando----------------------------------;
    mov ebx, key
    mov edx, msg
    mov esi, 0
    mov edi, 0
    mov ecx, [lenmsg]
    dec ecx
   
    L1: 
      mov ebp, ecx
      mov ecx, [lenkey]
      sub ecx, 2
      cmp edi,ecx
      jg reset
      
      voltar:
            
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
      mov [crip + esi], eax
      
      
      pop ebx
      mov ecx, ebp
      inc esi
      inc edi
      dec ecx
      jnz L1
      
      jmp continue
      
      reset:
      mov edi, 0
      jmp voltar
      
   ;--------------------------------------------------------------------------;
    continue:
    ;--------------Criando arquivo com mensagem criptografada-----------------;
    mov eax, 8
    mov ebx, encriptado
    mov ecx, 0777
    int 0x80
    ;FALTANDO TRATAR ERROS;
    PRINT_DEC 4, eax
    cmp eax, 0
    mov [msg_out], eax 
    ;-------------------------------------------------------------------------;
    
    mov eax, 4
    mov ebx, [msg_out]
    mov ecx, crip
    mov edx, [lenmsg]
    int 0x80
    
    mov ebx, encriptado
    mov edx, key
    mov esi, 0
    mov edi, 0
    mov ecx, [lenmsg]
    dec ecx
   
    L1: 
      mov ebp, ecx
      mov ecx, [lenkey]
      sub ecx, 2
      cmp edi,ecx
      jg reset
      
      voltar:
            
      mov al, [ebx + esi]
      push ebx
      mov bl, [edx + edi]
      movzx ax, al
      movzx cx, bl
      
      ;Calculo da cifra C = ((Palavra + chave) mod 26)+ 65(A)
      sub ax,cx
      add ax, 26
      mov bl, 26
      div bl
      add ah, 65
      movzx eax, ah
      mov [crip + esi], eax
      
      
      pop ebx
      mov ecx, ebp
      inc esi
      inc edi
      dec ecx
      jnz L1
      
      jmp go
      
      reset:
      mov edi, 0
      jmp voltar
      
      go:
      mov eax, 4
      mov ebx,1
      mov ecx, crip
      mov edx, [lenmsg]
    
   
    mov eax, 1
    int 0x80
    
    
   
    
    
    


