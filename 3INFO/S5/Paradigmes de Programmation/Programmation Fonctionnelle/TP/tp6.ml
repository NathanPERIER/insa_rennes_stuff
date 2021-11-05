(* remplacer par votre type *)
type 'a arbin = LEAF of 'a | NODE of ('a arbin) * 'a * ('a arbin)

let feuille v = LEAF v;; 
let noeud v g d = NODE (g, v, d);;

let rec compter a = match a with 
  | LEAF v -> 1
  | NODE (g, v, d) -> (compter g) + (compter d);;

(* TEST *)
(* ceci doit retourner 3 *)
let arbre_test = noeud 12 (feuille 5) (noeud 7 (feuille 6) (feuille 8));;
let _ = compter arbre_test;;
(* END TEST *)

let rec to_list a = match a with
  | LEAF v -> [v]
  | NODE (g, v, d) -> (to_list g) @ (v::(to_list d));;


(* TEST *)
(* ceci doit retourner [5; 12; 6; 7; 8] *)
let _ = to_list arbre_test;;
(* END TEST *)

let rec constr l = 
  let rec split l v (s, g) = match l with 
    | [] -> (s, g)
    | a::reste -> if a < v then split reste v (a::s, g) else split reste v (s, a::g)
  in match l with
  | [] -> feuille "Nil"
  | a::reste -> let (smaller, greater) = split reste a ([], []) 
      in noeud a (constr smaller) (constr greater);;

(* TEST *)
(* Ceci doit retourner true *)
let l = ["celeri";"orge";"mais";"ble";"tomate"; "soja"; "poisson"];;
let _ = List.filter (fun s -> s <> "Nil") (to_list (constr l)) = List.sort compare l;;
(* END TEST *)

type coord = int * int;;
type 'a arbinp = (coord * 'a) arbin;;
let d = 5;;
let e = 4;;

let placer a = 
  let rec placer_rec a xoff yoff = match a with 
    | LEAF v -> (feuille ((xoff, yoff), v), xoff+e)
    | NODE (l, v, r) -> let (left, lx) = placer_rec l xoff (yoff+d) 
        in let (right, rx) = placer_rec r (lx+e) (yoff+d)
        in (noeud ((lx, yoff), v) left right,rx)
  in let (res, xoff) = placer_rec a e d
  in res;;

let t =
  noeud 'a'
    (feuille 'j')
    (noeud 'b'
       (noeud 'c'
          (noeud 'd' (feuille 'w') (feuille 'k'))
          (feuille 'z'))
       (feuille 'y'));;

(* Pour tester *)
let res = placer t;;

(* TEST *)
(* Ceci doit retourner true *)
let res = (placer t = noeud ((8, 5), 'a')
             (feuille ((4, 10), 'j'))
             (noeud ((32, 10), 'b')
                (noeud ((24, 15), 'c')
                   (noeud ((16, 20), 'd') (feuille ((12, 25), 'w')) (feuille ((20, 25), 'k')))
                   (feuille ((28, 20), 'z')))
                (feuille ((36, 15), 'y'))));;
(* END TEST *)
