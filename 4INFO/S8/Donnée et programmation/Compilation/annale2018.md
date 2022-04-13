
# Compilation - Annale 2018

## Exercice 1

```
S  -> D E
D  -> let ident = E ; D
D  -> ε
E  -> F E'
E' -> + E | F
F  -> int | ident
```

### Question 1

| X  | Null(X) |
|----|---------|
| S  | 0       |
| D  | 1       |
| E  | 0       |
| E' | 0       |
| F  | 0       |

### Question 2

| X  | First(X)          |
|----|-------------------|
| S  | {let, int, ident} |
| D  | {let}             |
| E  | {int, ident}      |
| E' | {+, int, ident}   |
| F  | {int, ident}      |

### Question 3

| X  | Follow(X)               |
|----|-------------------------|
| S  | {eof}                   |
| D  | {int, ident}            |
| E  | {eof, ;}                |
| E' | {eof, ;}                |
| F  | {eof, ;, +, int, ident} |

## Exercice 2

```
Goal -> List
List -> List Pair
List -> Pair
Pair -> ( Pair )
Pair -> ( )
```

### Question 4

*Note : this is probably false, but I think there is something I don't understand with the 'follows'*

If you don't see a diagram below, paste the code here : https://mermaid.live/edit

```Mermaid
stateDiagram-v2
	s01: 1
	s01: Goal -> • List, $
	s01: List -> • List Pair, ( / )
	s01: List -> • Pair, ( / )
	s01: Pair -> • ( Pair ), ( / )
	s01: Pair -> • ( ), ( / )
	s02: 2
	s02: List -> Pair •, ( / )
	s03: 3
	s03: Pair -> ( • Pair ), ( / )
	s03: Pair -> ( • ), ( / )
	s03: Pair -> • ( Pair ), ( / )
	s03: Pair -> • ( ), ( / )
	s04: 4
	s04: Pair -> ( ) •, ( / )
	s05: 5
	s05: Pair -> ( Pair • ), ( / )
	s06: 6
	s06: Pair -> ( Pair ) •, ( / )
	s07: 7
	s07: Goal -> List •, $
	s07: List -> List • Pair, ( / )
	s07: Pair -> • ( Pair ), ( / )
	s07: Pair -> • ( ), ( / )
	s08: 8
	s08: List -> List Pair •, ( / )
	s01 --> s02 : Pair
	s01 --> s03 : (
	s03 --> s03 : (
	s03 --> s04 : )
	s03 --> s05 : Pair
	s05 --> s06 : )
	s01 --> s07 : List
	s07 --> s08 : Pair
```

### Question 5

Not sure what the parser is...

### Question 6

The grammar is porbably not LR(1) because when we reach the end of the axiom in question 4 (`Goal -> List •`, node 7), there are still other rules and they haven't even been fully processed (e.g. `List -> List • Pair`).


## Exercice 3

```Ocaml
type expression =
| Int of int
| False
| True
| Ident of string
| Operator of operator

and operator =
| Define of string * expression * expression
| If  of expression * expression * expression
| Add of expression * expression
| Eq  of expression * expression
| Not of expression
| And of expression * expression

type value = 
| IntVal of int
| BoolVal of bool
```

### Question 7

Pas eu le temps, utiliser Menhir ?

### Question 8

Définition de Tokens (qu'on suppose avoir été produits dans la question précédente) :

```Ocaml
type token =
| IntToken of int
| BoolToken of bool
| IdentToken of string
| LParen
| RParen
| PlusToken
| DefineToken
| IfToken
| NotToken
| EqToken
| AndToken
```

Code du parser :

```Ocaml
(* next : unit -> token *)

let rec parse_expr next =
	match next () with
	| IntToken i   -> Int i
	| IdentToken n -> Ident n
	| BoolToken b  -> if b then True else False
	| LParen -> let res = Operator (parse_op next)
	            in if next () = RParen then res
	               else error "Expected closed parenthesis"
	| _ -> error "Expected value, identifier or operator"
and parse_op next =
	match next () with
	| DefineToken -> let n = (match next () with
	                          | IdentToken id -> id
	                          | _ -> error "Expected identifier")
	                 in let e1 = parse_expr next
	                 in let e2 = parse_expr next
	                 in Define (n, e1, e2)
	| IfToken  -> let e1 = parse_expr next
	              in let e2 = parse_expr next
	              in let e3 = parse_expr next
	              in If (e1, e2, e3)
	| AddToken -> let e1 = parse_expr next
	              in let e2 = parse_expr next
	              in Add (e1, e2)
	| EqToken  -> let e1 = parse_expr next
	              in let e2 = parse_expr next
	              in Eq (e1, e2)
	| NotToken -> Not (parse_expr next)
	| AndToken -> let e1 = parse_expr next
	              in let e2 = parse_expr next
	              in And (e1, e2)
	| _ -> error "Expected operator"
```

*Note : the part with operators is a bit ugly but I was in a rush and didn't want to find a fnacy way of doing things*

### Question 9

Utility functions :

```Ocaml
let add_to_ctx n val ctx = (n, val)::ctx

let rec get_from_ctx n ctx =
	match ctx with
	| (n, v)::r -> v
	| _::r -> get_from_ctx n r
	| [] -> error "Identifier not found : " ^ n

let bool_values v1 v2 =
	match (v1, v2) with
	| (BoolVal b1, BoolVal b2) -> (b1, b2)
	| _ -> error "Expected boolean values"

let int_values v1 v2 =
	match (v1, v2) with
	| (IntVal i1, IntVal i2) -> (i1, i2)
	| _ -> error "Expected integer values"
```
*Note : I know there is a way to do maps in OCaml but I don't know the name of the library and the functions, so I just did that*

Evaluation of the syntaxic tree :

```Ocaml
let eval_prog p =
	let rec eval_expr e ctx =
		match e with
		| Int i -> IntVal i
		| False -> BoolVal false
		| True  -> BoolVal true
		| Ident n -> get_from_ctx n ctx
		| Operator op -> eval_op op ctx
	and eval_op op ctx =
		match op with
		| Define (n, e1, e2) -> let ctx2 = add_to_ctx n (eval_expr e1 ctx) ctx
		                        in eval_expr e2 ctx2
		| If (e1, e2, e3) -> (match eval_expr e1 ctx with
		                      | BoolVal b -> eval_expr (if b then e2 else e3) ctx
		                      | _ -> error "Expected boolean value")
		| Add (e1, e2) -> let (i1, i2) = int_values (eval_expr e1 ctx) (eval_expr e2 ctx)
		                  in IntValue (i1 + i2)
		| Eq (e1, e2) -> let (i1, i2) = int_values (eval_expr e1 ctx) (eval_expr e2 ctx)
		                 in BoolValue (i1 = i2)
		| Not e -> (match eval_expr e ctx with
		            | BoolVal b -> BoolVal (not b)
		            | _ -> error "Expected boolean value")
		| And (e1, e2) -> let (b1, b2) = bool_values (eval_expr e1 ctx) (eval_expr e2 ctx)
		                  in BoolVal (b1 && b2)
	in eval_expr p []
```


