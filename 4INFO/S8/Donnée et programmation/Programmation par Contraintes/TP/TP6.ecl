:- lib(ic).
:- lib(branch_and_bound).

% Optimisation

%moment_minimum(?, ?)
moment_minimum(Places, ContrainteTotale) :-
	minimize(
		(
			balancoire(Places, ContrainteTotale),
			labeling(Places)
		),
		ContrainteTotale
	).


% Variantes

% Élimination des symétries

%moment_minimum_nonsym(?, ?)
moment_minimum_nonsym(Places, ContrainteTotale) :-
	minimize(
		(
			balancoireNonSym(Places, ContrainteTotale),
			labeling(Places)
		),
		ContrainteTotale
	).

% Variables plus contraintes en premier, valeurs dans l'ordre croissant

%moment_minimum_custom1(?, ?)
moment_minimum_custom1(Places, ContrainteTotale) :-
	minimize(
		(
			balancoireNonSym(Places, ContrainteTotale),
			search(Places, 0, occurrence, indomain, complete, [])
		),
		ContrainteTotale
	).

% Variables dans l'ordre de la liste, valeurs dans un ordre adapté au problème

%moment_minimum_custom2(?, ?)
moment_minimum_custom2(Places, ContrainteTotale) :-
	minimize(
		(
			balancoireNonSym(Places, ContrainteTotale),
			search(Places, 0, input_order, indomain_median, complete, [])
		),
		ContrainteTotale
	).

% Variables plus contraintes en premier, valeurs dans un ordre adapté au problème

%moment_minimum_custom3(?, ?)
moment_minimum_custom3(Places, ContrainteTotale) :-
	minimize(
		(
			balancoireNonSym(Places, ContrainteTotale),
			search(Places, 0, occurrence, indomain_median, complete, [])
		),
		ContrainteTotale
	).

% Variables plus contraintes en premier, valeurs dans un ordre adapté au problème
% + tableau trié pour mettre les variables plus importantes en premier
% (ordre décroissant en poids, sauf pour les parents qui sont à la fin)

%moment_minimum_custom4(?, ?)
moment_minimum_custom4(Places, ContrainteTotale) :-
	minimize(
		(
			balancoireNonSym(Places, ContrainteTotale),
			Places = [](Ron, Zoe, Jim, Lou, Luc, Dan, Ted, Tom, Max, Kim),
			PlcTri = [](Jim, Luc, Ted, Zoe, Ron, Kim, Max, Dan, Lou, Tom),
			search(PlcTri, 0, occurrence, indomain_median, complete, [])
		),
		ContrainteTotale
	).

% ===============================================

% solve

%balancoire(?, ?)
balancoire(Places, ContrainteTotale) :-
	poserDonnees(Poids),
	poserVariables(Places),
	calcMoments(Poids, Places, Moments),
	calcMomentTotal(Moments, MomentTotal),
	calcContrainteTotale(Moments, ContrainteTotale),
	poserContraintesPlaces(Places),
	poserContraintesParents(Places),
	poserContraintesEnfants(Places),
	poserContraintesMoments(MomentTotal).

% ===============================================

% 6.3

% On a une symétrie par rapport au centre de la balançoire
% Par exemple, sur un problème de taille plus petite, si la 
% configuration suivante est valide :
% A _ B C  |  D _ E F
% Alors cette configuration l'est également :
% F E _ D  |  C B _ A
% Pour n'avoir qu'une seule des deux solutions, il suffit de forcer le côté
% où sont placés les parents
% Ici on mettra toujours Lou à gauche et Tom à droite

%poserContraintesParentsNonSym(+)
poserContraintesParentsNonSym(Places) :-
	Lou is Places[4],
	Tom is Places[8],
	Lou #< -1,
	Tom #> 1,
	Lou #= min(Places),
	Tom #= max(Places).

