#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <mpi.h>


void printIntArray(int* arr, int length) {
	printf("[");
	for(int i = 0; i < length; i++) {
		printf("%d ", arr[i]);
	}
	printf("\b]\n");
}

void fillRandInt(int* arr, int length) {
	for(int i = 0; i < length; i++) {
		arr[i] = rand()%200 - 100;
	}
}


int main(int argc, char *argv[]) {
	int n, rank, size;
	int root = 0;
	int scaling = 100;
	int *v, *part, *part_res;
	int *mat, *res; 			// où mat est la transposée de la matrice 
	double begin, end;

	MPI_Status status;

	MPI_Init(&argc, &argv);
	srand(time(NULL));
	
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	n = scaling * size;

	part_res = (int*) malloc(n*sizeof(int));
	part = (int*) malloc(scaling*n*sizeof(int));
	v = (int*) malloc(n*sizeof(int));

	for(int i = 0; i < n; i++) {
		part_res[i] = 0;
	}

	if(rank == 0) {
		printf("Begin random initialization\n");
		mat = (int*) malloc(n*n*sizeof(int));
		fillRandInt(mat, n*n);
		res = (int*) malloc(n*sizeof(int));
		fillRandInt(v, n);
		printf("Begin computation procedure\n");
		begin = MPI_Wtime();
		for(int i = 1; i < size; i++) {
			MPI_Send(v, n, MPI_INT, i, 1, MPI_COMM_WORLD);
		}
	} else {
		MPI_Recv(v, n, MPI_INT, root, 1, MPI_COMM_WORLD, &status);
	}


	MPI_Scatter(mat, scaling*n, MPI_INT, part, scaling*n, MPI_INT, root, MPI_COMM_WORLD);

	for(int i = 0; i < scaling; i++) {
		int component = v[i + rank*scaling];
		for(int j = 0; j < n; j++) {
			part_res[j] += component * part[i*scaling + j];
		}
	}

	MPI_Reduce(part_res, res, n, MPI_INT, MPI_SUM, root, MPI_COMM_WORLD);


	if(rank == 0) {
		end = MPI_Wtime();
		printf("End computation procedure\n");
		printIntArray(res, n);
		printf("Computation time : %lfs\n", end - begin);
		free(mat);
		free(res);
	}

	free(v);
	free(part);
	free(part_res);
	
	
	MPI_Finalize();
	
	return(0);
}


