package fr.nperier.ppd.tp1;

import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;

public class BankClient {

    public static void main(String[] args) throws RemoteException, NotBoundException {
        Registry registry = LocateRegistry.getRegistry("localhost", 1099);
        AccessControl acct = (AccessControl)registry.lookup("access");
        BankAccount account = acct.login(1);
        account.deposit(12);
        System.out.println(account.balance());
        account.withdraw(20);
        System.out.println(account.balance());
    }

}
