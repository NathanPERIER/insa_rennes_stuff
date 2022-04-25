# Portfolio

## Partie cours

### Problème de satisfaction de contraintes (CSP)

Un problème à satisfaction de contraintes `<X, D, C>` est consistué de trois ensembles finis :
 - `X = {X1, X2, ..., Xn}` l'ensemble des variables du problème
 - `D = {D1, D2, ..., Dn}` l'ensemble des domaines de ces variables (i.e. chaque variable `Xi` doit prendre une valeur dans `Di`)
 - `C` l'ensemble des contraintes qui sont des règles réduisant le nombre de possibilités sur les valeurs que peuvent prendre les variables

On définit une évaluation des variables comme une fonction qui à tout élément `Xi` de `X` associe une unique valeur dans `Di`. Une solution du problème est une évaluation qui satisfait l'ensemble des contraintes de `C`.

L'objectif du problème peut être de trouver une solution quelconque, une solution optimale, l'ensemble des solutions ou de déterminer s'il existe ou non des solutions.

### Défis des problèmes à contraintes

Ces problèmes sont très souvent NP-complets, donc on n'a à priori pas d'algorithmes qui permet de les résoudre en un temps raisonnable dans tous les cas. Cela ne signifie pas pour autant que la recherche sera nécessairement en temps exponentiel, c'est vrai dans le pire des cas mais on peut essayer de trouver des stratégies pour aller plus vite. 

Le temps de résolution (pour une taille de problème donnée) va dépendre de différents paramètres, qui peuvent être adaptés afin de résoudre les problèmes plus rapidement :
 - L'ordre dans lequel les variables sont traitées
 - L'ordre dans lequel les contraintes sont traitées
 - L'ordre dans lequel les valeurs du domaine sont essayées

Il n'y a cependant pas de méthode générale pour trouver les bonnes heuristiques à utiliser, il faut réfléchir au cas par cas.

L'ajout de contraintes redondantes peut également accélérer la recherche car certaines valeurs seront éliminées plus rapidement.

Il est à noter que si les points évoqués ci-dessus ont une influence sur la vitesse à laquelle on est capable de résoudre le problème, les solutions que l'on va obtenir à la fin seront les mêmes.

Un autre aspect des problèmes à contraintes auquel il faut être vigilent est la présence de symétries dans la structure du problème. S'il en existe, alors on va passer de temps à chercher des solutions qui n'apportent pas d'informations en plus. Par exemple, si on a un problème de la forme `P = A + B` (où `A` et `B` ont les mêmes contraintes) et qu'on trouve la solution `A=1, B=2`, alors `A=2, B=1` est aussi une solution. Pour éviter de passer du temps à énumérer des solutions redondantes, on peut poser des contraintes supplémentaires qui vont supprimer les symétries.

### De «Generate and Test» à «Constraint and Generate»

En Prolog de base, on va essayer toutes les valeurs possibles dans l'ordre jusqu'à tomber sur une solution. Ce n'est pas très efficace et peut s'avérer très long en fonction du nombre de variables et de la taille du problème. On va donc essayer d'utiliser les contraintes pour parcourir l'espace de recherche plus efficacement en éliminant d'abord les valeurs impossibles, puis enitérant sur ce qu'il reste.

Quand on pose une contrainte, on va tout d'abord propager cette contrainte pour réduire les domaines des variables. Quand toutes les contraintes sont propagées, on va essayer d'attribuer une valeur à chaque variable afin de constituer une évaluation. À chaque attribution de valeur (étiquetage), on continue de propager les contraintes pour réduire encore plus les domaines des variables. Si le domaine d'une variable devient vide, alors la solution est invalide et on utilise le backtracking pour la supprimer de l'espace de recherche. Si on parvient à réduire le domaine de chaque variable à une seule valeur après application de toutes les contraintes, alors on a trouvé une solution au problème.

Les algorithmes suivants peuvent être utilisés pour propager les contraintes

#### Cohérence de noeuds

La cohérence de noeuds consiste à utiliser une contrainte portant sur une unique variable pour en réduire le domaine. Pour cela, on va prendre chaque valeur du domaine de la variable et ne garder que celles qui satisfont la contrainte. Il est à noter que le domaine est un ensemble fini de valeurs à une dimension.

