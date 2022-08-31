#include "sema4.h"

#include <stdio.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <unistd.h>

#define NB_PRODUCERS 2
#define NB_CONSUMERS 4
#define SIZE_TAB 5

int shr_buf, shr_cpt, mutex_r, mutex_w, sem_r, sem_w;


int findIndex(int* cpt, int val) {
	for(int i=0; i<SIZE_TAB; i++) {
		if(cpt[i]==val) {
			return i;
		}
	}
	return -1;
}

void produce(int val, int* buf, int* cpt) {
	int i;
	P(sem_w);
	P(mutex_w);
	i = findIndex(cpt, 0);
	cpt[i] = -1;
	V(mutex_w);
	buf[i] = val;
	printf("%d <-- %d\n", i, val);
	cpt[i] = 1;
	V(sem_r);
}

void consume(int* buf, int* cpt) {
	int res, i;
	P(sem_r);
	P(mutex_r);
	i = findIndex(cpt, 1);
	cpt[i] = -2;
	V(mutex_r);
	res = buf[i];
	printf("%d --> %d\n", i, res);
	cpt[i] = 0;
	V(sem_w);
}


int producer(int val) {
	int* buf = (int*) shmat(shr_buf, NULL, 0);
	int* cpt = (int*) shmat(shr_cpt, NULL, 0);
	for(int i=0; i<10; i++) {
		produce(val, buf, cpt);
	}
}

int consumer() {
	int* buf = (int*) shmat(shr_buf, NULL, 0);
	int* cpt = (int*) shmat(shr_cpt, NULL, 0);
	for(int i=0; i<5; i++) {
		consume(buf, cpt);
	}
}


int main(int argc, char** argv) {
	int status;

	shr_buf = shmget(IPC_PRIVATE, SIZE_TAB*sizeof(int), IPC_CREAT | 0666);
	shr_cpt = shmget(IPC_PRIVATE, SIZE_TAB*sizeof(int), IPC_CREAT | 0666);
	mutex_r = init(1);
	mutex_w = init(1);
	sem_r = init(0);
	sem_w = init(SIZE_TAB);

	int* cpt = (int*) shmat(shr_cpt, NULL, 0);
	for(int i=0; i<SIZE_TAB; i++) {
		cpt[i] = 0;
	}
	
	for(int i=0; i<NB_PRODUCERS; i++) {
		if(!fork()) {
			producer(i+1);
			exit(0);
		}
	}

	for(int i=0; i<NB_CONSUMERS; i++) {
		if(!fork()) {
			consumer();
			exit(0);
		}
	}

	for(int i=0; i<NB_PRODUCERS+NB_CONSUMERS; i++) {
		wait(&status);
	}

	struct shmid_ds b;
	shmctl(shr_buf, IPC_RMID, &b);
	shmctl(shr_cpt, IPC_RMID, &b);
	destroy(mutex_r);
	destroy(mutex_w);
	destroy(sem_r);
	destroy(sem_w);
	return 0;
}


