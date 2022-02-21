#include <stdio.h>
#include <string.h>
#include <time.h>
#include <stdlib.h>
#include <stdint.h>
#include <errno.h>
#include <signal.h>

#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>


int volatile keepGoing = 1;
int volatile keepRunning = 1;

int writeString(int s, char* buff) {
	int lenght = strlen(buff) + 1;
	return (write(s, buff, sizeof(char)*lenght) == sizeof(char)*lenght);
}

void handler(int signum) {
	printf("Stopped with num %d\n", signum);
	keepGoing = 0;
	keepRunning = 0;
}


int main(int argc, char** argv) {
	int port = 2222;
	struct sockaddr_in client, server;
	int s, c;
	int len;
	int32_t read_val;
	char* read_buff = (char*) &read_val;
	char* write_buff;
	int random;
	
	struct sigaction a;
	a.sa_handler = handler;
	a.sa_flags = 0;
	sigemptyset(&a.sa_mask);
	sigaction(SIGINT, &a, NULL);
	
	srand(time(NULL));

	s = socket(AF_INET, SOCK_STREAM, 0);
	if(s == -1) {
		fprintf(stderr, "Error during the creation of the socket\n");
		return -1;
	}
	
	server.sin_family = AF_INET;
	server.sin_port = htons(port);
	server.sin_addr.s_addr = htonl(INADDR_ANY);
	
	if(bind(s, (struct sockaddr*) &server, sizeof(server)) < 0) {
		fprintf(stderr, "%s : connect %s\n", argv[0], strerror(errno));
		return -2;
	}
	
	if(listen(s, 5) != 0) {
		fprintf(stderr, "listen %s\n", strerror(errno));
		return -3;
	}
	
	printf("Server started on port %d\n", port);

	len = sizeof(client);

	while(keepRunning) {
		c = accept(s, (struct sockaddr*) &client, (socklen_t*) &len);
		
		if(c >= 0) {
			printf("Connection from client %s (port %d)\n", inet_ntoa(client.sin_addr), ntohs(client.sin_port));
			random = rand() % 100 + 1;
			printf("Random number : %d\n", random);
			while(keepGoing) {
				len = read(c, read_buff, sizeof(read_buff));
				if(len <= 0) {
					fprintf(stderr, "read=%d : %s", len, strerror(errno));
					keepGoing = 0;
				} else {
					printf("Recieved : %d\n", read_val);
					if(read_val == 0) {
						write_buff = "Number error";
					} else if(read_val < random) {
						write_buff = "Plus";
					} else if(read_val > random) {
						write_buff = "Moins";
					} else {
						write_buff = "Ok";
						keepGoing = 0;
					}
					if(! writeString(c, write_buff)) {
						fprintf(stderr, "Error while sending message (%s)\n", strerror(errno));
						keepGoing = 0;
					}
				}
			}
			close(c);
			printf("Client %s disconnected\n", inet_ntoa(client.sin_addr));
			keepGoing = 1;
		}
	}

	close(s);
	printf("Server closed\n");

	return 0;
}


