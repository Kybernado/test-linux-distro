#include <stdio.h>

int test_add(int a, int b);

int main(){
	int c = test_add(5, 3);
	printf("Result from lib add: %d\n", c);
	
	return 0;
}
