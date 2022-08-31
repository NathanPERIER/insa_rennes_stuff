package fr.nperier.system.tp6;

public class Table {

    private final Object[] baguettes;
    private final int[] taken;

    public Table(int nb) {
        baguettes = new Object[nb];
        taken = new int[nb];
        for(int i = 0; i < nb; i++) {
            taken[i] = -1;
            baguettes[i] = new Object();
        }
    }

    public void getBaguette(int n, int p) throws InterruptedException {
        int i = n % baguettes.length;
        synchronized (baguettes[i]) {
            while(taken[i] >= 0) {
                baguettes[i].wait();
            }
            taken[i] = p;
        }
        System.out.println("["+ p + "] <- \uD83E\uDD62" + i);
    }

    public void yieldBaguette(int n, int p) {
        int i = n % baguettes.length;
        synchronized (baguettes[i]) {
            baguettes[i].notify();
            if(taken[i] == p) {
                taken[i] = -1;
            } else {
                throw new IllegalStateException("Philosopher " + p + " doesn't own chopstick " + i);
            }
        }
        System.out.println("["+ p + "] -> \uD83E\uDD62" + i);
    }

}
