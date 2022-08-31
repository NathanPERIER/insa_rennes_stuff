package fr.nperier.system.tp3.q8;

import fr.nperier.system.tp3.Constants;

import java.util.ArrayList;
import java.util.List;

public class Semaphor {

    protected int counter;

    public Semaphor(int i) {
        counter = Math.max(i, 0);
    }

    public synchronized void P() {
        while(counter == 0) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        counter--;
    }

    public synchronized void V() {
        counter++;
        notifyAll();
    }

    public static void test(Semaphor mutex, int nb) {
        for(int i=0; i<nb; i++) {
            new TestThread(mutex).start();
        }
    }

    public static void main(String[] args) {
        test(new Semaphor(1), 4);
    }

    public static class TestThread extends Thread {
        private static final long WAIT_TIME_MS = 300;
        private static int next_nb = 1;

        private final Semaphor mutex;
        private final int num;

        public TestThread(Semaphor sem) {
            mutex = sem;
            num = next_nb;
            next_nb++;
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        public void run() {
            for(int i=0; i<Constants.NB_LOOP; i++) {
                mutex.P();
                System.out.println("Begin " + num);
                try {
                    Thread.sleep(WAIT_TIME_MS);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                System.out.println("End " + num);
                mutex.V();
            }
        }

    }

}