%poserContraintesEnfantsNonSym(+)
poserContraintesEnfantsNonSym(Places) :-
	Lou is Places[4],
	Tom is Places[8],
	Dan is Places[6],
	Max is Places[9],
	(Dan #= Lou+1 and Max #= Tom-1) or (Max #= Lou+1 and Dan #= Tom-1).

%balancoireNonSym(?, ?)
balancoireNonSym(Places, ContrainteTotale) :-
	poserDonnees(Poids),
	poserVariables(Places),
	calcMoments(Poids, Places, Moments),
	calcMomentTotal(Moments, MomentTotal),
	calcContrainteTotale(Moments, ContrainteTotale),
	poserContraintesPlaces(Places),
	poserContraintesParentsNonSym(Places),
	poserContraintesEnfantsNonSym(Places),
	poserContraintesMoments(MomentTotal).

% ===============================================

%poserDonnees(?)
poserDonnees(Poids) :-
	Poids = [](24, 39, 85, 60, 165, 6, 32, 123, 7, 14).

%poserVariables(?)
poserVariables(Places) :-
	dim(Places, [10]).

%calcMoments(+, +, ?)
calcMoments(Poids, Places, Moments) :-
	dim(Poids, [N]),
	dim(Places, [N]),
	dim(Moments, [N]),
	(for(I, 1, N), param(Poids, Places, Moments) do
		Poi is Poids[I],
		Pli is Places[I],
		Mi  is Moments[I],
		Mi #= Poi * Pli
	).

%calcMomentTotal(+, ?)
calcMomentTotal(Moments, MomentTotal) :-
	(foreachelem(E, Moments), fromto(0, In, Out, MomentTotal) do
		Out #= In + E
	).

%calcContrainteTotale(+, ?)
calcContrainteTotale(Moments, ContrainteTotale) :-
	(foreachelem(E, Moments), fromto(0, In, Out, ContrainteTotale) do
		Out #= In + abs(E)
	).

%poserContraintesPlaces(+)
poserContraintesPlaces(Places) :-
	alldifferent(Places),
	(foreachelem(P, Places) do
		P #:: -8..8,
		P #\= 0
	).

%poserContraintesParents(+)
poserContraintesParents(Places) :-
	Lou is Places[4],
	Tom is Places[8],
	(Lou #= min(Places) and Tom #= max(Places)) or (Lou #= max(Places) and Tom #= min(Places)).

%poserContraintesEnfants(+)
poserContraintesEnfants(Places) :-
	Lou is Places[4],
	Tom is Places[8],
	Dan is Places[6],
	Max is Places[9],
	(Lou #< 0) => ((Dan #= Lou+1 and Max #= Tom-1) or (Max #= Lou+1 and Dan #= Tom-1)),
	(Lou #> 0) => ((Dan #= Lou-1 and Max #= Tom+1) or (Max #= Lou-1 and Dan #= Tom+1)).

%poserContraintesMoments(+)
poserContraintesMoments(MomentTotal) :-
	MomentTotal #= 0.

% ===============================================

% Résultats des tests

% ?- moment_minimum(Places, ContrainteTotale).
% Found a solution with cost 2444
% Found a solution with cost 2416
% Found a solution with cost 2318
% Found a solution with cost 2004
% Found a solution with cost 1948
% Found a solution with cost 1856
% Found a solution with cost 1850
% Found a solution with cost 1764
% Found a solution with cost 1744
% Found a solution with cost 1736
% Found a solution with cost 1668
% Found a solution with cost 1604
% Found a solution with cost 1506
% Found no solution with cost -1.0Inf .. 1505
%
% Places = [](-3, 2, -1, -7, 1, 3, -2, 4, -6, -5)
% ContrainteTotale = 1506
% Yes (1.45s cpu)

% ?- moment_minimum_nonsym(Places, ContrainteTotale).
% Found a solution with cost 2444
% Found a solution with cost 2416
% Found a solution with cost 2318
% Found a solution with cost 2004
% Found a solution with cost 1948
% Found a solution with cost 1856
% Found a solution with cost 1850
% Found a solution with cost 1764
% Found a solution with cost 1744
% Found a solution with cost 1736
% Found a solution with cost 1668
% Found a solution with cost 1604
% Found a solution with cost 1506
% Found no solution with cost -1.0Inf .. 1505
%
% Places = [](-3, 2, -1, -7, 1, 3, -2, 4, -6, -5)
% ContrainteTotale = 1506
% Yes (0.54s cpu)

% ?- moment_minimum_custom1(Places, ContrainteTotale).
% Found a solution with cost 1856
% Found a solution with cost 1764
% Found a solution with cost 1744
% Found a solution with cost 1704
% Found a solution with cost 1506
% Found no solution with cost -1.0Inf .. 1505
%
% Places = [](-3, 2, -1, -7, 1, 3, -2, 4, -6, -5)
% ContrainteTotale = 1506
% Yes (0.16s cpu)

% ?- moment_minimum_custom2(Places, ContrainteTotale).

% ?- moment_minimum_custom3(Places, ContrainteTotale).

% ?- moment_minimum_custom4(Places, ContrainteTotale).
