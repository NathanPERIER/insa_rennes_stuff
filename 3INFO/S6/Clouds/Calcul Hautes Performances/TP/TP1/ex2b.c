#include <stdio.h>
#include <omp.h>

int main() {
	int i;
	omp_set_num_threads(10);

	#pragma omp parallel for
	for(i=0; i<100; i++) {
		int n = omp_get_thread_num();
		printf("Thread %d : %d\n", n, i);
	}
	
	return 0;
}
