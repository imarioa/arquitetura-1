
#include<stdio.h>
#include<string.h>

char cifra(char c, char chave){
    char cifra = ((c  + chave) % 26) + 65;

    printf("Crip: %c\n", cifra);
return cifra;
}
char decifra(char c, char chave){
    char cifra = (((c  - chave)+26) % 26) + 65;

    printf("Crip: %c\n", cifra);
return cifra;
}
int main(){
    char c = 'B';
    char chave = 'I'; 
    char k = decifra(c,chave);
}
