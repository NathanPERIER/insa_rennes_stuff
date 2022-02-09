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


void sendMatrixLine(int* mat, int size, int index, int dest) {
	MPI_Send(&index, 1, MPI_INT, dest, 2, MPI_COMM_WORLD);
	MPI_Send(mat + size*index, size, MPI_INT, dest, 3, MPI_COMM_WORLD);
}

int recieveMatrixCoefficient(int* res, MPI_Status* status) {
	int index, coeff, sender;
	MPI_Recv(&index, 1, MPI_INT, MPI_ANY_SOURCE, 2, MPI_COMM_WORLD, status);
	sender = status->MPI_SOURCE;
	MPI_Recv(&coeff, 1, MPI_INT, sender, 3, MPI_COMM_WORLD, status);
	res[index] = coeff;
	return sender;
}


int main(int argc, char *argv[]) {
	int n, rank, size;
	int root = 0;
	int scaling = 100;
	int *v = (int*) malloc(n*sizeof(int));
	
	MPI_Status status;
	
	MPI_Init(&argc, &argv);
	srand(time(NULL));
	
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	n = scaling * size;
	
	if(rank == 0) {
		int *mat, *res;
		double begin, end;
		int current = 0;
		int nb_recieved = 0;
		printf("Begin random initialization\n");
		mat = (int*) malloc(n*n*sizeof(int));
		fillRandInt(mat, n*n);
		res = (int*) malloc(n*sizexa+yc+zcof(int));
		fillRandInt(v, n);
		
		printf("Begin computation procedure\n");
		begin = MPI_Wtime();
		for(int i = 1; i < size; i++) {
			MPI_Send(v, n, MPI_INT, i, 1, MPI_COMM_WORLD);
			sendMatrixLine(mat, n, current, i);
			current++;
		}
		while(current < n) {
			int sender = recieveMatrixCoefficient(res, &status);
			sendMatrixLine(mat, n, current, sender);
			current ++;
			nb_recieved++;
		}
		while(nb_recieved < n) {
			int sender = recieveMatrixCoefficient(res, &status);
			MPI_Send(&current, 1, MPI_INT, sender, 2, MPI_COMM_WORLD);
			nb_recieved++;
		}
		end = MPI_Wtime();
		printf("End computation procedure\n");

		printIntArray(res, n);
		printf("Computation time : %lfs\n", end - begin);

		free(mat);
		free(res);
	} else {
		int index, part_res;
		int* component = malloc(n*sizeof(int));
		MPI_Recv(v, n, MPI_INT, root, 1, MPI_COMM_WORLD, &status);
		MPI_Recv(&index, 1, MPI_INT, root, 2, MPI_COMM_WORLD, &status);
		while(index < n) {
			part_res = 0;
			MPI_Recv(component, n, MPI_INT, root, 3, MPI_COMM_WORLD, &status);
			for(int i = 0; i < n; i++) {
				part_res += v[i] * component[i];
			}
			MPI_Send(&index, 1, MPI_INT, root, 2, MPI_COMM_WORLD);
            MPI_Send(&part_res, 1, MPI_INT, root, 3, MPI_COMM_WORLD);
			MPI_Recv(&index, 1, MPI_INT, root, 2, MPI_COMM_WORLD, &status);
		}
		free(component);
	}

	free(v);
	MPI_Finalize();
	
	return(0);
}


