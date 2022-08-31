#include "sema4.h"

#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>


#ifndef NB_PRINT
#define NB_PRINT 10
#endif


int main(int argc, char** argv) {
	int sem_a = init(2);
	int sem_b = init(0);
	int sem_c = init(0);
	int sem_o = init(0);
	int final = init(0);

	if(!fork()) {
		for(int i=0; i<NB_PRINT; i++) {
			P(sem_a);
			P(sem_a);
			printf("A\n");
			V(sem_b);
			V(sem_c);
			V(sem_o);
			V(sem_o);
		}
		P(final);
		P(final);
		destroy(sem_a);
		destroy(sem_b);
		destroy(sem_c);
		destroy(sem_o);
		destroy(final);
	} else if(!fork()) {
		for(int i=0; i<NB_PRINT; i++) {
			P(sem_b);
			P(sem_o);
			printf("B\n");
			V(sem_a);
		}
		V(final);
	} else {
		for(int i=0; i<NB_PRINT; i++) {
			P(sem_c);
			P(sem_o);
			printf("C\n");
			V(sem_a);
		}
		V(final);
	}
}
