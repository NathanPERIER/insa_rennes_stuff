% 1.1
% R = [3,4,3,4]
% R = [3,4,1,2]
% R = [1,2,3,4]
% R = [1,2,1,2]

remplace1([], []).
remplace1([1,2|X], [3,4|Y]):-
	remplace1(X, Y).
remplace1([A|X], [A|Y]):-
	remplace1(X, Y).

?- remplace1([1,2,1,2], Y).


% 1.2

remplace2([], []).
remplace2([1,2|X], [3,4|Y]):-
	!,
	remplace2(X, Y).
remplace2([A|X], [A|Y]):-
	remplace2(X, Y).

?- remplace2([1,2,1,2], Y).


vendeur(v1, nv1, pv1, 0).
vendeur(v2, nv2, pv2, 0).
vendeur(v3, nv3, pv3, 0).
produit(p1, prod1, 0, []).
produit(p2, prod2, 0, [gluten]).
produit(p3, prod3, 0, [arachides]).
produit(p4, prod4, 0, [arachides, gluten]).
commande(c1, 0, 0, 0, 0, 0, v1).
commande(c2, 0, 0, 0, 0, 0, v2).
commande(c3, 0, 0, 0, 0, 0, v2).
commande(c4, 0, 0, 0, 0, 0, v3).
commande(c5, 0, 0, 0, 0, 0, v3).
detail_commande(c1, p1, 1).
detail_commande(c2, p1, 1).
detail_commande(c2, p2, 1).
detail_commande(c2, p3, 1).
detail_commande(c3, p2, 1).
detail_commande(c3, p3, 1).
detail_commande(c3, p4, 1).
detail_commande(c4, p1, 1).
detail_commande(c4, p2, 1).
detail_commande(c4, p3, 1).
detail_commande(c4, p4, 1).
detail_commande(c5, p1, 1).
detail_commande(c5, p2, 1).
detail_commande(c5, p3, 1).
detail_commande(c5, p4, 1).


% 2.1 

% prod2 et prod3
un_allergene(N):-
	produit(_P, N, _C, [_]).


% 2.2

prod_g_a(P):-
	produit(P, _N, _C, R),
	member(arachides, R),
	!.
prod_g_a(P):-
	produit(P, _N, _C, R),
	member(gluten, R).

% nv2, pv2 et nv3, pv3
vend_g_a(Nom, Prenom):-
	produit(P, _N, _C, _R),
	prod_g_a(P),
	detail_commande(C, P, _),
	commande(C, _M, _JJ, _MM, _AA, _VL, V),
	vendeur(V, Nom, Prenom, _A).


% 2.3

% c4 et c5
pas_tous_prod(C):-
	produit(P, _N, _C, _R),
	not(detail_commande(C, P, _)).
tous_prod(C):-
	commande(C, _M, _JJ, _MM, _AA, _VL, _V),
	not(pas_tous_prod(C)).


% 3.1

pas_mieux(X, S, [X|S]).
pas_mieux(X, [Y|T], [Y|S]):-
	pas_mieux(X, T, S).

inconnu([], []).
inconnu([X|S], Y):-
	inconnu(S, Z),
	pas_mieux(X, Z, Y).

?- inconnu([6,3], R). % R=[3,6], R=[3,6]


% 3.2 : Produit tous les arrangements (ordres) possibles pour les elts de la liste 


% 4.1

meme_taille([], []).
meme_taille([_X|L], [_Y|M]):-
	meme_taille(L, M).

?- not(meme_taille([1,2,3], [3,7])).
?- meme_taille([1,2,3], [3,2,7]).


% 4.2
% Ici on ne réutilise pas meme_taille car cela ferait faire un itération en plus sur la liste
% Le cas où les deux listes sont de tailles différentes est de toute façon pris en compte à la fin

liste_somme([], [], []).
liste_somme([X|L], [Y|M], [S|R]):-
	liste_somme(L, M, R),
	S is X + Y.

?- liste_somme([1,2,3], [3,4,5], R). % R=[4,6,8]
?- not(liste_somme([1,2,3], [3,7], _)).


% 4.3

multiples([], []).
multiples([X|L], [X|R]):-
	0 is X mod 5,
	!,
	multiples(L, R).
multiples([_|L], R):-
	multiples(L, R).

?- multiples([1,5,6,20,10], R). % R=[5,20,10]


% 4.4

suppr([], [], R, R).
suppr([X|L], [X|M], A, R):-
	!,
	suppr(L, M, A, R).
suppr([X|L], M, A, R):-
	suppr(L, M, [X|A], R).

autres(L, R):-
	multiples(L, M),
	suppr(L, M, [], R).

?- autres([1,5,6,20,10], R). % R=[6,1]
