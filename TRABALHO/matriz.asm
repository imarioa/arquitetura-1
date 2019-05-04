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

matrix3 resd 10 * 10

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    GET_DEC 4, [linha] ;n linhas
    GET_DEC 4, [coluna] ;m colunas
    ;GET_DEC 4, [linha2] ;n linhas
    ;GET_DEC 4, [coluna2] ;m colunas
    
    ;mov edx, [linha2]
    mov ecx, [linha]
    ;mov esi, [coluna2]
    mov eax, [coluna]
    
    ;mov edi, matrix2
    mov ebx, matrix
    call ler_matriz
    ;push ebx
    ;mov ebx, edi
    mov edi, matrix3
    call transposta
    ;pop ebx
    mov ebx, edi
    mov ecx, [coluna]
    mov eax, [linha]
    ;call mult_matriz   
    call printar_matriz
    
    xor eax, eax
    ret

transposta:
    ;recebe a matriz 1 em ebx e a matriz 2 em edi
    pushad   
    ;eax = n total de colunas
    ;formula = endereço inicial + (Nº de COL * i + j) * 4
    mov esi, 0 ;j = indice das colunas
   
    ;ecx = n total de linhas e indice das colunas   
    mov edx, ecx ; move para edx o numero total de linhas
    .for1:
        push ecx
        dec eax
        mov ecx, eax
        inc eax
        mov ebp, eax
        .for2:
            ;antes de toda a multiplicação é usado o push edx para preservar o valor de edx
            ;nesse loop o ecx é tratado como indice das colunas
            push ebp ;Para guardar edx na pilha, pq a proxima instrução é uma multiplicação 
            push edx           
            mul esi      ;eax = COL * i
            pop edx
            add eax, ecx ;eax = COL * i + j
            push ebx
            mov ebx, [ebx + eax * 4]
            mov eax, edx ;eax recebe o numero de linhas 
            push edx         
            mul ecx ;eax = COL * j
            pop edx
            add eax, esi ; eax = COL * j + i
            mov [edi + eax * 4], ebx
            pop ebx
            pop ebp ;Retira o edx da pilha
            mov eax, ebp ;Reseta o valor de eax para o valor inicial(Nº total de Colunas)            
            dec ecx
            cmp ecx, 0
        jge .for2
        pop ecx
        add esi, 1
    loop .for1    
    .fim:
    popad
    ret           
            
         
mult_escalar:

    ;mult_escalar: mult_escalar(ebx, edi) edi = escalar
    pushad
    ;eax = n total de colunas
    ;ecx = n total de linhas
    mov esi, 0 ;esi = interador
    
    mul ecx ; eax = eax(colunas) * ecx(linhas)
    mov ecx, eax ;ecx = linhas x colunas
    
    .for1:
        mov eax, [ebx + esi]
        mul edi
        mov [ebx + esi], eax
        add esi, 4
    loop .for1
    popad
    ret


mult_matriz:
    ;parametro matriz1(ebx) matriz2(edi)
    pushad
    cmp eax,edx
    jne .false
    
    mov edx, 0
    mov eax, 0
    ;eax, ebx, ecx, edx, esp, ebp, esi, edi
    
    ;i = esi
    ;j = edx
    
    ;linha matriz 1 = ecx
    ;coluna matriz 2 = esi
    
    .for1:
        push ecx
        mov ecx, esi
        push esi
        .for2:
            push ecx
            mov ecx, eax
            mov edx, eax
            .for3:
                push edx ;Para guardar edx na pilha, pq a proxima instrução é uma multiplicação
                mul esi      ;eax = COL(eax) * i
                add eax, ecx ;eax = COL(eax) * i + j
                push esi
                mov esi, [ebx + eax * 4]
                mul ecx
                mov edx, eax
                pop eax
                add edx, eax
                push eax
                mov eax, [edi + eax * 4]
                mul esi
                
                pop edx ;Retira o edx da pilha
                mov eax, edx ;Reseta o valor de eax para o valor inicial(Nº total de Colunas)
    .false:
    popad
    ret
        
neg_matriz:
     ;neg_matriz: neg_matriz(ebx)
    pushad
    ;eax = n total de colunas
    ;ecx = n total de linhas
    mov esi, 0 ;interador
    mul ecx ;eax = ecx(linhas) * eax(colunas)
    mov ecx, eax ;ecx = linhas x colunas
    
    .for1:
        mov eax, [ebx + esi]
        neg eax
        mov [ebx + esi], eax
        add esi, 4
    loop .for1
    popad
    ret
    
equals_matriz:
    ;recebe a matriz 1 em ebx e a matriz 2 em edi
    pushad
    cmp ecx, edx
    jg .false
    cmp eax, esi
    jg .false
    
    ;eax = n total de colunas
    ;formula = endereço inicial + (Nº de COL * i + j) * 4
    mov esi, 0 ;j = indice das colunas
    
    ;ecx = n total de linhas e indice das colunas
    
    .for1:
        push ecx
        mov edx, eax
        dec eax
        mov ecx, eax
        inc eax
        .for2:
            ;o registrador ecx é tratado como indice das colunas(j)
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
    ;recebe a matriz 1 em ebx e a matriz 2 em edi
    pushad
    cmp ecx, edx
    jg .fim
    cmp eax, esi
    jg .fim
    
    ;eax = n total de colunas
    ;formula = endereço inicial + (Nº de COL * i + j) * 4
    mov esi, 0 ;j = indice das colunas
    ;ecx = n total de linhas e indice das colunas   
    .for1:
        push ecx
        mov edx, eax
        dec eax
        mov ecx, eax
        inc eax
        .for2:
            ;nesse loop o ecx é tratado como indice das colunas
            push edx ;Para guardar edx na pilha, pq a proxima instrução é uma multiplicação            
            mul esi      ;eax = COL * i
            add eax, ecx ;eax = COL * i + j
            push esi
            mov esi, [edi + eax * 4]
            sub [ebx + eax * 4], esi
            pop esi 
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
    ;recebe a matriz 1 em ebx e a matriz 2 em edi
    pushad
    cmp ecx, edx
    jg .fim
    cmp eax, esi
    jg .fim    
    ;eax = n total de colunas
    ;formula = endereço inicial + (Nº de COL * i + j) * 4
    mov esi, 0 ;j = indice das colunas
    ;ecx = n total de linhas e indice das colunas    
    .for1:
        push ecx
        mov edx, eax
        dec eax
        mov ecx, eax
        inc eax
        .for2:
            ;nesse loop o ecx é tratado como indice das colunas
            push edx ;Para guardar edx na pilha, pq a proxima instrução é uma multiplicação            
            mul esi      ;eax = COL * i
            add eax, ecx ;eax = COL * i + j
            push esi
            mov esi, [edi + eax * 4]
            add [ebx + eax * 4], esi
            pop esi 
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
    



           
    
    