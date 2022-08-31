#include "vb-util.h"
#include <stdio.h>
#include <unistd.h>
#include <wait.h>
#include <sys/types.h>
#include <sys/un.h>

// crée une socket, l’attache à une adresse donnée en argument 1, puis construit l’adresse du serveur à partir de l’argument 2 et s’y connecte. Le client entre dans une boucle sans fin dans laquelle il lit une suite de caractères au clavier, l’envoie au serveur, récupère sa réponse et l’affiche ; il se termine à la frappe de Ctrl+D ou à la déconnexion du serveur.

int main(int argc, char** argv) {
	int sock;
	struct sockaddr_un addr, sa;
	char word[256];
	char res[256];
	int loop = 1;
	fd_set set;
	int r;

	if(argc < 2) {
		printf("No path provided\n");
		return 1;
	}
	
	sock = vb_create_socket_un(SOCK_STREAM, argv[1], &addr, 0);
	if(sock < 0) { return 2; }

	while(loop) {
		FD_ZERO(&set);
		FD_SET(0, &set);
		FD_SET(sock, &set);

		r = select(sock+1, &set, NULL, NULL, NULL);
		if(r > 0) {
			if(FD_ISSET(0, &set)) {
				loop = loop && fgets(word, sizeof(word), stdin) 
							&& vb_write(sock, word, strlen(word)) >= 0;
			}
			if(FD_ISSET(sock, &set)) {
				loop = loop && vb_read(sock, res, 256) >= 0;
				printf("%s", res);
				fflush(stdin);
				res[0] = '\0';
			}
		} else if(r < 0) {
			loop = 0;
		}
	}

	close(sock);

	return 0;
}

