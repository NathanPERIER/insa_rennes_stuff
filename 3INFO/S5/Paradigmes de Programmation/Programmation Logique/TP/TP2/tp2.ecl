% TP2 TERMES CONSTRUITS - A compléter et faire tourner sous Eclipse Prolog
% ==============================================================================
% ============================================================================== 
%	FAITS
% ============================================================================== 
/*
	hauteur(Valeur)
*/

test :-
    test_est_carte,
    test_est_main,
    test_inf_carte,
    test_est_main_triee,
    test_une_paire,
    test_deux_paires,
    test_brelan,
    test_suite,
    test_full.

test_tmp_carte(Y) :-
    carte_test(_,Y),
    est_carte(Y).

test_est_carte :-
    findall(Y,test_tmp_carte(Y),LY),
    test(length(LY,2)). 

  % Prédicat permettant de récupérer toutes les mains définies dans la base de faits
test_tmp_est_main(Y):-
  main_test(_,Y),est_main(Y).
  
  % Prédicat vérifiant que 8 mains ont bien été récupérées
test_est_main :-
  findall(X,test_tmp_est_main(X),LX),
  test(length(LX,8)).

test_inf_carte :-
    test(inf_carte(carte(quatre, pique),carte(cinq,coeur))),
    test(inf_carte(carte(quatre, coeur),carte(cinq,coeur))),
    test(inf_carte(carte(quatre, carreau),carte(cinq,coeur))),
    test(inf_carte(carte(quatre, trefle),carte(cinq,coeur))),
    test(inf_carte(carte(cinq,trefle),carte(cinq,coeur))),
    findall(Y,inf_carte(carte(cinq,Y),carte(cinq,coeur)),LY),
    test(length(LY,2)). 
  
test_tmp_m2_triee(X):-
    main_test(m2,X),
    est_main_triee(X).

test_est_main_triee :-
	main_test(main_triee_une_paire,Y),test(est_main_triee(Y)),
        main_test(main_triee_deux_paires,Z),test(est_main_triee(Z)),
	findall(X,test_tmp_m2_triee(X),LX),test(length(LX,2)). 
  
test_tmp_deux_paires(Main):-
    main_test(_,Main),deux_paires(Main).

test_deux_paires:-
    findall(Y,test_tmp_deux_paires(Y),LY),test(length(LY,3)). 

test_tmp_une_paire(Main):-
    main_test(_,Main),une_paire(Main).

test_une_paire:-
    findall(Y,test_tmp_une_paire(Y),LY),test(length(LY,10)).

test_tmp_brelan(Main):-
    main_test(_,Main),brelan(Main).

test_brelan:-
    findall(Y,test_tmp_brelan(Y),LY),test(length(LY,2)).

test_tmp_suite(Main):-
    main_test(_,Main),suite(Main).

test_suite:-
    findall(Y,test_tmp_suite(Y),LY),test(length(LY,1)).

test_tmp_full(Main):-
    main_test(_,Main),full(Main).

test_full:-
  findall(Y,test_tmp_full(Y),LY),test(length(LY,1)).

test(P) :- P, !, printf("OK %w \n", [P]).
test(P) :- printf("echec %w \n", [P]), fail.

  
hauteur(deux).
hauteur(trois).
hauteur(quatre).
hauteur(cinq).
hauteur(six).
hauteur(sept).
hauteur(huit).
hauteur(neuf).
hauteur(dix).
hauteur(valet).
hauteur(dame).
hauteur(roi).
hauteur(as).

/*
	couleur(Valeur)
*/
couleur(trefle).
couleur(carreau).
couleur(coeur).
couleur(pique).

/*
	succ_hauteur(H1, H2)
*/
succ_hauteur(deux, trois).
succ_hauteur(trois, quatre).
succ_hauteur(quatre, cinq).
succ_hauteur(cinq, six).
succ_hauteur(six, sept).
succ_hauteur(sept, huit).
succ_hauteur(huit, neuf).
succ_hauteur(neuf, dix).
succ_hauteur(dix, valet).
succ_hauteur(valet, dame).
succ_hauteur(dame, roi).
succ_hauteur(roi, as).

/*
	succ_couleur(C1, C2)
*/
succ_couleur(trefle, carreau).
succ_couleur(carreau, coeur).
succ_couleur(coeur, pique).

/*
  carte_test
  cartes pour tester le prédicat EST_CARTE
*/

