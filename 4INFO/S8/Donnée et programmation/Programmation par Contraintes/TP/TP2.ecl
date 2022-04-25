:- lib(ic).
:- lib(ic_symbolic).

% 2.1

?- local domain(couleur(rouge,vert,blanc,bleu,jaune)).
?- local domain(nationalite(anglais,espagnol,ukrainien,norvegien,japonais)).
?- local domain(animal(chien,renard,cheval,serpent,zebre)).
?- local domain(voiture(bmw,ford,toyota,honda,datsun)).
?- local domain(boisson(the,cafe,lait,judoranj,eau)).

% ===============================================

% 2.2

domaines_maison(m(Pays, Couleur, Boisson, Voiture, Animal, Numero)) :-
	Pays &:: nationalite,
	Couleur &:: couleur,
	Boisson &:: boisson,
	Voiture &:: voiture,
	Animal &:: animal,
	Numero #:: 1..5.

% ===============================================

% 2.3

rue(Rue) :-
	M1 = m(P1, C1, B1, V1, A1, 1),
	M2 = m(P2, C2, B2, V2, A2, 2),
	M3 = m(P3, C3, B3, V3, A3, 3),
	M4 = m(P4, C4, B4, V4, A4, 4),
	M5 = m(P5, C5, B5, V5, A5, 5),
	domaines_maison(M1),
	domaines_maison(M2),
	domaines_maison(M3),
	domaines_maison(M4),
	domaines_maison(M5),
	ic_symbolic:alldifferent([P1, P2, P3, P4, P5]),
	ic_symbolic:alldifferent([C1, C2, C3, C4, C5]),
	ic_symbolic:alldifferent([B1, B2, B3, B4, B5]),
	ic_symbolic:alldifferent([V1, V2, V3, V4, V5]),
	ic_symbolic:alldifferent([A1, A2, A3, A4, A5]),
	Rue = [M1, M2, M3, M4, M5].

% ===============================================

% 2.4

ecrit_maisons(Rue) :-
	(foreach(M, Rue) do
		writeln(M)
	).

% ===============================================

% 2.5

getVarList([], []).
getVarList([m(Pi, Ci, Bi, Vi, Ai, _I) | R], [Pi, Ci, Bi, Vi, Ai | L]) :-
	getVarList(R, L).

% Something like this should also work :
% getVarList(Rue, Liste) :-
% 	(foreach(M, Rue), fromto([], In, Out, Liste) do
% 		M = m(Pi, Ci, Bi, Vi, Ai, _I)
% 		Out = [Pi, Ci, Bi, Vi, Ai | In]
% 	)

labeling_symbolic(VarList) :-
	(foreach(V, VarList) do
		ic_symbolic:indomain(V)
	).

% ===============================================

% 2.6

resoudre(Rue) :-
	rue(Rue),
	getVarList(Rue, Vars),
	contraintes_rue(Rue),
	labeling_symbolic(Vars).

% ===============================================

% 2.7

% (a) L'Anglais habite dans la maison rouge
% (b) L'Espagnol possède un chien
% (c) La personne vivant dans la maison verte boit du café
% (d) L'Ukrainien boit du thé
% (f) Le conducteur de la BMW possède des serpents
% (g) L'habitant de la maison jaune possède une Toyota
% (h) Du lait est bu dans la maison du milieu
% (i) Le Norvégien habite dans la maison la plus à gauche
% (l) Le conducteur de la Honda boit du jus d'orange
% (m) Le Japonais conduit une Datsun

% (e) La maison verte est située juste à la droite de la maison blanche
% (j) Le conducteur de la Ford habite à côté de la personne qui possède un renard
% (k) La personne qui conduit une Toyota habite à côté de la maison où il y a un cheval
% (n) Le Norvégien habite à côté de la maison bleue

contraintes_rue(Rue) :-
	(foreach(M, Rue), param(Rue) do
		M = m(Pi, Ci, Bi, Vi, Ai, I),
		(Pi &= anglais)   #= (Ci &= rouge),
		(Pi &= espagnol)  #= (Ai &= chien),
		(Ci &= vert)      #= (Bi &= cafe),
		(Pi &= ukrainien) #= (Bi &= the),
		(Vi &= bmw)       #= (Ai &= serpent),
		(Ci &= jaune)     #= (Vi &= toyota),
		(Bi &= lait)      #= (I #= 3),
		(Pi &= norvegien) #= (I #= 1),
		(Vi &= honda)     #= (Bi &= judoranj),
		(Pi &= japonais)  #= (Vi &= datsun),
		(foreach(M1, Rue), param(Pi, Ci, Vi, I) do
			M1 = m(_Pi1, Ci1, _Bi1, _Vi1, Ai1, I1),
			((Ci &= blanc)     and (Ci1 &= vert))   => (I1 #= I+1),
			((Vi &= ford)      and (Ai1 &= renard)) => ((I1 #= I+1) or (I1 #= I-1)),
			((Vi &= toyota)    and (Ai1 &= cheval)) => ((I1 #= I+1) or (I1 #= I-1)),
			((Pi &= norvegien) and (Ci1 &= bleu))   => ((I1 #= I+1) or (I1 #= I-1))
		)
	).

% ===============================================

% 2.8

% ?- resoudre(Rue), ecrit_maisons(Rue).
% m(norvegien, jaune, eau, toyota, renard, 1)
% m(ukrainien, bleu, the, ford, cheval, 2)
% m(anglais, rouge, lait, bmw, serpent, 3)
% m(espagnol, blanc, judoranj, honda, chien, 4)
% m(japonais, vert, cafe, datsun, zebre, 5)

% C'est donc le norvégien qui boit de l'eau et le japonais qui possède un zèbre
