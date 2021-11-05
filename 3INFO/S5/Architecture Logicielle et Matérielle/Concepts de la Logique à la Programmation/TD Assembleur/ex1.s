.data
x:	.word 10

.text
.global _start

_start:
	LDR r0,=x
	LDR r0,[r0]
	MOV r1,#1
	MOV r2,#3
while:
	CMP r0,r1
	BEQ end		@Test for flag Z (Zero)
	TST r0,#0b1
	BNE else	@Test for flag Z (Zero)
if:
	LSR r0,r0,#1
	B fi
else:
	MLA r0,r0,r2,r1
fi:
	B while
end: