#include "sema4.h"

#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <unistd.h>


int init(int n) {
	int retval;
	int sem = semget(IPC_PRIVATE, 1, 0666 | IPC_CREAT);
	if(sem < 0) {
		return -1;
	}
	union semun {
		int val;
		struct semid_ds *buf;
		ushort *array;
	} arg;
	arg.val = n;
	retval = semctl(sem, 0, SETVAL, arg);
	return (retval == 0) ? sem : -2;
}

int V(int sem) {
	struct sembuf op;
	op.sem_num = 0;
	op.sem_op  = 1;
	op.sem_flg = 0;
	return semop(sem, &op, 1);
}

int P(int sem) {
	struct sembuf op;
	op.sem_num = 0;
	op.sem_op = -1;
	op.sem_flg = 0;
	return semop(sem, &op, 1);
}

int destroy(int sem) {
	union semun {
		int val;
		struct semid_ds *buf;
		ushort *array;
	} arg;
	return semctl(sem, 0, IPC_RMID, arg);
}

