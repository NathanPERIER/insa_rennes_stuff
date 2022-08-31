
TARGETS = vb-util.o pair-ser pair-cli scrutpair-ser scrutpair-cli


build : $(TARGETS)

vb-util.o : vb-util.c
	gcc -c $<

pair-ser : pair-ser.c vb-util.o vb-util.h
	gcc -o $@ $^

pair-cli : pair-cli.c vb-util.o vb-util.h
	gcc -o $@ $^

scrutpair-ser : scrutpair-ser.c vb-util.o vb-util.h
	gcc -o $@ $^

scrutpair-cli : scrutpair-cli.c vb-util.o vb-util.h
	gcc -o $@ $^

clear :
	rm $(TARGETS)

