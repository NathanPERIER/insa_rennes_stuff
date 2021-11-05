(* TP2. Nathan PERIER *)

(* Compléter *)
let rec pair n = if n == 0 then true else impair (n-1)
and impair n = if n == 0 then false else pair (n-1);;

(* TEST *)
let res = pair 12;;   (* true *)
let res = impair 12;; (* false *)
(* END TEST *)

(* Compléter *)
let rec sigma (a, b) = if a > b then 0 else if a == b then a else (a + b + sigma (a+1, b-1));;

(* TEST *)
(* -2 + (-1 + (0 + (1) + 2) + 3) + 4 *)
let res = sigma (-2,4);; (* 7 *)
(* -1 + ( 0 + (1 + (0) + 2) + 3) + 4 *)
let res = sigma (-1,4);; (* 9 *)
(* END TEST *)

(* Compléter *)
let rec sigma2 f (a, b) = if a > b then 0 else if a == b then f a else (f a + f b + sigma2 f (a+1, b-1));;

(* TEST *)
let res = sigma2 (fun x -> 2 * x) (-2,4);; (* 14 *)
(* END TEST *)

(* Compléter *)
let rec sigma3 f (a,b,i) (fc,acci) = if a > b then acci else sigma3 f (a+i, b, i) (fc, fc (f a) acci);;

(* TEST *)
let res = sigma3 (fun x -> 2 * x) (2,6,2) ((fun v acc -> v + acc),0);; (* 24 *)
(* END TEST *)

(* TEST *)
let res = sigma3 (fun x -> x * x) (0,10,2) ((fun x acc -> x :: acc), []);; (* [100; 64; 36; 16; 4; 0] *)
(* END TEST *)

(* Compléter *)
let rec sigma4 f (p, fi) (fc, acci) a = if p a then acci else sigma4 f (p, fi) (fc, fc (f a) acci) (fi a);;
(* TEST *)
let res = sigma4 (fun x -> 2 * x) ((fun v -> v > 6),(fun v -> v + 2)) ((fun v acc -> v + acc), 0) 2;; (* 24 *)
(* END TEST *)

(* Compléter *)
let cum f (a, b, dx) (fc, vi) = sigma4 f ((fun x -> x > b), (fun x -> x +. dx)) (fc, vi) a;;

(* TEST *)
let res = cum (fun x -> 2. *. x) (0.2,0.7,0.2) ((fun v acc -> v +. acc),0.);; (* 2.4 *)
(* END TEST *)

(* Compléter *)
let integre f (a, b, dx) = cum f (a, b, dx) ((fun v acc -> acc +. v *. dx), 0.);;

(* TEST *)
let res = integre (fun x -> 1. /. x) (1., 2., 0.001);; (* 0.693897243059956925 *)
(* END TEST *)

(* Compléter *)
let rec maxi f (a,b) p = if b -. a < p then f ((a +. b) /. 2.) else if f (a +. p) > f (b -. p) then maxi f (a, b -. p) p else maxi f (a +. p, b) p;; 
      
(* TEST *)
let res = maxi (fun x -> 1. -. x *. x) (0.,2.) 0.0001;; (* 1. *)
(* END TEST *)

(* C'est vraiment pas joli, j'ai essayé de contourner la difficulté qui consiste à avoir les variables x et y qui s'actualisent à chaque appel récursif *)
let montepi = fun n -> let rec recpi = fun n i c x y -> 
		if n == i then c 
		else if x *. x +. y *. y <= 1. 
			then recpi n (i+1) (c+1) (Random.float 1.) (Random.float 1.) 
			else recpi n (i+1) c (Random.float 1.) (Random.float 1.) 
		in (float)(recpi n 0 0 (Random.float 1.) (Random.float 1.)) *. 4. /. (float)n

(* TEST *)
let pi = montepi 1000000;; (* Au moins ça marche, aussi bien que puisse marcher la méthode de Monte Carlo *)
(* END TEST *)
