#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

int main(int argc, char* argv[]) {
	double start, end, delta;
	double seuil, valmax;
	int nb_threads, n, m, i;
	double *t, *t1;

	if(argc > 5) {
		nb_threads = atoi(argv[1]);
		omp_set_num_threads(nb_threads);
		n = atoi(argv[2]);
		m = atoi(argv[3]);
		valmax = strtod(argv[4], NULL);
		seuil = strtod(argv[5], NULL);
	} else {
		printf("usage : %s <nb_threads> <N> <M> <MAX> <seuil>\n", argv[0]);
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
	
	if(m < 1) {
		printf("Tabarnak m doit être plus grand q'zéro\n");
		return -1;
	}

	if(valmax == 0) {
		printf("Mais calisse, donne-moi un max non nul là\n");
		return -1;
	}

	t = malloc((n+2)*(m+2)*sizeof(double));
	t1 = malloc((n+2)*(m+2)*sizeof(double));
	
	start = omp_get_wtime();
	
	#pragma omp parallel for
	for(i=0; i<n+2; i++) {
		int j;
		for(j=0; j<m+2; j++) {
			if(i == 0 || j == 0 || i == n+1 || j == m+1) {
				t[j*(n+2)+i]  = valmax;
				t1[j*(n+2)+i] = valmax;
			} else {
				t[j*(n+2)+i] = 0.0;
			}
		}
	}
	
	do {
		delta = 0.0;
		#pragma omp parallel for
		for(i=1; i<=n; i++) {
			int j;
			double mydelta = 0.0;
			for(j=1; j<=m; j++) {
				t1[j*(n+2)+i] = (t[j*(n+2)+i] + t[j*(n+2)+i+1] + t[(j+1)*(n+2)+i] 
												+ t[j*(n+2)+i-1] + t[(j-1)*(n+2)+i])/5;
				mydelta += abs(t[j*(n+2)+i] - t1[j*(n+2)+i]);
			}
			#pragma omp atomic
			delta += mydelta;
		}
		printf("%lf\n", delta);
		#pragma omp parallel for
		for(i=1; i<=n; i++) {
			int j;
			for(j=1; j<=m; j++) {
				t[j*(n+2)+i] = t1[j*(n+2)+i];
			}
		}
	} while(delta > seuil);
	
	end = omp_get_wtime();
	
	free(t);
	free(t1);
	
	printf("\e[1;32m%lf\n", end - start);
	
	return 0;
}

