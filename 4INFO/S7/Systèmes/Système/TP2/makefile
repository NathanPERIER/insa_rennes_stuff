
TARGETS = signal deroutement printstuff longprog transfersig transferkill


build : $(TARGETS)

signal : signal.c
	gcc -o $@ $<

deroutement : deroutement.c
	clang -o $@ $<

printstuff : printstuff.c
	gcc -o $@ $<

longprog : longprog.c
	gcc -o $@ $<

transfersig : transfersig.c
	gcc -o $@ $<

transferkill : transferkill.c
	gcc -o $@ $<


clear :
	rm $(TARGETS)

