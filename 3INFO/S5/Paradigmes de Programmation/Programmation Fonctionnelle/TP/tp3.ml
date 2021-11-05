(* TP3. Mettez vos noms ici. *)

(* Remplacer unit par votre définition de type *)
type matrix = { a:float; b:float; c:float; d:float } ;;
type vector = { x:float; y:float } ;;

let mkm a b c d = { a=a; b=b; c=c; d=d } ;;
let mkv x y = { x=x; y=y } ;;

(* let vtop v = match v with | { x; y } -> (x, y);; *)
let vtop { x; y } = (x, y);; (* Plus propre selon moi *)

(* TEST *)
(* doit retourner (1.,2.) *)
let res = vtop (mkv 1. 2.);;
(* END TEST *)

(* let mtop m = match m with | { a; b; c; d } -> ((a, b), (c, d));; *)
let mtop { a; b; c; d } = ((a, b), (c, d));;

(* TEST *)
(* doit retourner ((1.,2.),(3.;4.)) *)
let res = mtop (mkm 1. 2. 3. 4.);;
(* END TEST *)

(* Evaluate me *)
let m1 = mkm 0.0 0.0 0.172 0.496
let m2 = mkm 0.076 0.3122 0.257 0.204
let m3 = mkm 0.821 (-0.028) 0.030 0.845
let m4 = mkm 0.024 (-0.356) 0.323 0.074
let v1 = mkv 0.496 (-0.091)
let v2 = mkv 0.494 0.133
let v3 = mkv 0.088 0.176
let v4 = mkv 0.470 0.260

let mt m v = { x = ((m.a *. v.x) +. (m.b *. v.y)); y = ((m.c *. v.x) +. (m.d *. v.y)) };;

(* TEST *)
(* Le test suivant doit retourner true *)
let res = (mt (mkm 0. 1. (-1.) 0.) (mkv 3. 4.)) = (mkv 4. (-3.));;
(* END TEST *)

let sv v1 v2 = { x = v1.x +. v2.x; y = v1.y +. v2.y };;

(* TEST *)
(* Le test suivant doit retourner true *)
let res = (sv (mkv 1. 2.) (mkv 3. 4.)) = (mkv 4. 6.);;
(* END TEST *)

let genapplin m = fun v -> mt m v;;

(* TEST *)
(* Le test suivant doit retourner true *)
let res = (genapplin (mkm 0. 1. 2. 3.) (mkv 2. 3.)) = (mkv 3. 13.);;
(* END TEST *)

let gentraffine m v = fun u -> sv (genapplin m u) v;;

(* TEST *)
(* Le test suivant doit retourner true *)
let res = (gentraffine (mkm 1. 2. 3. (-1.)) (mkv 1. 2.) (mkv 2. 3.)) = (mkv 9. 5.);;
(* END TEST *)

let les4tr = (gentraffine m1 v1, gentraffine m2 v2, gentraffine m3 v3, gentraffine m4 v4);;

let elemrang (a, b, c, d) = let n = Random.int 4 in match n with 
					| 0 -> a
					| 1 -> b
					| 2 -> c
					| 3 -> d
					| _ -> assert false;;

let traff () = elemrang les4tr;;

let suite n =
  let rec suiterec v i =
    if i >= n
    then v
    else suiterec (traff () v) (i + 1)
  in suiterec (mkv 0.5 0.) 0;;

let identity f x = f x; x;;

let print_suite f n =
  let rec printrec v i =
    if i >= n
    then identity f v
    else printrec (traff (f v) v) (i + 1)
  in printrec (mkv 0.5 0.) 0;;

(* TEST *)
(* Cela devrait imprimer ceci :
   (0.50,0.00)
   (0.50,-0.01)
   (0.50,0.19)
   (0.49,0.35)
   (0.50,0.17)
   (0.49,0.33)
val res : vector = (0.490565619387583918, 0.331221843481839917)
*)
let res =
  let () = Random.init 0 in
  let f v = 
    let (x,y) = vtop v in 
    Printf.printf "(%.2f, %.2f)\n" x y in 
  print_suite f 5;;
(* END TEST *)

(* Copiez la ligne suivante (avec le #) dans le toplevel (fenêtre du bas) et
   tapez Entrée
#load "graphics.cma";;
 *)

let run n =
  Graphics.open_graph "";
  Graphics.set_window_title "Amazing Graph" (* It's not *);
  let _ = print_suite (fun v -> Graphics.plot (int_of_float (400. *. v.x)) (int_of_float (400. *. v.y))) n in
  let _ = Graphics.wait_next_event [Graphics.Key_pressed] in
  Graphics.close_graph () ;;

(* TEST *)
(* je vous laisse la surprise *)
let res = run 10000000;;
(* END TEST *)

