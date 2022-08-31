#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <signal.h>
#include <sys/types.h>
#include <setjmp.h>

int i = 0;
int j = 0;
jmp_buf env;
struct sigaction action;

void handler(int sig){
  printf("div 0\n");
  i=1;
  j=1;
  // À décommenter 
  // longjmp(env,0);
}

int main (int argc, char * argv[]) {
  
   //Définition du handler
    action.sa_handler=handler;
    sigaction(SIGFPE,&action, NULL);
    setjmp(env);    // A decommenter
    printf("deb i=%d j=%d\n", i ,j);
    j = 1/i;
    printf("fin i=%d j=%d\n", i, j);

    exit(0);
}
