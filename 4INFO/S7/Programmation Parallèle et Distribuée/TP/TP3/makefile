
TARGETS = thread1 pi writer_reader


build : $(TARGETS)


thread1 : thread1.c
	gcc -o $@ $< -lpthread

pi : pi.c
	gcc -o $@ $< -lpthread

writer_reader : writer_reader.c
	gcc -o $@ $< -lpthread


clear :
	rm $(TARGETS)

