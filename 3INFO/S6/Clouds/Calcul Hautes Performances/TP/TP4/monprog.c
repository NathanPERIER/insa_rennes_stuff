#include <stdio.h>
#include <mpi.h>
#include <unistd.h>

int main(int argc, char *argv[])
  {
    int rank, size;
    char hostname[1024];
    hostname[1023]='\0';
    gethostname(hostname, 1023);
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    MPI_Comm_size(MPI_COMM_WORLD,&size);

    printf("Hello wold from node %d on machine %s of %d nodes\n", rank, hostname, size);
    MPI_Finalize();
    printf("Fini\n");
    return(0);
  }
