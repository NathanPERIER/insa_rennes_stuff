
# Programmation Parallèle et Distribuée, janvier 2019

## Exercice 1

1.	On suppose que `N` est un entier strictement positif connu à la compilation (par exemple `#define N 10`). La déclaration de `T` est donc : 
```C
int T[N][N]
```

On peut lancer les threads de la manière suivante :
```C
pthread_t threads[N];
pthread_attr_t attr;
pthread_attr_init(&attr);
for(int i = 0; i < N; i++) {
	int* id = malloc(sizeof(int));
	*id = i;
	pthread_create(threads+i, &attr, thread_func, (void*) id);
}
```

Où `thread_func` est la fonction exécutée par le thread, c'est elle qui s'occupera de `free` l'argument `id`. Par exemple :
```C
void* thread_func(void* args) {
	int myId = *((int*)args);
	free(args);
	// ...
}
```

2.	On suppose que tous les threads ont accès aux variables initialisées comme suit :
```C
pthread_mutex_t mutex_tab  = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t mutex_comm = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond[N];
char comm[N][N];
for(int i = 0; i < N; i++) {
	cond[i] = PTHREAD_COND_INITIALIZER;
	for(int j = 0; j < N; j++) {
		comm[i][j] = 0;
	}
}
```

Chaque case `comm[i][j]` du tableau `comm` contient un octet qui indique :
 - Que le process `j` est en attente d'un message du process `i` si le bit de poids faible (indice 0) est à 1 (i.e. `comm[i][j] & 0b00000001 != 0`)
 - Qu'un message envoyé au process `j` par le process `i` est en attente de lecture si le bit d'indice 1 est à 1 (i.e. `comm[i][j] & 0b00000010 != 0`)

Code d'envoi d'un message :
```C
void send(int j, int m) {
	pthread_mutex_lock(&mutex_tab);
	T[myId][j] = m;
	pthread_mutex_unlock(&mutex_tab);
	pthread_mutex_lock(&mutex_comm);
	comm[myId][j] |= 0b10;             // Un message est en attente de lecture
	if(comm[myId][j] & 0b01) {         // Si j est déjà en attente d'un message
		comm[myId][j] &= 0b11111110;   // On enlève le bit d'attente
		pthread_cond_signal(cond+j);   // Et on le notifie
	}
	while(comm[myId][j] & 0b10) {      // Tant que le bit 1 est à 1
		pthread_cond_wait(cond+myId, &mutex_comm); // On attend que l'autre process ait lu la donnée
	}
	pthread_mutex_unlock(&mutex_comm);
}
```

Code de réception d'un message :
```C
int recv(int i) {
	int res;
	pthread_mutex_lock(&mutex_comm); 
	if(!(comm[i][myId] & 0b10)) {      // Si un message n'a pas déjà été envoyé
		comm[i][myId] |= 0b01;         // On met le bit d'attente à 1
	}
	while(comm[i][myId] & 0b01) {      // Tant que le bit n'est pas revenu à 0
		pthread_cond_wait(cond+myId, &mutex_comm); // On attend le message
	}
	pthread_mutex_unlock(&mutex_comm);
	pthread_mutex_lock(&mutex_tab);
	res = T[i][myId];
	pthread_mutex_unlock(&mutex_tab);
	pthread_mutex_lock(&mutex_comm);
	comm[i][myId] &= 0b11111101        // On montre qu'on a lu le message
	pthread_cond_signal(cond+i);       // Et on notifie le process i
	pthread_mutex_unlock(&mutex_comm);
	return res;
}
```

2.	On suppose que tous les threads ont accès aux variables initialisées comme suit :
```C
int tab_broad[N];
int cpt_broad[N];
pthread_mutex_t mutex_broad = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t mutex_cpt   = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond_broad   = PTHREAD_COND_INITIALIZER;
for(int i = 0; i < N; i++) {
	cpt_broad[i] = 0; // Compte le nombre de process qui n'ont pas encore lu un message du process i
}
```

