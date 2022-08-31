#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <signal.h>

#define MAX_DEPTH 4


int main() {
	int depth;
	pid_t child1_pid = 0;
	pid_t child2_pid = 0;
	
	pid_t hierarchy[MAX_DEPTH];
	for(int i=0; i<MAX_DEPTH; i++) {
		hierarchy[i] = 0;
	}
	//printf("parent : %d\n", getpid());


	for(depth=0; !child1_pid || !child2_pid; depth++) {
		hierarchy[depth] = getpid();
		if(depth < MAX_DEPTH) {
			child1_pid = fork();
			if(child1_pid) {
				child2_pid = fork();
			}
		} else {
			child1_pid = 0;
		}
	}
	
	for(int i=0; i<MAX_DEPTH; i++) {
		printf("%d ", hierarchy[i]);
	}
	

	return 0;
}

