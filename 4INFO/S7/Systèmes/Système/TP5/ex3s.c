#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <wait.h>

#define PIPE_PATH "/tmp/ex2pipe"

sigset_t empty_mask;
struct sigaction action_s2;
struct sigaction action_s1;
struct sigaction action_end;
int fd;


void service1() {
	printf("Service 1\n");
	write(fd, "Bonjour, Ceci n'est pas un service NodeJs", 42);
}

void service2() {
	printf("Service 2\n");
	write(fd, "Tiens, prends un cookie", 24);
}

void end_program() {
	printf("Closing program\n");
	close(fd);
	unlink(PIPE_PATH);
	exit(0);
}

int main(int argc, char** argv) {
	char pid[20];
	sprintf(pid, "%d", getpid());
	printf("Server started with PID %s\n", pid);

	if(mkfifo(PIPE_PATH, 0666) == -1) {
		printf("Can't create tube\n");
		return 1;
	}

	sigemptyset(&empty_mask);
	action_s1.sa_handler = service1;
	action_s2.sa_handler = service2;
	action_end.sa_handler = end_program;
	sigaction(SIGUSR1, &action_s1, NULL);
	sigaction(SIGUSR2, &action_s2, NULL);
	sigaction(SIGINT, &action_end, NULL);
	
	fd = open(PIPE_PATH, O_WRONLY);
	if(fd == -1) {
		printf("Can't open tube");
		return 2;
	}
	int fd2 = open(PIPE_PATH, O_RDONLY); // else crash when we write and there is no client

	while(1) {
		printf("Waiting for client ...\n");
		write(fd, pid, strlen(pid)+1);
		sigsuspend(&empty_mask);
	}
	
	return 0;
}
