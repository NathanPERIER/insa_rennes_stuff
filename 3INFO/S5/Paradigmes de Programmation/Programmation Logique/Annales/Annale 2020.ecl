
match(0, a, 0, 0, 0, 0, 1).
match(0, a, 0, 0, 0, 0, 2).
match(0, a, 0, 0, 0, 0, 1).
match(0, b, 0, 0, 0, 0, 1).
match(0, b, 0, 0, 0, 0, 2).
match(0, b, 0, 0, 0, 0, 3).
match(0, c, 0, 0, 0, 0, 1).
match(0, c, 0, 0, 0, 0, 2).
match(0, c, 0, 0, 0, 0, 3).
match(0, c, 0, 0, 0, 0, 4).

arbitre(1, 0, 0, 0).
arbitre(2, 0, 0, 0).
arbitre(3, 0, 0, 0).
arbitre(4, 0, 0, 0).

pas_tous_les_jours(A) :-
	match(_C, J, _H, _T, _J1, _J2, _A),
	not(match(_C, J, _H, _T, _J1, _J2, A)),
	!.

tous_les_jours(A) :-
	arbitre(A, _N, _P, _),
	not(pas_tous_les_jours(A)).
