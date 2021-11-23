/**
TP Listes Prolog

@author Prenom1 NOM1
@author Prenom2 NOM2
@version Annee scolaire 20__/20__
*/

% Tests

tests :-
	test( test_membre ),
	test( test_compte ),
	test( test_renverser ),
	test( test_palind ),
	test( test_nieme ),
	test( test_hors_de ),	
	test( test_tous_diff ),
	test( test_conc3 ),
	test( test_debute_par ),
	test( test_sous_liste ),
	test( test_elim ),
	test( test_tri ),
	test( test_inclus ),
	test( test_non_inclus ),
	test( test_union_ens ),
	test( test_inclus2 ),
	true.

test_membre :-
	membre(a, [a,b,c]),									% membre(+X,+L) : vérification présence
	not membre(0, [1,2,3]),								% membre(+X,+L) : vérification absence
	sortall(X, membre(X,[2,1,3,1]), [1,1,2,3]).			% membre(-X,+L) : production des solutions X

test_compte :-
	compte(a, [a,c,a,b,a,c,b], 3),						% compte(+X,+L,+N) : vérification compte
	findall(N, compte(b, [a,c,a,b,a,c,b], N), [2]),		% compte(+X,+L,-N) : production de la solution N
	sortall(X, compte(X, [a,c,a,b,a,c,b], 2), [b,c]),	% compte(-X,+L,+N) : production des solutions X
	sortall([X,N], compte(X,[b,c,a,b,a,a],N), [[a,3],[b,2],[c,1]]). % compte(-X,+L,-N) production X et N

test_renverser :-
	renverser([a,b,c], [c,b,a]),						% renverser(+,+)
	findall(L, renverser([1,2,2,4], L), [[4,2,2,1]]).	% renverser(+,-)

test_palind :-
	palind([a,b,b,a]),
	not palind([b,a,b,a]).

test_nieme :-
	nieme1(1,[a,b,a],a),
	nieme1(3,[a,b,a],a),
	findall(X, nieme1(2,[a,b,c],X), [b]),
	nieme2(1,[a,b,a],a),
	nieme2(3,[a,b,a],a),
	sortall(N, nieme2(N,[p,a,p,a],a), [2,4]).

test_hors_de :-
	hors_de(z, [a,b,c]),
	not hors_de(b, [a,b,c]).

test_tous_diff :-
	tous_diff([1,2,3,4,5,9,7]),
	not tous_diff([1,3,4,5,3]).

test_conc3 :-
	conc3([1,2,3,4],[5,6],[7,8,9,10], [1,2,3,4,5,6,7,8,9,10]),
	sortall([L1,L2,L3], conc3(L1,L2,L3,[1,2]), 
		[[[],[],[1, 2]], [[],[1],[2]], [[],[1,2],[]], [[1],[],[2]], [[1],[2],[]], [[1,2],[],[]]]).

test_debute_par :-
	debute_par([1,2,3,4,5,6], [1,2,3]),
	not debute_par([1,2,3], [1,2,3,4,5,6]),
	sortall(D, debute_par([1,2,3,4],D), [[], [1], [1,2], [1,2,3], [1,2,3,4]]).
	
test_sous_liste :-
	sous_liste([1,2,3,4,5,6],[3,4]),
	not sous_liste([1,2,3,4,5,6],[4,3]),
	setof(L, sous_liste([1,2,3],L), [[],[1],[1,2],[1,2,3],[2],[2,3],[3]]). % setof pour ignorer les multiples []

test_elim :-
	elim([a,b,a,b,a], [a,b]) ; elim([a,b,a,b,a], [b,a]).

test_tri :-
	tri([5,4,3,2,1], [1,2,3,4,5]),
	findall(Tri, tri([4,1,3,2],Tri), [[1,2,3,4]]).

test_inclus :-
	inclus([3,2], [1,2,3,4]),
	not inclus([3,55], [1,2,3,4]).

