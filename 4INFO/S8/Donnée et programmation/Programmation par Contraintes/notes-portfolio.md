# Portfolio

## Structure typique du prédicat principal

```Prolog
solve_problem(Problem) :-
	create_structure(Problem),
	constrain_data(Problem),
	get_vars(Problem, Vars),
	labeling(Vars)
```

## Création d'un domaine symbolique

```Prolog
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