/*
test :-
    test_est_carte,
    test_est_main,
    test_inf_carte,
    test_est_main_triee,
    test_une_paire,
    test_deux_paires,
    test_brelan,
    test_suite,
    test_full.

test_tmp_carte(Y) :-
    carte_test(_,Y),
    est_carte(Y).

test_est_carte :-
    findall(Y,test_tmp_carte(Y),LY),
    length(LY,2). 

test_tmp_est_main(Y):-
     main_test(_,Y),est_main(Y).

test_est_main :-
		findall(X,test_tmp_est_main(X),LX),length(LX,8).

test_inf_carte :-
    inf_carte(carte(quatre, pique),carte(cinq,coeur)),
    inf_carte(carte(quatre, coeur),carte(cinq,coeur)),
    inf_carte(carte(quatre, carreau),carte(cinq,coeur)),
    inf_carte(carte(quatre, trefle),carte(cinq,coeur)),
    inf_carte(carte(cinq,trefle),carte(cinq,coeur)),
    findall(Y,inf_carte(carte(cinq,Y),carte(cinq,coeur)),LY),
    length(LY,2). 


test_tmp_m2_triee(X):-
    main_test(m2,X),
    est_main_triee(X).

test_est_main_triee :-
	main_test(main_triee_une_paire,Y),est_main_triee(Y),
    main_test(main_triee_deux_paires,Z),est_main_triee(Z),
	findall(X,test_tmp_m2_triee(X),LX),length(LX,2). 

test_tmp_deux_paires(Main):-
    main_test(_,Main),deux_paires(Main).

test_deux_paires:-
    findall(Y,test_tmp_deux_paires(Y),LY),length(LY,3). 

test_tmp_une_paire(Main):-
    main_test(_,Main),une_paire(Main).

test_une_paire:-
    findall(Y,test_tmp_une_paire(Y),LY),length(LY,10).

test_tmp_brelan(Main):-
    main_test(_,Main),brelan(Main).

test_brelan:-
    findall(Y3(_,Main),suite(Main).

test_suite:-
    findall(Y,test_tmp_suite(Y),LY),length(LY,1).

test_tmp_full(Main):-
    main_test(_,Main),full(Main).

test_full:-
    findall(Y,test_tmp_full(Y),LY),length(LY,1).
    
    
*/


carte_test(c1,carte(sept,trefle)).
carte_test(c2,carte(neuf,carreau)).
carte_test(ce1,carte(7,trefle)).
carte_test(ce2,carte(sept,t)).

/* 
	main_test(NumeroTest, Main) 
	mains pour tester le prédicat EST_MAIN 
*/

main_test(main_triee_une_paire, main(carte(sept,trefle), carte(valet,coeur), carte(dame,carreau), carte(dame,pique), carte(roi,pique))).
% attention ici m2 représente un ensemble de mains	 
main_test(m2, main(carte(valet,_), carte(valet,coeur), carte(dame,carreau), carte(roi,coeur), carte(as,pique))).
main_test(main_triee_deux_paires, main(carte(valet,trefle), carte(valet,coeur), carte(dame,carreau), carte(roi,coeur), carte(roi,pique))).
main_test(main_triee_brelan, main(carte(sept,trefle), carte(dame,carreau), carte(dame,coeur), carte(dame,pique), carte(roi,pique))).	
main_test(main_triee_suite,main(carte(sept,trefle),carte(huit,pique),carte(neuf,coeur),carte(dix,carreau),carte(valet,carreau))).
main_test(main_triee_full,main(carte(deux,coeur),carte(deux,pique),carte(quatre,trefle),carte(quatre,coeur),carte(quatre,pique))).

main_test(merreur1, main(carte(sep,trefle), carte(sept,coeur), carte(dame,pique), carte(as,trefle), carte(as,pique))).
main_test(merreur2, main(carte(sep,trefle), carte(sept,coeur), carte(dame,pique), carte(as,trefle))).

% ============================================================================= 
%        QUESTION 1 : est_carte(carte(Hauteur,Couleur))
% ==============================================================================

est_carte(carte(H,C)) :-
	hauteur(H),
	couleur(C).

% ==============================================================================
%	QUESTION 2 : est_main(main(C1,C2,C3,C4,C5))
% ============================================================================== 

est_main(main(C1,C2,C3,C4,C5)) :- 
	est_carte(C1),
	est_carte(C2), \==(C1,C2),
	est_carte(C3), \==(C1,C3), \==(C2,C3),
	est_carte(C4), \==(C1,C4), \==(C2,C4), \==(C3,C4),
	est_carte(C5), \==(C4,C5), \==(C4,C5), \==(C4,C5), \==(C4,C5).

% ============================================================================= 
%       QUESTION 3
% ============================================================================= 

% trefle < carreau < coeur < pique

inf_coul(C1, C2) :-
	couleur(C1),
	couleur(C2),
	succ_couleur(C1, C2).
inf_coul(C1, C2) :-
	couleur(C1),
	couleur(C2),
	succ_couleur(C1, C),
	inf_coul(C, C2).

inf_haut(H1, H2) :-
	hauteur(H1),
	hauteur(H2),
	succ_hauteur(H1, H2).
