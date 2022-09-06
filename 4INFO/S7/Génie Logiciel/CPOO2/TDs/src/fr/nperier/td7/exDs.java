package fr.nperier.td7;

public class exDs {

    public static void main(String[] args) {
        AntiBucheronChene builder = new AntiBucheronChene();
        System.out.println(
                builder.avecFeuilles().age(10).taille(20).planter()
        );
    }

    public static abstract class Arbre {
        protected int age;
        protected int taille;

        public Arbre(int a, int t) {
            age = a;
            taille = t;
        }
    }

    public static class Chene extends Arbre {
        private final boolean feuilles;

        public Chene(int a, int t, boolean f) {
            super(a, t);
            feuilles = f;
        }

        @Override
        public String toString() {
            return "Chêne : " + age + " an" + (age > 1 ? "s" : "") + ", " + taille + " m, " + (feuilles ? "avec" : "sans") + " feuilles";
        }
    }

    public static class Pin extends Arbre {
        private final int cones;

        public Pin(int a, int t, int c) {
            super(a, t);
            cones = c;
        }

        @Override
        public String toString() {
            return "Chêne : " + age + " an" + (age > 1 ? "s" : "") + ", " + taille + " m, " + cones + " cone" + (cones > 1 ? "s" : "");
        }
    }

    public static abstract class AntiBucheron<T extends Arbre> {

        protected int age, taille;

        public AntiBucheron() {
            age = 1;
            taille = 1;
        }

        public AntiBucheron<T> age(int a) {
            age = a;
            return this;
        }

        public AntiBucheron<T> taille(int t) {
            taille = t;
            return this;
        }

        public abstract T planter();
    }

    public static class AntiBucheronChene extends AntiBucheron<Chene> {


        private boolean feuilles;

        public AntiBucheronChene() {
            super();
            feuilles = false;
        }

        public AntiBucheronChene avecFeuilles() {
            feuilles = true;
            return this;
        }

        public AntiBucheronChene sansFeuilles() {
            feuilles = false;
            return this;
        }

        public Chene planter() {
            return new Chene(age, taille, feuilles);
        }

    }

}
