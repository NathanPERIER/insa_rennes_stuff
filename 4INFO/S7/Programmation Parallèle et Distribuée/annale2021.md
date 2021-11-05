
# Programmation Parallèle et Distribuée, décembre 2020

## Exercice 1

```java

interface Library extends Remote {
	int getNbBooks(int year) throws RemoteException;
	Book getBook(int id) throws RemoteException;
	Account getAccount(String name) throws RemoteExeption;
}

interface Book extends Remote {
	int getId() throws RemoteException;
	int getYear() throws RemoteException;
	String getTitle() throws RemoteException;
}

class Account implements Serializable {
	private String name
	private Date creationDate;
	
	public Account(String name, Date d) {
		this.name = name;
		creationDate = d;
	}

	public String getName() {
		return name;
	}
}

class BookImpl extends UnicastRemoteObject implements Book {
	public BookImpl(int id, int y, String title) {
		super();
		// affectations
	}

	public int getId() {return id;}
	
	// ...
}

class LibraryImpl extends UnicastRemoteObject implements Library {
	private Map<Integer, Book> books;
	
	public LibraryImpl(int port) {
		super(port);
		books = new HashMap<>();
	}

	public addBook(Book b) {
		books.put(b.getId(), b);
	}

	public long getNbBooks(int year) {
		return books.values().stream()
				.filter(b -> b.getYear() == year)
				.count();
	}

	public Book getBook(int id) {
		if(! books.containsKey(id)) {
			throw new IllegalArgumentException("Book with id " + id + " doesn't exists");
		}
		return books.get(id);
	}

	public ...

}
```


## Exercice 2

1.	Topologie : 

```
  PositionDataSpout            RestSignalSpout
         |                            |
         | shuffleGrouping            |
		 |                            | allGrouping
         V                            |
         DistrictBolt                 |
              |     __________________|
fieldsGrouping|     |
              |     | 
              V     V
     DistrictCountBolt
```

2.	Algorithme At-least-once : a chaque tuple émis on associe un ID, pour chacun de ses fils on XOR cet ID avec l'ID des fils. Quand un tuple a été traité, on XOR une fois de plus avec son ID. Si le résultat atteint 0, le tuple a été traité de bout en bout, si ce n'est pas le cas au bout d'une certaine durée il est ré-émis.

S1  -> T1 0110 0110      0110 0110
B1  -> T2 0001 1001      0111 1111
B1 ack T1                0001 1001
B2 ack T2                0000 0000

3.	Le niveau de parallélisme voulu par l'utilisateur peut être spécifié au moment de l'ajout de bolt ou de spout au `TopologyBuilder` via la méthode `setNumTasks` et le troisième argument de `setBolt` ou `setSpout` qui spécifie le nombre de executor qui exécutent les tasks des Bolt ou des Spout. Il ne s'agit cependant que d'un hint dans le second cas, le nombre effectif de tasks (threads) sur le système est limité par un paramètre de Storm.

4.	Utiliser une BDD


### Exercice 2

1.	`1000*512 = 512000` car une par thread

	1000 car une par bloc de thread

2.	Par ce que beaucoup de parallélisme => exécution rapide donc on peut se permettre de prendre plus de temps à charger les données

3.	`vecAddKernel<<<ceil((double)20000/1024.0), 512>>>(A_d, B_d, D_d, 20000)`

4.	Warp divergeance + gros vecteur