inf_haut(H1, H2) :-
	hauteur(H1),
	hauteur(H2),
	succ_hauteur(H1, H),
	inf_haut(H, H2).

inf_carte(carte(H, C1), carte(H, C2)) :-
	est_carte(carte(H, C1)), 
	est_carte(carte(H, C2)), 
	inf_coul(C1, C2).
inf_carte(carte(H1, C1), carte(H2, C2)) :-
	\==(H1, H2),
	est_carte(carte(H1, C1)), 
	est_carte(carte(H2, C2)), 
	inf_haut(H1, H2).

?- inf_carte(C, carte(cinq, coeur)).

% ============================================================================= 
%       QUESTION 4 : est_main_triee(main(C1,C2,C3,C4,C5))
% ============================================================================= 

est_main_triee(main(C1,C2,C3,C4,C5)) :-
	est_main(main(C1,C2,C3,C4,C5)),
	inf_carte(C1, C2),
	inf_carte(C2, C3),
	inf_carte(C3, C4),
	inf_carte(C4, C5).

% ============================================================================= 
%       QUESTION 5 : une_paire(main(C1,C2,C3,C4,C5))
% ============================================================================== 

meme_hauteur(carte(H, C1), carte(H, C2)) :-
	est_carte(carte(H, C1)), 
	est_carte(carte(H, C2)).

une_paire(main(C1,C2,C3,C4,C5)) :- 
	est_main_triee(main(C1,C2,C3,C4,C5)),
	meme_hauteur(C1, C2).
une_paire(main(C1,C2,C3,C4,C5)) :- 
	est_main_triee(main(C1,C2,C3,C4,C5)),
	meme_hauteur(C2, C3).
une_paire(main(C1,C2,C3,C4,C5)) :- 
	est_main_triee(main(C1,C2,C3,C4,C5)),
	meme_hauteur(C3, C4).
une_paire(main(C1,C2,C3,C4,C5)) :- 
	est_main_triee(main(C1,C2,C3,C4,C5)),
	meme_hauteur(C4, C5).

% ============================================================================= 
%       QUESTION 6 : deux_paires(main(C1,C2,C3,C4,C5))
% ============================================================================= 
 
deux_paires(main(C1,C2,C3,C4,C5)) :- 
	est_main_triee(main(C1,C2,C3,C4,C5)),
	meme_hauteur(C1, C2),
	meme_hauteur(C4, C5).

deux_paires(main(C1,C2,C3,C4,C5)) :- 
	est_main_triee(main(C1,C2,C3,C4,C5)),
	meme_hauteur(C1, C2),
	meme_hauteur(C3, C4).

deux_paires(main(C1,C2,C3,C4,C5)) :- 
	est_main_triee(main(C1,C2,C3,C4,C5)),
	meme_hauteur(C2, C3),
	meme_hauteur(C4, C5).
             
% ==============================================================================
%       QUESTION 7 : brelan(main(C1,C2,C3,C4,C5))
% ==============================================================================

brelan(main(C1,C2,C3,C4,C5)) :- 
	est_main_triee(main(C1,C2,C3,C4,C5)),
	meme_hauteur(C1, C2),
	meme_hauteur(C2, C3).

brelan(main(C1,C2,C3,C4,C5)) :- 
	est_main_triee(main(C1,C2,C3,C4,C5)),
	meme_hauteur(C2, C3),
	meme_hauteur(C3, C4).

brelan(main(C1,C2,C3,C4,C5)) :- 
	est_main_triee(main(C1,C2,C3,C4,C5)),
	meme_hauteur(C3, C4),
	meme_hauteur(C4, C5).

% ============================================================================= 
%       QUESTION 8 : suite(main(C1,C2,C3,C4,C5))
% ============================================================================= 

suite(main(carte(H1, C1), carte(H2, C2), carte(H3, C3), carte(H4, C4), carte(H5, C5))) :- 
	est_main_triee(main(carte(H1, C1), carte(H2, C2), carte(H3, C3), carte(H4, C4), carte(H5, C5))),
	succ_hauteur(H1, H2),
	succ_hauteur(H2, H3),
	succ_hauteur(H3, H4),
	succ_hauteur(H4, H5).

% ============================================================================= 
%       QUESTION 9 : full(main(C1,C2,C3,C4,C5))
% =============================================================================

full(main(C1,C2,C3,C4,C5)) :- 
	est_main_triee(main(C1,C2,C3,C4,C5)),
	meme_hauteur(C1, C2),
	meme_hauteur(C2, C3),
	meme_hauteur(C4, C5).

full(main(C1,C2,C3,C4,C5)) :- 
	est_main_triee(main(C1,C2,C3,C4,C5)),
	meme_hauteur(C3, C4),
	meme_hauteur(C4, C5),
	meme_hauteur(C1, C2).

