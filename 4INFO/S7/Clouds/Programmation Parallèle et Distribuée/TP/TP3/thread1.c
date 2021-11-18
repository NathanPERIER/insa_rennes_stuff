#include <stdio.h>   // standard I/O routines
#include <unistd.h>
#include <stdlib.h>
#include <pthread.h> // pthread functions and data structures

pthread_mutex_t mutex1 = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t mutex2 = PTHREAD_MUTEX_INITIALIZER;


/* function to be executed by the new thread */
void* do_loop(void* data) {
	int i;
	int me = *((int*) data); // numéro du thread
	// if (me==0) sleep(5);
	pthread_mutex_t* mymutex = (me == 0) ? &mutex1 : &mutex2;
	pthread_mutex_t* othermutex = (me == 0) ? &mutex2 : &mutex1;
	for (i=0; i<20; i++){
		int delai =  (int)(rand() / (double)RAND_MAX * 2) ;
		pthread_mutex_lock(mymutex);
		printf("%d - étape %d\n", me, i);
		pthread_mutex_unlock(othermutex);
		// sleep(delai);
	}
	pthread_exit(NULL); // terminate the thread
}


int main(int argc, char* argv[]) {
	int thr_id1, thr_id2;            // thread ID
	pthread_t p_thread1, p_thread2; // thread's structure
	int a = 1;						 // thread 1 identifying number
	int b = 0;						 // thread 2 identifying number
	pthread_attr_t attr; 			 // thread attributes
	void* return_value = NULL;

	// creates 2 threads that will execute 'do_loop()'
	pthread_attr_init(&attr); //initializes the attributes
	pthread_mutex_lock(&mutex2);
	thr_id1 = pthread_create(&p_thread1, &attr, do_loop, (void*)&a);
	thr_id2 = pthread_create(&p_thread2, &attr, do_loop, (void*)&b);

	pthread_join(p_thread1, &return_value);
	pthread_join(p_thread2, &return_value);
	
	printf("programme terminé\n"); 
	return 0;
}

