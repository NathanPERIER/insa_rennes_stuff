1.	On n'observe rien car la division par zéro est un [comportement non défini](https://port70.net/%7Ensz/c/c11/n1570.html#6.5.5p5)
```
The result of the / operator is the quotient from the division of the first operand by the second; the result of the % operator is the remainder. In both operations, if the value of the second operand is zero, the behavior is undefined.
```
	On utilise `gcc` qui ignore l'opération de division quand il détecte un zéro au numérateur lors de la compilation, il ne se passe donc rien. Avec `clang`, on observe bien que le signal est levé.
	Si on décommente la ligne, le programme affiche le message en boucle.

2.	Cf. `signal.c`

3.	Cf. `printstuff.c`

4.	Cf. `printstuff.c`

5.	Cf. `longprog.c`
	Test avec `kill -s USR1 <pid>`

6.	Cf. `transfersig.c`
	Environ un signal reçu pour 30 signaux envoyés

7.	Cf. `transfersig.c`
	Signal est bloqué pendant l'exécution du handler (-> envoyés trop rapidement)
	Ajouter un `sleep` pour aller moins vite

8.	Cf. `transferkill.c`

