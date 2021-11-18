1.	Sans la ligne, n'affiche pas le retour du GPU car le programme se termine avant que le GPU ait fini.
	Avec la ligne, on attend la fin des threads sur le GPU et donc on voit l'affichage

3.	Nombre de coeurs : 384
	Fréquence d'un coeur : 1124 MHz

	GPU : 
	 - Simple précision : 2        2 * 1124e6 * 384 = 863  Gflops
	 - Double précision : 1/16  1/16 * 1124e6 * 384 = 26.9 Gflops
	
	CPU :
	 - Simple précision : 32 * 3.1e9 * 6 = 595 Gflops
	 - Double précision : 16 * 3.1e9 * 6 = 297 Gflops

4.  ...
| Image      | CPU    | GPU    |
|------------|--------|--------|
| castel     | 25.481 | 15.534 |
| landscape1 | 2.922  | 1.907  |
| landscape2 | 0.822  | 0.783  |
| Lenna      | 1.313  | 0.910  |


