
# CPOO Annale 2020

1.	Les patrons de conception utilisés sont :
     - Builder (L.1-8)
	 - Commande (L.2,3,5)

2.	On ne peut pas poids-moucher des objets mutables car le fait de poids-moucher consiste à faire en sorte de renvoyer toujours le même objet pour une même valeur d'entrée. Par exemple, si on prend l'exemple de la classe `Optional` qui est poids-mouchée et que l'on rajoute une fonction `setValue` pour changer la valeur, on peut faire la chose suivante : `Optional<String> opt = Optional.of("AAA"); opt.setValue(null);`. On a alors créé un objet de type `Optional` vide qui n'est pas `Optional.empty()` (i.e. `!opt.isPresent() && opt != Optional.empty()`). Cela montre bien que le fait de rendre la classe mutable empêche de poids-moucher correctement. 

3.	
```Java
Optional<Bar> getBar(List<Bar> src) {
	return src.stream()
			.filter(bar -> bar.isBabar())
			.findFirst();
}

boolean matchFoo(List<Foo> src) {
	return src.stream()
			.anyMatch(foo -> foo.isFooFoo());
}
```

4.	Observer

6.	Strategy

8.	Les patrons de conception utilisés sont :
     - `R2` : Adapter
	 - `R3` : Poids-mouche (et fabrique)
	 - `R4` : Commande, observer

