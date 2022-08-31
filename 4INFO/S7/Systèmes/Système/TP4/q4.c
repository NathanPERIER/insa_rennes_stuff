#include "sema4.h"

#include <stdio.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <unistd.h>

#define NB_READERS 5
#define NB_WRITERS 2

int shr_cpt, mutex_cpt, sem_file, sem_r;


void read_file(int* cpt) {
	P(mutex_cpt);
	if(cpt[0]) {
		V(mutex_cpt);
	} else {
		cpt[1]++;
		if(cpt[1] == 1) {
			V(mutex_cpt);
			P(sem_file);
			P(mutex_cpt);
			for(int i=1; i<cpt[1]; i++) {
				V(sem_r);
			}
			cpt[1] = 0;
			V(mutex_cpt);
		} else {
			V(mutex_cpt);
			P(sem_r);
		}
	}
	P(mutex_cpt);
	cpt[0]++;
	V(mutex_cpt);
	printf("R Begin\n");
	sleep(1);
	printf("R End\n");
	P(mutex_cpt);
	cpt[0]--;
	if(!cpt[0]) {
		V(sem_file);
	}
	V(mutex_cpt);
}

void reader() {
	int* cpt = (int*) shmat(shr_cpt, NULL, 0);
	for(int i=0; i<3; i++) {
		read_file(cpt);
	}
}


void write_file() {
	P(sem_file);
	printf("W Begin\n");
	sleep(2);
	printf("W End\n");
	V(sem_file);
}

void writer() {
	for(int i=0; i<5; i++) {
		write_file();
	}
}


int main(int argc, char** argv) {
	int status;

	shr_cpt = shmget(IPC_PRIVATE, 2*sizeof(int), IPC_CREAT | 0666);
	mutex_cpt = init(1);
	sem_file = init(1);
	sem_r = init(0);

	int* cpt = (int*) shmat(shr_cpt, NULL, 0);
	cpt[0] = 0;
	cpt[1] = 0;

	for(int i=0; i<NB_WRITERS; i++) {
		if(!fork()) {
			writer();
			exit(0);
		}
	}

	for(int i=0; i<NB_READERS; i++) {
		if(!fork()) {
			reader();
			exit(0);
		}
	}

	for(int i=0; i<NB_READERS+NB_WRITERS; i++) {
		wait(&status);
	}

	struct shmid_ds b;
	shmctl(shr_cpt, IPC_RMID, &b);
	destroy(mutex_cpt);
	destroy(sem_file);
	destroy(sem_r);
	return 0;
}


