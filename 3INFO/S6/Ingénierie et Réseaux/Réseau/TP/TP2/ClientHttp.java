package fr.nperier.s6.rezo.tp2;

import java.io.*;
import java.net.Socket;
import java.nio.charset.StandardCharsets;

public class ClientHttp implements AutoCloseable{

    private final Socket socket;

    public ClientHttp(int p, String addr) throws IOException {
        socket = new Socket(addr, p);
    }

    public void request(String resource) throws IOException {
        try(BufferedReader reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));) {
            String req = "GET " + resource + " HTTP/1.1\n\n";
            socket.getOutputStream().write(req.getBytes(StandardCharsets.UTF_8));
            System.out.println(req);
            String resp = reader.readLine();
            // System.out.println(resp);
            while(resp != null) {
                resp = reader.readLine();
                // System.out.println(resp);
            }
        }
    }

    @Override
    public void close() {
        try {
            socket.close();
        } catch(IOException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) throws IOException {
        try(ClientHttp client = new ClientHttp(8080, "127.0.0.1")) {
            client.request("/index.html");
        }
    }

}
