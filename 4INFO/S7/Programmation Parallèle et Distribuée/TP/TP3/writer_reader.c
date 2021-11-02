#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <string.h>

#define NB_ITER 20
#define NB_READERS 10
#define NB_WRITERS 2
#define BUFFER_SIZE 2048
char buffer[BUFFER_SIZE];

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond_r = PTHREAD_COND_INITIALIZER;
pthread_cond_t cond_w = PTHREAD_COND_INITIALIZER;

int chars_written = 0;
int writers_waiting = 0;
int readers = 0;
int writing = 0;

void* reader(void* args) {
	for(int i=0; i < NB_ITER; i++) {
		pthread_mutex_lock(&mutex);
		while(writing || writers_waiting > 0) {
			pthread_cond_wait(&cond_r, &mutex);
		}
		readers++;
		pthread_mutex_unlock(&mutex);
		printf("Read begin\n");
		printf("  %ld chars read\n", strlen(buffer));
		sleep(1);
		printf("Read end\n");
		pthread_mutex_lock(&mutex);
		readers--;
		if(readers == 0 && writers_waiting > 0) {
			pthread_cond_signal(&cond_w);
		}
		pthread_mutex_unlock(&mutex);
	}
	return NULL;
}

void* writer(void* args) {
	char c = *((char*) args);
	int chars_to_print;
	for(int i=0; i < NB_ITER; i++) {
		chars_to_print = i%20 + 40;
		pthread_mutex_lock(&mutex);
		writers_waiting++;
		while(readers > 0 || writing) {
			pthread_cond_wait(&cond_w, &mutex);
		}
		writing = 1;
		writers_waiting--;
		pthread_mutex_unlock(&mutex);
		printf("Write begin %c\n", c);
		sleep(1);
		if(chars_written + chars_to_print + 2 >= BUFFER_SIZE) {
			chars_written = 0;
		}
		for(int j=chars_written; j < chars_written+chars_to_print; j++) {
			buffer[j] = c;
		}
		buffer[chars_written+chars_to_print] = ' ';
		chars_written += chars_to_print + 1;
		printf("Write end %c\n", c);
		pthread_mutex_lock(&mutex);
		writing = 0;
		if(writers_waiting > 0) {
			pthread_cond_signal(&cond_w);
		} else {
			pthread_cond_broadcast(&cond_r);
		}
		pthread_mutex_unlock(&mutex);
	}
	return NULL;
}


int main(int argc, char** argv) { 
	char* args = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	pthread_t threads[NB_READERS + NB_WRITERS];
	pthread_attr_t attr;
	void* res;

	pthread_attr_init(&attr);

	for(int i=0; i < BUFFER_SIZE; i++) {
		buffer[i] = '\0';
	}
	
	for(int i=0; i < NB_WRITERS; i++) {
		pthread_create(threads+i, &attr, writer, (void*)(args+i));
	}

	for(int i=NB_WRITERS; i < NB_WRITERS + NB_READERS; i++) {
		pthread_create(threads+i, &attr, reader, NULL);
	}

	for(int i=0; i < NB_WRITERS + NB_READERS; i++) {
		pthread_join(threads[i], &res);
	}

	return 0;
}
