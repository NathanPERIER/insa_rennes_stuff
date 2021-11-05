% dana likes cody
% bess does not like dana
% cody does not like abby
% nobody likes someone who does not like her
% abby likes everyone who likes bess
% dana likes everyone bess likes
% everybody likes somebody

% people([abby, bess, cody, dana]).
people([abby, bess, cody, dana, peter]).

% 1.1

addAll(_, [], R, R).
addAll(E, [A|L], M, R) :-
        addAll(E, L, [likes(E, A)|M], R).

mkpairs(_, [], R, R).
mkpairs(L, [E|Li], A, R):-
        addAll(E, L, A, A1), 
        mkpairs(L, Li, A1, R).

make_all_pairs(L, R):-
        mkpairs(L, L, [], R).


% 1.2

sub_list([], []).
sub_list([_|L], R):-
        sub_list(L, R).
sub_list([A|L], [A|R]):-
        sub_list(L, R).


% 1.3

contains(E, [E|_]):- !.
contains(E, [_|L]):-
        contains(E, L).

contains_not(_, []).
contains_not(E, [E|_]):-
        !,
        fail.
contains_not(E, [_|L]):-
        contains_not(E, L).

remove(_, [], []).
remove(E, [E|L], R):-
        !, 
        remove(E, L, R).
remove(E, [A|L], [A|R]):-
        remove(E, L, R).


proposition1(L):-
        contains(likes(dana, cody), L).

proposition2(L):-
        contains_not(likes(bess, dana), L).

proposition3(L):-
        contains_not(likes(cody, abby), L).

proposition4([]).
proposition4([likes(A, A)|L]):-
        !,
        proposition4(L).
proposition4([likes(A, B)|L]):-
        contains(likes(B, A), L),
        remove(likes(B, A), L, L1),
        proposition4(L1).

aux5(_, []).
aux5(L, [likes(A, bess)|R]):-
        !,
        contains(likes(abby, A), L),
        aux5(L, R).
aux5(L, [_|R]):-
        aux5(L, R).

proposition5(L):-
        aux5(L, L).

aux6(_, []).
aux6(L, [likes(bess, A)|R]):-
        !,
        contains(likes(dana, A), L),
        aux6(L, R).
aux6(L, [_|R]):-
        aux6(L, R).

proposition6(L):-
        aux6(L, L).

aux7([], _) :-
        !.
aux7([_E|_L], []) :-
        fail.
aux7(P, [likes(A, _)|R]):-
        remove(A, P, P1),
        aux7(P1, R).

proposition7(L):-
        people(P),
        aux7(P, L).


% 1.4

possible_worlds(W) :-
        people(P),
        make_all_pairs(P, L),
        sub_list(L, W),
        proposition7(W),
        proposition1(W),
        proposition2(W),
        proposition3(W),
        proposition4(W),
        proposition5(W),
        proposition6(W).

% 1.5 : Pas de doublons

% Questions 1.6 and 1.7
test_possible_worlds :-
        possible_worlds(World),
        writeln(World),
        fail.

% 4 pers. : 65 536 sorties de sublist           = 2^8 * 2^4 * 2^2 * 2 * 2
% 5 pers. : 33 554 432 sorties de sublist       = 2^16 * 2^8 * 2^4 * 2^2 * 2 * 2
% O( 2 * 2^(sum for i in 0..(n-1) of 2^2^i) )

% Déplacer les propositions ne change pas le nombre de réponses mais change l'ordre dans lequel elles apparaissent
% Change les résultats du coverage => change (un peu) la complexité


% getcwd(Where).
% cd("/home/nathan/Documents/INSA Rennes 2020-2021/Programmation Logique/TP6").
% ?- lib(coverage).
% ?- coverage:ccompile("tp_possible_worlds_students").
% ?- test_possible_worlds.
% ?- coverage:result("tp_possible_worlds_students").