package fr.nperier.system.tp4.q3;

public class Parking {

    private static final int CAPACITY_SOUTH = 1;
    private static final int CAPACITY_NORTH = 2;

    private final Object LOCK_NORTH;
    private final Object LOCK_SOUTH;
    private final Object LOCK_FREE;
    private int nbFree;
    private int nbNorth;
    private int nbSouth;

    public Parking() {
        LOCK_NORTH = new Object();
        LOCK_SOUTH = new Object();
        LOCK_FREE = new Object();
        nbFree = CAPACITY_NORTH + CAPACITY_SOUTH;
        nbNorth = CAPACITY_NORTH;
        nbSouth = CAPACITY_SOUTH;
    }

    public void sortieVoiture() {

        boolean test = true;
        synchronized(LOCK_NORTH) {
            if(nbNorth < CAPACITY_NORTH) {
                nbNorth++;
                test = false;
            }
        }
        if(test) {
            synchronized(LOCK_SOUTH) {
                nbSouth++;
            }
        }
        synchronized(LOCK_FREE) {
            nbFree++;
            LOCK_FREE.notify();
            System.out.println("Sortie (" + nbFree + ")");
        }
    }

    public void entreeNord() {
        boolean test = false;
        synchronized (LOCK_NORTH) {
            if (nbNorth > 0) {
                nbNorth--;
                test = true;
            }
        }
        if(test) {
            synchronized (LOCK_FREE) {
                nbFree--;
            }
        } else {
            waitFree();
        }
        System.out.println("Entrée par la porte nord (" + nbFree + ")");
    }

    public synchronized void entreeSud() {
        boolean test = false;
        synchronized (LOCK_SOUTH) {
            if (nbSouth > 0) {
                nbSouth--;
                test = true;
            }
        }
        if(test) {
            synchronized (LOCK_FREE) {
                nbFree--;
            }
        } else {
            waitFree();
        }
        System.out.println("Entrée par la porte sud (" + nbFree + ")");
    }

    private void waitFree() {
        boolean test = true;
        synchronized (LOCK_FREE) {
            while(test) {
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                if(nbFree == 0) {
                    try {
                        LOCK_FREE.wait();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
                synchronized (LOCK_NORTH) {
                    if(nbNorth > 0) {
                        nbNorth--;
                        nbFree--;
                        test = false;
                    }
                }
                if(test) {
                    synchronized (LOCK_SOUTH) {
                        if(nbSouth > 0) {
                            nbSouth--;
                            nbFree--;
                            test = false;
                        }
                    }
                }
            }
        }
    }

}
