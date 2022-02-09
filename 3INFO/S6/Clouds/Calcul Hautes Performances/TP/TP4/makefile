
build : sequential parallel test monprog


sequential : sequential.c
	gcc -o $@ $<

parallel : parallel.c
	mpicc -o $@ $<

test : test.c
	mpicc -o $@ $<

monprog : monprog.c
	mpicc -o $@ $<

clear : 
	rm test monprog sequential parallel

