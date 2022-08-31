1.	`gcc -o pid pid.c`
	On observe que le programme se lance, crée un fils (fork) et affiche son PID et celui de son fils, le fils affiche son PID et celui de son père (getppid)

2.	On en conclut que le PID du fils n'est pas nécessairement le PID du père +1. Le PID du père est celui du shell, ici `fish`.

3.	Il lance `xed` (en théorie `gedit` mais je n'ai pas `gedit`), ensuite le process meurt et son process fils est récupéré par le process parent qui est le shell.

4.	Il y a deux process : 
```
   8674 pts/0    00:00:04 exec2
   8675 pts/0    00:00:00 exec2 <defunct>
```
	le fils a terminé mais il est en état zombie car le père n'a pas pris connaissance de sa mort.

5.	Ne fonctionne pas très bien car java est lent.

6.	Le fils prend un peu de temps à se lancer, puis les affichages du fils et du père s'alternent car les deux process s'exécutent en parallèle et le fils finit ses affichages.

7.	Avec le sleep, les deux lignes du père et du fils arrivent toutes les trois secondes mais pas toujours dans le même ordre, on peut en conclure que l'ordonnanceur ne priorise pas l'un par rapport à l'autre.

9.	Marche pareil, juste plus lent.

10.	Père : 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
	Fils : 1, 0, -1, -2, -3, -4, -5, -6, -7, -8, -9, -10
	La variable `i` est propre à chaque process

11.	L'objet `o` de type `VarObjet` est accessible par plusieurs thread, l'un qui lui affecte des valeurs allant de 10 à 0, l'autre qui lui affecte des valeurs allant de 0 à 10 d'où l'affichage suivant :
```
-10
-10
0
9
1
8
2
7
3
3
4
4
5
5
6
6
7
7
8
8
```


