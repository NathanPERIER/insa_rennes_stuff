:- lib(ic).
:- lib(ic_symbolic).
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
  ??nonc??: On vous donne une liste d'entiers. On veut savoir si les ??l??ments de la liste ne sont pas tous diff??rents.
  Entr??e: Une liste d'entiers non vide.
  Sortie: 0 si tous les entiers sont diff??rents 1 sinon.

  Exemple:
  Entr??e: [1, 1, 2, 3]
  Sortie: 1
*/
problem(problem1) :-
    read(stdin, L),
    ic:alldifferent(L) -> writeln(0); writeln(1).


/*
  Probl??me 2.
  ??nonc??: On vous donne trois tableaux d'entiers V1, V2 et Weights de m??me taille N. On voudrait rendre le produit scalaire de V1 et V2 pond??r?? par Weights: V1[1] * V2[1] * Weights[1] + ... + V1[N] * V2[N] * Weights[N].
  Entr??e: V1 puis V2 puis Weights.
  Sortie: V1[1] * V2[1] * Weights[1] + ... + V1[N] * V2[N] * Weights[N].

  Exemple:
  Entr??e: [](1, 2, 3, 4)
          [](5, 5, 10, 20)
          [](0, 1, 2, 1)
  Sortie: 150
*/
problem(problem2) :-
    read(stdin, V1),
    read(stdin, V2),
    read(stdin, Weights),
    dim(V1, [N]),
    dim(V2, [N]),
    dim(Weights, [N]),
    (for(I, 1, N), fromto(0, In, Out, Res), param(V1, V2, Weights) do
      Out is In + V1[I] * V2[I] * Weights[I]
    ),
    writeln(Res).

