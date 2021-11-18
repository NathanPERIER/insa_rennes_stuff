package fr.nperier.ppd.tp1;

import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.HashMap;
import java.util.Map;

public class AccessControlImpl extends UnicastRemoteObject implements AccessControl {
    private static final int PORT = 1099;
    private final Map<Integer, BankAccount> accounts;
    private static AccessControl INSTANCE;

    static {
        try {
            INSTANCE = new AccessControlImpl(PORT);
        } catch (RemoteException e) {
            throw new RuntimeException(e);
        }
    }

    private AccessControlImpl(int port) throws RemoteException {
        super(port);
        accounts = new HashMap<>();
    }

    @Override
    public BankAccount login(int id) throws RemoteException {
        if(!accounts.containsKey(id)) {
            accounts.put(id, new BankAccountImpl(PORT));
        }
        return accounts.get(id);
    }

    public static AccessControl getAC() throws RemoteException {
        return INSTANCE;
    }
}