test_non_inclus :-
	non_inclus([3,55], [1,2,3,4]),
	not non_inclus([3,2], [1,2,3,4]).

test_union_ens :-
	union_ens([1,2],[3,4], [1,2,3,4]).

test_inclus2 :-
	inclus2([3,2], [1,2,3,4]),	% mode (+,+)
	not inclus2([3,55], [1,2,3,4]), % mode (+,+) échec
	sortall(A, inclus2(A, [1,2]), [[], [1], [1, 2], [2], [2, 1]] ). % mode (-,+)
	% le mode (+,-) produit une infinité de solutions


sortall(Term, Goal, SortedList) :-
	findall(Term, Goal, List),
	msort(List, SortedList).

test(P) :- P, !, printf("OK %w \n", [P]).
test(P) :- printf("echec %w \n", [P]), fail.

% Fin des tests.


membre(A, [A|X]).	% A en mode - ? => No.
membre(A, [B|X]):-
	\==(A, B),
	membre(A, X).


compte(A, [], 0).		% Sujet et tests pas d'accord (- + +), (- + -)
compte(A, [B|X], N):-
	\==(A, B),
	compte(A, X, N).
compte(A, [A|X], N):-
	N1 is N - 1,
	compte(A, X, N1).


renv([], Y, Y).
renv([A|X], Y, Z):-
	renv(X, [A|Y], Z).

renverser(X, Y):-
	renv(X, [], Y).


palind(X):-
	renverser(X, R),
	==(X, R).


nieme1(1, [E|X], E):- !. % cut sinon maybe more ? No.
nieme1(N, [E|X], A):-
	N > 1,
	N1 is N-1,
	nieme1(N1, X, A).

nieme2(1, [E|X], E). % maybe more ? No.
nieme2(N, [E|X], A):-
	nieme2(N1, X, A),
	N is N1+1.

% sans doute pas


hors_de(A, []).
hors_de(A, [B|X]):-
	\==(A,B),
	hors_de(A, X).


tous_diff([]).
tous_diff([A|X]):-
	hors_de(A, X),
	tous_diff(X).



conc3([], [], Z, Z). % maybe more ? No.
conc3([], [A|Y], Z, [A|T]):-
	conc3([], Y, Z, T).
conc3([A|X], Y, Z, [A|T]):-
	conc3(X, Y, Z, T).

% ?- conc3([1,2,3,4],[5,6],[7,8,9,10], [1,2,3,4,5,6,7,8,9,10]).


debute_par(X, []).
debute_par([A|X], [A|Y]):-
	debute_par(X, Y).


sous_liste([A|X],Y):- % maybe more ? No.
	debute_par([A|X],Y).
sous_liste([A|X],Y):-
	sous_liste(X,Y).


elim([], []). % maybe more ? No.
elim([A|X], Y):-
	membre(A, Y),
	elim(X, Y).
elim([A|X], [A|Y]):-
	elim(X, Y).


inserer(E, [], [E]).
inserer(E, [A|L], [E,A|L]):-
	E =< A.
inserer(E, [A|L], [A|R]):-
	E > A,
	inserer(E, L, R).

tri([], []).
tri([A|L], R):-
	tri(L, R1),
	inserer(A, R1, R).


% 2.1

inclus([], Y).
inclus([A|X], Y):-
	membre(A, Y),
	inclus(X, Y).


non_inclus([A|X], Y):-
	hors_de(A,Y),
	!.					% => Peut faire autrement ?
non_inclus([A|X], Y):-
	non_inclus(X,Y).


union_ens([], Y, Y).	% Ordre ?
union_ens([A|X], Y, Z) :-
	membre(A, Y),
	union_ens(X, Y, Z).
union_ens([A|X], Y, [A|Z]) :-
	hors_de(A, Y),
	union_ens(X, Y, Z).


% 2.2 ==> solved

inclus2([], _).
inclus2([X|Xs], Y) :-
    append(L, [X|R], Y),
    append(L, R, Y1),
    inclus2(Xs, Y1).
