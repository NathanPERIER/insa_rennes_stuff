#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <wait.h>

#define PIPE_PATH "/tmp/ex2pipe"

int main(int argc, char** argv) {
	char buf[256];
	int pid;
	int fd;

	fd = open(PIPE_PATH, O_RDONLY);
	if(fd == -1) {
		printf("Can't open tube\n");
		return 2;
	}

	if(read(fd, buf, 255) <= 0) {
		printf("Can't get server PID\n");
		return 3;
	}

	pid = atoi(buf);
	printf("Server found at PID %s\n", buf);

	kill(pid, SIGUSR1);

	if(read(fd, buf, 255) <= 0) {
		printf("Can't get response\n");
		return 4;
	}

	printf("%s\n", buf);

	close(fd);

	return 0;
}
