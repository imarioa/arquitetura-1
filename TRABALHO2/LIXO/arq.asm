%define BUFF_SIZE 1024

section .text


global _start

_start:

    
    mov eax, 4
    mov ebx, 0
    mov ecx, option
    mov edx, [tam]
    int 80h
    
    mov eax, 1
    int 80h
    
    
section .data
chave db '/home/Imario/Documentos/UFC/ARQ.I/TRABALHO2/chave.txt', 0
encriptado db '/home/Imario/Documentos/UFC/ARQ.I/TRABALHO2/encriptado.txt', 0
mensagem db '/home/Imario/Documentos/UFC/ARQ.I/TRABALHO2/mensagem.txt', 0
desencriptado db '/home/Imario/Documentos/UFC/ARQ.I/TRABALHO2/desencriptado.txt', 0
option db 'teste', 0
tam equ ($-option)