type coul = Coeur | Trefle | Pique | Carreau;;
type haut = Sept | Huit | Neuf | Dix | Valet | Dame | Roi | As;;
type carte = Carte of (haut * coul);;

let coul c = match c with | Carte(_, coul) -> coul;;
let haut c = match c with | Carte(haut, _) -> haut;;

let haut_of_int i = match i with
  | 7 -> Sept
  | 8 -> Huit
  | 9 -> Neuf
  | 10 -> Dix
  | 11 -> Valet
  | 12 -> Dame
  | 13 -> Roi
  | 14 -> As
  | _ -> failwith "Le numéro de la carte doit être compris entre 7 et 14";;

(* TEST *)
(* doit retourner Dame *)
let _ = haut_of_int 12;;
(* END TEST *)

let coul_of_string s = match s with
  | "Coeur" -> Coeur
  | "Trefle" -> Trefle
  | "Pique" -> Pique
  | "Carreau" -> Carreau
  | _ -> failwith "Non mais en fait je t'explique, la couleur des cartes c'est 'Pique', 'Coeur', ... Je m'en fiche de savoir si elle est rouge";;

(* TEST *)
(* doit retourner Pique *)
let _ = coul_of_string "Pique";;
(* END TEST *)

let carte i s = Carte((haut_of_int i), (coul_of_string s));;
(* TEST *)
(* ces tests doivent retourner true *)
let _ = (haut (carte 8 "Trefle")) = Huit;;
let _ = (coul (carte 14 "Trefle")) = Trefle;;
(* END TEST *)

let string_of_carte c = 
  let (coul, haut) = match c with | Carte(haut, coul) -> (coul, haut) in
  let coul_s = match coul with 
    | Coeur -> "Coeur"
	| Trefle -> "Trefle"
	| Pique -> "Pique"
	| Carreau -> "Carreau"
  in let haut_s = match haut with
	| Sept -> "7"
	| Huit -> "8"
	| Neuf -> "9"
	| Dix -> "10"
	| Valet -> "Valet"
	| Dame -> "Dame"
	| Roi -> "Roi"
	| As -> "As"
  in haut_s ^ " de " ^ coul_s;;

(* TEST *)
(* ceci doit retourner la chaîne "Valet de Pique" *)
let res = string_of_carte (carte 11 "Pique");;

(* ceci doit retourner la chaîne "9 de Trefle" *)
let res = string_of_carte (carte 9 "Trefle");;
(* END TEST *)

(*Random.int bound returns a random integer between 0 (inclusive) and bound (exclusive)*)
let random_carte () = 
  let (i, coul) = (7 + Random.int 8, Random.int 4) in
  let coul_s = match coul with 
    | 0 -> "Coeur"
	| 1 -> "Trefle"
	| 2 -> "Pique"
	| 3 -> "Carreau"
	| _ -> failwith "How could this even happen ?"
  in carte i coul_s;;

let rec ajtcarte l = let c = random_carte () in 
  if List.exists (fun x -> x = c) l 
    then ajtcarte l
    else c::l;;

(* TEST *)
(* ceci doit retourner true *)
let res =
  let l1 = ajtcarte [] in
  let l2 = ajtcarte l1 in
  match l1,l2 with
  | [c],[c1; c2] -> c = c2 && c1 <> c2
  | _ -> false;;
(* END TEST *)

let rec faitjeu n = 
  if n > 32 then failwith "Et je fais comment moi ?"
  else if n > 0 then ajtcarte (faitjeu (n-1))
  else [];;

let rec reduc l = 
  let canfold (c1, c2) = match (c1, c2) with
    | (Carte (h1, cl1), Carte (h2, cl2)) -> (h1 = h2 || cl1 = cl2)
  in let canfoldlists (l1, l2) = match (l1, l2) with
       | (c1::r1, c2::r2) -> canfold (c1, c2)
       | _ -> failwith "No empty stacks allowed here" 
  in match l with 
    | a::b::c::reste -> if canfoldlists (a, c) then (b@a)::c::reste else a::(reduc (b::c::reste))
    | _ -> l;;

let p1 = [carte 14 "Trefle";  carte 10 "Coeur" ];;
let p2 = [carte 7 "Pique";    carte 11 "Carreau" ];;
let p3 = [carte 14 "Carreau"; carte 8 "Pique" ];;
let p4 = [carte 7 "Carreau";  carte 10 "Trefle" ];;

let p'1 = p2@p1;;

