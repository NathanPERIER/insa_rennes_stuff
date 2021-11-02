package fr.nperier.ppd.tp1;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface AccessControl extends Remote {

    public BankAccount login(int id) throws RemoteException;

}
