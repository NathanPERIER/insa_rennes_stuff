#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <wait.h>

#define PIPE_PATH "/tmp/ex2pipe"

int main(int argc, char** argv) {
	int fd;
	
	printf("pid : %d\n", getpid());

	if(mkfifo(PIPE_PATH, 0666) == -1) {
		printf("Can't create tube\n");
		return 1;
	}

	fd = open(PIPE_PATH, O_WRONLY);
	if(fd == -1) {
		printf("Can't open tube");
		return 2;
	}

	write(fd, "Bonjour", 8);
	write(fd, "Ça va ?", 8);

	close(fd);

	return 0;
}
