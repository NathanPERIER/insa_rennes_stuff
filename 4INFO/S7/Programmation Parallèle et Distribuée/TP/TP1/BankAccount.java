package fr.nperier.ppd.tp1;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface BankAccount extends Remote {
    public void deposit(float amount) throws RemoteException;
    public void withdraw(float amount) throws RemoteException, OverdrawException;
    public float balance() throws RemoteException;

    public static class OverdrawException extends ArithmeticException {
        public OverdrawException(String message) {
            super(message);
        }
    }
}