Code du broadcast :
```C
void broadcast(int m) {
	pthread_mutex_lock(&mutex_broad); 
	tab_broad[myId] = m;                 // On écrit le message
	pthread_mutex_unlock(&mutex_broad);
	pthread_mutex_lock(&mutex_cpt);
	cpt_broad[myId] = N-1;               // On initialise le compteur
	pthread_cond_broadcast(&cond_broad); // On réveille les receveurs potentiellement en attente
	while(cpt_broad[myId] > 0) {         // Et on attend que tout le monde ait lu le message
		pthread_cond_wait(&cond_broad, &mutex_cpt);
	}
	pthread_mutex_unlock(&mutex_cpt);
}
```

Code de réception :
```C
int broadcast_recv(int i) {
	int res;
	pthread_mutex_lock(&mutex_cpt);
	while(cpt_broad[i] == 0) {               // On attend que le message soit disponible (compteur initialisé)
		pthread_cond_wait(&cond_broad, &mutex_cpt);
	}
	pthread_mutex_unlock(&mutex_cpt);
	pthread_mutex_lock(&mutex_broad); 
	res = tab_broad[i];                      // On lit la valeur dans le tableau
	pthread_mutex_unlock(&mutex_broad);
	pthread_mutex_lock(&mutex_cpt);
	cpt_broad[i]--;                          // On décrémente le compteur car on a lu le message
	if(cpt_broad[i] == 0) {                  // Si on est le dernier à passer
		pthread_cond_broadcast(&cond_broad); // Alors on réveille tout le monde
	}
	while(cpt_broad[i] > 0) {                // Sinon on attend tant que tout le monde n'a pas lu le message
		pthread_cond_wait(&cond_broad, &mutex_cpt);
	}
	pthread_mutex_unlock(&mutex_cpt);
	return res;
}
```


## Exercice 3

