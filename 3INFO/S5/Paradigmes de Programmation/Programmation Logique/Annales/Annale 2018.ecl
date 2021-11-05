pred1([], _Y).
pred1([X|L], [X|S]):-
	pred1(L, S).

pred2([_Z], []):-
	fail.
pred2([X|L], [X|M]):-
	pred1(L, M).
pred2([X|L], [_T|M]):-
	pred2([X|L], M).

?- pred2([6,5], [1,6,6,5,8]).
?- not(pred2([6,7], [1,6,6,5,8])).


somme([], 0).
somme([E|L], N):-
	somme(L, N1),
	N is N1 + E.

?- somme([2,30,42,8], R). % R=82


impair(X):-
	1 is mod(X, 2).

?- not(impair(22)).
?- impair(21).


lii([], R, R).
lii([E|L], A, R):-
	impair(E),
	!,
	lii(L, [E|A], R).
lii([_E|L], A, R):-
	lii(L, A, R).

liste_imp_inv(L, R):-
	lii(L, [], R).

?- liste_imp_inv([2,5,45,66,3,12], R). % R=[3,45,5]


typage([], []).
typage([E|L], [impair(E)|R]):-
	impair(E),
	!,
	typage(L, R).
typage([E|L], [pair(E)|R]):-
	typage(L, R).

?- typage([2,5,45,66,3,12], R). % R=[pair(2), impair(5), impair(45), pair(66), impair(3), pair(12)]


pas_imp([]).
pas_imp([E|_L]):-
	impair(E),
	!,
	fail.
pas_imp([_E|L]):-
	pas_imp(L).

?- not(pas_imp([2,5,45,66,3,12])).
?- pas_imp([2,66,12]).




propriete(durand, [1,2,3]).
propriete(dupont, [1,2,3]).
propriete(duval, [1,3,5]).
propriete(dumoulin, [2]).

culture(1, 2013, mais).
culture(2, 2015, mais).
culture(3, 2013, mais).
culture(4, 2013, ble).

possede(A, N):-
	propriete(A, L),
	member(N, L).

?- possede(dupont, N).


champ_durand_dupont_mais_2013(N):-
	possede(durand, N),
	possede(dupont, N),
	culture(N, 2013, mais).

?- champ_durand_dupont_mais_2013(N).


champ3(N):-
	possede(A1, N),
	possede(A2, N),
	\==(A1, A2),
	possede(A3, N),
	\==(A1, A3),
	\==(A2, A3).

?- champ3(N).


except([], _L, []).
except([E|L1], L2, R):-
	member(E, L2),
	!,
	except(L1, L2, R).
except([E|L1], L2, [E|R]):-
	except(L1, L2, R).

duv_pas_dur(L):-
	propriete(duval, L1),
	propriete(durand, L2),
	except(L1, L2, L).

?- duv_pas_dur(L).



q(a). q(b). q(c).
r(b). r(c). r(d).
s(c). s(d). s(e).

p(X):- q(X), r(X), s(X).
p1(X):- q(X), r(X), not(s(X)).
p2(X):- not(q(X)), r(X), s(X).
p3(X):- q(X), not(r(X)), s(X).

?- p(X).  % X=c
?- p1(X). % X=b
?- not(p2(X)).
?- not(p3(X)).

