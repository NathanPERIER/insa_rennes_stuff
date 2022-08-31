package fr.nperier.system.tp3.q7;

import fr.nperier.system.tp3.Constants;

public class LongAlternanceWaitNotify {
    private static boolean b_can_go;
    private static boolean c_can_go;


    public static void main(String[] args) {
        b_can_go = false;
        c_can_go = false;
        new ThreadA().start();
        new ThreadB().start();
        new ThreadC().start();
    }

    private static class ThreadA extends Thread {
        public void run() {
            try {
                for(int i = 0; i<Constants.NB_LOOP; i++) {
                    synchronized(Constants.LOCK) {
                        while(b_can_go || c_can_go) {
                            Constants.LOCK.wait();
                        }
                        System.out.println("A");
                        b_can_go = true;
                        c_can_go = true;
                        Constants.LOCK.notifyAll();
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
                        while(!b_can_go) {
                            Constants.LOCK.wait();
                        }
                        System.out.println("B");
                        b_can_go = false;
                        Constants.LOCK.notifyAll();
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
                        while(!c_can_go) {
                            Constants.LOCK.wait();
                        }
                        System.out.println("C");
                        c_can_go = false;
                        Constants.LOCK.notifyAll();
                    }
                }
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
