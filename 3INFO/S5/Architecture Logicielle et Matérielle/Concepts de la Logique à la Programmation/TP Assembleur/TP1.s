@ pile :
@       ... 
@ sp => r1
@       r0
@ fp => ancien fp
@ +4    adresse retour
@ +8    valeur de retour
@ +12   b (ou y)
@ +16   a (ou x)
@       ...

@.set lr,r14

.data
x:	.word	24
y:	.word	18

.bss
res:	.word

.text
.global _start

_start:
	LDR r0,=x
	LDR r1,=y
	LDR r2,=res
	LDR r0,[r0]
	LDR r1,[r1]
	STMFD sp!,{r0}	@ first parameter is r0 = x
	STMFD sp!,{r1}	@ second parameter is r1 = y
	SUB sp,sp,#4	@ leave one byte for return value
	BL pgcd			@ call of pgcd(x, y)
	LDMFD sp!,{r0}	@ retrieve result
	ADD sp,sp,#8	@ free space allocated for the parameters
	STR r0,[r2]		@ store result
	B end_program
pgcd:
	STMFD sp!,{lr}	@ save the value of the link register
	STMFD sp!,{fp}	@ save the value of the previous frame pointer
	MOV fp,sp 		@ update the frame pointer to point on the current adress of the stack pointer
	STMFD sp!,{r0,r1}	@ save the value of the registers we are going to use
	LDR r0,[fp,#16] @ r0 = x
	LDR r1,[fp,#12] @ r1 = y
	CMP r0,#0		@ if x == 0,
	BEQ zero		@ break to zero
	CMP r1,#0		@ else if y == 0,
	BEQ zero		@ break to zero as well
	CMP r0,r1		@ else compare x and y
	BLT smaller		@ if x < y break to smaller
	BGT greater		@ if x > y break to greater
	B end			@ else do nothing
zero:				@ here we know that x == 0 or y == 0
	MOV r0,#0 		@ in that case we want to return 0 so r0 = 0
	B end
smaller:			@ here we know that x < y
	SUB r1,r1,r0	@ we want to perform the recursive call pgcd(x, y-x), hence r1 = y-x
	B recursive
greater:			@ here we know that x > y
	SUB r0,r0,r1	@ we want to perform the recursive call pgcd(x-y, y), hence r0 = x-y
	B recursive
recursive:			@ recursive call to the pgcd function : pgcd(r0, r1)
	STMFD sp!,{r0}	@ first parameter is r0
	STMFD sp!,{r1}	@ second parameter is r1
	SUB sp,sp,#4	@ leave one byte for return value
	BL pgcd			@ call of function
	LDMFD sp!,{r0}	@ retrieve result
	ADD sp,sp,#8	@ free space allocated for the parameters
end:
	STR r0,[fp,#8]	@ in the end, return the value of r0
	LDMFD sp!,{r0,r1}	@ restore registers
	LDMFD sp!,{fp}	@ restore frame pointer
	LDMFD sp!,{lr}	@ restore link register
	BX lr			@ go back to next instruction after call of function
end_program: