package fr.nperier.s6.rezo.tp3;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class ClientMajuscule implements AutoCloseable {
    Socket s;
    BufferedReader reader;
    PrintWriter writer;

    public static void main(String[] args) throws IOException {
        try(ClientMajuscule client = new ClientMajuscule("127.0.0.1", 2222)) {
            for (String str : args) {
                try {
                    System.out.println(client.toUpperCase(str));
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    public ClientMajuscule(String host, int port) throws IOException {
        s = new Socket(host, port);
        reader = new BufferedReader(new InputStreamReader(s.getInputStream()));
        writer = new PrintWriter(s.getOutputStream(), true);
        reader.readLine();
    }

    String toUpperCase(String str) throws IOException {
        writer.println(str);
        return reader.readLine();
    }

    public void close() throws IOException {
        toUpperCase(".");
        s.close();
    }

}
