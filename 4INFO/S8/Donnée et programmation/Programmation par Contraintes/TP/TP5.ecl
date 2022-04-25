:- lib(ic).
:- lib(branch_and_bound).


% 5.5

%optimal_profit(?, ?, ?)
optimal_profit(Fabriquer, ProfitTotal, NbTechniciens) :-
	ProfitTotalNeg #= -1 * ProfitTotal,
	minimize(solve(Fabriquer, ProfitTotal, NbTechniciens), ProfitTotalNeg).

% ===============================================

% 5.6

%poseContraintesMaisCestLaCrise(?, ?, ?)
poseContraintesMaisCestLaCrise(Fabriquer, NbTechniciens, ProfitTotal) :-
	(foreachelem(X, Fabriquer) do
		X #:: 0..1
	),
	NbTechniciens #=< 22,
	ProfitTotal #>= 1000.

%solveCrisis(?, ?, ?)
solveCrisis(Fabriquer, ProfitTotal, NbTechniciens) :-
	poserDonnees(Techniciens, Quantites, Benefices),
	poserVariables(Fabriquer, 9),
	calcBeneficesTotaux(Quantites, Benefices, BeneficesTotaux),
	calcNbTechniciens(Techniciens, Fabriquer, NbTechniciens),
	calcProfitTotal(BeneficesTotaux, Fabriquer, ProfitTotal),
	poseContraintesMaisCestLaCrise(Fabriquer, NbTechniciens, ProfitTotal),
	getVarList(ProfitTotal, NbTechniciens, Fabriquer, Vars),
	labeling(Vars).

%optimal_techniciens(?, ?, ?)
optimal_techniciens(Fabriquer, ProfitTotal, NbTechniciens) :-
	minimize(solveCrisis(Fabriquer, ProfitTotal, NbTechniciens), NbTechniciens).

% ===============================================

% Solve

%solve(?, ?, ?)
solve(Fabriquer, ProfitTotal, NbTechniciens) :-
	poserDonnees(Techniciens, Quantites, Benefices),
	poserVariables(Fabriquer, 9),
	calcBeneficesTotaux(Quantites, Benefices, BeneficesTotaux),
	calcNbTechniciens(Techniciens, Fabriquer, NbTechniciens),
	calcProfitTotal(BeneficesTotaux, Fabriquer, ProfitTotal),
	poseContraintes(Fabriquer, NbTechniciens, ProfitTotal),
	getVarList(ProfitTotal, NbTechniciens, Fabriquer, Vars),
	labeling(Vars).

% ===============================================

% 5.1

%poserDonnees(?, ?, ?)
poserDonnees(Techniciens, Quantites, Benefices) :-
	Techniciens = [](5,   7,   2,  6,  9,  3,  7,   5,  3),
	Quantites   = [](140, 130, 60, 95, 70, 85, 100, 30, 45),
	Benefices   = [](4,   5,   8,  5,  6,  4,  7,   10, 11).

%poserVariables(?, +)
poserVariables(Fabriquer, Taille) :-
	dim(Fabriquer, [Taille]).

% ===============================================

% 5.3

%poseContraintes(?, ?, ?)
poseContraintes(Fabriquer, NbTechniciens, ProfitTotal) :-
	(foreachelem(X, Fabriquer) do
		X #:: 0..1
	),
	NbTechniciens #=< 22,
	ProfitTotal #>= 0.

%getVarList(+, +, +, ?)
getVarList(ProfitTotal, NbTechniciens, Fabriquer, Vars) :-
	(foreachelem(X, Fabriquer), fromto([ProfitTotal,NbTechniciens], In, Out, Vars) do
		Out = [X|In]
	).

% ===============================================

% 5.2

%produitScalaire(?, ?, ?)
produitScalaire(Vec1, Vec2, Res) :-
	dim(Vec1, [Taille]),
	dim(Vec2, [Taille]),
	(for(I, 1, Taille), fromto(0, In, Out, Res), param(Vec1, Vec2) do
		V1i is Vec1[I],
		V2i is Vec2[I],
		Out #= In + V1i * V2i
	).
% ou ic:sum(Vector1*Vector2)

