let rec split v l = 
  match l with 
  | [] -> ([], [])
  | a::reste -> let (l1, l2) = split v reste in if a < v then (a::l1, l2) else (l1, a::l2);;

(* TEST *)
(* doit retourner [-12; 1; 3], [12; 27; 7; 8; 6; 12; 42] *)
let res1, res2 = split 4 [12; 27; -12; 7; 8; 1; 3; 6; 12; 42];;
(* END TEST *)

let rec qs l = match l with
  | [] -> l
  | a::[] -> l
  | a::reste -> let (l1, l2) = split a reste in ((qs l1) @ (a::(qs l2)));;

(* TEST *)
(* doit retourner [-12; 1; 3; 4; 6; 7; 8; 12; 12; 27; 42] *)
let res = qs [4; 12; 27; -12; 7; 8; 1; 3; 6; 12; 42];;
(* END TEST *)

let rec kieme k l = 
  let rec smallest li min = match li with
    | [] -> min
    | a::reste -> if a < min then smallest reste a else smallest reste min 
  in if k = 1 then match l with  (*Condition d'arrêt : pour k = 1 on retourne le plus petit élément de la liste*)
    | [] -> assert false
    | _  -> smallest l max_int
  else match l with
    | [] -> assert false 
    | a::reste -> let (l1, l2) = split a reste in let l1_len = List.length l1 in
        if k <= l1_len then kieme k l1
        else if k = l1_len + 1 then a
        else kieme (k - (l1_len+1)) l2;; 
  
(* TEST *)
(* doit retourner 8 *)
let res = kieme 7 [4; 12; 27; -12; 7; 8; 1; 3; 6; 12; 42];;
(* END TEST *)

let rec jqastable x f = let y = f x in if y = x then x else (jqastable y f);;

(* TEST *)
(* doit retourner 1 *)
let res = jqastable 13 (fun x -> if (x = 1) then 1 else if (x mod 2 = 1) then 3 * x + 1 else x / 2);;
(* END TEST *)

let rec unebulle l = match l with
  | [] -> l
  | a::[] -> l
  | a::b::reste -> if a < b then a::(unebulle (b::reste)) else b::(unebulle (a::reste));;

(* TEST *)
(* doit retourner [4; 12; -12; 7; 8; 1; 3; 6; 27; 12; 42] *)
let res = unebulle [4; 12; 27; -12; 7; 8; 1; 3; 6; 42; 12];;
(* END TEST *)

let tribulle l = jqastable l unebulle;;

(* TEST *)
(* doit retourner [-12; 1; 3; 4; 6; 7; 8; 12; 12; 27; 42] *)
let res = tribulle [4; 12; 27; -12; 7; 8; 1; 3; 6; 12; 42];;
(* END TEST *)

let rec merge ll = match ll with 
  | [] -> []
  | l::reste -> l @ (merge reste);;

(* TEST *)
(* doit retourner [1; 2; 3; 5] *)
let res = merge [[1];[2;3];[5]];;
(* END TEST *)

let create f k = 
  let rec create_rec i = if i <= k then (f i)::(create_rec (i+1)) else []
  in create_rec 1;; 

(* TEST *)
(* doit retourner [2; 3; 4; 5] *)
let res = create (fun x -> x+1) 4;;
(* END TEST *)

let rec insert j ll = match ll with 
  | [] -> []
  | l::reste -> (j::l)::(insert j reste);;

(* TEST *)
(* doit retourner [[1;3;5];[1;7;3;9];[1];[1;6]]*)
let res = insert 1 [[3;5];[7;3;9];[];[6]];;
(* END TEST *)

(*Ne faites pas attention aux blocs comments suivants, il s'agit d'une tentative ratée*)

(*let rec lfilter test l = match l with
  | [] -> []
  | a::reste -> if test a then a::(lfilter test reste) else lfilter test reste;;*)

(* TEST *)
(* doit retourner [5; 4; 9; 7; 2]*)
(*let res = lfilter (fun i -> i != 1) [1; 5; 4; 1; 1; 9; 1; 7; 2];;*)
(* END TEST *)

(*let isSorted l = 
  let rec isSorted_rec b li = match li with
    | [] -> true
    | a::reste -> if b >= a then isSorted_rec a reste else false
  in isSorted_rec max_int l;;*)

(* TEST *)
(* doit retourner true*)
(*let res = isSorted [456; 12; 5; 2; 1; 1];;*)
(* doit retourner false*)
(*let res = isSorted [5; 4; 2; 1; 2];;*)
(* END TEST *)

(*let partition n = 
  let rec partition_rec i = 
    if i = 0 then [[]] 
    else merge (create (fun k -> insert k (partition_rec (i-k))) i)
  in lfilter isSorted (partition_rec n);;*)
  
  
  
let partition n = 
  let rec p (n, k) = 
    if k = 0 then 
	  if n = 0 then [[]] else []
    else if k > n then p (n, n) 
	else merge (create (fun j -> insert j (p (n-j, j))) k)
  in p(n, n);;

(* TEST *)
(* doit retourner une liste contenant [5], [4;1], [3;2], [3;1;1], [2;2;1],
   [2;1;1;1], [1;1;1;1;1] dans un ordre arbitraire *)
let res = partition 5;;
(* END TEST *)



let rec insert_cond j ll = match ll with 
  | [] -> []
  | l::reste -> match l with 
    | [] -> [j]::(insert j reste) (*Cas à un élément*)
    | a::r -> if j >= a 
	    then (j::l)::(insert_cond j reste) (*On insère le nombre au début ssi il est conforme à la règle qui dit que la liste doit être décroissante*)
		else insert_cond j reste;;         (*Sinon le cas est traité autre part, on oublie simplement ce terme*)
	


let partition_t n = 
  let rec getElement i ll = match ll with (*Aparamment ça existe déjà mais de toute façon il me faut le permier élément au rang 0*)
    | [] -> []
    | a::reste -> if i = 0 then a else getElement (i-1) reste
  in let rec part_rec i ll = 
       if i > n then getElement n ll
       else part_rec (i+1) (ll@[merge (create (fun j -> insert_cond j (getElement (i-j) ll)) i)])
  in part_rec 1 [[[]]];; (*On initialise avec la liste des partitions de rang 0 qui contient seulement une liste vide, cela permet de prendre en compte le cas de la liste à un élément*)

(* TEST *)
(* doit retourner une liste contenant [5], [4;1], [3;2], [3;1;1], [2;2;1],
   [2;1;1;1], [1;1;1;1;1] dans un ordre arbitraire *)
let res = partition_t 5;;
(* END TEST *)


(*marcherait sans doute si ça ne faisait pas un stack overflow*)
let coin_partition = 
  let rec getElement i ll = match ll with
    | [] -> []
    | a::reste -> if i = 0 then a else getElement (i-1) reste
  in let rec coin_rec i ll = 
       if (List.length (getElement (i-1) ll)) mod 1000000 = 0 then (i-1)
       else part_rec (i+1) (ll@[merge (create (fun j -> insert_cond j (getElement (i-j) ll)) i)])
  in coin_rec 1 [[[]]];; 
