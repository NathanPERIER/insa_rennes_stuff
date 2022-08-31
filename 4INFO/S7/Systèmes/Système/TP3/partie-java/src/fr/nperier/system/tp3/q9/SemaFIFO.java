package fr.nperier.system.tp3.q9;

import fr.nperier.system.tp3.q8.Semaphor;

public class SemaFIFO extends Semaphor {

    private long waiting;
    private long next;

    public SemaFIFO(int i) {
        super(i);
        waiting = 0L;
        next = 0L;
    }

    @Override
    public synchronized void P() {
        long id = waiting;
        waiting++;
        while(counter == 0 || next != id) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        counter--;
        next++;
    }

    public static void main(String[] args) {
        Semaphor.test(new SemaFIFO(1), 4);
    }

}
