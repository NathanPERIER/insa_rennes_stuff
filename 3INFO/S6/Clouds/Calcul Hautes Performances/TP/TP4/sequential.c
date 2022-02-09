#include <stdio.h>
#include <stdlib.h>

double f(double x) {
	return (4 / (1 + x*x));
}

int main(int argc, char** argv) {
	int n = 0;
	double pi;

	if(argc > 1) {
		n = atoi(argv[1]);
	}

	if(n == 0) {
		printf("Osti d'calisse, j'y met combien de termes dans ma somme moi ?\n");
		return -1;
	}
	
	for(int i = 1; i <= n; i++) {
		pi += (f((double)(i+1)/(double)n) + f((double)i/(double)n));
	}

	pi /= (double)(2*n);

	printf("%lf\n", pi);

	return 0;
}
