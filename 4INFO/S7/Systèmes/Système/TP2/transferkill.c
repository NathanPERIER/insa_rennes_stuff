#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <signal.h>
#include <sys/types.h>
#include <unistd.h>
#include <wait.h>

#define NB_CHILDS 10

int pids[NB_CHILDS];

void parent_handler(int sig) {
	printf("Signal recieved\n");
	for(int i=0; i<NB_CHILDS; i++) {
		kill(pids[i], SIGUSR1);
	}
	for(int i=0; i<NB_CHILDS; i++) {
		wait(NULL);
	}
}

void child_handler(int sig) {
	printf("%d stopped\n", getpid());
	exit(0);
}

struct sigaction action;

int main (int argc, char * argv[]) {
	printf("Parent started with pid %d\n", getpid());
	int pid = 1;
	for(int i=0; i<NB_CHILDS && pid; i++) {
		pid = fork();
		if(pid) {
			pids[i] = pid;
			printf("%d started\n", pid);
		}
	}
	if(pid) {
		action.sa_handler=parent_handler;
		sigaction(SIGUSR1, &action, NULL);
		pause();
	} else {
		action.sa_handler=child_handler;
		sigaction(SIGUSR1, &action, NULL);
		pause();
	}
}

