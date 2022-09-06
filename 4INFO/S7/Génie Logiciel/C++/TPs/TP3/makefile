
CC_OPTS = -std=c++0x
TARGETS = main


build : $(TARGETS)

main : main.cpp ensemble.h
	g++ $(CC_OPTS) -o $@ $^


clear : 
	rm $(TARGETS)

