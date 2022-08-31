#include "vb-util.h"
#include <stdio.h>
#include <unistd.h>
#include <wait.h>
#include <sys/types.h>
#include <sys/un.h>
#include <errno.h>
#include <signal.h>

// crée une socket d’écoute, l’attache à une adresse donnée en argument, puis entre dans une boucle sans fin, dans laquelle il attend une connexion sur la socket d’écoute ; à chaque connexion, il crée un fils qui dialogue avec le client sur la socket de service, en lui renvoyant les caractère reçus qui sont des chiffres pairs. Le père se termine à la frappe de Ctrl+C, les fils se terminent à la déconnexion de leur client.

int sock;
struct sockaddr_un addr;

void serve_client(int soc) {
	char c;
	int loop = 1;
	while(loop) {
		loop = loop && vb_read(soc, &c, 1) > 0;
		printf("%c", c);
		if(loop && (c >= 48 && c <= 57 && c%2 == 0) || c == '\n') {
			loop = loop && vb_write(soc, &c, 1) >= 0;
		}
	}
	close(soc);
}

void handler(int sig) {
	close(sock);
	unlink(addr.sun_path);
	printf("Quitting\n");
	exit(0);
}

int main(int argc, char** argv) {
	int sock;
	int serv;
	struct sockaddr_un sa;
	struct sigaction action;
	
	if(argc < 2) {
		printf("No path provided\n");
		return 1;
	}

	action.sa_handler = handler;
	sigaction(SIGINT, &action, NULL);
	
	sock = vb_create_socket_un(SOCK_STREAM, argv[1], &addr, 1);
	if(sock < 0) { return 2; }

	if(vb_listen(sock, 1) < 0) { return 2; }

	while(1) {
		serv = vb_accept_un(sock, &sa);
		if(serv < 0) { return 2; }
		if(!fork()) {
			serve_client(serv);
			return 0;
		} else {
			int rs;
			wait(&rs);
		}
	}

	return 0;
}

