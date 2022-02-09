#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>
#include <omp.h>

#define MAX 50

int main(int argc, char* argv[]) {
	double start, end;
	double seuil;
	int nb_threads, n;
	int convergeance = false;
	double *a, *b, *x, *next_x;
	
	srand(time(NULL));
	
	if(argc > 3) {
		nb_threads = atoi(argv[1]);
		omp_set_num_threads(nb_threads);
		n = atoi(argv[2]);
		seuil = strtod(argv[3], NULL);
	} else {
		printf("usage : %s <nb_threads> <n> <seuil>\n", argv[0]);
		return -1;
	}
	
	if(nb_threads < 1) {
		printf("Osti d'cri d'calisse, y'm faut au moins un thread moi\n");
		return -1;
	} 
	
	if(n < 1) {
		printf("Tabarnak n doit être plus grand q'zéro\n");
		return -1;
	}
	
	a = malloc(n*n*sizeof(double));
	b = malloc(n*sizeof(double));
	x = malloc(n*sizeof(double));
	next_x = malloc(n*sizeof(double));
		
	start = omp_get_wtime();
	
	#pragma omp parallel for
	for(unsigned long i = 0; i < n; i++) {
		for(unsigned long j = 0; j < n; j++) {
			if(j != i) {
				a[j*n+i] = (double) (2*MAX - rand() % MAX);
			}
			a[i*(n+1)] = (double) (n*(MAX + 1) + rand() % MAX);
		}
		x[i] = (double) (n*(MAX + 1) + rand() % MAX);
		b[i] = (double) (n*(MAX + 1) + rand() % MAX);
	}
	
	while(! convergeance) {
		#pragma omp parallel for
		for(unsigned long i = 0; i < n; i++) {
			double sigma = 0.0;
			for(unsigned long j = 0; j < n; j++) {
				if(j != i) {
					sigma += a[j*n+i] * x[j];
				}
			}
			next_x[i] = (b[i] - sigma) / a[i*(n+1)];
		}
		
		double* temp = x;
		x = next_x;
		next_x = temp;
		
		convergeance = true;
		
		#pragma omp parallel for
		for(unsigned long i = 0; i < n; i++) {
			double sum = 0;
			for(unsigned long j = 0; j < n; j++) {
				sum = a[j*n+i] * x[j];
			}
			sum = abs(sum - b[i]);
			#pragma omp critical
			{
				convergeance = convergeance && (sum < seuil);
			}
		}
	}
	
	end = omp_get_wtime();
	
	free(a);
	free(b);
	free(x);
	free(next_x);
	
	printf("\e[1;32m%lf\e[0m\n", end - start);
	
	return 0;
}

