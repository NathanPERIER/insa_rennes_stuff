:- lib(ic).

% 1.1

% choixCouleur(?, ?)
choixCouleur(Bateau, Voiture) :-
	couleurBateau(Bateau),
	couleurVoiture(Voiture),
	memeCouleur(Bateau, Voiture).

memeCouleur(X, X).
memeCouleur(vert, vert(_)).

couleurBateau(vert).
couleurBateau(noir).
couleurBateau(blanc).

couleurVoiture(rouge).
couleurVoiture(gris).
couleurVoiture(blanc).
couleurVoiture(vert(clair)).

% ?- choixCouleur(X, Y).
%
% X = vert
% Y = vert(clair)
% Yes (0.00s cpu, solution 1, maybe more) ? ;
%
% X = blanc
% Y = blanc
% Yes (0.00s cpu, solution 2, maybe more) ? ;
%
% No (0.00s cpu)

% ===============================================

% 1.2
% Afin d'apporter une réponse à une requête, Prolog effectue une unification sur des arbres avec backtracking.
% On peut donc considérer que prolog est un solveur qui travaille sur des arbres, avec pour but de trouver 
% une ou des unifications telles que les arbres soient égaux (ce qui constitue la contrainte du solveur). 

% ===============================================

% 1.3

% isBetween(?, +, +)
isBetween(Min, Min, Max):-
	Min =< Max.
isBetween(Var, Min, Max):-
	Min =< Max,
	Min1 is Min + 1,
	isBetween(Var, Min1, Max).

% ?- isBetween(X, 1, 3).
%
% X = 1
% Yes (0.00s cpu, solution 1, maybe more) ? ;
% 
% X = 2
% Yes (0.00s cpu, solution 2, maybe more) ? ;
%
% X = 3
% Yes (0.00s cpu, solution 3, maybe more) ? ;
%
% No (0.00s cpu)

% ===============================================

% 1.4

% commande(?, ?)
commande(NbResistance, NbCondensateur):-
	isBetween(NbResistance, 5000, 10000),
	isBetween(NbCondensateur, 9000, 20000),
	NbResistance >= NbCondensateur.

% ?- commande(X, Y). 
%
% X = 9000
% Y = 9000
% Yes (2.49s cpu, solution 1, maybe more) ? ;
%
% X = 9001
% Y = 9000
% Yes (2.49s cpu, solution 2, maybe more) ? ;
% 
% X = 9001
% Y = 9001
% Yes (2.49s cpu, solution 3, maybe more) ? ;
%
% X = 9002
% Y = 9000
% Yes (2.49s cpu, solution 4, maybe more) ? ;
%
% X = 9002
% Y = 9001
% Yes (2.49s cpu, solution 5, maybe more) ? ;
%
% X = 9002
% Y = 9002
% Yes (2.50s cpu, solution 6, maybe more) ? ;
% 
% X = 9003
% Y = 9000
% Yes (2.50s cpu, solution 7, maybe more) ?
% ...

% ===============================================

% 1.5
% Voir fichiers joints (Ex1-5.png)

% ===============================================

% 1.6
% Si la prédicat >= intervient avant les appels à isBetween, le prédicat commande passe
% en mode (++, ++). En effet, comme le dit le titre de l'exercice, Prolog ne comprend pas
% les maths. Le langage est seulement capable de comparer des nombres déjà instanciés, ce
% qui nous oblige à appeler isBetween en premier pour générer des valeurs et vérifier si
% elles conviennent (generate & test). Les contraintes nous permettrons d'optimiser ce
% comportement en restreignant d'abord l'espace de recherche.

% ===============================================

% 1.7

% commandeC(?, ?)
commandeC(NbResistance, NbCondensateur):-
	NbResistance #:: 5000..10000,
	NbCondensateur #:: 9000..20000,
	NbResistance #>= NbCondensateur.

% ?- commandeC(X, Y).
%
% X = X{9000 .. 10000}
% Y = Y{9000 .. 10000}
%
%
% Delayed goals:
%        Y{9000 .. 10000} - X{9000 .. 10000} #=< 0

% Le solveur de contraintes a réussi à restreindre les espaces
% des variables mais il reste encore du travail à faire (labelling).

% ===============================================

% 1.8

% commandeCL(?, ?)
commandeCL(NbResistance, NbCondensateur):-
	commandeC(NbResistance, NbCondensateur),
	labeling([NbResistance, NbCondensateur]).

