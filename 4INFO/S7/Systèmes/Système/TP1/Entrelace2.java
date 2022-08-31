public class Entrelace2 extends Thread {
    private int _id;
    
    Entrelace2(int i) {
	_id = i;
    }

    public void run() {
	for(int i = 0; i < 100; i++) {
	    try {
		System.out.print(_id);
		Thread.sleep(1);
	    } catch (InterruptedException e) {
		e.printStackTrace();
	    }
	}
		
    }

    public static void main(String[] args) {
	for (int i = 0; i < 10; i++) {
	    Entrelace2 mt = new Entrelace2(i);
	    mt.start();
	}
    }

}
