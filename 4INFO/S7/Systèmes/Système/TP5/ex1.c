#include <stdio.h>
#include <unistd.h>
#include <wait.h>


void who(int* p) {
	close(p[0]);
	dup2(p[1], STDOUT_FILENO);
	execl("/usr/bin/who", "/usr/bin/who", (char*)NULL);
}

void grep(int* p) {
	close(p[1]);
	dup2(p[0], STDIN_FILENO);
	execl("/bin/grep", "/bin/grep", "nathan", (char*)NULL);
}


int main(int argc, char** argv) {
	int p[2];
	int res;
	pipe(p);

	if(fork()) {
		grep(p);
	} else if(fork()) {
		who(p);
	} else {
		wait(&res);
		wait(&res);
		close(p[0]);
		close(p[1]);
	}

	return 0;
}
