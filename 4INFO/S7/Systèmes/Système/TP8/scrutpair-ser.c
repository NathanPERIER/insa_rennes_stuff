#include "vb-util.h"
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/un.h>
#include <errno.h>
#include <signal.h>

// crée une socket d’écoute, l’attache à une adresse donnée en argument, puis entre dans une boucle sans fin, dans laquelle il attend une connexion sur la socket d’écoute ; à chaque connexion, il crée un fils qui dialogue avec le client sur la socket de service, en lui renvoyant les caractère reçus qui sont des chiffres pairs. Le père se termine à la frappe de Ctrl+C, les fils se terminent à la déconnexion de leur client.

#define NB_CLIENTS 16
int clients[NB_CLIENTS];

int sock;
struct sockaddr_un addr;

int add_client(int client) {
	for(int i=0; i<NB_CLIENTS; i++) {
		if(clients[i] == 0) {
			clients[i] = client;
			return 1;
		}
	}
	return 0;
}

void serve_client(int i) {
	printf("serve\n");
	int soc = clients[i];
	char c = ' ';
	int loop = 1;
	int itworks = 1;
	while(loop) {
		itworks = itworks && vb_read(soc, &c, 1) > 0;
		// printf("%c", c);
		if(itworks && (c >= 48 && c <= 57 && c%2 == 0) || c == '\n') {
			itworks = itworks && vb_write(soc, &c, 1) >= 0;
		}
		loop = itworks && c != '\n';
	}
	if(!itworks) {
		close(clients[i]);
		clients[i] = 0;
	}
}

int purge_clients() {
	int res = 0;
	struct timeval t;
	fd_set set;
	t.tv_sec = 0;
	t.tv_usec = 0;
	for(int i=0; i<NB_CLIENTS; i++) {
		if(clients[i] != 0) {
			FD_ZERO(&set);
			FD_SET(clients[i], &set);
			if(select(clients[i]+1, &set, NULL, NULL, &t) < 0) {
				close(clients[i]);
				clients[i] = 0;
				res = 1;
			}
		}
	}
	return res;
}

void handler(int sig) {
	for(int i=0; i<NB_CLIENTS; i++) {
		if(clients[i] != 0) {
			close(clients[i]);
		}
	}
	close(sock);
	unlink(addr.sun_path);
	printf("Quitting\n");
	exit(0);
}

int main(int argc, char** argv) {
	int loop = 1;
	int sock;
	struct sockaddr_un sa;
	struct sigaction action;
	fd_set set;
	int r, max;
	
	if(argc < 2) {
		printf("No path provided\n");
		return 1;
	}

	action.sa_handler = handler;
	sigaction(SIGINT, &action, NULL);
	
	sock = vb_create_socket_un(SOCK_STREAM, argv[1], &addr, 1);
	if(sock < 0) { return 2; }

	if(vb_listen(sock, 1) < 0) { return 2; }

	while(loop) {
		FD_ZERO(&set);
		FD_SET(sock, &set);
		max = sock;
		for(int i=0; i<NB_CLIENTS; i++) {
			if(clients[i] != 0) {
				FD_SET(clients[i], &set);
				max = max > clients[i] ? max : clients[i];
			}
		}
		r = select(max+1, &set, NULL, NULL, NULL);
		if(r > 0) {
			if(FD_ISSET(sock, &set)) {
				printf("aaaaa\n");
				int cli = vb_accept_un(sock, &sa);
				loop = loop && cli >= 0;
				if(!add_client(cli)) {
					close(cli);
				}
			}
			for(int i=0; i<NB_CLIENTS; i++) {
				if(clients[i] != 0 && FD_ISSET(clients[i], &set)) {
					serve_client(clients[i]);
				}
			}
		} else if(r < 0) {
			if(errno == EBADF) {
				loop = loop && purge_clients();
			} else {
				loop = 0;
			}
		}
	}

	handler(0);

	return 0;
}

