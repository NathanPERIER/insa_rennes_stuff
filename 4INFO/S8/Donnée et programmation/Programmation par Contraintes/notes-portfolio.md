# Portfolio

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


