
1.	On observe que le message "1 - etape 0" est affiché à certaines exécutions mais pas à d'autres, ceci est dû au fait que le programme principal n'attend pas que les threads aient fini de s'exécuter avant de se terminer (ce qui tue les threads avant qu'ils n'aient fini leur affichage).


2.	Mesuré avec la commande time :

| Threads | Temps d'exécution |
|---------|-------------------|
| 1       | 789.20 ms         |
| 2       | 426.84 ms         |
| 3       | 305.07 ms         |
| 4       | 236.94 ms         |
| 5       | 276.78 ms         |

	On n'a que 4 coeurs donc on peut penser que le test avec 5 workers prend plus de temps car deux threads sont en concurrence sur le même coeur.


3.	TODO
