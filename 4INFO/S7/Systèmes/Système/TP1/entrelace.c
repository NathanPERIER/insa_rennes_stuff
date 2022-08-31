#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <signal.h>


pid_t pidFils;  

void cree10() {
	pid_t child_pid;
	for(int i=0; i < 10 && !(child_pid = fork()); i++) {
		// if(getpid() == parent_pid) {
		// 	fork();
		// }
		printf("%d %d\n", getppid(), getpid());
	}
	sleep(10);
}

int main() {

	pidFils = fork();
	if (pidFils!=0){
		/* ------------ code du père ----------------- */
		int i;
		for(i=0;i<1000;i++){
			printf("je suis le pere\n");
		}
		cree10();

	}
	else{
		/* ------------ code du fils ----------------- */
		int i;
		for (i=0;i<1000;i++){
			printf("je suis le fils\n");
		}
	}
	

}

