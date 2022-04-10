# Portfolio

## Structure typique du prédicat principal

```Prolog
:- lib(ic).

solve_problem(Problem) :-
	create_structure(Problem),
	constrain_data(Problem),
	get_vars(Problem, Vars),
	labeling(Vars)
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

(for(I, 1, Size), fromto([], In, Out, Res) do
	Out = [I|In]
).

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

## Produit scalaire

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

