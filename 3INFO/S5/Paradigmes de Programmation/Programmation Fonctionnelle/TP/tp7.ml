type 'a narbr = NODE of 'a * 'a narbr list;;

let feuille v = NODE (v, []);;
let noeud v l = NODE (v, l);;
let valeur a = match a with | NODE (v, l) -> v;;
let sous_arbres a = match a with | NODE (v, l) -> l;;

let a1 = feuille 4;;
let a2 = noeud 3 [a1; a1];;

(* TEST *)
(* Doivent retourner true *)
let _ = valeur a1 = 4;;
let _ = valeur a2 = 3;;
let _ = sous_arbres a1 = [];;
let _ = sous_arbres a2 = [a1;a1];;
(* END TEST *)

let rec compter a =
  let rec compter_rec l = match l with
    | [] -> 0
    | a::reste -> (compter a) + (compter_rec reste)
  in let l = sous_arbres a
  in if l = [] then 1 else compter_rec l;;

(* TEST *)
(* doit retourner 2 *)
let _ = compter a2;;
(* END TEST *)

let rec pluslongue a =
  let rec max_lenghts l = match l with
    | [] -> 0
    | a::reste ->
       let len = pluslongue a in
       let max_reste = max_lenghts reste in
       if len > max_reste then len else max_reste
  in let l = sous_arbres a
  in (max_lenghts l) + 1;;

let a3 = noeud 8 [a1; a2; a1];;
(* TEST *)
(* doit retourner 3 *)
let _ = pluslongue a3;;
(* END TEST *)

let listsa a =
  let rec liste_rec l = match l with
    | [] -> []
    | a::reste -> a::(liste_rec (sous_arbres a))@(liste_rec reste)
  in a::(liste_rec (sous_arbres a));;

let f4 = feuille 4;;
let f10 = feuille 10;;
let f12 = feuille 12;;
let f13 = feuille 13;;
let f20 = feuille 20;;
let f21 = feuille 21;;
let n7 = noeud 7 [ f10; f12; f13 ];;
let n3 = noeud 3 [ f4; n7; f20];;
let n5 = noeud 5 [ n3; f21 ];;

(* TEST *)
(* Ceci doit retourner true *)
let _ =
  List.sort compare (listsa n5) = List.sort compare [f4; f10; f12; f13; f20; f21; n7; n3; n5]
(* END TEST *)

let rec listbr a =
  let rec insert ll elt = match ll with
    | [] -> []
    | a::reste -> (elt::a)::(insert reste elt)
  in let rec list_rec l = match l with
       | [] -> failwith "This should not happen"
       | a::[] -> listbr a
       | a::reste -> (listbr a)@(list_rec reste)
  in match a with
    | NODE (v, []) -> [[v]]
    | _ -> insert (list_rec (sous_arbres a)) (valeur a);;

(* TEST *)
(* doit retourner true *)
let _ =
  let res = [
    [5; 3; 4];
    [5; 3; 7; 10];
    [5; 3; 7; 12];
    [5; 3; 7; 13];
    [5; 3; 20];
    [5; 21]
  ] in
  List.sort compare (listbr n5) =
  List.sort compare res
(* END TEST *)

let rec egal a b =
  let rec egal_rec (l1, l2) = match (l1, l2) with
    | ([], []) -> true
    | (a::reste1, b::reste2) -> if egal a b then egal_rec (reste1, reste2) else false
    | _ -> false
  in if (valeur a) = (valeur b) then egal_rec (sous_arbres a, sous_arbres b) else false;;
  
(* TEST *)
(* doit retourner true *)
let _ = egal n5 n5;;
(* doit retourner false *)
let _ = egal n5 n3;;
(* END TEST *)

let rec remplace a1 a2 a =
  let rec remplace_rec l = match l with
    | [] -> []
    | a::reste -> (remplace a1 a2 a)::(remplace_rec reste)
  in if egal a a1 then a2 else noeud (valeur a) (remplace_rec (sous_arbres a));;

let n42 = noeud 42 [feuille 2048];;
let res = noeud 5 [(noeud 3 [f4; n42; f20]); f21];;

(* TEST *)
(* ceci doit retourner true *)
let _ = (remplace n7 n42 n5) = res;;
(* END TEST *)
