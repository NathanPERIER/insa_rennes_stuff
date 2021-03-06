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
  Probl??me 1.
  ??nonc??: On vous donne une liste d'entiers. On veut savoir si tous les ??l??ments de la liste sont diff??rents.
  Entr??e: Une liste d'entiers.
  Sortie: 1 si tous les entiers sont diff??rents 0 sinon.

  Exemple:
  Entr??e: [1, 1, 2, 3]
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
  Probl??me 2.
  ??nonc??: On nous donne 2 entiers N et M avec 1 <= N <= 1000 et 1 <= M <= 1000. vous devez trouver 2 entiers 1 <= A <= 100000  et 1 <= B <= 100000 tels que :
          * A * N = B * 17,
          * et (B * 11) / M = A
            l'op??rateur `/` repr??sente la division enti??re.
          * A et B sont telles que la somme A + B est maximis??e.
  Entr??e: N puis M.
  Sortie: A + B (il y aura toujours une solution dans les tests pour les N et M donn??es).

  Exemple:
  Entr??e: 340 220
  Sortie: 105000
  Remarque: pour l'exemple, A = 5000 et B = 100000.

  Hint: l'op??rateur division enti??re dans `ic` se note `/` (ok bon vous vous en seriez s??rement dout??).
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
  Probl??me 3.
  ??nonc??: On veut trouver un nombre en base B > 1 comportant 6 digits, ??gal ?? une valeur V.
  Entr??e: La base B > 1 puis la valeur V.
  Sortie: La liste de 6 digits avec les digits de poids faible ?? droite. Il sera toujours possible de trouver ce nombre.

  Exemples:
  Entr??e: 2 8
  Sortie: [0, 0, 1, 0, 0, 0]

  Entr??e: 16 12345678
  Sortie: [11, 12, 6, 1, 4, 14]

  Entr??e: 17 1001000
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
  Probl??me 4.
  ??nonc??: On vous donne une liste de N > 1 entiers et une valeur V. Est-il possible d'obtenir V en utilisant les N nombres et les op??rateurs `+`, `-` ou `*` entre chacun d'entre eux ? On ??value de la gauche vers la droite. Par exemple : 1 + 3 * 4 + 5 = ((1 + 3) * 4) + 5.
  Entr??e: La valeur N, puis la valeur V et la liste de N entiers.
  Sortie: 1 si c'est possible et 0 sinon.

  Exemple:
  Entr??e: 4 20
          [1, 2, 3, 4]
  Sortie: 1

  Entr??e: 5 2021
          [1, 2, 3, 4, 6]
  Sortie: 0

*/
problem(problem4) :-
  fail.

/*
  Probl??me 5.
  ??nonc??: On nous donne une liste d'entiers. On veut se rapprocher le plus d'une certaine valeur en faisant la somme d'??l??ments du tableau. On peut utiliser au maximum deux fois chaque valeur du tableau. La somme que l'on obtient doit ??tre inf??rieure ou ??gale ?? la valeur recherch??e (bien s??r le mieux c'est d'obtenir exactement la valeur recherch??e).
  Entr??e: Un entier V (la valeur recherch??e) puis une liste d'entiers.
  Sortie: La meilleur valeur obtenue ou "impossible" (sans les guillemets) s'il n'y a pas de solution.

  Exemple:
  Entr??e: 12
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
  Probl??me 6.
  ??nonc??: ?? l'INSA il y a N lampes initialement allum??es. On voudrait les ??teindre, mais quelqu'un s'est amus?? ?? modifier tous les interrupteurs. Maintenant chaque interrupteur peut changer l'??tat de chacune des lampes. Par exemple, s'il y a 4 lampes, un des interrupteurs pourrait ??tre d??crit par la liste [1, 0, 1, 1]. Cela signifie qu'il changera l'??tat de la lampe 1 (si elle est allum??e elle s'??teindra et vice-versa). La lampe 2 ne sera pas affect??e par l'interrupteur, les lampes 3 et 4 seront affect??es (m??me comportement que la lampe 1 mais pour les lampes 3 et 4).
On voudrait trouver le plus petit sous-ensemble d'interrupteurs qui permette d'??teindre toutes les lampes.

  Entr??e: N le nombre de lampes puis M le nombre d'interrupteurs et ensuite M listes d??crivants les interrupteurs.
  Sortie: -1 s'il est impossible d'??teindre les lampes. Sinon le nombre minimum d'interrupteurs ?? utiliser.

  Exemple:
  Entr??e: 3 4
          [1, 0, 0]
          [0, 1, 0]
          [0, 1, 1]
          [1, 1, 0]
  Sortie: 2

  Entr??e: 3 2
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
  Probl??me 7.
  ??nonc??: On nous donne un graphe non orient?? sous forme de liste d'adjacence. On nous donne aussi un liste de sommets L.
          On souhaite d??terminer le nombre de couleurs minimal n??cessaires pour colorier le graphe sans que deux sommets adjacents n'aient la m??me couleur sauf pour les sommets dans L qui eux peuvent ??tre colori??s de la m??me couleur qu'un de leur voisin.

  Entr??e: Un entier N donnant le nombre de sommets dans le graphe. Puis une liste L repr??sentant les sommets qui peuvent ??tre colori??s de la m??me couleur qu'un de leur voisin. Puis N lignes avec des listes. La liste de la premi??re ligne donne les sommets reli??s au sommet i.
  Sortie: Le nombre minimum de couleurs permettant de colorier le graphe.
  Contrainte: On aura jamais besoin de plus de 20 couleurs.

  Exemple:
  Entr??e: 3
          []
          [2, 3]
          [1, 3]
          [1, 2]
  Sortie: 3

  Entr??e: 3
          [1, 2]
          [2, 3]
          [1]
          [1]
  Sortie: 1
*/
problem(problem7) :-
    fail.

/*
  Probl??me 8.
  ??nonc??: On nous fournit plusieurs intervalles avec des bonus associ??s. On voudrait trouver un intervalle I dont le gain est maximal et calcul?? ainsi :
            * I doit ??tre au minimum de longueur 1.
            * si I a une intersection non vide avec un des intervalles donn??s, on obtient le bonus associ?? ?? ce dernier.
            * notre intervalle I nous co??te sa longueur au carr?? (si I = [a, b], son co??t est (b - a)^2).

  Entr??e: N, le nombre d'intervalles. Puis N intervalles avec leur bonus. Chaque interval est repr??sent?? par deux entiers compris entre 1 et 10000, la borne inf??rieure puis la borne sup??rieure. Ensuite vient le bonus associ?? ?? l'intervalle.
  Sortie: Le gain maximal que l'on peut obtenir.

  Exemple:
  Entr??e: 5
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

	



