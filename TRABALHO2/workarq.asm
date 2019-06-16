;%include "io.inc"
%define BUF_SIZE 1024
section .data
;--------------------------------------Arquivos---------------------------------------;
chave db 'chave.txt', 0
encriptado db 'encriptado.txt', 0
desencriptado db 'desencriptado.txt', 0
mensagem db 'mensagem.txt', 0
;-------------------------------------------------------------------------------------;
;-------------------------------------Mensagens---------------------------------------;
option db 'Digite C para criptografar e D para descriptografar', 10,0
tam equ ($-option)
erro db 'Opcao invalida',10,0
errot equ ($-erro)
;-------------------------------------------------------------------------------------;
section .bss
;-------------------------------Tamanho das strings-----------------------------------;
lenkey resd 1
lenmsg resd 1
;-------------------------------------------------------------------------------------;
;--------------------------------Descritor de arquivos--------------------------------;
chave_in resd 1
msg_in resd 1
;-------------------------------------------------------------------------------------;
;-----------------------------------Strings-------------------------------------------;
crip resb 500
decrip resb 500
msg resb 500
key resb 500
;-------------------------------------------------------------------------------------;
;-------------------------------------Opções------------------------------------------;
op resb 1
;-------------------------------------------------------------------------------------;
section .text
global _start
;CMAIN:
    
_start:
    
    menu:
;-----------------------------Imprimindo o menu--------------------------------------;
    mov eax, 4
    mov ebx, 0
    mov ecx, option
    mov edx, tam
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, op
    mov edx, 2
    int 0x80
;------------------------------------------------------------------------------------;
;-------------------------Fazendo a verificação se a opção é valida------------------;    
    mov al, [op]
    cmp al, 'C'
    jz criptografar
    cmp al, 'D'
    jz descriptografar
    
    mov eax, 4
    mov ebx, 0
    mov ecx, erro
    mov edx, errot
    int 0x80
    jmp menu
;-----------------------------------------------------------------------------------;
;--------------------------------Algoritmo de Criptografia--------------------------;    
criptografar:
    push mensagem
    push chave
    call abrir
    push msg
    push key
    call ler
;---------------------Tirando da pilha a mensagem e a chave-------------------------;    
    pop ebx
    pop edx
;-----------------------------------------------------------------------------------;   
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
      
;----------Calculo da cifra C = ((Palavra + chave) mod 26)+ 65(A)-------------------;
      add ax,cx ;ax = chave + palavra
      mov bl, 26 ;bl = 26
      div bl ;ax = ax/bl
      add ah, 65 ;ah = (ax % 26) + 65
;-----------------------------------------------------------------------------------;
      movzx eax, ah
      mov [crip + esi], eax
           
      pop ebx
      mov ecx, ebp
      inc esi
      inc edi
      dec ecx
      jnz L1
;-------------------------------Criação do arquivo encriptado----------------------;     
      call arq_crip
      call fechar_arq
;----------------------------------------------------------------------------------;
      pop eax
      pop eax
      
      mov eax, 1
      int 0x80
;--------------------------Reseta caso chegue no final da chave--------------------;      
      reset:
      mov edi, 0
      jmp voltar
;----------------------------------------------------------------------------------;
;---------------------------Algoritmo da Descriptografia---------------------------;

descriptografar:

    push encriptado
    push chave
    call abrir
    push crip
    push key
    call ler
;--------------Tirando da pilha a mensagem encriptada e a chave--------------------;   
    pop edx ;crip
    pop ebx ;key
;----------------------------------------------------------------------------------;
    mov esi, 0
    mov edi, 0
    mov ecx, [lenmsg]
    dec ecx
   
    .L1: 
      mov ebp, ecx
      mov ecx, [lenkey]
      sub ecx, 2
      cmp edi,ecx
      jg .reset
      
      .voltar:
            
      mov al, [ebx + esi]
      push ebx
      mov bl, [edx + edi]
      movzx ax, al
      movzx cx, bl
      
;---------Calculo da mensagem M = ((cifra - chave + 26) mod 26)+ 65(A)------------;
      sub ax,cx
      add ax, 26
      mov bl, 26
      div bl
      add ah, 65
;---------------------------------------------------------------------------------;
  
      movzx eax, ah
      mov [decrip + esi], eax
            
      pop ebx
      mov ecx, ebp
      inc esi
      inc edi
      dec ecx
      jnz .L1
;------------------------Criando o arquivo descriptografado-----------------------;
      call arq_descrip
      call fechar_arq
;---------------------------------------------------------------------------------;
;--------------------Tirando da pilha para o programa não 'crashar'---------------;
      pop eax
      pop eax
;---------------------------------------------------------------------------------;      
      mov eax,1
      int 0x80
;---------------------Resetar caso a chave chegue no final------------------------;   
      .reset:
      mov edi, 0
      jmp .voltar
;---------------------------------------------------------------------------------;
            
    
;----------------------------------Abrir arquivo----------------------------------;      
abrir:
    enter 12,0
    mov edi, [ebp + 12]
    mov esi, [ebp + 8]
    
    mov eax, 5
    mov ebx, edi ;edi
    mov ecx, 0
    mov edx, 0777
    int 0x80
    
    mov [msg_in], eax
    
    mov eax, 5
    mov ebx, esi ;esi
    mov ecx, 0
    mov edx, 0777
    int 0x80
    
    mov [chave_in], eax
    leave
ret
;--------------------------------------------------------------------------------;   
;---------------------------------Ler arquivo------------------------------------;  
ler:
    enter 12,0
    mov edi, [ebp + 12]
    mov esi, [ebp + 8]
    
    .primeiro:
    mov eax, 3
    mov ebx, [msg_in]
    mov ecx, edi
    mov edx, BUF_SIZE
    int 0x80
    
    cmp eax, 0
    jl .primeiro
    mov [lenmsg], eax
    
    .segundo:
    mov eax, 3
    mov ebx, [chave_in]
    mov ecx, esi
    mov edx, BUF_SIZE
    int 0x80
    
    cmp eax, 0
    jl .segundo
    
    mov [lenkey], eax
    leave 
ret
;------------------------------------------------------------------------------;
;--------------------------Criação do arquivo encriptado-----------------------;
arq_crip:

    mov eax, 8
    mov ebx, encriptado
    mov ecx, 0777
    int 0x80
    
    mov ebx, eax
    mov eax, 4
    mov ecx, crip
    mov edx, [lenmsg]
    int 0x80
    
    mov eax, 6
    int 0x80
    
ret
;-----------------------------------------------------------------------------;
;----------------------Criação do arquivo desencriptado-----------------------;
arq_descrip:

mov eax, 8
    mov ebx, desencriptado
    mov ecx, 0777
    int 0x80
    
    mov ebx, eax
    mov eax, 4
    mov ecx, decrip
    mov edx, [lenmsg]
    int 0x80
    
    mov eax, 6
    int 0x80
    
ret
;----------------------------------------------------------------------------;
;-----------------------------Fechando arquivos------------------------------;
fechar_arq:
    mov eax, 6
    mov ebx, [msg_in]
    int 0x80
    
    mov eax, 6
    mov ebx,[chave_in]
    int 0x80
    
ret
;----------------------------------------------------------------------------;   