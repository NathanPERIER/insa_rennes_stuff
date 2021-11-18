package fr.nperier.ppd.tp2.q2;

import fr.nperier.ppd.tp2.Message;

import java.net.MalformedURLException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.rmi.AlreadyBoundException;
import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.server.UnicastRemoteObject;
import java.util.ArrayList;
import java.util.List;

/**
*   This class provides an implementation for the server
*/

public class ServeurChatImpl extends UnicastRemoteObject implements ServeurChat {

	private final List<ClientDistant> clients;

	public ServeurChatImpl() throws RemoteException {
	    super(50000);
	    clients = new ArrayList<>();
	}

	public static void main(String[] args) throws UnknownHostException, RemoteException, AlreadyBoundException, MalformedURLException {
		String url = "rmi://"+ InetAddress.getLocalHost().getHostAddress() + ":50100/simpleChatServer";
		ServeurChatImpl theServer = new ServeurChatImpl();
		LocateRegistry.createRegistry(50100);
		Naming.bind(url, theServer);
	}

	@Override
	public void connect(ClientDistant ref) throws RemoteException {
		clients.add(ref);
	}

	@Override
	public void disconnect(ClientDistant ref) throws RemoteException {
		clients.remove(ref);
	}

	@Override
	public void sendMsg(Message m) throws RemoteException {
		System.out.println(m);
		for (ClientDistant c : clients) {
			c.msg(m);
		}
	}
}
