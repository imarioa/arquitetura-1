%include "io.inc"

section .data
matriz times 5 * 4 dd  0

section .bss
matrix resd 10 * 10
linha resd 1
coluna resd 1
matrix2 resd 10 * 10
linha2 resd 1
coluna2 resd 1

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    GET_DEC 4, [linha] ;n linhas
    GET_DEC 4, [coluna] ;m colunas

    mov ecx, [linha]
    mov eax, [coluna]

    
    mov ebx, matrix
    call ler_matriz
    call neg_matriz    
    call printar_matriz
    
    xor eax, eax
    ret

neg_matriz:
    ;parametro: ler_matriz(ebx)
    pushad
    ;eax = n total de colunas
    ;formula = endereço inicial + (Nº de COL * i + j) * 4
    mov esi, 0 ;j = indice das colunas
    mov edi, 0 ;i = indice das linhas
    ;ecx = n total de linhas
    
    .for1:
        push ecx
        mov ecx, eax
        mov edx, eax
        .for2:
            push edx ;Para guardar edx na pilha, pq a proxima instrução é uma multiplicação
            mul edi      ;eax = COL * i
            add eax, esi ;eax = COL * i + j
            push esi
            mov esi, [ebx + eax * 4]
            neg esi 
            mov [ebx + eax * 4], esi
            pop esi
            add esi, 1
            pop edx ;Retira o edx da pilha
            mov eax, edx ;Reseta o valor de eax para o valor inicial(Nº total de Colunas)
        loop .for2
        pop ecx
        mov esi, 0
        add edi, 1
    loop .for1
    popad
    ret
    
equals_matriz:
    ;recebe a matriz em ebx e a matriz em edi
    pushad
    cmp ecx, edx
    jg .false
    cmp eax, esi
    jg .false
    
    ;eax = n total de colunas
    ;formula = endereço inicial + (Nº de COL * i + j) * 4
    mov esi, 0 ;j = indice das colunas
    ;mov edi, 0 ;i = indice das linhas
    ;ecx = n total de linhas
    
    .for1:
        push ecx
        mov edx, eax
        dec eax
        mov ecx, eax
        inc eax
        .for2:
            push edx ;Para guardar edx na pilha, pq a proxima instrução é uma multiplicação            
            mul esi      ;eax = COL * i
            add eax, ecx ;eax = COL * i + j
            push esi
            mov esi, [edi + eax * 4]
            cmp esi,[ebx + eax * 4]
            pop esi 
            pop edx 
            jne .false
            mov eax, edx ;Reseta o valor de eax para o valor inicial(Nº total de Colunas)
            dec ecx
            cmp ecx, 0
        jge .for2
        pop ecx
        add esi, 1
        dec ecx
    jnz .for1
    
    popad
    mov eax, 1
    ret
    
       .false:
    pop ecx
    popad
    mov eax, 0
    ret
    

  
       
 
    
sub_matriz:
    ;recebe a matriz em ebx e a matriz em edi
    pushad
    cmp ecx, edx
    jg .fim
    cmp eax, esi
    jg .fim
    
    ;eax = n total de colunas
    ;formula = endereço inicial + (Nº de COL * i + j) * 4
    mov esi, 0 ;j = indice das colunas
    ;mov edi, 0 ;i = indice das linhas
    ;ecx = n total de linhas
    
    .for1:
        push ecx
        mov edx, eax
        dec eax
        mov ecx, eax
        inc eax
        .for2:
            push edx ;Para guardar edx na pilha, pq a proxima instrução é uma multiplicação            
            mul esi      ;eax = COL * i
            add eax, ecx ;eax = COL * i + j
            push esi
            mov esi, [edi + eax * 4]
            sub [ebx + eax * 4], esi
            pop esi 
           ; add esi, 1
            pop edx ;Retira o edx da pilha
            mov eax, edx ;Reseta o valor de eax para o valor inicial(Nº total de Colunas)
            dec ecx
            cmp ecx, 0
        jge .for2
        pop ecx
        add esi, 1
    loop .for1
    
    .fim:
    popad
    ret
       
soma_matriz:
    ;recebe a matriz em ebx e a matriz em edi
    pushad
    cmp ecx, edx
    jg .fim
    cmp eax, esi
    jg .fim
    
    ;eax = n total de colunas
    ;formula = endereço inicial + (Nº de COL * i + j) * 4
    mov esi, 0 ;j = indice das colunas
    ;mov edi, 0 ;i = indice das linhas
    ;ecx = n total de linhas
    
    .for1:
        push ecx
        mov edx, eax
        dec eax
        mov ecx, eax
        inc eax
        .for2:
            push edx ;Para guardar edx na pilha, pq a proxima instrução é uma multiplicação            
            mul esi      ;eax = COL * i
            add eax, ecx ;eax = COL * i + j
            push esi
            mov esi, [edi + eax * 4]
            add [ebx + eax * 4], esi
            pop esi 
           ; add esi, 1
            pop edx ;Retira o edx da pilha
            mov eax, edx ;Reseta o valor de eax para o valor inicial(Nº total de Colunas)
            dec ecx
            cmp ecx, 0
        jge .for2
        pop ecx
        add esi, 1
    loop .for1
    
    .fim:
    popad
    ret
    
ler_matriz:
    ;parametro: ler_matriz(ebx)
    pushad
    ;eax = n total de colunas
    ;formula = endereço inicial + (Nº de COL * i + j) * 4
    mov esi, 0 ;j = indice das colunas
    mov edi, 0 ;i = indice das linhas
    ;ecx = n total de linhas
    
    .for1:
        push ecx
        mov ecx, eax
        mov edx, eax
        .for2:
            push edx ;Para guardar edx na pilha, pq a proxima instrução é uma multiplicação
            mul edi      ;eax = COL * i
            add eax, esi ;eax = COL * i + j
            GET_DEC 4, [ebx + eax * 4] ;Faz a leitura e armazena em no endereço determinado pela fórmula endereço inicial + (Nº de COL * i + j) * 4 
            add esi, 1
            pop edx ;Retira o edx da pilha
            mov eax, edx ;Reseta o valor de eax para o valor inicial(Nº total de Colunas)
        loop .for2
        pop ecx
        mov esi, 0
        add edi, 1
    loop .for1
    popad
    ret
    
printar_matriz:
    ;Parametro: printar_matriz(ebx)
    pushad
    ;eax = n total de colunas
    ;formula = endereço inicial + (Nº de COL * i + j) * 4
    mov esi, 0 ;j = indice das colunas
    mov edi, 0 ;i = indice das linhas
    ;ecx = n total de linhas
    
    .for1:
        push ecx
        mov ecx, eax
        mov edx, eax
        .for2:
            push edx ;Para guardar edx na pilha, pq a proxima instrução é uma multiplicação
            mul edi ;eax = COL * i
            add eax, esi ;eax = COL * i + j
            add esi, 1
            PRINT_CHAR "["
            PRINT_DEC 4, [ebx + eax * 4]
            PRINT_CHAR "]"
            PRINT_CHAR " "
            pop edx
            mov eax, edx
            dec ecx
        jnz .for2
        pop ecx
        NEWLINE
        mov esi, 0
        add edi, 1
        dec ecx
    jnz .for1
    popad
    ret
    



           
    
    