#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <math.h>

int main(int argc, char* argv[]) {
	double start, end;
	int nb_threads, n;
	int *t;

	if(argc > 2) {
		nb_threads = atoi(argv[1]);
		omp_set_num_threads(nb_threads);
		n = atoi(argv[2]);
	} else {
		printf("usage : %s <nb_threads> <N>\n", argv[0]);
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
	
	t = malloc(n*sizeof(int));
	
	start = omp_get_wtime();
	
	#pragma omp parallel for
	for(int i = 0; i < n; i++) {
		t[i] = i;
	}

	int sqrt_n = (int)sqrt((double)n);
	
	//#pragma omp parallel for
	for(int i = 2; i <= sqrt_n; i++) {
		if(t[i] > 0) {
			#pragma omp parallel for
			for(int j = i*i; j < n; j += i) {
				t[j] = 0;
			}
		} 
	}
	
	int p = 0;
	for(int j = 0; j < n; j++) {
		if(t[j] > 0) {
			t[p] = t[j];
			//printf("%d\n", t[p]);
			p++;
		}
	}
	
	end = omp_get_wtime();
	
	free(t);
	
	printf("\e[1;32m%lf\e[0m\n", end - start);
	
	return 0;
}

