#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

// 1e8
#define NB_PAS 100000000
double PAS = 1.0 / (double)NB_PAS;


void* calc_part(void* args) {
	long* range = (long*) args;
	double x, sum_part = 0.0;
	double* res;
	printf("Started worker form %ld to %ld\n", range[0], range[1]);
	for(long i = range[0]; i < range[1]; i++) {
		x = (i+0.5) * PAS;
		sum_part += 4.0 / (1.0+x*x);
	}
	free(range);
	res = malloc(sizeof(double));
	res[0] = sum_part;
	return (void*) res;
}


int main(int argc, char** argv) { 
	int nb_workers;
	long per_worker, taken_care_of = 0L;
	double pi, sum = 0.0; 
	long* args;

	pthread_t* threads;
	pthread_attr_t attr;
	void* res;

	if(argc < 2) {
		printf("usage : %s <nb_workers>\n", argv[0]);
		return 1;
	}

	nb_workers = (int) strtol(argv[1], (char**)&res, 10);

	if(nb_workers <= 0) {
		printf("Invalid number of workers\n");
		return 1;
	}
	
	pthread_attr_init(&attr);
	threads = malloc(nb_workers * sizeof(pthread_t));
	per_worker = NB_PAS / nb_workers;

	for(int i = 0; i < nb_workers; i++) {
		args = malloc(2*sizeof(long));
		args[0] = taken_care_of;
		taken_care_of += per_worker;
		args[1] = (i == nb_workers-1) ? NB_PAS : taken_care_of;
		pthread_create(threads+i, &attr, calc_part, (void*)args);
	}

	for(int i = 0; i < nb_workers; i++) {
		pthread_join(threads[i], &res);
		sum += *((double*) res);
		free(res);
	}

	free(threads);

	pi = sum * PAS;
	printf("PI=%1.18f\n",pi);
	return 0;
}
