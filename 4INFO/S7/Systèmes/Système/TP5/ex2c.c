#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <wait.h>

#define PIPE_PATH "/tmp/ex2pipe"

int main(int argc, char** argv) {
	char buf[256];
	int fd;
	
	fd = open(PIPE_PATH, O_RDONLY);
	if(fd == -1) {
		printf("Can't open tube");
		return 2;
	}

	while(read(fd, buf, 255) > 0) {
		printf("%s\n", buf);
	}

	close(fd);
	unlink(PIPE_PATH);

	return 0;
}
