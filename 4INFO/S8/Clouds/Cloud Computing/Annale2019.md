
# Clouds - Annale 2019

## Question 1

Avantages des clouds privés : 
 - Pas de partage avec d'autres utilisateurs (temps d'attente, ...)
 - On a tout le contrôle sur l'infra

Inconvénients par rapport aux clouds publics :
 - Il faut mettre en place l'infra (techniciens, stockage, ...)
 - Suivant les besoins de l'entreprise, une grande partie des ressources disponibles peut ne pas être utilisée à certains moments

## Question 2

La virtualisation est importante pour le cloud car elle permet de séparer les taĉhes qui tournent dans des machines virtuelles différentes et ainsi contrôler les ressources qui leurs sont attribuées. 

Si on travaille avec des données qui arrivent en continu (e.g. stream processing), la virtualisation permet également de démarrer ou d'arrêter de nouvelles machines virtuelles pour s'adapter à la demande. 

Enfin, cela permet de faire des migrations à chaud où une application qui tourne sur une machine physique est transférée sur une autre machine physique et continue son traitement avec peu ou pas d'effets de bord visibles.

## Question 3

Quand on travaille avec des hyperviseurs de type 2 (s'exécutant en tant que logiciel sur un OS hôte), il faut convertir les syscalls de l'OS invité pour qu'ils soient exécutés par l'OS hôte (interactions avec les périphériques, ...). Le problème est que les syscalls sont utilisés très fréquemment et que donc il y a beaucoup de traduction à faire, ce qui ralentit inévitablement l'OS inivté. 

Les hyperviseurs de type 1 ne sont pas affectés car les machines virtuelles utilisent directement le matériel pour s'exécuter, il n'y a donc pas de traduction de syscalls.

En ce qui concerne les conteneurs, ils ne sont pas affectés non plus car ce sont simplement des ensembles de processus isolés, leur syscalls sont directement exécutés par l'OS.

## Question 4

1. Pour un backend stateless, un serveur physique peut suffire mais l'idéal serait quand même d'utiliser des conteneurs afin de pouvor auto-scale en fonction de la demande.

2. Comme il est nécessaire d'avoir des versions spécifiques de la JVM, on peut utiliser une machine virtuelle avec tous les composants déjà intégrés.

3. Puisque l'application est critique, on peut utiliser des conteneurs pour l'application et la base de données. Cela permettra d'auto-scale et de faire de la migration à chaud très rapidement.

## Question 5

L'"energy proportionality" est une mesure de l'énergie consommée par un serveur en fonction de son utilisation. Idéalement, l'énergie consommée par un serveur serait strictement proportionnelle à son utilisation, et donc il ne consommerait presque rien au repos. On sait cependat que ce n'est pas vrai et un serveur au repose consomme au moins 50% de l'énergie consommée à pleine charge.

## Question 6

L'avantage des instances EC2 est qu'il est possible de faire de l'auto scaling et de la tolérence aux pannes selon les règles qu'on définit

L'inconvénient est qu'il faut parfois attendre pour avoir certaines ressources (selon le prix des instances)

## Question 7

L'availability est exprimée en pourcentage du temps pendant lequel le service est fonctionnel.

Amazon Virtual Private Cloud permet d'augmenter l'availability en proposant des services d'auto-scaling et de load balancing.

## Question 8

Le NFS ne devrait pas être géré par Kubernetes car c'est une application qui a besoin d'accéder fréquemment au disque et qui est proche de l'OS.

MySQL ne peut pas auto-scale car c'est une base de données qui n'est pas distribuée. Si on rajoute de nouvelles instances, elles ne verront que leurs propres données, ce qui posera des problèmes.

Les autres composants peuvent être auto-scale :
 - le frontend et le backend car ce sont des applications stateless
 - Redis car il est possible de travailler en distribué en faisant du maître-esclave

(Note : comme Redis stocke les données dans la RAM, il est important que ce composant scale en même temps que les autres, sinon on va avoir des problèmes)

## Question 9

L'allocation fine de ressources permet de ne demander que les ressources dont on va avoir besoin, ce qui fait que le fournisseur peut mieux rentabiliser ses machines.

L'inconvénient est que les utilisateurs ne savent pas nécessairement de combien de ressources ils ont besoin et que cela rajoute de la complexité dans le processus d'allocation de ressources.

## Question 10

À chaque événement, une fonction AWS Lambda est appelée dans un conteneur. Donc, si de nombreux événements ont lieu à la suite, il est possible que de nombreuses fonctions s'exécutent en même temps. S'il n'y a pas assez de ressources allouées, le temps de réponse va augmenter et donc on va payer plus car on monopolise les ressources plus longtemps. 

En augmentant la mémoire allouée à nos fonctions, on leur permet de s'exécuter plus rapidement. Il est alors possible que le coût de la mémoire supplémentaire soit plus faible que le coût qui était précédemment engendré par le temps d'exécution supplémentaire.

C'est le cas par ce que le temps de réponse n'est pas linéairement proportionnel au nombre de processus (plutôt exponentiellement).

## Question 11

En FaaS, les fonctions sont appelées dès qu'une action est effectuée, donc l'auto-scaling est automatique dû au fait que chaque action génère la création d'un nouveau conteneur, qui s'arrête ensuite dès qu'il a fini (modulo le warm start).

En PaaS, la création ou la destruction de nouveaux conteneurs n'a lieu que quand c'est nécessaire, selon des règles qui sont définies à l'avance (seuil d'utilisation, ...).

