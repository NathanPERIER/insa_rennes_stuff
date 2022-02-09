

build : ex1 ex2a ex2b ex3

ex1 : ex1.c
	gcc -fopenmp $^ -o $@

ex2a : ex2a.c
	gcc -fopenmp $^ -o $@

ex2b : ex2b.c
	gcc -fopenmp $^ -o $@

ex3 : ex3.c
	gcc -fopenmp $^ -o $@


.clean : 
	rm ex1 ex2a ex2b ex3

