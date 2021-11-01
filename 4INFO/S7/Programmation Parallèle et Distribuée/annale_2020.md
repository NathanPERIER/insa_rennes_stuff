
# Programmation Parallèle et Distribuée, janvier 2019

## Exercice 1

1.	On passe l'adresse de la variable `i` comme argument au thread, cependant le thread n'est pas instantané et le contenu de la variable est modifié par l'incrément de la boucle `for` entre l'appel de `pthread_create` et la récupération de l'argument.

Pour corriger ce problème, il faut allouer un argument à chaque exécution de la boucle `for` :
```C
for(int i = 0; i < 10; i++) {
	int* arg = malloc(sizeof(int));
	*arg = i;
	t_id[i] = pthread_create(p_thread+i, NULL, do_loop, (void*)arg);
}
```

C'est ensuite à la fonction `do_loop` de libérer le pointeur :
```C
void* do_loop(void* arg) {
	int me = *((int*)arg);
	free(arg);
	printf("%d\n", me);
	pthread_exit(NULL);
}
```

2.	[Wikipédia](https://fr.wikipedia.org/wiki/Inversion_de_priorit%C3%A9) définit l'inversion de priorité comme "une situation dans laquelle un processus de haute priorité ne peut pas avoir accès au processeur car il est utilisé par un processus de plus faible priorité"

	Soient trois processus A, B et C tels que A est plus prioritaire que B, qui est lui-même plus prioritaire que C. A et C accèdent à une ressource partagée protégée par une mutes. Le scénario d'inversion de priorité suivant peut alors se produire :
	 - Le processus C acquiert la ressource durant son exécution
	 - Le processus B arrive ensuite et préempte la taĉhe C qui n'a pas encore libéré le mutex
	 - Le processus A arrive enfin, préempte B et s'exécute jusuq'à atteindre la section critique
	 - Ne pouvant acquérir la ressource, A rend la main et la têche B finit de s'exécuter
	 - La tâche C finit ensuite de s'exécuter, puis la têche A continue enfin son exécution
	
	On constate que A est la tâche la plus prioritaire, pourtant elle s'exécute en dernier. De plus, on remarque que la tâche B peut bloquer la tâche A alors qu'elles ne partagent aucune ressource en commun.


## Exercice 2

1.	On a 2000 éléments pour un nombre entier de blocs de 512 threads qui traitent chacun un élément au maximum. 

	2000/512 = 3,91

	Il faudra donc 4 blocs pour traiter tous les éléments, soit 4*512 = 2048 threads au total

2.	Sur les 2048 threads, seuls 2000 effectuent un calcul, on a donc 48 threads qui ne sont pas utilisés. Cela aboutit à 48 divergeances de wraps car ces thredans n'exécutent alors pas le même code que les autres.

3.	Le code du kernel est le suivant :
```Cuda
__global__ void reverseVector(int* d_out, int* d_in) {
	int x = blockIdx.x * blockDim.x + threadIdx.x;
	d_out[x] = d_in[256-x];
}
```

4.	Code d'invocation du kernel pour `N > 0` :
```Cuda
reverseVector<<<ceil((double)N/256.0), 256>>>(d_out, d_in, N);
```

5.	Code du kernel pour `N > 0` :
```Cuda
__global__ void reverseVector(int* d_out, int* d_in, int n) {
	int x = blockIdx.x * blockDim.x + threadIdx.x;
	if(x < n) {
		d_out[x] = d_in[n-x];
	}
}
```


## Exercice 4

1.	Voici les modifications à apporter afin que l'interface fonctionne avec rmi : 
```java
class Mesure implements Serializable {
	float temp;
	float wind;
	int humidity;
	// ...
}

interface Server extends Remote {
	int register_station() throws RemoteException;
	void send(int station_id, Mesure m) throws RemoteException;
	Mesure get_measure(int station_id) throws RemoteException;
}
```

*Attention : cette correction est probablement incorrecte car on demande de renvoyer la `Mesure` par référence dans `get_mesure`, je viens de me rendre compte de cette erreur*

*Note : la signature de `get_measure` n'est pas la même que celle indiquée dans le sujet, je l'ai modifiée car elle correspond mieux selon moi à l'énoncé qui indique que "Les clients peuvent ensuite se connecter à ce serveur pour visualiser les données qui sont transmises par référence". En effet, si on veut transmettre une mesure  il faut bien renvoyer un objet de type `Mesure`, et il faut bien donner l'identifiant d'une station pour savoir quelle donnée renvoyer*

2.	Implémentation du serveur :
```java
class ServerImpl extends UnicastRemoteObject implements Server {

	public static NEXT_ID = 1;
	private Map<Integer, Mesure[]> measures;
	
	public ServerImpl(int port) {
		super(port);
	}

	public int register_station() {
		measures.put(NEXT_ID, new Mesure[2]);
		return NEXT_ID++;
	}

	public void send(int station_id, Mesure m) {
		if(!mesures.containsKey()) {
			throw new IllegalArgumentException("Station " + station_id + " does not exist");
		}
		Mesures[] mes = measures.get(station_id);
		mes[1] = mes[0];
		mes[0] = m;
	}

	public Mesure get_measure(int station_id) {
		if(!mesures.containsKey()) {
			throw new IllegalArgumentException("Station " + station_id + " does not exist");
		}
		return measures.get(station_id)[0];
	}
}
```

