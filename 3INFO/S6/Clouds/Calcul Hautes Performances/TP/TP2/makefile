

build : ex1 ex2 ex3

ex1 : ex1.c
	gcc -fopenmp $^ -o $@

ex2 : ex2.o
	gcc -o $@ $^ -lm -fopenmp

ex2.o : ex2.c
	gcc -fopenmp -c $^ -o $@

ex3 : ex3.c
	gcc -fopenmp $^ -o $@


.clean : 
	rm ex1 ex2 ex3


