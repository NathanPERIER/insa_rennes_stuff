
TARGETS = semaphore sema4.o q2 q3 q4 q5
NB_PRINT = 5


build : $(TARGETS)

semaphore : semaphore.c
	gcc -o $@ $<

sema4.o : sema4.c
	gcc -c $<

q2 : q2.c sema4.h sema4.o
	gcc -o $@ $^

q3 : q3.c sema4.h sema4.o
	gcc -DNB_PRINT=$(NB_PRINT) -o $@ $^

q4 : q4.c sema4.h sema4.o
	gcc -DNB_PRINT=$(NB_PRINT) -o $@ $^

q5 : q5.c sema4.h sema4.o
	gcc -DNB_PRINT=$(NB_PRINT) -o $@ $^


clear :
	rm $(TARGETS)

