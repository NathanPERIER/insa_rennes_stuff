package fr.nperier.system.tp6;

public class SmortPhilosopher extends AbstractPhilosopher {

    private final int[] chopId;

    public SmortPhilosopher(Table t) {
        super(t);
        chopId = new int[2];
        chopId[0] = (id%2 == 0) ? id : id+1;
        chopId[1] = (id%2 == 0) ? id+1 : id;
    }

    public void run() {
        try {
            for(int i=0; i < NB_EXEC; i++) {
                think();
                tb.getBaguette(chopId[0], id);
                tb.getBaguette(chopId[1], id);
                eat();
                tb.yieldBaguette(chopId[0], id);
                tb.yieldBaguette(chopId[1], id);
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        Table t = new Table(NB_PHILO);
        for(int i=0; i < NB_PHILO; i++) {
            new SmortPhilosopher(t).start();
        }
    }

}
