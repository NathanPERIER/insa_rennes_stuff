.data
A:	.word	14,-50,132,10,-2000,3456,76,-123,45,345
X:	.word	0
Y:	.word	0

.text
.global _start

_start:
	LDR r0,=A
	MOV r1,#8
	LDR r3,[r0],#4
	MOV r4,r3
loop:
	LDR r5,[r0],#4
	CMP r5,r3
	MOVLT r3,r5

	CMP r5,r4
	MOVGT r4,r5

	SUBS r1,r1,#1
	BGT loop

	LDR r6,=X
	STR r3,[r6]
	LDR r6,=Y
	STR r4,[r6]
.end