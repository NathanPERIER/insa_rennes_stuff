:- lib(ic).
:- lib(ic_symbolic).
:- lib(ic_global).
:- lib(branch_and_bound).

/*
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:::::::::::::::::::::::::::::::::::::::::::::-'    `-::::::::::::::::::
::::::::::::::::::::::::::::::::::::::::::-'  IL FAUT  ::::::::::::::::
:::::::::::::::::::::::::::::::::::::::-  '  UTILISER   `::::::::::::::
:::::::::::::::::::::::::::::::::::-'      minimize_quiet :::::::::::::
::::::::::::::::::::::::::::::::-         .  AU LIEU DE  ::::::::::::::
::::::::::::::::::::::::::::-'             .  minimize  :::::::::::::::
:::::::::::::::::::::::::-'                 `-.        ::::::::::::::::
:::::::::::::::::::::-'                  _,,-::::::::::::::::::::::::::
::::::::::::::::::-'                _,--:::::::::::::::::::::::::::::::
::::::::::::::-'               _.--::::::::::::::::::::::#####:::::::::
:::::::::::-'             _.--:::::::::::::::::::::::::::#####:::::####
::::::::'    ##     ###.-::::::###:::::::::::::::::::::::#####:::::####
::::-'       ###_.::######:::::###::::::::::::::#####:##########:::####
:'         .:###::########:::::###::::::::::::::#####:##########:::####
     ...--:::###::########:::::###:::::######:::#####:##########:::####
 _.--:::##:::###:#########:::::###:::::######:::#####:#################
'#########:::###:#########::#########::######:::#####:#################
:#########:::#############::#########::######:::#######################
##########:::########################::################################
##########:::##########################################################
##########:::##########################################################
#######################################################################
#######################################################################
################################################################# dp ##
#######################################################################
*/
minimize_quiet(P, Cost) :-
    branch_and_bound:bb_min(P, Cost, bb_options{report_success:true/0, report_failure:true/0}).

symbolic_labeling(Vars) :-
	collection_to_list(Vars, List),
	( foreach(Var, List) do
	  ic_symbolic:indomain(Var)
	).

main :-
    (read(stdin, Problem),
     problem(Problem)) -> exit(0); exit(1).

/*
  Problème 1.
  Énoncé: On vous donne une liste d'entiers. On veut savoir si tous les éléments de la liste sont différents.
  Entrée: Une liste d'entiers.
  Sortie: 1 si tous les entiers sont différents 0 sinon.

  Exemple:
  Entrée: [1, 1, 2, 3]
  Sortie: 0
*/
problem(problem1) :-
	read(stdin, L),
	ic:alldifferent(L),
	writeln(1),
	!.
problem(problem1) :-
	writeln(0).

/*
  Problème 2.
  Énoncé: On nous donne 2 entiers N et M avec 1 <= N <= 1000 et 1 <= M <= 1000. vous devez trouver 2 entiers 1 <= A <= 100000  et 1 <= B <= 100000 tels que :
          * A * N = B * 17,
          * et (B * 11) / M = A
            l'opérateur `/` représente la division entière.
          * A et B sont telles que la somme A + B est maximisée.
  Entrée: N puis M.
  Sortie: A + B (il y aura toujours une solution dans les tests pour les N et M données).

  Exemple:
  Entrée: 340 220
  Sortie: 105000
  Remarque: pour l'exemple, A = 5000 et B = 100000.

  Hint: l'opérateur division entière dans `ic` se note `/` (ok bon vous vous en seriez sûrement douté).
*/
problem(problem2) :-
	read(stdin, N),
	read(stdin, M),
	N #:: 1..1000,
	M #:: 1..1000,
	A #:: 1..100000,
	B #:: 1..100000,
	Res #= A + B,
	A * N #= B * 17,
	A * M #= B * 11,
	ResNeg #= -1 * Res,
	minimize_quiet(
		labeling([A, B, Res]), 
		ResNeg
	),
    writeln(Res).

