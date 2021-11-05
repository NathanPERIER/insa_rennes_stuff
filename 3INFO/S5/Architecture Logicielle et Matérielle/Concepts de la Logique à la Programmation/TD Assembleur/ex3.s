.set lg,0
.set tcar,4

.data
chaine:	.word	4
		.align
		.ascii	"1023"

.text
.global _start

_start:
	LDR r0,=chaine	@ r0 = &chaine
	LDR r1,[r0,#lg]	@ r1 = lg
	ADD r0,r0,#tcar	@ r0 = tcar (pointeur)
	MOV r2,#0
	MOV r3,#0
	MOV r5,#10
for:
	CMP r2,r1		@ while r2 < r1 = lg
	BGE end
	LDRB r4,[r0,r2]	@ r4 = tcar[r2]
	SUB r4,r4,#'0'	@ r4 = r4 - '0'
	MLA r3,r3,r5,r4	@ r3 = r3 * 10 + r4
	ADD r2,r2,#1	@ r2++
	B for
end: