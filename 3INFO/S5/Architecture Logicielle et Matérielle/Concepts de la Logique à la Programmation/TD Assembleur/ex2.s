@ fonctionne jusqu'à x = 12 (valeur : 479 001 600)
@ plus de valeurs => augmenter le nombre de bits (stockage sur plusieurs registres ...)

.data
N:	.word	13

.text
.global _start

_start:
	MOV r0,#1
	MOV r1,#1
	LDR r2,=N
	LDR r2,[r2]
for:
	CMP r1,r2
	BGT end
	MUL r0,r0,r1
	ADD r1,r1,#1
	B for
end: