#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

int main(int argc, char* argv[]) {
	double start, end, delta;
	double seuil = 0.002, maxval = 10.0;
	int nb_threads = 0;
	int n = 10;
	int m = 10;
	double t[12][12];
	double t1[12][12];
	int i, j;

	if(argc > 1) {
		nb_threads = atoi(argv[1]);
	}
	
	if(nb_threads < 1) {
		printf("Osti d'cri d'calisse, y'm faut au moins un thread moi\n");
		return -1;
	}

	omp_set_num_threads(nb_threads);
	
	
	#pragma omp parallel for
	for(i=0; i<n+2; i++) {
		//printf("%d %d\n", i, omp_get_thread_num());
		int j;
		for(j=0; j<m+2; j++) {
			if(i == 0 || j == 0 || i == n+1 || j == m+1) {
				t[i][j] = maxval;
				t1[i][j] = maxval;
			} else {
				t[i][j] = 0.0;
			}
		}
	}
	
	start = omp_get_wtime();
	
	do {
		delta = 0.0;
		//#pragma omp parallel for
		for(i=1; i<=n; i++) {
			for(j=1; j<=m; j++) {
				t1[i][j] = (t[i][j] + t[i+1][j] + t[i][j+1] + t[i-1][j] + t[i][j-1])/5;
				delta += abs(t[i][j] - t1[i][j]);
			}
		}
		printf("%lf\n", delta);
		#pragma omp parallel for
		for(i=1; i<=n; i++) {
			int j;
			for(j=1; j<=m; j++) {
				t[i][j] = t1[i][j];
			}
		}
	} while(delta > seuil);
	
	end = omp_get_wtime();
	
	
	return 0;
}