1.	Pour passer un point par valeur (copie de l'objet) :
```java
public class PointImpl extends Point implements Serializable {
	// Rien à faire ici, tout est déjà dans la classe Point
}

// La classe Point n'a pas besoin de changer
public class Point {
	float x; // C'est pas très propre de laisser l'accès aux attributs
	float y; // mais c'est pour l'exemple
}
```

2.	Pour passer un point par référence :
```java
// La classe Point devient une interface qui dérive de Remote
public interface Point extends Remote {
	// On n'oublie pas que les méthodes de l'interface doivent lancer des RemoteException
	float getX() throws RemoteException;
	float getY() throws RemoteException;
	void setCoords(float x, float y) throws RemoteException;
}

// L'implémentation doit aussi hériter de UnicastRemoteObject
public class PointImpl extends UnicastRemoteObject implements Point {

	private float x;
	private float y;

	public PointImpl(int x, int y) throws RemoteException {
		setCoords(x, y);
	}

	@Override
	// ici pas besoin de throw RemoteException (mais on peut le mettre quand même)
	public float getX() {
		return x;
	}

	@Override
	public float getY() {
		return y;
	}

	@Override
	public void setCoords(float x, float y) {
		this.x = x;
		this.y = y;
	}
}
```

3.	Code de `Geometrie` et de l'implémentation :
```java
// On dérive toujours de Remote
public interface Geometrie extends Remote {
	// On lance toujours des RemoteException
	float distance(Point p) throws RemoteException;
	void deplace(Point p, float dx, float dy) throws RemoteException;
}

// On hérite toujours de UnicastRemoteObject
public class GeometrieImpl extends UnicastRemoteObject implements Geometrie {

	public GeometrieImpl(int port) throws RemoteException {
		super(port);
	}

	@Override
	// ici il faut throw RemoteException car on appelle les méthodes de Point
	public float distance(Point p) throws RemoteException {
		float x = p.getX();
		float y = p.getY();
		return (float) Math.sqrt(x*x + y*y);
	}

	@Override
	public void deplace(Point p, float dx, float dy) throws RemoteException {
		float x = p.getX() + dx;
		float y = p.getY() + dy;
		p.setCoords(x, y);
	}
}
```

Code du serveur :
```java
String serverAddr = InetAddress.getLocalHost().getHostAddress();
String geomUrl = "rmi://" + serverAddr + ":50100/geom";
GeometrieImpl geom = new GeometrieImpl(50000);
LocateRegistry.createRegistry(50100);
Naming.bind(geomUrl, geom);
```

Code du client :
```java
String serverAddr = InetAddress.getLocalHost().getHostAddress();
String geomUrl = "rmi://" + serverAddr + ":50100/geom";
Geometrie geom = (Geometrie) Naming.lookup(geomUrl);
Point p = new PointImpl(1, 1);
System.out.println("p = (" + p.getX() + ", " + p.getY() + ")");
System.out.println("Distance to origin : " + geom.distance(p));
geom.deplace(p, 2, 3);
System.out.println("p = p + (2, 3) = (" + p.getX() + ", " + p.getY() + ")");
System.out.println("Distance to origin : " + geom.distance(p));
System.exit(0); // Sinon le client continue de tourner dans le vide
```


## Exercice 4

```Cuda
__global__ void kernel_ca(char* C_current, char* C_next, int n, int i) {
	if(i < n) {
		char c   = C_current[i];
		char c_r = C_current[(i+1)%n];
		char c_l = C_current[(n+i-1)%n];
		C_next[i] = (c_l + c + c_r) % 2;
	}
}
```

Exemple d'appel :
```Cuda
kernel_ca<<<ceil((double)n/1024), 1024>>>(...);
```

On utilise une astuce mathématique afin d'éviter de mettre des conditions (`if(...)`) qui aboutiraient à de la warp divergeance et donc des réductions de performance : 
| `c_l` | `c` | `c_r` | `next = (c_l + c + c_r) % 2` |
|:-----:|:---:|:-----:|:----------------------------:|
| 0     | 0   | 0     | 0                            |
| 0     | 0   | 1     | 1                            |
| 0     | 1   | 0     | 1                            |
| 0     | 1   | 1     | 0                            |
| 1     | 0   | 0     | 1                            |
| 1     | 0   | 1     | 1                            |
| 1     | 1   | 0     | 0                            |
| 1     | 1   | 1     | 1                            |


## Remarques

Le code dans l'exercice 1 est très lourd à écrire, surtout à la main. Dans des conditions réelles on pourrait sans doute utiliser des raccourcis afin d'aller plus vite, par exemple :
```
pthread_mutex_lock(&mutex)       -> P(mutex)
pthread_mutex_unlock(&mutex)     -> V(mutex)
pthread_cond_wait(&cond, &mutex) -> wait(cond, mutex);
pthread_cond_signal(&cond)       -> notify(cond);
pthread_cond_broadcast(&cond)    -> nitify_all(cond);
```

Dans le même exercice, l'astuce utilisée avec les bits qui indiquent si un message est en attente de lecture ou si on attend un message n'est pas forcément évidente. Une manière équivalente de réaliser l'exercice est d'avoir deux tableaux qui contiennent chacun l'une des deux informations :
```C
char comm_in[N][N];
char waiting[N][N];
```

Les règles seraient alors :
 - `comm_in[i][j]` vaut 1 si le process `j` est en attente d'un message du process `i`, 0 sinon
 - `waiting[i][j]` vaut 1 si un message envoyé au process `j` par le process `i` est en attente de lecture, 0 sinon

Et on aurait les équivalences suivantes :
```
comm[i][j] & 0b01 == 0    <=>  comm_in[i][j] == 0
comm[i][j] & 0b01 != 0    <=>  comm_in[i][j] == 1
comm[i][j] |= 0b01        <=>  comm_in[i][j] = 1
comm[i][j] &= 0b11111110  <=>  comm_in[i][j] = 0
comm[i][j] & 0b10 == 0    <=>  waiting[i][j] == 0
comm[i][j] & 0b10 != 0    <=>  waiting[i][j] == 1
comm[i][j] |= 0b10        <=>  waiting[i][j] = 1
comm[i][j] &= 0b11111101  <=>  waiting[i][j] = 0
```
