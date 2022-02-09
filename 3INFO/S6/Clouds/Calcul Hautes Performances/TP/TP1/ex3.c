#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

int main(int argc, char* argv[]) {
	long thread_steps, i, nb_pas = 100000000; // 10^8
	double start, end, pi, som = 0.0;
	double pas = 1.0 / (double)nb_pas;
	int nb_threads = 0;
	
	if(argc > 1) {
		nb_threads = atoi(argv[1]);
	}
	
	if(nb_threads < 1) {
		printf("Osti d'cri d'calisse, j'y met combien de threads moi ?\n"); 
		return -1;
	}
	
	omp_set_num_threads(nb_threads);
	thread_steps = nb_pas / (long)nb_threads;
	//printf("%d\n", thread_steps);
	//printf("%ld\n", (long)thread_steps*nb_threads);
	
	start = omp_get_wtime();
	
	#pragma omp parallel
	{
		double x, s = 0.0;
		int n = omp_get_thread_num();
		long i;
		for (i=thread_steps*n; i<thread_steps*(n+1); i++) {
			x = (i+0.5) * pas;
			s += 4.0 / (1.0+x*x);
		}
		#pragma omp atomic
		som += s;
	}
	
	end = omp_get_wtime();
	
	pi = pas * som; 
	printf("PI = %f\n",pi);
	
	printf("%lfs\n", end - start);
	
	return 0;
}
