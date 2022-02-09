#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <mpi.h>


void printDoubleArray(double* arr, int length) {
	printf("[");
	for(int i = 0; i < length; i++) {
		printf("%lf ", arr[i]);
	}
	printf("\b]\n");
}


double abs_d(double x) {
	return (x >= 0) ? x : (-1*x);
}


int main(int argc, char *argv[]) {
	int n, m, rank, size;
	int root = 0;
	int scaling_x = 2;
	int scaling_y = 1;
	double max_val = 500;
	double threshold = 0.2;
	double *mat, *part, *next, *temp;
	double delta, part_delta;
	double begin, end;

	MPI_Status status;

	MPI_Init(&argc, &argv);
	srand(time(NULL));
	
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	n = scaling_x * size;
	m = scaling_y * size;

	part = (double*) malloc((scaling_x+2)*m*sizeof(double));
	next = (double*) malloc((scaling_x+2)*m*sizeof(double));


	if(rank == 0) {
		printf("Begin random initialization\n");
		mat = (double*) malloc((n+2)*m*sizeof(double));
		for(int i = 1; i <= n; i++) {
			int lineoffset = m*i;
			mat[lineoffset] = max_val;
			for(int j = 1; j < m-1; j++) {
				mat[lineoffset + j] = 0;
			}
			mat[lineoffset + m-1] = max_val;
		}
		for(int j = 0; j < m; j++) {
			mat[j] = max_val;
			part[j] = max_val;
			mat[m*(n+1)+j] = max_val;
		}
		printf("Begin computation procedure\n");
		begin = MPI_Wtime();
		MPI_Send(mat + m*(n+1), m, MPI_DOUBLE, size-1, 1, MPI_COMM_WORLD);
	}

	MPI_Scatter(mat + m, scaling_x*m, MPI_DOUBLE, part + m, scaling_x*m, MPI_DOUBLE, root, MPI_COMM_WORLD);
	
	if(rank == size-1) {
		MPI_Recv(part + m*(scaling_x+1), m, MPI_DOUBLE, root, 1, MPI_COMM_WORLD, &status);
	}
	
	if(rank == 2) {
		printDoubleArray(part, (scaling_x+2)*m);
	}

	do {
		if(rank > 0) {
			MPI_Send(part + m, m, MPI_DOUBLE, rank-1, 2, MPI_COMM_WORLD);
		}
		if(rank < size-1) {
			MPI_Send(part + m*(scaling_x), m, MPI_DOUBLE, rank+1, 3, MPI_COMM_WORLD);
		}
		if(rank > 0) {
			MPI_Recv(part, m, MPI_DOUBLE, rank-1, 3, MPI_COMM_WORLD, &status);
		}
		if(rank < size-1) {
			MPI_Recv(part + m*(scaling_x+1), m, MPI_DOUBLE, rank+1, 2, MPI_COMM_WORLD, &status);
		}
		part_delta = 0;
		for(int i = 1; i < n+1; i++) {
			for(int j = 1; j < m-1; j++) {
				next[i*m+j] = (part[i*m+j]+part[(i+1)*m+j]+part[(i-1)*m+j]+part[i*m+j+1]+part[i*m+j-1])/5;
				part_delta += abs_d(next[i*m+j] - part[i*m+j]);
			}
		}
		//MPI_Reduce(&part_delta, &delta, 1, MPI_DOUBLE, MPI_SUM, root, MPI_COMM_WORLD);
		//MPI_Bcast(&delta, 1, MPI_DOUBLE, root, MPI_COMM_WORLD);
		MPI_Allreduce(&part_delta, &delta, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);
		temp = part;
		part = next;
		next = temp;
		break;
	} while(delta > threshold);
	
	/*if(rank == 2) {
		printDoubleArray(part, (scaling_x+2)*m);
	}*/
	//MPI_Gather(part + m, scaling_x*m, MPI_DOUBLE, mat + m, scaling_x*m, MPI_DOUBLE, root, MPI_COMM_WORLD);


	if(rank == 0) {
		end = MPI_Wtime();
		printf("End computation procedure\n");
		printf("Computation time : %lfs\n", end - begin);
		free(mat);
	}

	//free(part);
	//free(next);
	
	
	MPI_Finalize();
	
	return 0;
}


