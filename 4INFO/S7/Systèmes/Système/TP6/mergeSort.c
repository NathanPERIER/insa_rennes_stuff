#include <stdio.h>
#include <string.h> // memcpy
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <wait.h>

#define SIZE_TAB 100

int shr_buf;

void print_tab(int* tab) {
	printf("[");
	if(SIZE_TAB > 0) {
		printf("%d", tab[0]);
	}
	for(int i=1; i < SIZE_TAB; i++) {
		printf(", %d", tab[i]);
	}
	printf("]\n");
}

void init_tab() {
	srand(time(NULL));
	shr_buf = shmget(IPC_PRIVATE, SIZE_TAB*sizeof(int), IPC_CREAT | 0666);
	int* tab = (int*) shmat(shr_buf, NULL, 0);
	for(int i=0; i < SIZE_TAB; i++) {
		tab[i] = rand() % SIZE_TAB + 1;
	}
	print_tab(tab);
}


void merge_sort(int begin, int end) {
	int* tab = (int*) shmat(shr_buf, NULL, 0);
	if(begin >= end) {
		return;
	}
	if(begin+1 == end) {
		int lower  = tab[begin] < tab[end] ? tab[begin] : tab[end];
		int higher = lower == tab[end]     ? tab[begin] : tab[end];
		tab[begin] = lower;
		tab[end]   = higher;
	} else {
		int middle = (begin+end)/2;
		if(!fork()) {
			merge_sort(begin, middle);
			exit(0); //return;
		} else if(!fork()) {
			merge_sort(middle+1, end);
			exit(0); //return;
		}
		int s;
		wait(&s);
		wait(&s);
		int size1 = middle-begin+1;
		int size2 = end-middle;
		int* p1 = malloc(size1 * sizeof(int));
		int* p2 = malloc(size2 * sizeof(int));
		memcpy(p1, tab + begin,      size1 * sizeof(int));
		memcpy(p2, tab + (middle+1), size2 * sizeof(int));
		int i = 0;
		int j = 0;
		while(i < size1 && j < size2) {
			if(p1[i] < p2[j]) {
				tab[begin+i+j] = p1[i];
				i++;
			} else {
				tab[begin+i+j] = p2[j];
				j++;
			}
		}
		for(; i < size1; i++) {
			tab[begin+i+j] = p1[i];
		}
		for(; j < size2; j++) {
			tab[begin+i+j] = p2[j];
		}
		free(p1);
		free(p2);
	}
}


int main(int argc, char** argv) {
	init_tab();
	int status;

	merge_sort(0, SIZE_TAB-1);

	print_tab((int*) shmat(shr_buf, NULL, 0));

	struct shmid_ds b;
	shmctl(shr_buf, IPC_RMID, &b);
}
