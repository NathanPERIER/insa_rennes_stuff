#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <stdint.h>

#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <arpa/inet.h>


int writeInt(int s, int v) {
	int32_t val = (int32_t) v;
	char* buff = (char*) &val;
	int lenght = sizeof(buff);
	return (write(s, buff, lenght) == lenght);
}


int main(int argc, char** argv) {
	int port = 2222;
	char* host = "127.0.0.1";
	struct sockaddr_in client, server;
	int s;
	int len;
	char read_buff[256];
	char write_buff[256];
	
	s = socket(AF_INET, SOCK_STREAM, 0);
	if(s == -1) {
		fprintf(stderr, "Error during the creation of the socket\n");
		return -1;
	}
	
	server.sin_family = AF_INET;
	server.sin_port = htons(port);
	inet_aton(host, (struct in_addr*) &server.sin_addr);
	
	if(connect(s, (struct sockaddr*) &server, sizeof(server)) < 0) {
		fprintf(stderr, "%s : connect %s\n", argv[0], strerror(errno));
		perror("bind");
		return -2;
	}
	
	len = sizeof(client);
	getsockname(s, (struct sockaddr*) &client, (socklen_t*) &len);
	
	printf("(%s, %4d) -> (%s, %4d)\n", inet_ntoa(client.sin_addr), ntohs(client.sin_port), inet_ntoa(server.sin_addr), ntohs(server.sin_port));
	
	read_buff[0] = '\0';
	while(strcmp(read_buff, "Ok") != 0) {
		fgets(write_buff, 256, stdin);
		if(! writeInt(s, atoi(write_buff))) {
			fprintf(stderr, "Error while sending message (%s)\n", strerror(errno));
			return -2;
		}
		len = read(s, read_buff, sizeof(read_buff));
		if(len <= 0) {
			fprintf(stderr, "Error while reading response (%d, %s)\n", len, strerror(errno));
			return -3;
		}
		read_buff[len-1] = '\0';
		printf("%s\n", read_buff);
	}
	
	close(s);

	return 0;
}


