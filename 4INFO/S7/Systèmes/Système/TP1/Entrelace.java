public class Entrelace extends Thread {
    private int _id;
    
    Entrelace(int i) {
	_id = i;
    }

    public void run() {
	for(int i = 0; i < 100; i++) {
	    System.out.print(_id);
	}
		
    }

    public static void main(String[] args) {
	for (int i = 0; i < 10; i++) {
	    Entrelace mt = new Entrelace(i);
	    mt.start();
	}
    }

}