Plus précisément, on dit qu'une contrainte `c` de `C` est cohérente par noeuds avec un domaine `D` si elle ne fait intervenir qu'une seule variable `x` et que pour tout `d` dans `D(x)`, l'assignation de `d` à `x` est une solution de `c`.

#### Cohérence d'arcs

La cohérence d'arcs ressemble à la cohérence de noeuds mais sur des contraintes binaires. On ne travaille donc à présent sur un espace fini en deux dimensions, dont on va tester chacune des valeurs pour déterminer lesquelles sont à garder. 

On peut généraliser cette idée avec la cohérence d'hyperarcs (ou cohérence d'arcs généralisée) qui travaille avec des contraintes `n`-aires (`n > 2`). Il est cependant à noter que c'est une approche qui est côuteuse en temps (NP-difficile) et qui va demander de stocker de grands domaines (puisqu'on travaille avec des ensembles à `n` dimensions).

#### Cohérence de bornes

La cohérence de bornes est un compromis, dans le sens où on ne vas pas supprimer toutes les valeurs incohérentes, mais on va tout de même garantir qu'on ne perd pas de solutions. En effet, on ne travaille plus sur des ensembles mais sur des intervalles, ce qui signifie qu'il n'y a plus qu'a stocker la borne inférieure et la borne supérieure des domaines au lieu d'énumérer chaque valeur possible. Cela signifie aussi qu'on ne peut travailler qu'avec des valeurs numériques et qu'on ne peut pas supprimer des valeurs incohérentes au milieu des domaines, ce sera fait lors de la phase de test. Pour trouver les bornes des intervalles, on utilise des propriétés sur les opérations arithmétiques.

#### Cohérence spécialisée

Pour certaines contraintes que l'on appelle contraintes globales, les méthodes ci-dessus ne suffisent pas nécessairement et il est plus intéressant de créer des méthodes de cohérence spécialisées pour traiter ces cas. Par exemple si on veut que trois vairables `X`, `Y` et `Z` soient différentes deux à deux mais que ces trois variables ont pour domaine `{1, 2}`, on est dans un cas où il n'existe pas de solution au problème mais ça ne serait pas détectable par cohérence de bornes, alors qu'une méthode spécialisée serait capable d'être plus précise.

### Programmation par contraintes en Prolog

Pour résoudre des problèmes à contraintes en Prolog, on utilisera la librairie `ic`. Elle introduit des variables particulières qui, en plus des propriétés classiques des variables de Prolog, ont un domaine ainsi qu'une liste des contraintes dans lesquelles elles interviennent.

