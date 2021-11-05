/**
TP Base Menu

@author Prenom1 NOM1
@author Prenom2 NOM2
@version Annee scolaire 20__/20__
*/

% Tests

tests :-
	test_plat,
	test_repas,
	test_plat200_400,
	test_plat_bar,
	test_val_cal,
	test_repas_eq.

test_plat :-
	test( plat(grillade_de_boeuf) ),
	test( plat(saumon_oseille) ),
	test( not plat(artichauts_Melanie) ),
	test( not plat(sorbet_aux_poires) ).

test_repas :-
	test( repas(cresson_oeuf_poche, poulet_au_tilleul, fraises_chantilly) ),
	test( not repas(melon_en_surprise, poulet_au_tilleul, fraises_chantilly) ).

test_plat200_400 :-
	test( sortedof(P, plat200_400(P), [bar_aux_algues, poulet_au_tilleul, saumon_oseille]) ).

test_plat_bar :-
	test( sortedof(P, plat_bar(P), [grillade_de_boeuf, poulet_au_tilleul]) ).

test_val_cal :-
	test( val_cal(cresson_oeuf_poche, poulet_au_tilleul, fraises_chantilly, 901) ),
	test( not val_cal(truffes_sous_le_sel, grillade_de_boeuf, sorbet_aux_poires, 901) ).

test_repas_eq :-
	test( repas_eq(artichauts_Melanie, saumon_oseille, fraises_chantilly) ),
	test( not repas_eq(truffes_sous_le_sel, grillade_de_boeuf, sorbet_aux_poires) ).

sortedof(Term, Goal, SortedList) :-
	findall(Term, Goal, List),
	msort(List, SortedList).

test(P) :- P, !, printf("OK %w \n", [P]).
test(P) :- printf("echec %w \n", [P]), fail.

% Fin des tests.


hors_d_oeuvre(artichauts_Melanie).
hors_d_oeuvre(truffes_sous_le_sel).
hors_d_oeuvre(cresson_oeuf_poche).

viande(grillade_de_boeuf).
viande(poulet_au_tilleul).

poisson(bar_aux_algues).
poisson(saumon_oseille).

dessert(sorbet_aux_poires).
dessert(fraises_chantilly).
dessert(melon_en_surprise).

calories(artichauts_Melanie, 150).
calories(truffes_sous_le_sel, 202).
calories(cresson_oeuf_poche, 212).
calories(grillade_de_boeuf, 532).
calories(poulet_au_tilleul, 400).
calories(bar_aux_algues, 292).
calories(saumon_oseille, 254).
calories(sorbet_aux_poires, 223).
calories(fraises_chantilly, 289).
calories(melon_en_surprise, 122).

?- hors_d_oeuvre(X).
?- viande(X).
?- poisson(X).
?- dessert(X).
?- calories(X, Y).

plat(X) :- viande(X).
plat(X) :- poisson(X).

repas(X,Y,Z) :-
	hors_d_oeuvre(X),
	plat(Y),
	dessert(Z).

plat200_400(X) :-
	plat(X),
	calories(X, C),
	C =< 400,
	C >= 200.

plat_bar(X) :- 
	plat(X),
	calories(X, C1),
	calories(bar_aux_algues, C2),
	C1 > C2.

val_cal(X, Y, Z, C) :- 
	repas(X,Y,Z),
	calories(X, C1),
	calories(Y, C2),
	calories(Z, C3),
	C is C1 + C2 + C3.

repas_eq(X, Y, Z) :-
	val_cal(X, Y, Z, C),
	C < 800.