% Note : "L'objectif du cours est de savoir rep??rer les probl??mes ?? contraintes"
% Ici, ce n'est pas un probl??me ?? contraintes, donc on n'utilise pas de contraintes
% (pas besoin de sortir l'artillerie lourde)


/*
  Probl??me 3.
  ??nonc??: On vous donne une liste de listes de pairs, par exemple : [[(X, 1), (Y, 1)], [(X, 0)], [(Y, 0)]]. Cette liste va repr??senter une forme normale conjonctive. Une variable associ??e ?? un 0 repr??sente la n??gation d'une proposition, une variable associ??e ?? un 1 repr??sente une proposition. Une liste dans cette liste de listes repr??sente une clause, du coup les propositions ?? l'int??rieur sont s??par??es par des OU et les clauses sont s??par??es par des ET. La liste [[(X, 1), (Y, 1)], [(X, 0)], [(Y, 0)]] repr??sente donc la forme normale conjonctive suivante : (X OU Y) ET (not X) ET (not Y). Le but de ce probl??me est de rendre 1 si on peut satisfaire cette forme normale conjonctive et 0 sinon.
  Entr??e: La forme normale conjonctive.
  Sortie: 1 si on peut satisfaire celle-ci et 0 sinon.

  Exemple:
  Entr??e: [[(X, 1), (Y, 1)], [(X, 0)], [(Y, 0)]]
  Sortie: 0
*/
problem(problem3) :-
  read(stdin, FNC),
  (foreach(Clause, FNC), fromto(1, In, Out, Res) do
    (foreach(Elt, Clause), fromto(0, In, Out, C) do
      Elt = (Prop, Val),
      Out #= (In or (Prop #= Val))
    ),
    Out #= (In and C)
  ),
  Res #= 1,
  labeling([Res]) -> writeln(1); writeln(0).

/*
  Probl??me 4.
  ??nonc??: On vous donne une liste d'entiers L positifs. On voudrait trouver la longueur de la sous-s??quence croissante la plus grande. Par exemple, pour la liste [3, 10, 4, 1, 5, 0, 8], la longueur de la plus grande sous-s??quence croissante est 4, avec la sous-s??quence [3, _, 4, _, 5, _, 8].
  Entr??e: L.
  Sortie: La longueur de la sous-s??quence croissante la plus grande.

  Exemple:
  Entr??e: [3, 10, 4, 1, 5, 0, 8]
  Sortie: 4
*/
problem(problem4) :-
    read(stdin, L),
    array_list(Arr, L),
    dim(Arr, [N]),
    dim(Present, [N]),
    Present #:: 0..1,
    (foreachelem(E, Arr, [I]), fromto([-1, 0], [In, C1], [Out, C2], [End, Res]), param(Present) do
      Pi is Present[I],
      (Pi #= 1) => ((In #= -1) or (In #=< E)),
      Out #= E * (Pi #= 1) + In * (Pi #= 0),
      C2 #= C1 + Pi
    ),
    Cost #= -1 * Res,
    array_list(Present, Vars),
    minimize_quiet(
      labeling([Res, End | Vars]),
      Cost
    ),
    writeln(Res).


/*
  Probl??me 5.
  ??nonc??: On vous donne une liste de listes d'entiers, par exemple : [[1, 1, 2], [1, 2, 1, 1]] et un entier Max. On va calculer une sorte de hash pour chaque liste d'entiers, et on voudrait qu'il n'y ait aucune collision (tous les hashs sont diff??rents). Voici notre fa??on (un peu singuli??re) de calculer un hash pour un nombre [X, Y, Z, T] et Max : ((((0 * P + X) * P) + Y) * P + Z) * P + T avec P dans [1..31] (on va voir apr??s comment choisir P) et avec la particularit?? suivante : si un des r??sultats interm??diaire d??passe Max, on le met ?? 0. Ce qui veut dire que si (0 * P + X) >= Max, ce r??sultat devient 0 dans le calcul. De m??me pour ((_) * P) + Y et ainsi de suite. Le but de ce probl??me est de trouver la plus grande puissance P qui permette de ne pas avoir de collisions avec notre fa??on de calculer les hashs. Il existera toujours une puissance P qui permette de r??soudre le probl??me.
  Pour [[1, 1, 2], [1, 2, 1, 1]] et Max = 5, le r??sultat est P = 31. En effet on obtient les deux hashs suivants : 2 et 0 qui sont bien diff??rents.
  Entr??e: Une liste de listes d'entiers.
  Sortie: La puissance la plus grande permettant de ne pas avoir de collisions.

  Exemple: 
  Entr??e: [[1, 1, 2], [1, 2, 1, 1]]
          5
  Sortie: 31
*/
problem(problem5) :-
  read(stdin, LL),
  read(stdin, Max),
  P #:: 1..31,
  (foreach(L, LL), fromto([], In, Out, Res), param(P, Max) do
    (foreach(E, L), fromto(0, In, Out, Val), param(P, Max) do
      V #= In * P + E,
      Out #= V * (V #=< Max) 
    ),
    Out = [Val|In]
  ),
  ic:alldifferent(Res),
  Cost #= -1 * P,
  minimize_quiet(
    labeling([P|Res]),
    Cost
  ),
  writeln(P).
  

/*
  Probl??me 6.
  ??nonc??: On vous donne une grille contenant des 0 et des 1. Par exemple la grille :
              []([](0, 1, 0, 1, 1),
                 [](0, 0, 1, 1, 1), 
                 [](0, 1, 1, 0, 1),
                 [](0, 1, 1, 1, 1))
          On vous donne aussi un nombre Max qui est le nombre maximum de 0 qui peuvent se transformer en 1. Le but de ce probl??me est de trouver le nombre de cases dans la plus grande sous-grille qui se termine forc??ment dans le coin inf??rieur droit de la grille et qui ne contient que des 1. On peut transformer au maximum Max 0 en 1. 
          Si Max = 1, on obtient : 9. En effet, la sous-grille est :
              []([](0, 1, 0, 1, 1),
                 [](0, 0, #, #, #), 
                 [](0, 1, #, #, #),
                 [](0, 1, #, #, #))

          Il y aura toujours une solution avec un nombre de cases >= 1.

  Entr??e: La grille et le nombre Max.
  Sortie: Le nombre de cases de la sous-grille (pas forc??ment un carr??) de taille maximale qui se termine dans le coin inf??rieur droit.

  Exemple: 
  Entr??e: []([](0, 1, 0, 1, 1),
             [](0, 0, 1, 1, 1), 
             [](0, 1, 1, 0, 1),
             [](0, 1, 1, 1, 1))
            1
          
  Sortie: 9
*/
problem(problem6) :-
  read(stdin, Tab),
  read(stdin, Max),
  dim(Tab, [H,L]),
  X #:: 1..H,
  Y #:: 1..L,
  Size #= (H - X + 1) * (L - Y + 1),
  (foreachelem(E, Tab, [I,J]), fromto(0, In, Out, Res), param(X, Y) do
    Out #= In + E * (X #=< I and Y #=< J)
  ),
  Size #=< Res + Max,
  Cost #= -1 * Size,
  minimize_quiet(
    labeling([Size, X, Y]),
    Cost
  ),
  writeln(Size).

  

/*
  Probl??me 7.
  ??nonc??: Dans un d??partement d'enseignement il y a N cours ?? distribuer ?? N enseignants. Chaque enseignant donne ses pr??f??rences sous forme d'un entier (plus l'entier est grand mieux c'est pour lui). Le but est de trouver une bijection entre enseignants et cours qui maximise la somme des pr??f??rences. Par exemple pour la matrice de pr??f??rences suivante :
            [](
               [](3, 3, 1, 2),
               [](0, 4, -8, 3),
               [](0, 2, 3, 0),
               [](-1, 1, 2, -5)
            )
          On obtient 10 en choisissant :
            [](
               [](X, 3, 1, 2),
               [](0, 4, -8, X),
               [](0, X, 3, 0),
               [](-1, 1, X, -5)
            )

  Entr??e: La matrice de pr??f??rences.
  Sortie: La plus grande somme de pr??f??rences que l'on puisse obtenir.

  Exemple:
  Entr??e: [](
               [](3, 3, 1, 2),
               [](0, 4, -8, 3),
               [](0, 2, 3, 0),
               [](-1, 1, 2, -5)
            )
          
  Sortie: 10
*/
problem(problem7) :-
  read(stdin, Tab),
  dim(Tab, [N,N]),
  dim(Allocate, [N]),
  Allocate #:: 1..N,
  ic:alldifferent(Allocate),
  (for(I, 1, N), fromto(0, In, Out, Res), param(Tab, Allocate) do
    Ti is Tab[I],
    Ai is Allocate[I],
    (foreachelem(E, Ti, [J]), fromto(0, In, Out, V), param(Ai) do
      Out #= In + E * (Ai #= J)
    ),
    Out #= In + V
  ),
  Cost #= -1 * Res,
  array_list(Allocate, Vars),
  minimize_quiet(
    labeling([Res|Vars]),
    Cost
  ),
  writeln(Res).