% ?- commandeCL(X, Y).
%
% X = 9000
% Y = 9000
% Yes (0.00s cpu, solution 1, maybe more) ? ;
% 
% X = 9001
% Y = 9000
% Yes (0.00s cpu, solution 2, maybe more) ? ;
%
% X = 9001
% Y = 9001
% Yes (0.00s cpu, solution 3, maybe more) ? ;
% 
% X = 9002
% Y = 9000
% Yes (0.00s cpu, solution 4, maybe more) ? ;
%
% X = 9002
% Y = 9001
% Yes (0.00s cpu, solution 5, maybe more) ? ;
%
% X = 9002
% Y = 9002
% Yes (0.00s cpu, solution 6, maybe more) ?
% ...

% Pour l'arbre, voir fichiers joints (Ex1-8.png)

% ===============================================

% 1.9

% chapie(-, -, -, -)
chapie(Chats, Pies, Pattes, Tetes):-
	Chats  #>= 0,
	Pies   #>= 0,
	Tetes  #>= 0,
	Pattes #>= 0,
	Tetes  #= Chats + Pies,
	Pattes #= 4 * Chats + 2 * Pies.

% chapi1(-, -, -, -)
chapi1(Chats, Pies, Pattes, Tetes):-
	Chats  #=< 1000,
	Pies   #=< 1000,
	Tetes  #=< 2000,
	Pattes #=< 6000,
	chapie(Chats, Pies, Pattes, Tetes),
	labeling([Chats, Pies, Tetes, Pattes]).

% ?- chapi1(2, Pies, Pattes, 5).
%
% Pies = 3
% Pattes = 14
% Yes (0.00s cpu)

% ===============================================

% 1.10

% chapi2(-, -, -, -)
chapi2(Chats, Pies, Pattes, Tetes):-
	Chats  #=< 1000,
	Pies   #=< 1000,
	Tetes  #=< 2000,
	Pattes #=< 6000,
	chapie(Chats, Pies, Pattes, Tetes),
	Pattes #= 3 * Tetes,
	labeling([Chats, Pies, Tetes, Pattes]).

% ?- chapi2(Chats, Pies, Pattes, Tetes).
%
% Chats = 0
% Pies = 0
% Pattes = 0
% Tetes = 0
% Yes (0.00s cpu, solution 1, maybe more) ? ;
%
% Chats = 1
% Pies = 1
% Pattes = 6
% Tetes = 2
% Yes (0.00s cpu, solution 2, maybe more) ?
% ...

% ===============================================

% 1.11

% vabsSemicolon(?, ?)
vabsSemicolon(Val, AbsVal) :-
	AbsVal #>= 0,
	Val #= AbsVal,
	labeling([Val, AbsVal]);
	AbsVal #> 0,
	Val #= -1 * AbsVal,
	labeling([Val, AbsVal]).


% ?- vabsSemicolon(1, 1).
% 
% Yes (0.00s cpu, solution 1, maybe more) ? ;
% 
% No (0.00s cpu)
%
% ?- vabsSemicolon(1, X).
% 
% X = 1
% Yes (0.00s cpu, solution 1, maybe more) ? ;
% 
% No (0.00s cpu)
%
% ?- vabsSemicolon(-1, X).
%
% X = 1
% Yes (0.00s cpu)
%
% ?- vabsSemicolon(X, 1).
%
% X = 1
% Yes (0.00s cpu, solution 1, maybe more) ? ;
%
% X = -1
% Yes (0.00s cpu, solution 2)
%
% ?- vabsSemicolon(X, Y).
% 
% X = 0
% Y = 0
% Yes (0.00s cpu, solution 1, maybe more) ? ;
%
% X = 1
% Y = 1
% Yes (0.00s cpu, solution 2, maybe more) ? ;
%
% X = 2
% Y = 2
% Yes (0.00s cpu, solution 3, maybe more) ? 
% ...

% Note : si on met AbsVal #>= 0 à la place de AbsVal #> 0, on a le cas suivant :
% vabsSemicolon(0, X).
% 
% X = 0
% Yes (0.00s cpu, solution 1, maybe more) ? ;
% 
% X = 0
% Yes (0.00s cpu, solution 2)

% vabsOr(+, ?)
vabsOr(Val, AbsVal) :-
	AbsVal #>= 0,
	Val #= AbsVal or Val #= -AbsVal,
	labeling([Val, AbsVal]).

