package fr.nperier.ppd.tp1;

import java.net.MalformedURLException;
import java.rmi.AlreadyBoundException;
import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;

public class BankServer {

    public static void main(String[] args) throws RemoteException, MalformedURLException, AlreadyBoundException {
        AccessControl acct  = AccessControlImpl.getAC();
        LocateRegistry.createRegistry(1099);
        Naming.bind("rmi://0.0.0.0:1099/access", acct);
    }

}
