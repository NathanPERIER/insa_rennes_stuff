

build : prodScalaire1 prodScalaire2

prodScalaire1 : prodScalaire1.c
	mpicc -o $@ $<

prodScalaire2 : prodScalaire2.c
	mpicc -o $@ $<

clear : 
	rm prodScalaire1 prodScalaire2

