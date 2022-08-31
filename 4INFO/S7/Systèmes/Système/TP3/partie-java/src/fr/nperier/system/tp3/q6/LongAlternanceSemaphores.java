package fr.nperier.system.tp3.q6;

import fr.nperier.system.tp3.Constants;

import java.util.concurrent.Semaphore;

public class LongAlternanceSemaphores {
    private static Semaphore sem_a;
    private static Semaphore sem_b;
    private static Semaphore sem_c;
    private static Semaphore sem_o;


    public static void main(String[] args) {
        sem_a = new Semaphore(2);
        sem_b = new Semaphore(0);
        sem_c = new Semaphore(0);
        sem_o = new Semaphore(0);
        new ThreadA().start();
        new ThreadB().start();
        new ThreadC().start();
    }

    private static class ThreadA extends Thread {
        public void run() {
            try {
                for(int i = 0; i<Constants.NB_LOOP; i++) {
                    sem_a.acquire();
                    sem_a.acquire();
                    System.out.println("A");
                    sem_b.release();
                    sem_c.release();
                    sem_o.release();
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
                    sem_b.acquire();
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
                    sem_c.acquire();
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
