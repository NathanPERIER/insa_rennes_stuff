/**
TP 4 Arbres binaires - Prolog

@author Prenom1 NOM1
@author Prenom2 NOM2
@version Annee scolaire 20__/20__
*/


/*
-------------------------------------------------------------------------------
 Définition des prédicats
-------------------------------------------------------------------------------
*/

arbre_binaire(vide).
arbre_binaire(arb_bin(I, G, D)):-
	integer(I),
	arbre_binaire(G),
	arbre_binaire(D).


dans_arbre_binaire(E, arb_bin(E, G, D)).
dans_arbre_binaire(E, arb_bin(E1, G, D)):-
	\==(E, E1),
	dans_arbre_binaire(E, G).
dans_arbre_binaire(E, arb_bin(E1, G, D)):-
	\==(E, E1),
	dans_arbre_binaire(E, D).


sous_arbre_binaire(vide, A).
sous_arbre_binaire(SA, SA).
sous_arbre_binaire(SA, arb_bin(E2, G2, D2)):-
	\==(SA, arb_bin(E2, G2, D2)),
	sous_arbre_binaire(SA, G2).
sous_arbre_binaire(SA, arb_bin(E2, G2, D2)):-
	\==(SA, arb_bin(E2, G2, D2)),
	sous_arbre_binaire(SA, D2).


remplacer(SA, SA, A, A).
remplacer(SA1, SA2, vide, vide):-
	\==(SA1, vide),
	\==(SA2, vide).
remplacer(SA1, SA2, SA1, SA2).
remplacer(SA1, SA2, arb_bin(E1, G1, D1), arb_bin(E1, G2, D2)):-
	\==(SA1, arb_bin(E1, G1, D1)),
	remplacer(SA1, SA2, G1, G2),
	remplacer(SA1, SA2, D1, D2).


isomorphe(vide, vide).
isomorphe(arb_bin(E, G1, D1), arb_bin(E, G2, D2)):-
	isomorphe(G1, G2),
	isomorphe(D1, D2).
isomorphe(arb_bin(E, G1, D1), arb_bin(E, G2, D2)):-
	isomorphe(G1, D2),
	isomorphe(D1, G2).


concat([], R, R).
concat([X|L1], L2, [X|R]):-
	concat(L1, L2, R).

infixe(vide, []).
infixe(arb_bin(E, G, D), L):-
	infixe(G, LG),
	infixe(D, LD),
	concat(LG, [E|LD], L).


insertion_arbre_ordonne(X, vide, arb_bin(X, vide, vide)).
insertion_arbre_ordonne(X, arb_bin(X, G, D), arb_bin(X, G, D)):-
	!.
insertion_arbre_ordonne(X, arb_bin(E, G, D1), arb_bin(E, G, D2)):-
	X > E,
	insertion_arbre_ordonne(X, D1, D2).
insertion_arbre_ordonne(X, arb_bin(E, G1, D), arb_bin(E, G2, D)):-
	X < E,
	insertion_arbre_ordonne(X, G1, G2).


% insertion_arbre_ordonne(X, B):-
%	free(B),
%	!,
%	B = arb_bin(X, G, D)


/*
-------------------------------------------------------------------------------
 Tests
-------------------------------------------------------------------------------
*/

% Quelques arbres à copier coller pour vous faire gagner du temps, mais
% n'hésitez pas à en définir d'autres

/*
arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide)))

arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))

arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, 7, vide))

arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide)))

arb_bin(3, arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide)), arb_bin(4, vide, vide))

arb_bin(3, arb_bin(6, vide, vide), arb_bin(5, arb_bin(4, vide, vide), arb_bin(7, vide, vide)))

arb_bin(8, arb_bin(4, arb_bin(2, vide, vide), arb_bin(6, vide, vide)), arb_bin(12, arb_bin(10, vide, vide), vide))

arb_bin(8, arb_bin(4, arb_bin(2, _, _), arb_bin(6, _, _)), arb_bin(12, arb_bin(10, _, _), _))

arb_bin(6,arb_bin(2,arb_bin(1,vide,vide),arb_bin(4,vide,vide)),arb_bin(8,vide,arb_bin(10,vide,vide)))

arb_bin(8,arb_bin(2,arb_bin(1,vide,vide),arb_bin(4,vide,vide)),arb_bin(6,vide,arb_bin(10,vide,vide)))

arb_bin(6,arb_bin(2,arb_bin(1,vide,vide),arb_bin(4,vide,vide)),arb_bin(8,arb_bin(2,arb_bin(1,vide,vide),arb_bin(4,vide,vide)),arb_bin(10,vide,vide)))

*/

?- arbre_binaire(vide).
?- arbre_binaire(arb_bin(1, arb_bin(5, vide, vide), vide)).
?- not arbre_binaire(arb_bin(a, vide, vide)).

?- dans_arbre_binaire(1, arb_bin(1, arb_bin(5, vide, vide), vide)).
?- not dans_arbre_binaire(6, arb_bin(1, arb_bin(5, vide, vide), vide)).

?- sous_arbre_binaire(vide, arb_bin(1, arb_bin(5, vide, vide), vide)).
?- sous_arbre_binaire(arb_bin(5, vide, vide), arb_bin(1, arb_bin(5, vide, vide), vide)).
?- not sous_arbre_binaire(arb_bin(8, vide, vide), arb_bin(1, arb_bin(5, vide, vide), vide)).

?- remplacer(vide, arb_bin(5, vide, vide), arb_bin(1, vide, vide), arb_bin(1, arb_bin(5, vide, vide), arb_bin(5, vide, vide))).
?- remplacer(arb_bin(5, vide, vide), vide, arb_bin(1, arb_bin(5, vide, vide), arb_bin(5, vide, vide)), arb_bin(1, vide, vide)).
?- remplacer(arb_bin(5, vide, vide), arb_bin(8, vide, vide), arb_bin(1, arb_bin(5, vide, vide), arb_bin(5, arb_bin(5, vide, vide), vide)), arb_bin(1, arb_bin(8, vide, vide), arb_bin(5, arb_bin(8, vide, vide), vide))).

?- isomorphe(vide, vide).
?- isomorphe(arb_bin(5, vide, vide), arb_bin(5, vide, vide)).
?- isomorphe(arb_bin(5, arb_bin(9, vide, vide), vide), arb_bin(5, vide, arb_bin(9, vide, vide))).
?- not isomorphe(arb_bin(5, vide, vide), arb_bin(5, arb_bin(5, vide, vide), vide)).
?- isomorphe(arb_bin(1, arb_bin(5, vide, vide), arb_bin(5, vide, vide)), arb_bin(1, arb_bin(5, vide, vide), arb_bin(5, vide, vide))).

?- infixe(arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))), [6, 2, 1, 4, 3, 5]).

?- insertion_arbre_ordonne(5, arb_bin(8, arb_bin(4, arb_bin(2, vide, vide), arb_bin(6, vide, vide)), arb_bin(12, arb_bin(10, vide, vide), vide)), arb_bin(8, arb_bin(4, arb_bin(2, vide, vide), arb_bin(6, arb_bin(5, vide, vide), vide)), arb_bin(12, arb_bin(10, vide, vide), vide))).

