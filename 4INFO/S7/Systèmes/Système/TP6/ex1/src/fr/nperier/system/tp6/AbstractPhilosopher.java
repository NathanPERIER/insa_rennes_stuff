package fr.nperier.system.tp6;

public abstract class AbstractPhilosopher extends Thread{
    public static final int NB_EXEC = 3;
    public static final int NB_PHILO = 5;
    private static int NEXT_ID = 0;
    protected final int id;
    protected final Table tb;

    protected AbstractPhilosopher(Table t) {
        tb = t;
        id = NEXT_ID++;
    }

    public void eat() throws InterruptedException {
        System.out.println("Philosopher " + id + " eating");
        Thread.sleep(800);
        System.out.println("Philosopher " + id + " done eating");
    }

    public void think() throws InterruptedException {
        System.out.println("Philosopher " + id + " thinking");
        Thread.sleep(1000);
        System.out.println("Philosopher " + id + " done thinking");
    }

}
