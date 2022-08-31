#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <signal.h>
#include <sys/types.h>
#include <unistd.h>
#include <wait.h>

void handler(int sig) {
	printf("Receieved signal\n");
}

int pid;

int main (int argc, char * argv[]) {
	if(0 == (pid=fork())) {
		struct sigaction action;
		action.sa_handler=handler;
		sigaction(SIGUSR1, &action, NULL);
		while(1) {
			pause(); // or sigwait()
		}
	} else {
		for(int i=0; i<30; i++) {
			printf("Sent signal\n");
			kill(pid, SIGUSR1);
			sleep(1);
		}
		kill(pid, SIGINT);
	}
}
