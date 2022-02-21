package fr.nperier.s6.rezo.tp3;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Date;

public class ServeurPlusMoins {

    ServerSocket ss;

    public static void main(String[] args) throws IOException {
        ServeurPlusMoins server = new ServeurPlusMoins(2222);
        server.start();
    }

    public ServeurPlusMoins(int port) throws IOException {
        ss = new ServerSocket(port);
    }

    void start() {
        while(true) {
            try(Socket s = ss.accept();
                BufferedReader reader = new BufferedReader(new InputStreamReader(s.getInputStream()));
                PrintWriter writer = new PrintWriter(s.getOutputStream(), true)) {
                    System.out.println("["+ (new Date()) +"] Connection @ " + s.getInetAddress().getHostName() + ":" + s.getPort() + " (" + s.getInetAddress().getHostAddress() + ") ");
                    int rand = (int) (Math.random() * 100 + 1);
                    System.out.println("Random number : " + rand);
                    int guess;
                    String str = "";
                    boolean keepGoing = true;
                    while(keepGoing) {
                        str = reader.readLine();
                        if(str != null) {
                            try {
                                System.out.println("Guess : " + str);
                                guess = Integer.parseInt(str);
                                if(guess > rand) {
                                    writer.println("Moins");
                                } else if(guess < rand) {
                                    writer.println("Plus");
                                } else {
                                    writer.println("Ok");
                                    keepGoing = false;
                                }
                            } catch (NumberFormatException e) {
                                writer.println("Bad number format");
                            }
                        } else {
                            keepGoing = false;
                        }
                    }
                    System.out.println("["+ (new Date()) +"] Connection " + ((str == null) ? "interrupted" : "closed"));
                    s.shutdownInput();
                    s.shutdownOutput();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