% ?- vabsOr(1, 1).
%
% Yes (0.00s cpu)
%
% ?- vabsOr(1, X).
%
% X = 1
% Yes (0.00s cpu)
%
% ?- vabsOr(-1, X).
%
% X = 1
% Yes (0.00s cpu)

% Note : pour une raison inconnue, cette version de vabs ne fonctionne pas
% si Val n'est pas instancié. Nous ne sommes pas parvenus à déterminer pourquoi
% ni comment changer cela.

% ===============================================

% 1.12

% X #:: -10..10, vabsSemicolon(X, Y).
% Pour x allant de 0 à 10 on obtient X=x, Y=x
% Puis, pour x allant de -10 à -1 on a X=x, Y=-x
% Cela s'explique par le fait que le premier cas (Val #= AbsVal) est exploré en premier,
% puis le second est exploré (Val #= -1 * AbsVal)

% X #:: -10..10, vabsOr(X, Y).
% Pour x allant de -10 à -1 on obtient X=x, Y=-x
% Puis, pour x allant de 0 à 10 on a X=x, Y=x
% Cettes fois-ci les résultats sont dans l'ordre car on utilise une seule contrainte

% ===============================================

% 1.13

% faitListe(?, ?, +, +)
faitListe([], 0, _Min, _Max).
faitListe([E|L], Taille, Min, Max) :-
	E #:: Min..Max,
	T1 #= Taille - 1,
	T1 #>= 0,
	faitListe(L, T1, Min, Max).

% Note : on utilise T1 #>= 0 dans la seconde clause car sinon le programme entre dans 
% une boucle infinie après avoir trouvé la première solution en mode (-, +, +, +)

% ?- faitListe([1, 2, 3, 4, 5, 6], N, 1, 10).
%
% N = 6
% Yes (0.00s cpu)
%
% ?- faitListe([1, 2, 3, 4, 5, 6], 6, 1, 10).
%
% Yes (0.00s cpu)
%
% ?- faitListe(L, 6, 1, 10).
%
% L = [_219{1 .. 10}, _321{1 .. 10}, _423{1 .. 10}, _525{1 .. 10}, _627{1 .. 10}, _729{1 .. 10}]
% Yes (0.00s cpu)
% 
% ?- faitListe(L, N, 1, 10).
%
% L = []
% N = 0
% Yes (0.00s cpu, solution 1, maybe more) ? ;
%
% L = [_224{1 .. 10}]
% N = 1
% Yes (0.00s cpu, solution 2, maybe more) ? ;
% 
% L = [_224{1 .. 10}, _372{1 .. 10}]
% N = 2
% Yes (0.00s cpu, solution 3, maybe more) ?
% ...

% ===============================================

% 1.14

% suite(?)
suite([]).
suite([_X]).
suite([_X, _Y]).
suite([X, Y, Z | L]) :-
	AbsY #>= 0,
	Y #= AbsY or Y #= -AbsY,
	X #= AbsY - Z,
	suite([Y, Z | L]).

% ===============================================

% 1.15

% Pour vérifier que la suite est péridique, on a juste besoin de montrer que u_0 = u_9 et u_1 = u_10
% Le fait que la suite est 9-périodique en découle alors du fait que pour tout n>=2, u_n = |u_(n-1)| - u_(n-2) 

% ninePeriodic(?)
ninePeriodic([U10, U9, _U8, _U7, _U6, _U5, _U4, _U3, _U2, U1, U0]) :-
	U0 #= U9,
	U1 #= U10.

% Comme on ne peut pas vérifier cette propriété pour toutes les possibilités existantes, on va plutôt
% se restreindre à un domaine de Z. Pour toutes les suites possibles dans ce domaine, on va vérifier
% qu'il n'existe pas de solution telle que la suite ne soit pas périodique, de fait nous aurons
% prouvé la propriété sur ce domaine

% notNinePeriodic(?)
notNinePeriodic([U10, U9, _U8, _U7, _U6, _U5, _U4, _U3, _U2, U1, U0]) :-
	U0 #\= U9,
	U1 #\= U10.

% checkNinePeriodic(+, +)
checkNinePeriodic(Min, Max) :-
	faitListe(L, 11, Min, Max),
	suite(L),
	notNinePeriodic(L),
	labeling(L).

% ?- checkNinePeriodic(-1000, 1000).
% 
% No (57.93s cpu)

% On voit ici que la propriété est au moins vérifiée sur [-1000, 1000] (domaine entier)
