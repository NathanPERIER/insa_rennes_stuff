package fr.nperier.system.tp3.q6;

import fr.nperier.system.tp3.Constants;

import java.util.concurrent.Semaphore;

public class DualAlternanceSemaphores {

    private static Semaphore sem_a;
    private static Semaphore sem_o;


    public static void main(String[] args) {
        sem_a = new Semaphore(1);
        sem_o = new Semaphore(0);
        new ThreadA().start();
        new ThreadB().start();
        new ThreadC().start();
    }

    private static class ThreadA extends Thread {
        public void run() {
            try {
                for(int i = 0; i<2*Constants.NB_LOOP; i++) {
                    sem_a.acquire();
                    System.out.println("A");
                    sem_o.release();
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
                    sem_o.acquire();
                    System.out.println("B");
                    sem_a.release();
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    private static class ThreadC extends Thread {
        public void run() {
            try {
                for(int i=0; i<Constants.NB_LOOP; i++) {
                    sem_o.acquire();
                    System.out.println("C");
                    sem_a.release();
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
