@ Représentation de la pile : 
@       ...
@       r0
@ fp => ancien fp
@ +4    adresse de retour
@ +8   adresse de m2
@ +12   adresse de m1
@       ...

.set N,3

.data
m1:	.word	1,2,3,4,5,6,7,8,9
m2:	.word	1,1,1,2,2,2,3,3,3

.bss
res:	.space	N*N*4

.text
.global _start

_start:
	LDR r0,=m1
	LDR r1,=m2
	STMFD sp!,{r0}
	STMFD sp!,{r1}
	BL produit
	ADD sp,sp,#8
	B end_program
produit:
	STMFD sp!,{lr}
	STMFD sp!,{fp}
	MOV fp,sp
	STMFD sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9}
	LDR r0,=res
	LDR r4,[fp,#12]
	LDR r5,[fp,#8]
	LDR r1,#0
for_i:
	CMP r1,#N		@ compare r1 = i with N
	BGE end_for_i	@ if i >= N-1, end for_i
	LDR r2,#0		@ else, r2 = j := 0
for_j:
	CMP r2,#N		@ compare r2 = j with N
	BGE end_for_j	@ if j >= N-1, end for_j
	LDR r7,#0		@ r7 = res[i,j] := 0
	LDR r3,#0		@ r3 = k := 0
for_k:
	CMP r3,#N		@ compare r3 = k with N
	BGE end_for_k	@ if i >= N-1, end for_i
	MOV r6,=N 		@ r6 := N
	MLA r6,r1,r6,r3	@ r6 := i * N + k
	STR r8,[r4,r6,LSL #2]	@ r8 := m1[i,k]
	MOV r6,=N 		@ r6 := N
	MLA r6,r3,r6,r2	@ r6 := k * N + j
	STR r9,[r5,r6,LSL #2]	@ r9 := m2[k,j]
	MUL r8,r8,r9	@ r8 := r8*r9 = m1[i,k]*m2[k,j]
	ADD r7,r7,r8	@ r7 = res[i,j] += m1[i,k]*m2[k,j]
	ADD r3,r3,#1
	B for_k
end_for_k:
	MOV r6,=N
	MLA r6,r1,r6,r2	@ r6 := i * N + j
	STR r7,[r0,r6,LSL #2]
	ADD r2,r2,#1
	B for_j
end_for_j:
	ADD r1,r1,#1
	B for_i
end_for_i:
	LDMFD sp!,{r0,r1,r2,r3,r4,r5,r6,r7,r8,r9}	@ restore registers
	LDMFD sp!,{fp}	@ restore frame pointer
	LDMFD sp!,{lr}	@ get return adress
	BX lr 			@ break to retrun adress
end_program:
