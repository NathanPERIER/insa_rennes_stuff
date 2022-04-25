:- lib(ic).

% 4.1

%getData(?, ?, ?, ?, ?)
getData(TailleEquipes, NbEquipes, CapaBateaux, NbBateaux, NbConf) :-
	NbConf = 3,
	TailleEquipes = [](5, 5, 2, 1),
	CapaBateaux = [](7, 6, 5),
	dim(TailleEquipes, [NbEquipes]),
	dim(CapaBateaux, [NbBateaux]).


% ===============================================

% 4.2

%defineVars(+, ?, ?, ?)
defineVars(T, NbEquipes, NbConf, NbBateaux) :-
	dim(T, [NbEquipes, NbConf]),
	(foreachelem(E, T), param(NbBateaux) do
		E #:: 1..NbBateaux
	).

% ===============================================

% 4.3

%getVarList(+, ?)
getVarList(T, L) :-
	dim(T, [MaxI, MaxJ]),
	(multifor([J, I], [MaxJ, MaxI], [1, 1], [-1, -1]), fromto([], In, Out, L), param(T) do
		E is T[I,J],
		Out = [E|In]
	).

% ?- defineVars(T, 4, 3, 3), getVarList(T, L).
%
% T = []([](_359{1 .. 3}, _414{1 .. 3}, _470{1 .. 3}), [](_531{1 .. 3}, _586{1 .. 3}, _642{1 .. 3}), [](_703{1 .. 3}, _758{1 .. 3}, _814{1 .. 3}), [](_872{1 .. 3}, _927{1 .. 3}, _983{1 .. 3}))
% L = [_359{1 .. 3}, _531{1 .. 3}, _703{1 .. 3}, _872{1 .. 3}, _414{1 .. 3}, _586{1 .. 3}, _758{1 .. 3}, _927{1 .. 3}, _470{1 .. 3}, _642{1 .. 3}, _814{1 .. 3}, _983{1 .. 3}]

% ===============================================

% 4.4

%solve1(?)
solve1(T) :-
	getData(_TailleEquipes, NbEquipes, _CapaBateaux, NbBateaux, NbConf),
	defineVars(T, NbEquipes, NbConf, NbBateaux),
	getVarList(T, L),
	labeling(L).

% ?- solve1(T).
% 
% T = []([](1, 1, 1), [](1, 1, 1), [](1, 1, 1), [](1, 1, 1))
% Yes (0.00s cpu, solution 1, maybe more) ? ;
% 
% T = []([](1, 1, 1), [](1, 1, 1), [](1, 1, 1), [](1, 1, 2))
% Yes (0.00s cpu, solution 2, maybe more) ? ;
% 
% T = []([](1, 1, 1), [](1, 1, 1), [](1, 1, 1), [](1, 1, 3))
% Yes (0.00s cpu, solution 3, maybe more) ? ;
% 
% T = []([](1, 1, 1), [](1, 1, 1), [](1, 1, 2), [](1, 1, 1))
% Yes (0.00s cpu, solution 4, maybe more) ?
% ...

% ===============================================

% 4.5

%pasMemesBateaux(+, +, +)
pasMemesBateaux(T, NbEquipes, _NbConf) :-
	(for(I, 1, NbEquipes), param(T) do
		L is T[I],
		alldifferent(L)
	).

%solve2(?)
solve2(T) :-
	getData(_TailleEquipes, NbEquipes, _CapaBateaux, NbBateaux, NbConf),
	defineVars(T, NbEquipes, NbConf, NbBateaux),
	pasMemesBateaux(T, NbEquipes, NbConf),
	getVarList(T, L),
	labeling(L).

% ?- solve2(T).
%
% T = []([](1, 2, 3), [](1, 2, 3), [](1, 2, 3), [](1, 2, 3))
% Yes (0.00s cpu, solution 1, maybe more) ? ;
%
% T = []([](1, 2, 3), [](1, 2, 3), [](1, 2, 3), [](1, 3, 2))
% Yes (0.00s cpu, solution 2, maybe more) ? ;
%
% T = []([](1, 2, 3), [](1, 2, 3), [](1, 3, 2), [](1, 2, 3))
% Yes (0.00s cpu, solution 3, maybe more) ? ;
%
% T = []([](1, 2, 3), [](1, 2, 3), [](1, 3, 2), [](1, 3, 2))
% Yes (0.00s cpu, solution 4, maybe more) ?
% ...

% ===============================================

% 4.6

