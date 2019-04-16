#include<stdio.h>

int mult(int x, int y){
	int resultado = 0;
	for(int i = 0; i < y; i++){
		resultado = resultado + x;
	}
	return resultado;
}

int main(){
	
	int v[4] ={ 10 , 20 , 30, 40};
	int aux = v[0];
	int aux2 = v[0];
	
		
	for(int i = 1; i < 5; i++){
		aux = aux2;
		aux2 = v[i % 4];
		v[(i) % 4] = aux;
		
	}
	
	printf("Resultado: %d\n", v[0]);
	
	
}
