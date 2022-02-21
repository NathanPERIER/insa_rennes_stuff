package fr.nperier.s6.rezo.tp2;

import java.io.IOException;
import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.SocketException;
import java.util.Date;

public class ServeurUDP {

    private static DatagramSocket socket;

    public static void main(String[] args) throws SocketException {
        socket = new DatagramSocket(9090);
        Thread thread = new Thread(new ServerRunnable());
        thread.start();
    }


    private static class ServerRunnable implements Runnable {

        public void run() {
            while(true) {
                byte[] buffer = new byte[256];
                DatagramPacket packet = new DatagramPacket(buffer, buffer.length);
                try {
                    socket.receive(packet);
                } catch (IOException e) {
                    e.printStackTrace();
                    return;
                }
                System.out.println("[" + (new Date()) + "] Request from " + packet.getAddress() + " (port " + packet.getPort() + ")");

                DatagramPacket response = new DatagramPacket(buffer, buffer.length, packet.getAddress(), packet.getPort());

                try {
                    socket.send(response);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

    }

}
