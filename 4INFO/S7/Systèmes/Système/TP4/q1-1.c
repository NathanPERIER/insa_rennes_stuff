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

int shared, mutex, sem_r, sem_w;


void produce(int val, int* buf) {
	P(sem_w);
	P(mutex);
	buf[buf[SIZE_TAB]] = val;
	printf("%d <-- %d\n", buf[SIZE_TAB], val);
	buf[SIZE_TAB]++;
	V(mutex);
	V(sem_r);
}

void consume(int* buf) {
	int res;
	P(sem_r);
	P(mutex);
	buf[SIZE_TAB]--;
	res = buf[buf[SIZE_TAB]];
	printf("%d --> %d\n", buf[SIZE_TAB], res);
	V(mutex);
	V(sem_w);
}


int producer(int val) {
	int* buf = (int*) shmat(shared, NULL, 0);
	for(int i=0; i<10; i++) {
		produce(val, buf);
	}
}

int consumer() {
	int* buf = (int*) shmat(shared, NULL, 0);
	for(int i=0; i<5; i++) {
		consume(buf);
	}
}


int main(int argc, char** argv) {
	int status;

	shared = shmget(IPC_PRIVATE, (SIZE_TAB+1)*sizeof(int), IPC_CREAT | 0666);
	mutex = init(1);
	sem_r = init(0);
	sem_w = init(SIZE_TAB);
	
	int* buf = (int*) shmat(shared, NULL, 0);
	printf("%d %s\n", shared, (buf == NULL) ? "true" : "false");
	buf[SIZE_TAB] = 0;

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
	shmctl(shared, IPC_RMID, &b);
	destroy(mutex);
	destroy(sem_r);
	destroy(sem_w);
	return 0;
}


