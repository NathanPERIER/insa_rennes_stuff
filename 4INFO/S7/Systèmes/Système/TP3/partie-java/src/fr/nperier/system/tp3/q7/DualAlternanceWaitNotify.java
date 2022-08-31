package fr.nperier.system.tp3.q7;

import fr.nperier.system.tp3.Constants;

public class DualAlternanceWaitNotify {

    private static boolean a_turn;

    public static void main(String[] args) {
        a_turn = true;
        new ThreadA().start();
        new ThreadB().start();
        new ThreadC().start();
    }

    private static class ThreadA extends Thread {
        public void run() {
            try {
                for(int i = 0; i<2*Constants.NB_LOOP; i++) {
                    synchronized(Constants.LOCK) {
                        while(!a_turn) {
                            Constants.LOCK.wait();
                        }
                        System.out.println("A");
                        a_turn = false;
                        Constants.LOCK.notify();
                    }
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
                    synchronized(Constants.LOCK) {
                        while(a_turn) {
                            Constants.LOCK.wait();
                        }
                        System.out.println("B");
                        a_turn = true;
                        Constants.LOCK.notify();
                    }
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
                    synchronized(Constants.LOCK) {
                        while(a_turn) {
                            Constants.LOCK.wait();
                        }
                        System.out.println("C");
                        a_turn = true;
                        Constants.LOCK.notify();
                    }
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
