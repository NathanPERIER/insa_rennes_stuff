@ constantes pour etudiant
.set id,0
.set notes,4
.set e_size,8
.set nb_notes,6

@ constantes pour sommeNotes
.set sumNotes,-8
.set i,-4
.set e,12
.set nbNotes,16


.data
tabNotes:	.word 3,18,20,6,13,12
ivan:		.word 148
			.word tabNotes

.text
.global _start

_start:
	LDR r0,=ivan
	MOV r1,#nb_notes
	STMFD sp!,{r0,r1}
	SUB sp,sp,#4
	BL sommeNotes
	LDMFD sp!,{r1}
	ADD sp,sp,#8
	B end_program
sommeNotes:
	STMFD sp!,{lr}	@ store return adress
	STMFD sp!,{fp}	@ store previous frame pointer
	MOV fp,sp 		@ update frame pointer
	SUB sp,sp,#8	@ allocate space for local variables
	STMFD sp!,{r0,r1}
	MOV r0,#0
	STR r0,[fp,#sumNotes]
	STR r0,[fp,#i]
for:
	LDR r0,[fp,#i]
	LDR r1,[fp,#nbNotes]
	CMP r0,r1
	BGE end_for
	LDR r1,[fp,#e]
	LDR r1,[r1,#notes]
	LDR r1,[r1,r0,LSL #2]
	ADD r0,r0,#1
	STR r0,[fp,#i]
	LDR r0,[fp,#sumNotes]
	ADD r0,r0,r1
	STR r0,[fp,#sumNotes]
	B for
end_for:
	LDR r0,[fp,#sumNotes]
	STR r0,[fp,#8]
	LDMFD sp!,{r0,r1}	@ restore registers
	ADD sp,sp,#8	@ free space allocated for the local variables
	LDMFD sp!,{fp}	@ restore frame pointer
	LDMFD sp!,{lr}	@ get return adress
	BX lr 			@ break to retrun adress
end_program:
	MOV r0,r1
.end