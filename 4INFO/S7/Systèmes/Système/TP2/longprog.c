#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <signal.h>
#include <sys/types.h>
#include <unistd.h>
#include <wait.h>

int cpt;

void handler(int sig){
	printf("Counter : %d\n", cpt);
}

int main (int argc, char * argv[]) {
	struct sigaction action;
	action.sa_handler=handler;
	sigaction(SIGINT, &action, NULL);
	printf("%d\n", getpid());
	while(1) {
		sleep(1);
		cpt++;
	}
}

