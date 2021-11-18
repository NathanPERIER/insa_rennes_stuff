package fr.nperier.ppd.tp2.q2;

import fr.nperier.ppd.tp2.Message;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface ServeurChat extends Remote {

	public void connect(ClientDistant ref) throws RemoteException;

	public void disconnect(ClientDistant ref) throws RemoteException;

	public void sendMsg(Message m) throws RemoteException;

}
