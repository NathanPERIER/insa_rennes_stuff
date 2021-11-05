(* TP1. Nathan PERIER *)

(* Compl�ter, en enlevant le "failwith" et tout ce qui suit et en mettant votre code.
   �valuer ensuite avec ctrl-x crtl-e *)
let mul2 = fun x -> 2*x;;

(* Tester, en faisant ctrl-x ctrl-e sur la phrase de "mul2" et sur la phrase suivante *)
(* La valeur attendue est indiqu�e en commentaire *)
(* TEST *)
let _ = mul2 21;; (* 42 *)
(* END TEST *)

(* Compl�ter *)
let vabs = fun x -> if x < 0 then -1 * x else x;;

(* TEST *)
let _ = vabs (-5);; (* 5 *)
let _ = vabs 12;; (* 12 *)
(* END TEST *)

(* Compl�ter *)
let test1 = fun n -> n >= 12 && n <= 29;;

(* TEST *)
let _ = test1 25;; (* true *)
let _ = test1 (-8);; (* false *)
(* END TEST *)

(* Compl�ter *)
let test2 = fun n -> match n with
  | 2 -> true
  | 5 -> true
  | 9 -> true
  | 53 -> true
  | _ -> false;;

(* TEST *)
let _ = test2 5;; (* true *)
let _ = test2 6;; (* false *)
(* END TEST *)

(* Compl�ter *)
let test3 = fun (x, y) -> x == 12;;

(* TEST *)
let _ = test3 (12,"foo");; (* true *)
let _ = test3 (12,42);; (* true *)
let _ = test3 (13,true);; (* false *)
(* END TEST *)

(* Compl�ter *)
let bissext = fun y -> if y mod 4 == 0 && (y mod 100 != 0 || y mod 400 == 0) then true else false;;

(* TEST *)
let _ = bissext 2000;; (* true *)
let _ = bissext 1900;; (* false *)
let _ = bissext 2016;; (* true *)
let _ = bissext 2017;; (* false *)
(* END TEST *)

(* Compl�ter *)
let proj1 = fun (x, y, z) -> x;;
let proj23 = fun (x, y, z) -> (y, z);;

(* TEST *)
let _ = proj1 (1,"foo",true);; (* 1 *)
let _ = proj23 (1,"foo",true);; (* ("foo",true) *)
(* END TEST *)

(* Compl�ter *)
let inv2 = fun ((x1, y1), (x2, y2)) -> (y2, x2);;

(* TEST *)
let _ = inv2 ((true,'a'),(1,"un"));; (* ("un",1) *)
(* END TEST *)

(* Compl�ter *)
let incrpaire = fun (x, y) -> (x+1, y+1);;

(* TEST *)
let _ = incrpaire (12,42);; (* (13,43) *)
(* END TEST *)

(* Compl�ter *)
let appliquepaire = fun f (x, y) -> (f x, f y);;

(* TEST *)
let _ = appliquepaire (fun x -> not x) (false,true);; (* (true,false) *)
(* END TEST *)

(* Compl�ter *)
let incrpaire2 = fun (x, y) -> appliquepaire (fun z -> z+1) (x, y);;

(* TEST *)
let _ = incrpaire2 (4,18);; (* (5,19) *)
(* END TEST *)

(* Compl�ter *)
let rapport = fun (f, g) x -> (f x) /. (g x);;

(* TEST *)
let _ = rapport ((fun x -> x +. 1.), (fun x -> x -. 1.)) 2.;; (* 3. *)
(* END TEST *)

let _ = cos 2.0;; (*Type de cos : float*)
let _ = sin 2.0;; (*Type de sin : float*)

(* Compl�ter *)
let mytan = fun x -> rapport ((fun x -> sin x), (fun x -> cos x)) x;;

(* TEST *)
let _ = mytan 0.;; (* 0. *)
(* END TEST *)

(* Compl�ter *)
let premier = fun x -> let rec multiplerec = fun x i -> if x == i then true else if x mod i == 0 then false else multiplerec x (i+1) in if x < 2 then false else multiplerec x 2;;

(* TEST *)
let _ = premier 1;; (* false *)
let _ = premier 2;; (* true *)
let _ = premier 6;; (* false *)
let _ = premier 13;; (* true *)
(* END TEST *)

(* Compl�ter *)
let n_premier = fun n -> let rec findrec = fun x i -> if premier x then if n == (i+1) then x else findrec (x+1) (i+1) else findrec (x+1) i in findrec 2 0;;

(* TEST *)
let _ = n_premier 10;; (* 29 *)
(* END TEST *)
