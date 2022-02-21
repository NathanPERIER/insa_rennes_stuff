package fr.nperier.s6.rezo.tp3;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class ClientPlusMoins implements AutoCloseable {
    Socket s;
    BufferedReader reader;
    PrintWriter writer;

    public static void main(String[] args) throws IOException {
        try(ClientPlusMoins client = new ClientPlusMoins("127.0.0.1", 2222);
            BufferedReader keyboardInput = new BufferedReader(new InputStreamReader(System.in))) {
            String str = "";
            System.out.println("Enter a number : ");
            while(!"Ok".equals(str)) {
                client.write(keyboardInput.readLine());
                str = client.read();
                System.out.println(str);
            }
        }
    }

    public ClientPlusMoins(String host, int port) throws IOException {
        s = new Socket(host, port);
        reader = new BufferedReader(new InputStreamReader(s.getInputStream()));
        writer = new PrintWriter(s.getOutputStream(), true);
    }

    public void write(String str) {
        writer.println(str);
    }

    public String read() throws IOException {
        return reader.readLine();
    }

    public void close() throws IOException {
        s.close();
    }

}
