
TARGETS = fraction.o ex1


build : $(TARGETS)

fraction.o : fraction.cpp
	g++ -c $<

ex1 : ex1.cpp fraction.o fraction.h
	g++ -o $@ $^


clear :
	rm $(TARGETS)

