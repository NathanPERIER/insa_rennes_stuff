
TARGETS = sema4.o q1-1 q1 q4 q5 q6


build : $(TARGETS)

sema4.o : sema4.c
	gcc -c $<

q1-1 : q1-1.c sema4.h sema4.o
	gcc -o $@ $^

q1 : q1.c sema4.h sema4.o
	gcc -o $@ $^

q4 : q4.c sema4.h sema4.o
	gcc -o $@ $^

q5 : q5.c sema4.h sema4.o
	gcc -o $@ $^

q6 : q6.c sema4.h sema4.o
	gcc -o $@ $^


clear :
	rm $(TARGETS)