La librairie gère toute seule les optimisations sur les contraintes (ordre d'appel, simplifications, ...) ainsi que les listes de contraintes déjà utilisées ou en attente. Il nous reste donc à choisir l'ordre de traitement des variables et l'ordre d'essai des valeurs d'un domaine (voir prédicat `search/6`).

Contraintes actives : DELAY, wake et RESUME

#### Contraintes globales

La librairie définit plus de 400 contraintes globales (bibliothèque `ic_global`) avec des méthodes de cohérence spécialisées (http://sofdem.github.io/gccat). 

On notera par exemple :
 - `alldifferent(+List)` contraint toutes les variables de `List` à être différentes deux à deux
 - `element(?Index, ++List, ?Value)` contraint `Value` à être égale à l'élément à la position `Index` de `List`
 - `atmost(+N, ?List, +V)` contraint les éléments de `List`, de telle sorte à ce qu'il y ait au maximum `N` occurences de la valeur `V`
 - `maxlist(+List, ?Max)` contraint le maximum de `List` à être égal à `Max`
 - `minlist(+List, ?Min)` contraint le minimum de `List` à être égal à `Min`
 - `sumlist(+List, ?Sum)` contraint la somme des éléments de `List` à être égale à `Sum`

## Structure typique du prédicat principal

```Prolog
:- lib(ic).

solve_problem(Problem) :-
	create_structure(Problem),
	constrain_data(Problem),
	get_vars(Problem, Vars),
	labeling(Vars).
```

## Minimisation

```Prolog
:- lib(branch_and_bound).

solve_min(Arg, Res) :-
	minimize(solve(Arg, Res), Res).
```

Structure plus complexe (où `solve` n'appelle pas `labeling`) :
```Prolog
solve_min(Vars, Sum) :-
	minimize(
		(
			solve(Vars, Sum),
			labeling(Vars)
		),
		Sum
	).
```

## Maximisation

```Prolog
solve_max(Arg, Res) :-
	ResNeg #= -1 * Res,
	minimize(solve(Arg, Res), ResNeg).
```

## Création d'un domaine symbolique

```Prolog
:- lib(ic_symbolic).

?- local domain(greeting(bonjour, hello, hola, hej)).
```

### Contraindre une variable à un domaine symbolique

```Prolog
Greet &:: greeting
```

### Contraindre une variable à une valeur du domaine symbolique

```Prolog
Greet &= bonjour
```

### Contraindres les variables à être différentes

```Prolog
ic_symbolic:alldifferent([Greet1, Greet2, Greet3])
```

## Labeling avec des domaines symboliques

```Prolog
labeling_symbolic(Vars) :-
	(foreach(V, Vars) do
		ic_symbolic:indomain(V)
	).
```

## Opérateurs avec les domaines numériques

| Opérateur | Signification            |
|-----------|--------------------------|
| `#=`      | Égalité (ou équivalence) |
| `#\=`     | Différence               |
| `=>`      | Implication              |
| `#<`      | Infériorité stricte      |
| `#=<`     | Infériorité              |
| `#>`      | Supériorité stricte      |
| `#>=`     | Supériorité              |
| `or`      | Disjonction              |
| `and`     | Conjonction              |

## Itérateurs

- `fromto(First, In, Out, Last)`
- `foreach(X, List)`
- `foreacharg(X, Struct, Idx)`
- `foreachelem(X, Array, Idx)`
- `foreachindex(Idx, Array)`
- `for(I, MinExpr, MaxExpr, Increment)`
- `multifor(List, MinList, MaxList, IncrementList)`

## Imbrication de `foreach`

```Prolog
(foreach(X, List), param(List) do
	X = x(A, B, C)
	% Maybe do something with X
	(foreach(X1, List), param(A, B, C) do
		X1 = x(A1, B1, C1)
		% ...
	)
).
```

## Utilisation d'un résultat booléen comme valeur numérique

```Prolog
nb_val(Tab, Val, Res) :-
	(foreachelem(E, Tab), fromto(0, In, Out, Res), param(Val) do
		Out #= In + (E #= Val)
	).
```

## Itération sur plusieurs indices

```Prolog
flatmap(T) :-
	dim(T, [MaxI, MaxJ]),
	(multifor([J, I], [MaxJ, MaxI], [1, 1], [-1, -1]), fromto([], In, Out, L), param(T) do
		E is T[I,J],
		Out = [E|In]
	).
```

## Aggrégation de données

### Ordre inverse

```Prolog
(for(I, 1, Size), fromto([], In, Out, Res) do
	Out = [I|In]
).
```

### Ordre conservé

```Prolog
(for(I, 1, Size), fromto(Res, In, Out, []) do
	In = [I|Out]
).
```

### Somme

```Prolog
(foreachelem(E, Tab), fromto(0, In, Out, Res) do
	Out #= In + E
).
```

### Cas particulier : produit scalaire

```Prolog
dot_product(Tab1, Tab2, Res) :-
	dim(Tab1, [Taille]),
	dim(Tab2, [Taille]),
	(for(I, 1, Taille), fromto(0, In, Out, Res), param(Tab1, Tab2) do
		T1i is Tab1[I],
		T2i is Tab2[I],
		Out #= In + T1i * T2i
	).
```

## Prédicat `search`

```Prolog
search(+L, ++Arg, ++Select, +Choice, ++Method, +Option)
```

Dans notre cas d'utilisation : 
```Prolog
search(+L, 0, ++Select, +Choice, complete, [])
```
(`L` est une liste de variables à domaines de `ic`)

Note : `labeling(L) <=> search(L, 0, input_order, indomain, complete, [])`

### Valeurs possibles pour `Select`

- `input_order`: the first entry in the list is selected
- `first_fail`: the entry with the smallest domain size is selected
- `anti_first_fail`: the entry with the largest domain size is selected
- `smallest`: the entry with the smallest value in the domain is selected
- `largest`: the entry with the largest value in the domain is selected
- `occurrence` the entry with the largest number of attached constraints is selected
- `most_constrained`: the entry with the smallest domain size is selected. If several entries have the same domain size, the entry with the largest number of attached constraints is selected.
- `max_regret`: the entry with the largest difference between the smallest and second smallest value in the domain is selected. This method is typically used if the variable represents a cost, and we are interested in the choice which could increase overall cost the most if the best possibility is not taken. Unfortunately, the implementation does not always work: If two decision variables incur the same minimal cost, the regret is not calculated as zero, but as the difference from this minimal value to the next greater value.

Il est aussi possible de passer un prédicat défini par l'utilisateur d'arité 2 où le permier argument est une variable X et le second argument doit être unifié à un critère de sélection (nombre). La variable avec la plus petite valeur sera sélectionnée en premier.

### Valeurs possibles pour `Choice`

- `indomain`: uses the built-in `indomain/1`. Values are tried in increasing order. On failure, the previously tested value is not removed.
- `indomain_min`: Values are tried in increasing order. On failure, the previously tested value is removed. The values are tested in the same order as for indomain, but backtracking may occur earlier.
- `indomain_max`: Values are tried in decreasing order. On failure, the previously tested value is removed.
- `indomain_reverse_min`: Like `indomain_min`, but the alternatives are tried in reverse order. I.e. the smallest value is first removed from the domain, and only if that fails, the value is assigned.
- `indomain_reverse_max`: Like `indomain_max`, but the alternatives are tried in reverse order. I.e. the largest value is first removed from the domain, and only if that fails, the value is assigned.
- `indomain_middle`: Values are tried beginning from the middle of the domain. On failure, the previously tested value is removed.
- `indomain_median`: Values are tried beginning from the median value of the domain. On failure, the previously tested value is removed.
- `indomain_split`: Values are tried by succesive domain splitting, trying the lower half of the domain first. On failure, the tried interval is removed. This enumerates values in the same order as `indomain` or `indomain_min`, but may fail earlier.
- `indomain_reverse_split`: Values are tried by succesive domain splitting, trying the upper half of the domain first. On failure, the tried interval is removed. This enumerates values in the same order as `indomain_max`, but may fail earlier.
- `indomain_random`: Values are tried in a random order. On backtracking, the previously tried value is removed. Using this routine may lead to non-reproducible results, as another call will create random numbers in a different sequence. This method uses the built-in `random/1` to create random numbers, `seed/1` can be used to force the same number generation sequence in another run.
- `indomain_interval`: If the domain consists of several intervals, we first branch on the choice of the interval. For one interval, we use domain splitting.

Il est aussi possible de passer un prédicat défini par l'utilisateur d'arité 1 qui prend une variable et qui fait un choix de labeling sur cette variable.

De même, on peut passer un terme à deux arguments qui prend en paramètres la première entrée et la dernière sortie. À chaque appel du prédicat défini par l'utilisateur (d'arité 3), la sortie sera enrgistée pour être passée en entrée au prochain appel.

```
search(..., my_choice(FirstIn, LastOut), ...)

my_choice(X, In, Out) :- ...
```

On peut également ajouter un paramètre au terme en première position de ses paramètres (ce qui augmente l'arité du prédicat utilisateur d'un élément)

```
search(..., my_choice(Param), ...)

my_choice(X, Param) :- ...
```

```
search(..., my_choice(Param, FirstIn, LastOut), ...)

my_choice(X, Param, In, Out) :- ...
```

### Évaluation d'opérations arithmétiques

| Opération                      | Résultat |
|--------------------------------|----------|
| `10 = 5 * 2`                   | No       |
| `10 is 5 * 2`                  | Yes      |
| `2 * 5 > 2 * 2`                | Yes      |
| `max([1, 2 + 2, 2 * 5], 10)`   | Yes      |
| `10 is max([1, 2 + 2, 2 * 5])` | Yes      |
| `T = [](1, 2, 3), 2 is T[2]`   | Yes      |

