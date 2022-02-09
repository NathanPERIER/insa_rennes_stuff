#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

double f(double x) {
	return (4 / (1 + x*x));
}

int main(int argc, char** argv) {
	int n = 0;
	int nproc, rg;
	double pi = 0;
	int start, end;
	
	MPI_Status stat;

	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rg);
	MPI_Comm_size(MPI_COMM_WORLD, &nproc);
	
	if(rg == 0) {
		if(argc > 1) {
			n = atoi(argv[1]);
		}
		if(n > 0) {
			int step = n/nproc;
			for(int i = 1; i < nproc; i++) {
				start = (i-1)*step;
				end = start + step;
				MPI_Send(&n, 1, MPI_INT, i, 2, MPI_COMM_WORLD);
				MPI_Send(&start, 1, MPI_INT, i, 0, MPI_COMM_WORLD);
				MPI_Send(&end, 1, MPI_INT, i, 1, MPI_COMM_WORLD);
			}
			start = (nproc - 1) * step;
			end = n;
		} else {
			for(int i = 1; i < nproc; i++) {
				MPI_Send(&n, 1, MPI_INT, i, 2, MPI_COMM_WORLD);
			}
			printf("Osti d'calisse, j'y met combien de termes dans ma somme moi ?\n");
			return -1;
		}
	} else {
		MPI_Recv(&n, 1, MPI_INT, 0, 2, MPI_COMM_WORLD, &stat);
		if(n > 0) {
			MPI_Recv(&start, 1, MPI_INT, 0, 0, MPI_COMM_WORLD, &stat);
			MPI_Recv(&end, 1, MPI_INT, 0, 1, MPI_COMM_WORLD, &stat);
		} else {
			return -1;
		}
	}

	printf("Process %d starting (%d - %d)\n", rg, start, end);
	
	for(int i = start; i < end; i++) {
		pi += (f((double)(i+1)/(double)n) + f((double)i/(double)n));
	}

	if(rg == 0) {
		double sum;
		for(int i = 1; i < nproc; i++) {
			MPI_Recv(&sum, 1, MPI_INT, i, 10, MPI_COMM_WORLD, &stat);
			pi += sum;
		}
		pi /= (double)(2*n);
		printf("pi = %lf\n", pi);
	} else {
		MPI_Send(&pi, 1, MPI_INT, 0, 10, MPI_COMM_WORLD);
	}
	
	MPI_Finalize();

	return 0;
}
