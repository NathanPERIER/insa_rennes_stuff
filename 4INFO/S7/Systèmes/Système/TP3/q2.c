#include "sema4.h"

#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>


#ifndef NB_PRINT
#define NB_PRINT 5
#endif

void loop(char* proc, int mutex) {
	for(int i=0; i<NB_PRINT; i++) {
		P(mutex);
		printf("Before sleep %s\n", proc);
		sleep(1);
		printf("After sleep %s\n", proc);
		V(mutex);
	}
}


int main(int argc, char** argv) {
	int mutex = init(1);
	int final = init(0);

	if(!fork()) {
		loop("A", mutex);
		P(final);
		printf("Destruction\n");
		destroy(mutex);
		destroy(final);
	} else {
		loop("B", mutex);
		printf("Ok for destruction\n");
		V(final);
	}
}
