package fr.nperier.ppd.tp1;

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class BankAccountImpl extends UnicastRemoteObject implements BankAccount {
    private float balance;

    public BankAccountImpl(int port) throws RemoteException {
        super(port);
        balance = 0;
    }

    @Override
    public void deposit(float amount) throws RemoteException {
        balance += amount;
    }

    @Override
    public void withdraw(float amount) throws RemoteException, OverdrawException {
        if(balance < amount) {
            throw new OverdrawException("Not enough money in the bank account to perform this withdrawal");
        }
        balance -= amount;
    }

    @Override
    public float balance() throws RemoteException {
        return balance;
    }
}