(* TEST *)
(* ceci doit retourner true *)
let _ = (reduc [p1; p2; p3; p4]) = [p'1; p3; p4];;
(* END TEST *)

let rec reussite l = let li = reduc l in if li = l then l else reussite li;;

let p''1 = p3@p'1;;
(* TEST *)
(* ceci doit retourner true *)
let res = (reussite [p1; p2; p3; p4]) = [p''1; p4];;
(* END TEST *)

(* Copiez la ligne suivante (avec le #) dans le toplevel (fenêtre du bas) et
   tapez Entrée
#load "graphics.cma";;
*)
open Graphics

let b = white
let n = black
let r = red

let carr   = [| [|b;b;b;b;b;r;b;b;b;b;b|];
                [|b;b;b;b;r;r;r;b;b;b;b|];
                [|b;b;b;r;r;r;r;r;b;b;b|];
                [|b;b;r;r;r;r;r;r;r;b;b|];
                [|b;r;r;r;r;r;r;r;r;r;b|];
                [|b;b;r;r;r;r;r;r;r;b;b|];
                [|b;b;b;r;r;r;r;r;b;b;b|];
                [|b;b;b;b;r;r;r;b;b;b;b|];
                [|b;b;b;b;b;r;b;b;b;b;b|] |]

let tref   = [| [|b;b;b;b;b;n;n;b;b;b;b|];
                [|b;b;b;b;n;n;n;n;b;b;b|];
                [|b;b;b;b;n;n;n;n;b;b;b|];
                [|b;b;n;n;b;n;n;b;n;n;b|];
                [|b;n;n;n;n;n;n;n;n;n;n|];
                [|b;n;n;n;n;n;n;n;n;n;n|];
                [|b;b;n;n;b;n;n;b;n;n;b|];
                [|b;b;b;b;b;n;n;b;b;b;b|];
                [|b;b;b;b;n;n;n;n;b;b;b|] |]

let coeu   = [| [|b;b;r;r;b;b;b;r;r;b;b|];
                [|b;r;r;r;r;b;r;r;r;r;b|];
                [|b;r;r;r;r;r;r;r;r;r;b|];
                [|b;r;r;r;r;r;r;r;r;r;b|];
                [|b;b;r;r;r;r;r;r;r;b;b|];
                [|b;b;b;r;r;r;r;r;b;b;b|];
                [|b;b;b;b;r;r;r;b;b;b;b|];
                [|b;b;b;b;b;r;b;b;b;b;b|];
                [|b;b;b;b;b;r;b;b;b;b;b|] |]


let piqu   = [| [|b;b;b;b;b;n;b;b;b;b;b|];
                [|b;b;b;b;b;n;b;b;b;b;b|];
                [|b;b;b;b;n;n;n;b;b;b;b|];
                [|b;b;n;n;n;n;n;n;n;b;b|];
                [|b;n;n;n;n;n;n;n;n;n;b|];
                [|b;n;n;n;n;n;n;n;n;n;b|];
                [|b;n;n;n;b;n;b;n;n;n;b|];
                [|b;b;b;b;b;n;b;b;b;b;b|];
                [|b;b;b;b;n;n;n;b;b;b;b|] |]

let draw_haut h = match h with
  | Sept -> draw_string " 7"
  | Huit -> draw_string " 8"
  | Neuf -> draw_string " 9"
  | Dix -> draw_string "10"
  | Valet -> draw_string " V"
  | Dame -> draw_string " D"
  | Roi -> draw_string " R"
  | As -> draw_string " A"

let draw_coul c l coul = match coul with
  | Carreau -> draw_image (make_image carr) c (l+2)
  | Trefle -> draw_image (make_image tref) c (l+2)
  | Coeur -> draw_image (make_image coeu) c (l+2)
  | Pique -> draw_image (make_image piqu) c (l+2)

let draw_carte ca =
  let (c,l) = current_point() in
  draw_haut (haut ca); draw_coul (c+12) l (coul ca); moveto c (l+14)

let draw_pile li =
  let (x, y) = current_point() in
  let rec pile_rec li yoff = 
      match li with 
      | [] -> ()
      | ca::reste -> let _ = moveto x yoff
          in let _ = draw_carte ca
          in pile_rec reste (yoff - 20)
  in let _ = pile_rec li (20*(List.length li) - 20) in moveto (x+30) y;;

(* TEST *)
let () = Graphics.open_graph "";;
let _ = draw_pile p''1;;
let _ = draw_pile p''1;;
let () = Graphics.close_graph ();;
(* END TEST *)

let draw_jeu j = clear_graph (); moveto 5 5; 
  let rec darw_rec l = let (x, y) = current_point() in
    match l with 
    | [] -> ()
    | p::reste -> let _ = draw_pile p in darw_rec reste
  in darw_rec j;;


let rec convert_list li = match li with
  | [] -> []
  | a::reste -> [a]::(convert_list reste);;


(*Attention, peut provoquer des segfault d'OCaml, aucune idée de pourquoi*)
(*Marche à tous les coups si on fait : 
 - Ctrl+x, Ctrl+e sur une instruction, n'importe laquelle
 - Coller #load "graphics.cma";; dans la console
 - Ctrl+c, Ctrl+b*)
let draw_reussite () = let _ = open_graph "" in let j = convert_list (faitjeu 32) in let _ = draw_jeu j in 
  let rec reussite_rec jeu = 
    let next_game = reduc jeu in let k = read_key () in
      if k != 'q' then let _ = draw_jeu next_game in reussite_rec next_game
      else close_graph ()
  in reussite_rec j;;

(* TEST *)
let res = draw_reussite ();;
(* END TEST *)
