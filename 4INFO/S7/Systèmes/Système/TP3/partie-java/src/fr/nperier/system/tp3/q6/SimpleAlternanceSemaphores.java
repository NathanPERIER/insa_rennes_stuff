package fr.nperier.system.tp3.q6;

import fr.nperier.system.tp3.Constants;

import java.util.concurrent.Semaphore;

public class SimpleAlternanceSemaphores {

    private static Semaphore sem_a;
    private static Semaphore sem_b;


    public static void main(String[] args) {
        sem_a = new Semaphore(1);
        sem_b = new Semaphore(0);
        new ThreadA().start();
        new ThreadB().start();
    }

    private static class ThreadA extends Thread {
        public void run() {
            try {
                for(int i=0; i<Constants.NB_LOOP; i++) {
                    sem_a.acquire();
                    System.out.println("A");
                    sem_b.release();
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    private static class ThreadB extends Thread {
        public void run() {
            try {
                for(int i=0; i<Constants.NB_LOOP; i++) {
                    sem_b.acquire();
                    System.out.println("B");
                    sem_a.release();
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

}
