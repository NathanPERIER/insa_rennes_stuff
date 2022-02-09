#include <stdio.h>
#include <omp.h>

int main() {
	omp_set_num_threads(10);
	
	#pragma omp parallel
	{
		int n = omp_get_thread_num();
		int i;
		for(i=n*10; i < (n+1)*10; i++) {
			printf("Thread %d : %d\n", n, i);
		}
	}
	
	return 0;
}
