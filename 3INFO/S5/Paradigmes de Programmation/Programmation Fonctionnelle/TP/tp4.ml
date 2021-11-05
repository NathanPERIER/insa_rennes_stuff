let longueur l = 
  let rec longueur_rec li n = match li with
    | [] -> n
    | a::reste -> longueur_rec reste (n+1)
  in longueur_rec l 0;;

(* TEST *)
(* Ceci doit retourner 3 *)
let res = longueur [1;2;3];;
(* END TEST *)

let appartient e l = 
  let rec appartient_rec li = match li with
    | [] -> false
    | a::reste -> if a = e then true else appartient_rec reste
  in appartient_rec l;;

(* TEST *)
(* Ceci doit retourner false *)
let res = appartient 4 [1;2;3];;
(* END TEST *)

let rang e l =
  let rec rang_rec li n = match li with
    | [] -> 0
    | a::reste -> if a = e then n else rang_rec reste (n + 1)
  in rang_rec l 1;;

(* TEST *)
(* Ceci doit retourner 2 *)
let res = rang 2 [3;2;1];;
(* END TEST *)

let concatl l1 l2 = 
  let rec concatl_rec li res = match li with
    | [] -> res
    | a::reste -> a::(concatl_rec reste res)
  in concatl_rec l1 l2;;

(* TEST *)
(* Ceci doit retourner [1;2;3;4;5;6] *)
let res = concatl [1;2;3] [4;5;6];;
(* END TEST *)

let debliste l n = 
  let rec debliste_rec li i = match li with
    | [] -> []
    | a::reste -> if i = n then [a] else a::(debliste_rec reste (i+1))
  in debliste_rec l 1;;

(* TEST *)
(* Ceci doit retourner [1; 2; 3] *)
let res = debliste [1;2;3;4;5;6;7] 3;;
(* END TEST *)

let finliste l n = 
  let longueur_l = longueur l in
  let rec finliste_rec li n = match li with 
    | [] -> []
    | a::reste -> if n < 0 then finliste_rec reste (n+1) else a::(finliste_rec reste (n+1))
  in finliste_rec l (n - longueur_l);;

(* TEST *)
(* Ceci doit retourner [5; 6; 7] *)
let res = finliste [1;2;3;4;5;6;7] 3;;
(* END TEST *)

let remplace x y l = 
  let rec remplace_rec li = match li with 
    | [] -> [] 
    | a::reste -> if a=x then y::(remplace_rec reste) else a::(remplace_rec reste) 
  in remplace_rec l;;
  
(* TEST *)
(* Ceci doit retourner [1; 42; 3; 42; 5] *)
let res = remplace 2 42 [1;2;3;2;5];;
(* END TEST *)

let entete l l1 = 
  let rec entete_rec (la, lb) = match (la, lb) with
    | ([], _) -> true
    | (a::reste, []) -> false
    | (a::reste1, b::reste2) -> if a=b then entete_rec (reste1, reste2) else false 
  in entete_rec (l, l1);;

(* TEST *)
(* Ceci doit retourner true *)
let res = entete [1;2;3] [1;2;3;2;5];;
(* Ceci doit retourner false *)
let res = entete [2;3] [1;2;3;2;5];;
(* END TEST *)

let sousliste l l1 = 
  let rec sousliste_rec li = match li with 
    | [] -> true
    | a::reste -> if appartient a l1 then sousliste_rec reste else false 
  in sousliste_rec l;;

(* TEST *)
(* Ceci doit retourner true *)
let res = sousliste [2;3;2] [1;2;3;2;5];;
(* Ceci doit retourner false *)
let res = sousliste [3;2;8] [1;2;3;2;5];;
(* END TEST *)

let oter l l1 = if entete l l1 then finliste l1 ((longueur l1) - (longueur l)) else l1;;

(* TEST *)
 (* Ceci doit retourner [2; 5] *)
let res = oter [1;2;3] [1;2;3;2;5];;
 (* Ceci doit retourner [1; 2; 3] *)
let res = oter [5; 2] [1;2;3];;
(* END TEST *)

let remplacel l1 l2 l = 
  let rec replacel_rec li = match li with 
    | [] -> [] 
    | a::reste -> if entete l1 li 
        then concatl l2 (replacel_rec (oter l1 li)) 
        else a::(replacel_rec reste)
  in match l1 with 
  | [] -> l (* Pas nécessaire mais utile pour la suite *)
  | _  -> replacel_rec l;;

(* TEST *)
(* Ceci doit retourner [4; 5; 6; 2; 5; 6; 2; 1; 3; 8] *)
let res = remplacel [1;2;1] [5;6] [4;1;2;1;2;1;2;1;2;1;3;8];;
(* END TEST *)

let supprimel l1 l = remplacel l1 [] l;;

(* TEST *)
(* Ceci doit retourner [4; 2; 1; 3; 8] *)
let res = supprimel [1;2;1] [4;1;2;1;2;1;3;8];;

(* Ceci doit retourner [1; 2; 3] *)
let res = supprimel [] [1;2;3];;
(* END TEST *)

let maxl l = 
  let rec maxofsublists li s m = match li with
    | [] -> m
    | b::r -> if s + b > m then maxofsublists r (s+b) (s+b) else maxofsublists r (s+b) m
  in let rec maxl_rec li m = 
     let sum = maxofsublists li 0 0 
       in match li with
       | [] -> m
       | a::reste -> if sum > m then maxl_rec reste sum else maxl_rec reste m 
  in maxl_rec l 0;;
                    

(* TEST *)
(* Ceci doit retourner 5 *)
let res = maxl [-1; 3; -4; 2; -3; 4; -2; 3; -1];;
(* END TEST *)