%pasMemePartenaires(+, +, +)
pasMemePartenaires(T, NbEquipes, NbConf) :-
	(multifor([J, I], [1, 1], [NbConf-1, NbEquipes-1]), param(T, NbEquipes, NbConf) do
		(multifor([I1, J1], [I+1, J+1], [NbEquipes, NbConf]), param(T, I, J) do
			(T[I,J] #= T[I1,J]) => (T[I,J1] #\= T[I1,J1])
		)
	).

%solve3(?)
solve3(T) :-
	getData(_TailleEquipes, NbEquipes, _CapaBateaux, NbBateaux, NbConf),
	defineVars(T, NbEquipes, NbConf, NbBateaux),
	pasMemesBateaux(T, NbEquipes, NbConf),
	pasMemePartenaires(T, NbEquipes, NbConf),
	getVarList(T, L),
	labeling(L).

% ?- solve3(T).
%
% T = []([](1, 2, 3), [](1, 3, 2), [](2, 1, 3), [](2, 3, 1))
% Yes (0.00s cpu, solution 1, maybe more) ? ;
% 
% T = []([](1, 2, 3), [](1, 3, 2), [](2, 3, 1), [](2, 1, 3))
% Yes (0.00s cpu, solution 2, maybe more) ? ;
% 
% T = []([](1, 3, 2), [](1, 2, 3), [](2, 1, 3), [](2, 3, 1))
% Yes (0.00s cpu, solution 3, maybe more) ? ;
% 
% T = []([](1, 3, 2), [](1, 2, 3), [](2, 3, 1), [](2, 1, 3))
% Yes (0.00s cpu, solution 4, maybe more) ?
% ...

% ===============================================

% 4.7

%capaBateaux(+, +, +, +, +, +)
capaBateaux(T, TailleEquipes, NbEquipes, CapaBateaux, NbBateaux, NbConf) :-
	(multifor([Bat, J], [1, 1], [NbBateaux, NbConf]), param(T, NbEquipes, TailleEquipes, CapaBateaux) do
		(for(I, 1, NbEquipes), fromto(0, In, Out, Sum), param(T, TailleEquipes, Bat, J) do
			Out #= TailleEquipes[I] * (T[I,J] #= Bat) + In
		),
		Sum #=< CapaBateaux[Bat]
	).


%solve(?)
solve(T) :-
	getData(TailleEquipes, NbEquipes, CapaBateaux, NbBateaux, NbConf),
	defineVars(T, NbEquipes, NbConf, NbBateaux),
	pasMemesBateaux(T, NbEquipes, NbConf),
	pasMemePartenaires(T, NbEquipes, NbConf),
	capaBateaux(T, TailleEquipes, NbEquipes, CapaBateaux, NbBateaux, NbConf),
	getVarList(T, L),
	labeling(L).

% ?- solve(T).
%
% T = []([](1, 2, 3), [](2, 3, 1), [](3, 1, 2), [](3, 2, 1))
% Yes (0.00s cpu, solution 1, maybe more) ? ;
% 
% T = []([](1, 3, 2), [](2, 1, 3), [](3, 2, 1), [](3, 1, 2))
% Yes (0.00s cpu, solution 2, maybe more) ? ;
% 
% T = []([](1, 2, 3), [](3, 1, 2), [](2, 3, 1), [](1, 3, 2))
% T = []([](1, 2, 3), [](3, 1, 2), [](2, 3, 1), [](1, 3, 2));
% 
% T = []([](1, 3, 2), [](3, 2, 1), [](2, 1, 3), [](1, 2, 3))
% Yes (0.01s cpu, solution 4, maybe more) ?
% ...

% ===============================================

% 4.8

%solveBig(?)
solveBig(T) :-
	getDataBig(TailleEquipes, NbEquipes, CapaBateaux, NbBateaux, NbConf),
	defineVars(T, NbEquipes, NbConf, NbBateaux),
	pasMemesBateaux(T, NbEquipes, NbConf),
	pasMemePartenaires(T, NbEquipes, NbConf),
	capaBateaux(T, TailleEquipes, NbEquipes, CapaBateaux, NbBateaux, NbConf),
	getVarList(T, L),
	labeling(L).

%getDataBig(?, ?, ?, ?, ?)
getDataBig(TailleEquipes, NbEquipes, CapaBateaux, NbBateaux, NbConf) :-
	NbConf = 7,
	TailleEquipes = [](7, 6, 5, 5, 5, 4, 4, 4, 4, 4, 4, 4, 4, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2),
	CapaBateaux = [](10, 10, 9, 8, 8, 8, 8, 8, 8, 7, 6, 4, 4),
	dim(TailleEquipes, [NbEquipes]),
	dim(CapaBateaux, [NbBateaux]).

% ?- solveBig(T).
%
% T = []([](1, 2, 3, 4, 5, 6, 7), [](2, 1, 4, 3, 6, 5, 8), [](3, 4, 1, 2, 7, 8, 5), [](4, 3, 1, 5, 2, 7, 6), [](5, 6, 2, 1, 3, 4, 9), [](2, 3, 5, 1, 4, 9, 10), [](3, 1, 2, 6, 4, 10, 11), [](6, 5, 7, 2, 1, 3, 4), [](6, 7, 5, 8, 2, 1, 3), [](7, 5, 6, 8, 3, 2, 1), [](7, 8, 9, 6, 1, 11, 2), [](8, 7, 6, 9, 10, 3, 2), [](8, 9, 7, 10, 11, 1, 12), [](1, 4, 8, 3, 9, 7, 10), [](4, 2, 8, 7, 1, 9, 11), [](5, 8, 3, 7, 6, 10, 1), [](9, 6, 4, 5, 8, 11, 1), [](9, 8, 10, 11, 7, 12, 3), [](9, 10, 8, 12, 11, 2, 13), [](9, 11, 12, 7, 10, 13, 4), [](10, 9, 11, 7, 8, 12, 2), [](10, 11, 9, 12, 13, 1, 5), [](10, 12, 13, 11, 9, 2, 4), [](11, 9, 10, 13, 12, 2, 6), [](11, 10, 12, 9, 13, 4, 8), [](11, 12, 9, 10, 8, 13, 3), [](12, 10, 11, 13, 9, 8, 1), [](12, 11, 10, 9, 8, 5, 13))
% Yes (20.10s cpu, solution 1, maybe more) ?

% Afin d'optimiser la recherche, on va alterner les équipes avec beaucoup de membres (au début de la liste)
% et celles avec peu de membres (à la fin).
% Pour cela, on crée un prédicat qui va réordonner les indices de la liste :

%getNewIndex(+, +, -)
getNewIndex(OriginalIndex, Size, NewIndex) :-
	1 is OriginalIndex mod 2,
	NewIndex is 1 + OriginalIndex div 2,
	!.
getNewIndex(OriginalIndex, Size, NewIndex) :-
	NewIndex is Size - OriginalIndex div 2 + 1.

% On peut tester ce prédicat comme suit :

%testNewIndex(+, ?)
testNewIndex(Size, Res) :-
	(for(I, 1, Size), fromto(Res, In, Out, []), param(Size) do
		getNewIndex(I, Size, NI),
		In = [NI|Out]
	).

% ?- testNewIndex(4, L).
%
% L = [1, 4, 2, 3]
% Yes (0.00s cpu)
% ?- testNewIndex(5, L).
%
% L = [1, 5, 2, 4, 3]
% Yes (0.00s cpu)

% Cela nous permet d'écrire une nouvelle version de getVarList :

%getOptimisedVarList(+, ?)
getOptimisedVarList(T, L) :-
	dim(T, [MaxI, MaxJ]),
	(multifor([J, I], [MaxJ, MaxI], [1, 1], [-1, -1]), fromto([], In, Out, L), param(T, MaxI) do
		getNewIndex(I, MaxI, K),
		E is T[K,J],
		Out = [E|In]
	).

% Et enfin on résoud avec les nouvelles optimisations :

%solveBigOptimised(?)
solveBigOptimised(T) :-
	getDataBig(TailleEquipes, NbEquipes, CapaBateaux, NbBateaux, NbConf),
	defineVars(T, NbEquipes, NbConf, NbBateaux),
	pasMemesBateaux(T, NbEquipes, NbConf),
	pasMemePartenaires(T, NbEquipes, NbConf),
	capaBateaux(T, TailleEquipes, NbEquipes, CapaBateaux, NbBateaux, NbConf),
	getOptimisedVarList(T, L),
	labeling(L).

% ?- solveBigOptimised(T).
%
% T = []([](1, 2, 3, 4, 5, 6, 7), [](2, 1, 4, 3, 6, 5, 8), [](3, 4, 1, 2, 8, 7, 9), [](4, 3, 5, 1, 2, 9, 10), [](5, 6, 2, 7, 1, 3, 11), [](6, 5, 7, 2, 1, 4, 3), [](6, 7, 8, 5, 2, 1, 4), [](7, 5, 6, 8, 4, 10, 1), [](8, 9, 7, 6, 11, 1, 13), [](8, 10, 9, 11, 3, 12, 5), [](9, 8, 10, 13, 12, 11, 2), [](10, 9, 11, 8, 13, 2, 6), [](11, 12, 13, 9, 10, 8, 1), [](12, 11, 10, 7, 9, 13, 3), [](13, 11, 9, 12, 10, 5, 2), [](11, 13, 8, 10, 7, 9, 2), [](10, 8, 12, 9, 7, 3, 4), [](9, 10, 8, 12, 11, 4, 1), [](9, 7, 6, 10, 8, 3, 5), [](7, 8, 9, 10, 6, 2, 3), [](7, 6, 5, 9, 3, 1, 2), [](5, 7, 1, 3, 4, 2, 10), [](4, 1, 6, 5, 3, 2, 9), [](3, 2, 4, 1, 7, 11, 12), [](3, 1, 2, 6, 9, 10, 4), [](2, 4, 3, 1, 9, 8, 6), [](2, 3, 1, 6, 7, 4, 5), [](1, 3, 2, 5, 4, 7, 6))
% Yes (0.63s cpu, solution 1, maybe more) ?
