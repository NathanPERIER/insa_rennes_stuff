package fr.nperier.ppd.tp2.q2;

import fr.nperier.ppd.tp2.Message;
import fr.nperier.ppd.tp2.UserStampedMessage;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.rmi.Naming;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;


public class ClientDistantImpl extends UnicastRemoteObject implements ClientDistant, AutoCloseable {
  protected String user;
  protected ServeurChat theServer;

  public ClientDistantImpl(String user, ServeurChat server) throws RemoteException {
    this.user = user;
    this.theServer = server;
    theServer.connect(this);
  }

  public static void main(String[] args) throws RemoteException, NotBoundException, MalformedURLException, UnknownHostException {
    String server_name, user;
    String adresseClient, adresseServer;
    String serverUrl;

    if (args.length < 2) {
      System.out.println("Usage: client <server> <username>");
      System.exit(1);
      return;
    } else {
      server_name = args[0];
      user = args[1];
    }
    adresseServer = InetAddress.getByName(server_name).getHostAddress();
    adresseClient = InetAddress.getLocalHost().getHostAddress();

    serverUrl = "rmi://" + adresseServer + ":50100/simpleChatServer";
    ServeurChat server = (ServeurChat) Naming.lookup(serverUrl); // lookup in the rmiregistry
    if (server != null) {
      System.out.println("Server found at URL " + serverUrl);
    } else {
      System.out.println("No server found at URL " + serverUrl);
      System.exit(2);
      return;
    }
    try (ClientDistantImpl client = new ClientDistantImpl(user, server)) {
      client.readMsgs();
    } catch (IOException e) {
      e.printStackTrace();
    }
    System.exit(0);
  }

  @Override
  public void msg(Message m) throws RemoteException {
    System.out.println(m);
  }

  public void readMsgs() throws IOException {
    String line = "";
    boolean keepGoing = true;
    BufferedReader clavier = new BufferedReader(new InputStreamReader(System.in));
    while(keepGoing) {
      System.out.print("> ");
      line = clavier.readLine();
      if ("/quit".equals(line)) {
        keepGoing = false;
      } else {
        theServer.sendMsg(new UserStampedMessage(line, user));
      }
    }
  }

  @Override
  public void close() throws RemoteException {
    System.out.println("Goodbye !");
    theServer.disconnect(this);
  }
}