/*
  Problème 3.
  Énoncé: On veut trouver un nombre en base B > 1 comportant 6 digits, égal à une valeur V.
  Entrée: La base B > 1 puis la valeur V.
  Sortie: La liste de 6 digits avec les digits de poids faible à droite. Il sera toujours possible de trouver ce nombre.

  Exemples:
  Entrée: 2 8
  Sortie: [0, 0, 1, 0, 0, 0]

  Entrée: 16 12345678
  Sortie: [11, 12, 6, 1, 4, 14]

  Entrée: 17 1001000
  Sortie: [0, 11, 16, 12, 11, 6]
*/
problem(problem3) :-
	read(stdin, B),
	read(stdin, V),
	B > 1,
	Res = [D5, D4, D3, D2, D1, D0],
	Calc = [D0, D1, D2, D3, D4, D5],
	(foreach(D, Calc), fromto(V, In, Out, 0), param(B) do
		D is In mod B,
		Out is In // B
	),
    writeln(Res).

/*
  Problème 4.
  Énoncé: On vous donne une liste de N > 1 entiers et une valeur V. Est-il possible d'obtenir V en utilisant les N nombres et les opérateurs `+`, `-` ou `*` entre chacun d'entre eux ? On évalue de la gauche vers la droite. Par exemple : 1 + 3 * 4 + 5 = ((1 + 3) * 4) + 5.
  Entrée: La valeur N, puis la valeur V et la liste de N entiers.
  Sortie: 1 si c'est possible et 0 sinon.

  Exemple:
  Entrée: 4 20
          [1, 2, 3, 4]
  Sortie: 1

  Entrée: 5 2021
          [1, 2, 3, 4, 6]
  Sortie: 0

*/
problem(problem4) :-
  fail.

/*
  Problème 5.
  Énoncé: On nous donne une liste d'entiers. On veut se rapprocher le plus d'une certaine valeur en faisant la somme d'éléments du tableau. On peut utiliser au maximum deux fois chaque valeur du tableau. La somme que l'on obtient doit être inférieure ou égale à la valeur recherchée (bien sûr le mieux c'est d'obtenir exactement la valeur recherchée).
  Entrée: Un entier V (la valeur recherchée) puis une liste d'entiers.
  Sortie: La meilleur valeur obtenue ou "impossible" (sans les guillemets) s'il n'y a pas de solution.

  Exemple:
  Entrée: 12
          [3, 2, 8, 15, 20]
  Sortie: 11
*/

problem(problem5) :-
	read(stdin, V),
	read(stdin, L),
	length(L, N),
	M is 2*N,
	dim(T, [M]),
	dim(Add, [M]),
	Add #:: 0..1,
	(foreach(E, L), fromto(1, In, Out, _), param(T) do
		T1 is T[In],
		T2 is T[In+1],
		T1 = E,
		T2 = E,
		Out is In + 2
	),
	(for(I, 1, M), fromto(0, In, Out, Sum), param(T, Add) do
		Ti is T[I],
		Ai is Add[I],
		Out #= In + Ti * Ai
	),
	Sum #=< V,
	SumNeg #= -1 * Sum,
	array_list(Add, Vars),
	minimize_quiet(
		labeling([Sum|Vars]),
		SumNeg
	),
	writeln(Sum),
	!.
problem(problem5) :-
	writeln("impossible").

/*
  Problème 6.
  Énoncé: À l'INSA il y a N lampes initialement allumées. On voudrait les éteindre, mais quelqu'un s'est amusé à modifier tous les interrupteurs. Maintenant chaque interrupteur peut changer l'état de chacune des lampes. Par exemple, s'il y a 4 lampes, un des interrupteurs pourrait être décrit par la liste [1, 0, 1, 1]. Cela signifie qu'il changera l'état de la lampe 1 (si elle est allumée elle s'éteindra et vice-versa). La lampe 2 ne sera pas affectée par l'interrupteur, les lampes 3 et 4 seront affectées (même comportement que la lampe 1 mais pour les lampes 3 et 4).
On voudrait trouver le plus petit sous-ensemble d'interrupteurs qui permette d'éteindre toutes les lampes.

  Entrée: N le nombre de lampes puis M le nombre d'interrupteurs et ensuite M listes décrivants les interrupteurs.
  Sortie: -1 s'il est impossible d'éteindre les lampes. Sinon le nombre minimum d'interrupteurs à utiliser.

  Exemple:
  Entrée: 3 4
          [1, 0, 0]
          [0, 1, 0]
          [0, 1, 1]
          [1, 1, 0]
  Sortie: 2

  Entrée: 3 2
          [1, 1, 0]
          [0, 1, 1]
  Sortie: -1
*/
problem(problem6) :-
	read(stdin, N),
	read(stdin, M),
	dim(T, [M]),
	dim(Use, [M]),
	Use #:: 0..1,
	(for(I, 1, M), param(T) do
		Ti is T[I],
		read(stdin, L),
		array_list(Ti, L)
	),
	(for(I, 1, N), param(T, Use, M) do
		(for(J, 1, M), param(T, Use, I), fromto(0, In, Out, Off) do
			Switch is T[J,I],
			Usej is Use[J],
			Out #= (In #\= Switch * Usej)
		),
		Off #= 1
	),
	SumSwitches #= sum(Use),
	array_list(Use, Vars),
	minimize_quiet(
		labeling([SumSwitches|Vars]),
		SumSwitches
	),
	writeln(SumSwitches),
	!.