%calcBeneficesTotaux(+, +, ?)
calcBeneficesTotaux(Quantites, Benefices, BeneficesTotaux) :-
	dim(Benefices, [Taille]),
	dim(BeneficesTotaux, [Taille]),
	(for(I, 1, Taille), param(Quantites, Benefices, BeneficesTotaux) do
		Qi is Quantites[I],
		Bi is Benefices[I],
		Ri is Qi * Bi,
		BTi is BeneficesTotaux[I],
		BTi = Ri
	).

%calcNbTechniciens(+, ?, ?)
calcNbTechniciens(Techniciens, Fabriquer, NbTechniciens) :-
	produitScalaire(Techniciens, Fabriquer, NbTechniciens).

%calcProfitTotal(+, ?, ?)
calcProfitTotal(BeneficesTotaux, Fabriquer, ProfitTotal) :-
	produitScalaire(BeneficesTotaux, Fabriquer, ProfitTotal).

% ===============================================

% 5.4

test_minimize1(X, Y, Z, W) :-
	[X, Y, Z, W] #:: 0..10,
	X #= Z + Y + 2*W,
	X #\= Z + Y + W,
	minimize(labeling([X]), X).
	
% ?- test_minimize1(X, Y, Z, W).
% Found a solution with cost 1
% Found no solution with cost 0.0 .. 0.0
%
% X = 1
% Y = Y{[0, 1]}
% Z = Z{[0, 1]}
% W = 0
% 
% 
% Delayed goals:
%         - Z{[0, 1]} - Y{[0, 1]} #= -1
%         - Y{[0, 1]} - Z{[0, 1]} - 0 + 1 #\= 0
% Yes (0.00s cpu)

test_minimize2(X, Y, Z, W) :-
	[X, Y, Z, W] #:: 0..10,
	X #= Z + Y + 2*W,
	X #\= Z + Y + W,
	minimize(labeling([X, Y, Z, W]), X).

% ?- test_minimize1(X, Y, Z, W).
% Found a solution with cost 2
% Found no solution with cost 0.0 .. 1.0
%
% X = 2
% Y = 0
% Z = 0
% W = 1
% Yes (0.00s cpu)

% On voit que la seconde version renvoie une solution, contrairement à la première 
% qui n'a pas fini d'appliquer les contraintes
% Il faut donc toujours lister toutes les variables du problème dans le but.

% ===============================================

% Résultats des tests

% ?- solve(Fabriquer, ProfitTotal, NbTechniciens).
%
% Fabriquer = [](0, 0, 0, 0, 0, 0, 0, 0, 0)
% ProfitTotal = 0
% NbTechniciens = 0
% Yes (0.00s cpu, solution 1, maybe more) ? ;
%
% Fabriquer = [](1, 0, 0, 0, 0, 0, 0, 0, 0)
% ProfitTotal = 560
% NbTechniciens = 5
% Yes (0.00s cpu, solution 2, maybe more) ? ;
%
% Fabriquer = [](0, 1, 0, 0, 0, 0, 0, 0, 0)
% ProfitTotal = 650
% NbTechniciens = 7
% Yes (0.00s cpu, solution 3, maybe more) ? ;
%
% Fabriquer = [](1, 1, 0, 0, 0, 0, 0, 0, 0)
% ProfitTotal = 1210
% NbTechniciens = 12
% Yes (0.00s cpu, solution 4, maybe more) ?
% ...
% (232 solutions au total)

% ?- optimal_profit(Fabriquer, ProfitTotal, NbTechniciens).
% Found a solution with cost 0
% Found a solution with cost -560
% Found a solution with cost -650
% Found a solution with cost -1210
% Found a solution with cost -1690
% Found a solution with cost -2165
% Found a solution with cost -2390
% Found a solution with cost -2525
% Found a solution with cost -2575
% Found a solution with cost -2665
% Found no solution with cost -1.0Inf .. -2666
% 
% Fabriquer = [](0, 1, 1, 0, 0, 1, 1, 0, 1)
% ProfitTotal = 2665
% NbTechniciens = 22
% Yes (0.00s cpu)

% ?- optimal_techniciens(Fabriquer, ProfitTotal, NbTechniciens).
% Found a solution with cost 12
% Found a solution with cost 7
% Found no solution with cost -1.0Inf .. 6
%
% Fabriquer = [](1, 0, 1, 0, 0, 0, 0, 0, 0)
% ProfitTotal = 1040
% NbTechniciens = 7
% Yes (0.00s cpu)
