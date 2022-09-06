package fr.nperier.td1;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import static java.lang.Math.PI;

public class ex1 {

    public static class Collector{
        private final List<Exception> exceptions;
        private static final Collector COLLECTOR = new Collector();
        private Collector() {
            exceptions = new ArrayList<>();
        }
        public void logException(Exception e) {
            exceptions.add(e);
        }
        public List<Exception> getExceptions() {
            return new ArrayList<>(exceptions);
        }
        public static Collector getCollector() {
            return Collector.COLLECTOR;
        }
    }

    public static class Q1 {
        public URL toURL(String path) {
            URL url = null;
            try {
                url = new URL(path);
            } catch(MalformedURLException e) {
                Collector.getCollector().logException(e);
            }
            return url;
        }
    }


    public static class SomeMath {
        public static double toRadians(double deg) {
            return deg/180.0 * PI;
        }
    }

}