problem(problem6) :-
	writeln(-1).

/*
  Problème 7.
  Énoncé: On nous donne un graphe non orienté sous forme de liste d'adjacence. On nous donne aussi un liste de sommets L.
          On souhaite déterminer le nombre de couleurs minimal nécessaires pour colorier le graphe sans que deux sommets adjacents n'aient la même couleur sauf pour les sommets dans L qui eux peuvent être coloriés de la même couleur qu'un de leur voisin.

  Entrée: Un entier N donnant le nombre de sommets dans le graphe. Puis une liste L représentant les sommets qui peuvent être coloriés de la même couleur qu'un de leur voisin. Puis N lignes avec des listes. La liste de la première ligne donne les sommets reliés au sommet i.
  Sortie: Le nombre minimum de couleurs permettant de colorier le graphe.
  Contrainte: On aura jamais besoin de plus de 20 couleurs.

  Exemple:
  Entrée: 3
          []
          [2, 3]
          [1, 3]
          [1, 2]
  Sortie: 3

  Entrée: 3
          [1, 2]
          [2, 3]
          [1]
          [1]
  Sortie: 1
*/
problem(problem7) :-
    fail.

/*
  Problème 8.
  Énoncé: On nous fournit plusieurs intervalles avec des bonus associés. On voudrait trouver un intervalle I dont le gain est maximal et calculé ainsi :
            * I doit être au minimum de longueur 1.
            * si I a une intersection non vide avec un des intervalles donnés, on obtient le bonus associé à ce dernier.
            * notre intervalle I nous coûte sa longueur au carré (si I = [a, b], son coût est (b - a)^2).

  Entrée: N, le nombre d'intervalles. Puis N intervalles avec leur bonus. Chaque interval est représenté par deux entiers compris entre 1 et 10000, la borne inférieure puis la borne supérieure. Ensuite vient le bonus associé à l'intervalle.
  Sortie: Le gain maximal que l'on peut obtenir.

  Exemple:
  Entrée: 5
          1 2 10
          1 4 8
          3 7 7
          6 10 14
          9 10 1
  Sortie: 25
*/
problem(problem8) :-
    read(stdin, N),
	dim(Intervals, [N]),
	(for(I, 1, N), param(Intervals) do
		read(stdin, Lb),
		read(stdin, Hb),
		read(stdin, Bonus),
		Itvi is Intervals[I],
		Itvi = [Lb, Hb, Bonus]
	),
	(for(I, 1, N), param(Intervals), fromto([10000, 0], [Inm, InM], [Outm, OutM], [Min, Max]) do
		Itvi is Intervals[I],
		Itvi = [Lb, Hb, _Bonus],
		Outm is min(Inm, Lb),
		OutM is max(InM, Hb)
	),
	Lower #:: Min..Max,
	Higher #:: Min..Max,
	Higher #> Lower,
	Cost #= (Higher-Lower) * (Higher-Lower),
	(for(I, 1, N), param(Intervals, Lower, Higher), fromto(0, In, Out, ItvGain) do
		Itvi is Intervals[I],
		Itvi = [Lb, Hb, Bonus],
		Out #= In + Bonus * (((Lower #>= Lb) and (Lower #=< Hb)) or ((Lower #< Lb) and (Higher #>= Lb)))
	),
	Gain #= ItvGain - Cost,
	GainNeg #= -1 * Gain,
	minimize_quiet(
		labeling([Lower, Higher, Cost, ItvGain, Gain, GainNeg]),
		GainNeg
	),
	writeln(Gain).

	



