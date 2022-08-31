package fr.nperier.system.tp6;

public class StoopidPhilosopher extends AbstractPhilosopher {

    public StoopidPhilosopher(Table t) {
        super(t);
    }

    public void run() {
        try {
            for(int i=0; i < NB_EXEC; i++) {
                think();
                synchronized (tb) {
                    tb.getBaguette(id, id);
                    tb.getBaguette(id + 1, id);
                    eat();
                    tb.yieldBaguette(id, id);
                    tb.yieldBaguette(id + 1, id);
                }
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        Table t = new Table(NB_PHILO);
        for(int i=0; i < NB_PHILO; i++) {
            new StoopidPhilosopher(t).start();
        }
    }

}
