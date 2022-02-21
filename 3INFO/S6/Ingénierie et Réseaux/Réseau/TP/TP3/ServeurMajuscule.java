package fr.nperier.s6.rezo.tp3;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Date;

public class ServeurMajuscule {

    ServerSocket ss;

    public static void main(String[] args) throws IOException {
        ServeurMajuscule server = new ServeurMajuscule(2222);
        server.start();
    }

    public ServeurMajuscule(int port) throws IOException {
        ss = new ServerSocket(port);
    }

    void start() {
        while(true) {
            try {
                Socket s = ss.accept();
                System.out.println("["+ (new Date()) +"] Connection @ " + s.getInetAddress().getHostName() + ":" + s.getPort() + " (" + s.getInetAddress().getHostAddress() + ") ");
                Thread t = new Thread(new ServerRunnable(s));
                t.start();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }


    private static class ServerRunnable implements Runnable {
        Socket s;

        public ServerRunnable(Socket sock) {
            s = sock;
        }

        @Override
        public void run() {
            try(BufferedReader reader = new BufferedReader(new InputStreamReader(s.getInputStream()));
                PrintWriter writer = new PrintWriter(s.getOutputStream(), true)) {
                writer.println("Hello. This is server. You send message, we send uppercase. Fullstop ends session. Have fun.");
                writer.flush();
                boolean keepGoing = true;
                String str;
                while(keepGoing) {
                    str = reader.readLine();
                    if(".".equals(str)) {
                        keepGoing = false;
                    } else {
                        writer.println(str.toUpperCase());
                    }
                }

                s.shutdownInput();
                s.shutdownOutput();
                s.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

    }



}
