%include "io.inc"

section .data
soma dd 0
vet dd 1,2,3

section .bss

matrix resd 10 * 10
linha resd 1
coluna resd 1

matrix2 resd 10 * 10
linha2 resd 1
coluna2 resd 1

matrix3 resd 10 * 10

matr resd 100

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    GET_DEC 4, [linha] ;n linhas
    GET_DEC 4, [coluna] ;m colunas
    ;GET_DEC 4, [linha2] ;n linhas
    ;GET_DEC 4, [coluna2] ;m colunas
       
    mov ecx, [linha]
    mov eax, [coluna]
    ;mov edx, [linha2]
    ;mov edi, [coluna2]
   
    
    mov ebx, matrix
    call ler_matriz
    ;push ebx
    ;mov ebx, matrix2
    ;push eax
    ;push ecx
    ;mov eax, [coluna2]
    ;mov ecx, [linha2]
    ;call ler_matriz
    ;pop ecx
   ; pop eax
    ;pop ebx
    ;mov esi, matrix2
    mov esi, vet
    call mul_vet
    mov ebx, ebp
    
    ;mov ebx, edi
    ;mov ecx, 4
    mov eax, 1
    
        
    call printar_matriz
    
    xor eax, eax
    ret
    
mul_matriz:
    ;parametro: mul_matriz(matriz A: ebx, matriz B: esi)
    ;nºlinhas matriz A: ecx
    ;nºcolunas matriz A: eax
    ;nºlinhas matriz B: edx
    ;nºcolunas matriz B: edi
    pushad
    cmp eax,edx
    jne .false
    ;formula = endereço inicial + (Nº de COL * i + j) * 4
    mov ebp, ecx
    mov ecx, edi ;mover para o ecx o nº de colunas da matriz B
    mov edi, ebp
    mov ebp, 0
    .for3:
        push edi
        push ecx
        mov ecx, edi ;mover para o ecx o nº de linhas da matriz A
        mov edi, 0
        .for1:
            ;O for1 é usado para andar com a colunas da mat B    
            push ecx
            mov ecx, eax
            mov edx, eax ;Guadar o valor o nº de colunas, que é usado na formula(COL * i + j)
            dec ecx
            ;Antes de toda a multiplicação o edx é colocado na pilha e em seguida é tirado
            ;O for2 faz a soma de uma linha da mat A com uma coluna da mat B
            .for2:
                push edx 
                mul edi      ;eax = COL * i
                pop edx
                add eax, ecx ;eax = COL * i + j
                push ebx
                mov ebx, [ebx + eax * 4]
                mov eax, [coluna2]
                push edx
                mul ecx ; eax = COL * i , aqui tem que ser o ecx, pq é ele que vai variar
                pop edx
                add eax, ebp ;ebp é usado para andar as colunas somente no quando for para o for3
                push ebp
                mov ebp, [esi + eax * 4] ;esi = endereço da matriz 2
                push eax
                mov eax, ebx ;move o valor da posição (ebx + eax * 4) para eax
                push edx
                mul ebp
                pop edx 
                add eax, [soma]
                mov [soma], eax
                pop eax
                pop ebp
                pop ebx          
                mov eax, edx ;Reseta o valor de eax para o valor inicial(Nº total de Colunas)
                dec ecx
                cmp ecx, 0
            jge .for2
            ;Armazenando na matriz resultado
            ;Armazena coluna por coluna
            push eax
            push edx
            mov eax, [coluna2]
            mul edi 
            pop edx
            add eax, ebp
            push ecx
            mov ecx, [soma]
            mov [matrix3 + eax * 4], ecx
            mov ecx, 0
            mov [soma], ecx
            pop ecx
            pop eax
            inc edi
            pop ecx
        loop .for1
        inc ebp
        pop ecx
        pop edi
    loop .for3
    .false:
    popad
    ret

mul_vet:
    ;parametro: mul_vet(matriz A: ebx, vetor: esi)
    ;nºlinhas matriz A: ecx
    ;nºcolunas matriz A: eax
    pushad
    ;formula = endereço inicial + (Nº de COL * i + j) * 4
    mov edi, 0 
    .for1:
    
        push ecx
        mov ecx, eax
        mov edx, eax ;Guadar o valor o nº de colunas, que é usado na formula(COL * i + j)
        dec ecx
        ;Antes de toda a multiplicação o edx é colocado na pilha e em seguida é tirado
        .for2:
            push edx
            mul edi      ;eax = COL * i
            pop edx
            add eax, ecx ;eax = COL * i + j
            push ebx
            mov ebx, [ebx + eax * 4]
            mov ebp, [esi + ecx * 4] ;percorrendo vetor normalmente
            push eax
            mov eax, ebx
            push edx
            mul ebp
            pop edx 
            add eax, [soma]
            mov [soma], eax
            pop eax
            pop ebx            
            mov eax, edx ;Reseta o valor de eax para o valor inicial(Nº total de Colunas)
            dec ecx
            cmp ecx, 0
        jge .for2
        push eax
        mov eax, [soma]
        mov [matr + edi * 4], eax
        mov eax, 0
        mov [soma], eax
        pop eax
        inc edi
        pop ecx
    loop .for1
    popad
    mov ebp, matr
    ret
transposta:
    ;recebe a matriz em ebx e a retorna a matriz transposta em edi
    pushad   
    ;eax = n total de colunas
    ;ecx = n total de linhas e indice das colunas 
    ;formula = endereço inicial + (Nº de COL * i + j) * 4
    mov esi, 0 ;j = indice das colunas      
    mov edx, ecx ; move para edx o numero total de linhas
    .for1:
        push ecx
        mov ecx, eax ;move para ecx, o número de colunas
        dec ecx
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