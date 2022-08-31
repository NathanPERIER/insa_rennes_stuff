
TARGETS = pid exec exec2 MonThread.class entrelace entrelace2 Entrelace.class Entrelace2.class variable Variable.class VarObjet.class hierarchy


build : $(TARGETS)


pid : pid.c
	gcc -o $@ $<

exec : exec.c
	gcc -o $@ $<

exec2 : exec2.c
	gcc -o $@ $<

MonThread.class : MonThread.java
	javac $<

entrelace : entrelace.c
	gcc -o $@ $<

entrelace2 : entrelace2.c
	gcc -o $@ $<

Entrelace.class : Entrelace.java
	javac $<

Entrelace2.class : Entrelace2.java
	javac $<

variable : variable.c
	gcc -o $@ $<

Variable.class : Variable.java
	javac $<

VarObjet.class : VarObjet.java
	javac $<

hierarchy : hierarchy.c
	gcc -o $@ $<


.clear : 
	rm $(TARGETS)

