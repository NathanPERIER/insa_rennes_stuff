package fr.nperier.system.tp4.q2;

public class Parking {

    private static final int CAPACITY = 3;
    private int nbFree;

    public Parking() {
        nbFree = CAPACITY;
    }

    public synchronized void sortieVoiture() {
        nbFree++;
        notify();
        System.out.println("Sortie (" + nbFree + ")");
    }

    public synchronized void entreeNord() {
        try {
            Thread.sleep(1000);
            while(nbFree == 0) {
                wait();
                Thread.sleep(1000);
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        nbFree--;
        System.out.println("Entrée par la porte nord (" + nbFree + ")");
    }

    public synchronized void entreeSud() {
        try {
            Thread.sleep(1000);
            while(nbFree == 0) {
                wait();
                Thread.sleep(1000);
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        nbFree--;
        System.out.println("Entrée par la porte sud (" + nbFree + ")");
    }

}
