
TARGETS = heritage planete.o mammifere.o


build : $(TARGETS)

heritage : heritage.cpp mammifere.o mammifere.h planete.o planete.h
	g++ -o $@ $^

planete.o : planete.cpp
	g++ -c $<

mammifere.o : mammifere.cpp
	g++ -c $<


clear :
	rm $(TARGETS)

