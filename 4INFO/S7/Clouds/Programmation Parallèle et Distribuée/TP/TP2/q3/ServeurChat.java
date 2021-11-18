package fr.nperier.ppd.tp2.q3;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface ServeurChat extends Remote {

	public void connect(ClientDistant ref) throws RemoteException;

	public void disconnect(ClientDistant ref) throws RemoteException;

}
