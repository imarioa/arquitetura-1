;A file copy program                                               file_copy.asm
;
;Objective: To copy a file using the int 0x80 services.
;    Input: Requests names of the input and output files.
;   Output: Creates a new output file and copies contents of the input file.

%include "io.inc"

%define BUF_SIZE 1024

section .data
chave db '/home/Imario/Documentos/UFC/ARQ.I/TRABALHO2/chave.txt', 0
out_file_name db '/home/Imario/Documentos/UFC/ARQ.I/TRABALHO2/encriptado.txt', 0
mensagem db '/home/Imario/Documentos/UFC/ARQ.I/TRABALHO2/mensagem.txt', 0

section .bss
crip resb 1028
;out_file_name resb 30

chave_in resd 1
chave_out resd 1
msg_in resd 1
msg_out resd 1
msg resb BUF_SIZE
key resb BUF_SIZE
teste resb BUF_SIZE
lenmsg resd 1
lenkey resd 1

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ;;Abrindo o arquivo da mensagem;;
    mov EAX,5            ;file open
    mov EBX,mensagem ;input file name pointer
    mov ECX,0            ;access bits (read only)
    mov EDX,0700         ;file permissions
    int 0x80
    
    mov [msg_in],EAX      ;store fd for use in read routine
    
    ;;Criando o arquivo da mensagem encriptada;;
    create_file:
    ;create output file
    mov EAX,8                ;file create
    mov EBX,out_file_name    ;output file name pointer
    mov ECX,777             ;r/w/e by owner only
    int 0x80
    
    mov [msg_out],EAX         ;store fd for use in write routine
    ;cmp EAX,0                ;create error if fd < 0
   ; jge repeat_read
   ; PRINT_STRING out_file_err_msg
   ; NEWLINE
   ; jmp close_exit
    
    ;;Lendo o conteúdo do arquivo da mensagem e armazenando na variavel "msg";;
    repeat_read:
    ; read input file
    mov EAX,3             ;file read
    mov EBX, [msg_in]      ;file deor
    mov ECX, msg       ;input buffer
    mov EDX, BUF_SIZE  ;size
    int 0x80
    
    mov [lenmsg], eax
    ;;Abrindo o arquivo da chave;;
    
    mov EAX,5            ;file open
    mov EBX, chave ;input file name pointer
    mov ECX,0            ;access bits (read only)
    mov EDX,0700         ;file permissions
    int 0x80
    
    mov [chave_in],EAX      ;store fd for use in read routine
        
    ;;Lendo o conteúdo do arquivo da mensagem e armazenando na variavel "msg";;
    ;repeat_read:
    ; read input file
    
    ;;Lendo o conteúdo de chave.txt e armazenando em key.txt;;
    mov EAX,3             ;file read
    mov EBX, [chave_in]      ;file deor
    mov ECX, key       ;input buffer
    mov EDX, BUF_SIZE     ;size
    int 0x80
    
    mov [lenkey], eax
    
    PRINT_STRING msg
    PRINT_STRING key
    
    ;criptografia;;edx carrega a palavra e ebx carrega a chave
    mov edx, msg
    mov ebx, key
    ;call encriptar
    ;PRINT_STRING teste
    NEWLINE
               
    mov EAX,4             ;file write
    mov EBX, 1      ;file deor
    mov ECX, teste        ;input buffer
    mov EDX,[lenmsg]  ;byte count
    int 0x80
    
    mov eax, 1
    int 0x80
    
    

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
      
    
    
    