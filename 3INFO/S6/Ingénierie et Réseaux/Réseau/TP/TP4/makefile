
build : ClientPlusMoins ServeurPlusMoins ClientUDP ServeurUDP


ClientPlusMoins : ClientPlusMoins.c
	gcc -o $@ $<

ServeurPlusMoins : ServeurPlusMoins.c
	gcc -o $@ $<

ClientUDP : ClientUDP.c
	gcc -o $@ $<

ServeurUDP : ServeurUDP.c
	gcc -o $@ $<

