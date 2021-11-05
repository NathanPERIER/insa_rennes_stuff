@ 2.1 : Ne fonctionne pas car pour un chargement par MOV, la valeur doit pouvoir s'écrire comme une valeur sur un octet décalée d'un nombre pair de bits
@
@ 2.2 : 'BL fonction' fait un saut à l'adresse de l'instruction correspondant au label 'fonction' et place l'adresse de l'instruction suivant le BL dans le registre lr (link register)
@        C'est utile car cela permet de faire une fonction qui récupère l'adresse du lr et qui revient exécuter le code après le BL une foi sa tâche effectuée
@        BL se place juste après le passage des paramètres et l'allocation d'espace pour la valeur de retour de la fonction dans la pile et juste avant la récupération de la valeur de retour
@
@ 2.3 : 'BX lr' fait un saut à l'adresse contenue dans le link register
@       C'est la dernière instruction exécutée par une fonction

@ 3.1 : 
.equ dte_a,0
.equ dte_b,4
.equ dte_c,8
.equ dte_len,12
.equ vec_x,0
.equ vec_y,4
.equ vec_len,8

@ 3.4 : 
.equ i,-4
.equ nbDroites,8
.equ ptTabVectDir,12
.equ ptTabDroites,16

@ 3.7 : 
.equ vect_v,12
.equ vect_u,16

.set NbDroites,3 @ Donné dans le sujet

@ 3.2 :
.bss
v1:	.skip	vec_len
v2:	.skip	vec_len
v3:	.skip	vec_len

.data
d1:	.word	3,2,12
d2:	.word	6,4,0
d3:	.word	-1,2,3
tabDroites:	.word	d1,d2,d3
tabVectDir: .word	v1,v2,v3
estParallele:	.word 0	@ donné dans le sujet

@ 3.3
@ 
@       sauvegarde des registres
@ -4    i
@ fp => ancien fp
@ +4    adresse de retour
@ +8    nbDroites
@ +12   ptTabVectDir
@ +16   ptTabDroites
@ 

@ 3.6
@ 
@       sauvegarde des registres
@ fp => ancien fp
@ +4    adresse de retour
@ +8    valeur de retour
@ +12   vect_v
@ +16   vect_u
@ 


.global _start

_start: @ 3.8
	LDR r0,=NbDroites
	LDR r1,=tabVectDir
	LDR r2,=tabDroites
	STMFD sp!,{r0,r1,r2}
	BL generationVectDir
	ADD sp,sp,#12
	LDR r0,=v2
	LDR r1,=v1
	STMFD sp!,{r0,r1}
	SUB sp,#4
	BL colinearite
	LDMFD sp!,{r0}
	ADD sp,sp,#8
	LDR r1,=estParallele
	STR r0,[r1]
	B end_prog

generationVectDir: @ 3.5
	STMFD sp!,{fp,lr}
	MOV fp,sp
	SUB sp,sp,#4
	STMFD sp!,{r0,r1,r2}
	LDR r0,=0
	STR r0,[fp,#i]
for:
	LDR r0,[fp,#i]
	LDR r1,[fp,#nbDroites]
	CMP r0,r1
	BGE end_for
 	LDR r1,[fp,#ptTabDroites]
 	LDR r1,[r1,r0,LSL #2]
 	LDR r1,[r1,#dte_b]
 	RSB r1,r1,#0
 	LDR r2,[fp,#ptTabVectDir]
 	LDR r2,[r2,r0,LSL #2]
 	STR r1,[r2,#vec_x]
	LDR r1,[fp,#ptTabDroites]
 	LDR r1,[r1,r0,LSL #2]
 	LDR r1,[r1,#dte_a]
 	LDR r2,[fp,#ptTabVectDir]
 	LDR r2,[r2,r0,LSL #2]
 	STR r1,[r2,#vec_y]
 	ADD r0,r0,#1
 	STR r0,[fp,#i]
 	B for
end_for:
	LDMFD sp!,{r0,r1,r2}
	ADD sp,sp,#4
	LDMFD sp!,{fp,lr}
	BX lr

colinearite:
	STMFD sp!,{fp,lr}
	MOV fp,sp
	STMFD sp!,{r0,r1,r2}
	LDR r0,[fp,#vect_u]
	LDR r0,[r0,#vec_x]
	LDR r1,[fp,#vect_v]
	LDR r1,[r1,#vec_y]
	MUL r2,r0,r1
	LDR r0,[fp,#vect_u]
	LDR r0,[r0,#vec_y]
	LDR r1,[fp,#vect_v]
	LDR r1,[r1,#vec_x]
	MLA r2,r0,r1,r2
	CMP r2,#0
	BEQ if_zero
	MOV r0,#0
if_zero:
	MOV r0,#1
end_if:
	STR r0,[fp,#8]
	LDMFD sp!,{r0,r1,r2}
	LDMFD sp!,{fp,lr}
	BX lr

end_prog: 
	BAL end_prog
.end

