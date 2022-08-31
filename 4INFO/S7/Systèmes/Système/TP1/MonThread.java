public class MonThread extends Thread {
    private int _id;
    
    MonThread(int i) {
		_id = i;
    }

    public void run() {
		for(int i = 0; i < 500; i++) {
		    System.out.println(_id);
		}
    }

    public static void main(String[] args) {
		MonThread mt = new MonThread(1);
		//mt.run();
		mt.start();
		for (int i = 0; i < 500; i++) {
			System.out.println(0);
		}
    }
}
