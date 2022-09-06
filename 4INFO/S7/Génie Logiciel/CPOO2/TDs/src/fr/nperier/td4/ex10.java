package fr.nperier.td4;

// 1. Typage structurel
// 2. Car typage nominal
// 3. Adapteur

public class ex10 {

    public static void main(String[] args) {
        Loup l = new Loup();
        Canard c = new CosplayCanard(l);
        System.out.println(c.coincoin());
        System.out.println(c.danser());
        System.out.println(l.manger(null));
    }

    public interface Canard {
        String coincoin();
        String danser();
    }

    public static class Loup {
        public String coincoin() {
            return "COIN COIN OUUUUH";
        }
        public String danser() {
            return "¯\\_(ツ)_/¯";
        }
        public String manger(Canard c) {
            return "¯\\_(@@)_/¯";
        }
    }

    public static class CosplayCanard implements Canard {
        private final Loup loup;
        public CosplayCanard(Loup l) {
            loup = l;
        }
        public String coincoin() {
            return loup.coincoin();
        }
        public String danser() {
            return loup.danser();
        }
    }
}
