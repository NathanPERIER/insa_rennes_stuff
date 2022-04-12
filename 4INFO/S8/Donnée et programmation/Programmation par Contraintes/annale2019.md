
# Programmation par contraintes - Annale 2019

## Exercice 1

### 1.1

Les algorithmes de bounds consistency travaillent sur des intervalles. Leur objectif est de supprimer les intervalles (en n >= 1 dimensions) dans lesquels on est certains qu'une solution ne peut pas se trouver. L'avantage est qu'ils ne suppriment jamais de réponses valides et sont assez rapides car ils ne travaillent qu'avec les bornes des intervalles. En revanche, ils vont laisser des points qui ne sont pas des soluions valides et qu'il faudra éliminer par la suite (ce qui peut prendre du temps).

Ils sont opposés aux algorithmes de node consistency et arc consistency qui travaillent avec des ensembles numériques et qui élimenent des valeurs au sein de ces ensembles (potentiellement au milieu). 

### 1.2

Le prédicat `alldifferent/1` prend une liste de variables ic et les contraint à être différentes deux à deux.

### 1.3

Il est important de contrôller la recherche sur les données du problème car le temps de réponse peut être grandement diminué si on trouve des bonnes solutions dès le départ. Pour cela, on peut agir sur l'ordre dans lequel sont traitées les variables, l'ordre dans lequel sont traitées les valeurs des domaines ainsi que le nombre de contraintes redondantes.

### 1.4

????


## Exercice 2

### 2.1

```Prolog
fractions_3(T) :-
	T = [[X1, Y1, Z1], [X2, Y2, Z2], [X3, Y3, Z3]],
	[](X1, Y1, Z1, X2, Y2, Z2, X3, Y3, Z3) #:: 1..9,
	alldifferent([X1, Y1, Z1, X2, Y2, Z2, X3, Y3, Z3]),
	Den1 #= Y1 * 10 + Z1,
	Den2 #= Y2 * 10 + Z2,
	Den3 #= Y3 * 10 + Z3,
	Den1 * Den2 * Den3 #= (X1 * Den2 * Den3) + (X2 * Den1 * Den3) + (X3 * Den1 * Den2),
	labeling([X1, Y1, Z1, X2, Y2, Z2, X3, Y3, Z3]).
```

### 2.2

?

### 2.3

La commutativité de l'addition induit des symétries car on peut permuter les termes au sein de la somme (`a + b = b + a`).

(comment faire pour les supprimer ?)

### 2.4

```Prolog
nfractions(N, T) :-
	poser_variables(N, T),
	compter_occurences(T, Occurences),
	calculer_den(T, Den),
	calculer_prod(Den, Prod),
	calculer_somme(N, T, Den, Sum),
	contraindre_valeurs(T),
	contraindre_occurences(N, Occurences),
	contraindre_eq(Prod, Sum),
	getvarlist(T, Vars),
	labeling(Vars).


poser_variables(N, T) :-
	(for(_I, 1, N), fromto([], In, Out, T) do
		Out = [[_X, _Y, _Z] | In]
	).

compter_occurences(T, Occurences) :-
	Init = [](0, 0, 0, 0, 0, 0, 0, 0, 0),
	(foreach(E, T), fromto(Init, In, Out, Occurences) do
		E = [X, Y, Z],
		dim(Out, [9]),
		(for(I, 1, 9), param(In, Out, X, Y, Z) do
			Ci is In[I],
			Ni is Out[I],
			Ni #= Ci + (X #= I) + (Y #= I) + (Z #= I)
		)
	).

calculer_den(T, Den) :-
	(foreach([_X, Y, Z], T), fromto(Den, In, Out, []) do
		D #= Y * 10 + Z,
		In = [D | Out]
	).

calculer_prod(Den, Prod) :-
	(foreach(D, Den), fromto(1, In, Out, Prod) do
		Out #= In * D
	).

partial_prod(T, Except, Res) :-
	partial_prod_helper(1, T, Except, Res).
partial_prod_helper(I, [_E|T], Except, Res) :-
	I = Except,
	I1 is I + 1,
	partial_prod_helper(I1, T, Except, Res).
partial_prod_helper(I, [E|T], Except, Res) :-
	I \= Except,
	I1 is I + 1,
	partial_prod_helper(I1, T, Except, Res1),
	Res #= E * Res1.
partial_prod_helper(_I, [], _Except, 1).

calculer_somme(N, T, Den, Sum) :-
	array_list(Arr, T),
	(for(I, 1, N), fromto(0, In, Out, Sum), param(Arr, Den) do
		Ai is Arr[I],
		Ai = [X, _Y, _Z],
		partial_prod(Den, I, Partial),
		Out #= In + Partial * X
	).

contraindre_valeurs(T) :-
	(foreach([X, Y, Z], T) do 
		X #:: 1..9,
		Y #:: 1..9,
		Z #:: 1..9
	).

contraindre_occurences(N, Occurences) :-
	Max is integer(ceiling(N/3)),
	(foreachelem(O, Occurences), param(Max) do
		O #:: 1..Max
	).

contraindre_eq(Prod, Sum) :-
	Prod #= Sum.

getvarlist(T, Vars) :-
	(foreach([X, Y, Z], T), fromto([], In, Out, Vars) do
		Out = [X, Y, Z | In]
	).
```
