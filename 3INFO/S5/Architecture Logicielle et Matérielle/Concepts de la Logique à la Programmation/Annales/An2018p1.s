@ 1.1 : Ce programme compte le nombre d'élements < 0 et = 0 jusqu'au premier élément < 0 d'un tableau
@
@ 1.2 : X = 1, Y = 1, Z = 8
@
@ 1.3 : 
@      ┌──────┐
@      │.bss  │
@ 0x78 │X     │ (Je ne sais pas pourquoi cette adresse)
@ 0x7C │Y     │
@ 0x80 │Z     │
@      ├──────┤
@      │.data │
@ 0x50 │T     │ (Je ne sais pas pourquoi cette adresse)
@      ├──────┤
@      │.text │
@ ...  │      │
@ 0xC  │boucle│
@ ...  │      │
@ 0x0  │_start│
@      └──────┘

.equ N,10

.data
T:	.word	4,8,12,9,0,-1,0,-18,2,0
.align

.bss
X:	.skip	4
Y:	.skip	4
Z:	.skip	4

.text
.global _start

_start:
	MOV r2,#0
	MOV r3,#0
	LDR r1,=T

boucle:
	LDR r0,[r1],#4
	CMP r0,#0
	ADDLT r3,r3,#1
	ADDEQ r4,r4,#1
	BGE boucle

	LDR r0,=X
	STR r3,[r0]

	LDR r0,=Y
	STR r4,[r0]

	ADD r3,r3,r4
	RSB r3,r3,#N
	LDR r0,=Z
	STR r3,[r0]
.end
