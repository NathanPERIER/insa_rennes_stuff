:- lib(ic).
:- lib(ic_symbolic).

?- local domain(machine(m1, m2)).

% 3.1

% taches(?)
taches(Taches) :-
	Taches = [](
		tache(3, [],      m1, _),
		tache(8, [],      m1, _),
		tache(8, [4, 5],  m1, _),
		tache(6, [],      m2, _),
		tache(3, [1],     m2, _),
		tache(4, [1, 7],  m1, _),
		tache(8, [3, 5],  m1, _),
		tache(6, [4],     m2, _),
		tache(6, [6, 7],  m2, _),
		tache(6, [9, 12], m2, _),
		tache(3, [1],     m2, _),
		tache(6, [7, 8],  m2, _)
	).

% ===============================================

% 3.2

affiche(Taches) :-
	(foreachelem(E, Taches) do
		writeln(E)
	).

% ===============================================

% 3.3

% domaines(+, ?)
domaines(Taches, Fin) :-
	Fin #>= 0,
	(foreachelem(E, Taches), param(Fin) do
		E = tache(Duree, _Noms, _Machine, Debut),
		Debut #>= 0,
		Debut + Duree #=< Fin
	).

% ===============================================

% 3.4

% getVarList(+, ?, ?)
getVarList(Taches, Fin, [Fin|Last]) :-
	(foreachelem(E, Taches), fromto([], In, Out, Last) do
		E = tache(_Duree, _Noms, _Machine, D),
		Out = [D|In]
	).

% ===============================================

% 3.5

% solvePartial(?, ?)
solvePartial(Taches, Fin) :-
	taches(Taches),
	domaines(Taches, Fin),
	getVarList(Taches, Fin, Vars),
	ic:labeling(Vars).

% ?- solvePartial(T, F).
%
% T = [](tache(3, [], m1, 0), tache(8, [], m1, 0), tache(8, [4, 5], m1, 0), tache(6, [], m2, 0), tache(3, [1], m2, 0), tache(4, [1, 7], m1, 0), tache(8, [3, 5], m1, 0), tache(6, [4], m2, 0), tache(6, [6, 7], m2, 0), tache(6, [9, 12], m2, 0), tache(3, [1], m2, 0), tache(6, [7, 8], m2, 0))
% F = 8
% Yes (0.00s cpu, solution 1, maybe more) ? ;
%
% T = [](tache(3, [], m1, 1), tache(8, [], m1, 0), tache(8, [4, 5], m1, 0), tache(6, [], m2, 0), tache(3, [1], m2, 0), tache(4, [1, 7], m1, 0), tache(8, [3, 5], m1, 0), tache(6, [4], m2, 0), tache(6, [6, 7], m2, 0), tache(6, [9, 12], m2, 0), tache(3, [1], m2, 0), tache(6, [7, 8], m2, 0))
% F = 8

% C'est cohérent avec les contraintes qui sont posées pour le moment : aucune tâche ne commence avant 0 et toutes les tâches finissent avant fin

% ===============================================

% 3.6

% precedences(?)
precedences(Taches) :-
	(foreachelem(E, Taches), param(Taches) do
		E = tache(_Duree, Noms, _Machine, Debut),
		(foreach(N, Noms), param(Taches, Debut) do
			tache(Duree1, _Noms1, _Machine1, Debut1) is Taches[N],
			Debut #>= Debut1 + Duree1
		)
	).

% ===============================================

% 3.7

% conflits(+)
conflits(Taches) :-
	(foreachelem(E1, Taches, [I1]), param(Taches) do
		(foreachelem(E2, Taches, [I2]), param(E1, I1) do
			E1 = tache(Duree1, _Noms1, Machine1, Debut1),
			E2 = tache(Duree2, _Noms2, Machine2, Debut2),
			((Machine1 &= Machine2) and (I1 #\= I2)) => ((Debut1 #> Debut2 and Debut1 #>= Debut2 + Duree2) or (Debut2 #> Debut1 and Debut2 #>= Debut1 + Duree1))
		)
	).

% solve(?, ?)
solve(Taches, Fin) :-
	taches(Taches),
	domaines(Taches, Fin),
	precedences(Taches),
	conflits(Taches),
	getVarList(Taches, Fin, Vars),
	ic:labeling(Vars).

% ?- solve(Taches, Fin).
%
% Taches = [](tache(3, [], m1, 0), tache(8, [], m1, 29), tache(8, [4, 5], m1, 9), tache(6, [], m2, 0), tache(3, [1], m2, 6), tache(4, [1, 7], m1, 25), tache(8, [3, 5], m1, 17), tache(6, [4], m2, 12), tache(6, [6, 7], m2, 31), tache(6, [9, 12], m2, 37), tache(3, [1], m2, 9), tache(6, [7, 8], m2, 25))
% Fin = 43
% Yes (0.03s cpu, solution 1, maybe more) ?
% ...

% ===============================================

% 3.8

% ?- Fin #< 43, solve(Taches, Fin).
% 
% No (0.01s cpu)

% Donc la solution est bien optimale
