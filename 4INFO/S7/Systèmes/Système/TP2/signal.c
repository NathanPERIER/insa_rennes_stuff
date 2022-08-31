#include <stdlib.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <signal.h>
#include <sys/types.h>
#include <unistd.h>
#include <wait.h>

struct sigaction action;
sigset_t mask_nv;
sigset_t mask_anc;

void handler(int sig) {
  printf("Signal recu\n");
}

int main (int argc, char * argv[]) {
  
  // bloque SIGUSR1
  sigemptyset(&mask_nv);                       //vide le set de signaux
  // � d�commenter
  sigaddset(&mask_nv, SIGUSR1);                // Ajoute SIGUSR1 au set
  sigprocmask(SIG_BLOCK, &mask_nv, &mask_anc); // Ajoute les signaux du set � l'ensemble des signaux bloqu�s et r�cup�re l'ancien mask

  //D�finition du handler
  action.sa_handler=handler;
  sigaction(SIGUSR1,&action,NULL);        // Affecte l'action au signal

  //creation d'un processus
  int pid=fork();
	
  if(pid==-1) {
    perror("Creation du processus fils echoue");
    exit(0);
  }

  if(pid==0) { // fils
    sleep(1);
    printf("Debut attente du fils\n");
    sigsuspend(&mask_anc);               // Attend de recevoir un signal accept� par le masquepass� en param�tre
    printf("Fin attente du fils\n");
    exit(0);
  } else { // p�re
    kill(pid, SIGUSR1);                  // Envoi du signal SIGUSR1 au processus fils
    //On a red�fini le comportement du handler de SIGUSR1
    printf("Debut attente du pere\n");
    wait(NULL);                         //Attend la fin d'un fils
    printf("Fin attente du pere\n");
  }	
  exit(0);
}
