package fr.nperier.ppd.tp2.q2;

import fr.nperier.ppd.tp2.Message;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface ClientDistant extends Remote {

    public void msg(Message m) throws RemoteException;

}
