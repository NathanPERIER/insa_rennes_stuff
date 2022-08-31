public class Variable extends Thread {
    private VarObjet _id;
    
    Variable(VarObjet i) {
		_id = i;
    }

    public void run() {
		for(int i = 0; i < 10; i++) {
			try {
				System.out.println(_id.getVal());
				_id.setVal(i);
				Thread.sleep(1);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}
    }

    public static void main(String[] args) {
		VarObjet o = new VarObjet();
		Variable mt = new Variable(o);
		mt.start();
		for (int i = 10; i > 0; i--) {
			try {
				System.out.println(o.getVal());
				o.setVal(i);
				Thread.sleep(1);
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
			
		}
    }

}
