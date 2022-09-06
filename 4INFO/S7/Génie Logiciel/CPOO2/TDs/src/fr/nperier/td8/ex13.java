package fr.nperier.td8;

import java.util.ArrayDeque;
import java.util.Deque;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class ex13 {

    public static void main(final String[] args) {
        Noeud n = new NoeudPlus(
                new NoeudMoins(
                        new NoeudPlus(new NoeudValeur(3), new NoeudValeur(2)),
                        new NoeudPlus(new NoeudValeur(1), new NoeudValeur(1))
                ),
                new NoeudMoins(new NoeudValeur(8), new NoeudValeur(4))
        );
        Arbre a = new Arbre("Gaston", n);
        List<VisiteurArbre> visiteurs = List.of(new PostfixVisiteur(), new ComputeVisiteur(), new XmlVisiteur());
        for(VisiteurArbre v: visiteurs) {
            a.accept(v);
            v.printResult();
            System.out.println();
        }
    }

    public interface Noeud {
        void accept(VisiteurArbre va);
    }

    public static class NoeudPlus implements Noeud {
        private final Noeud gauche, droite;

        public NoeudPlus(Noeud g, Noeud d) {
            gauche = g;
            droite = d;
        }

        public void accept(VisiteurArbre va) {
            gauche.accept(va);
            droite.accept(va);
            va.visiteNoeudPlus(this);
        }
    }

    public static class NoeudMoins implements Noeud {
        private final Noeud gauche, droite;

        public NoeudMoins(Noeud g, Noeud d) {
            gauche = g;
            droite = d;
        }

        public void accept(VisiteurArbre va) {
            gauche.accept(va);
            droite.accept(va);
            va.visiteNoeudMoins(this);
        }
    }

    public static class NoeudValeur implements Noeud {
        private final int val;

        public NoeudValeur(int i) {
            val = i;
        }

        public void accept(VisiteurArbre va) {
            va.visiteNoeudValeur(this);
        }

        public int getVal() {
            return val;
        }
    }

    public static class Arbre {
        private final Noeud racine;
        private final String name;

        public Arbre(String n, Noeud r) {
            racine = r;
            name = n;
        }

        public void accept(VisiteurArbre va) {
            va.visiteArbre(this);
            racine.accept(va);
        }

        public String getName() {
            return name;
        }
    }


    public interface VisiteurArbre {
        void visiteArbre(Arbre a);
        void visiteNoeudPlus(NoeudPlus n);
        void visiteNoeudMoins(NoeudMoins n);
        void visiteNoeudValeur(NoeudValeur n);
        void printResult();
    }

    public static class PostfixVisiteur implements VisiteurArbre {

        private StringBuilder res;

        @Override
        public void visiteArbre(Arbre a) {
            res = new StringBuilder(a.getName() + " :");
        }

        @Override
        public void visiteNoeudPlus(NoeudPlus n) {
            res.append(" +");
        }

        @Override
        public void visiteNoeudMoins(NoeudMoins n) {
            res.append(" -");
        }

        @Override
        public void visiteNoeudValeur(NoeudValeur n) {
            res.append(" ").append(n.getVal());
        }

        @Override
        public void printResult() {
            System.out.println(res.toString());
        }
    }


    public static class ComputeVisiteur implements VisiteurArbre {

        private String name;
        private final Deque<Integer> stack;

        public ComputeVisiteur() {
            stack = new ArrayDeque<>();
        }

        @Override
        public void visiteArbre(Arbre a) {
            name = a.getName();
        }

        @Override
        public void visiteNoeudPlus(NoeudPlus n) {
            int i1 = stack.removeLast();
            int i2 = stack.removeLast();
            // System.out.println(i1 + " + " + i2);
            stack.addLast(i1 + i2);
        }

        @Override
        public void visiteNoeudMoins(NoeudMoins n) {
            int i1 = stack.removeLast();
            int i2 = stack.removeLast();
            // System.out.println(i2 + " - " + i1);
            stack.addLast(i2 - i1);
        }

        @Override
        public void visiteNoeudValeur(NoeudValeur n) {
            stack.addLast(n.getVal());
        }

        @Override
        public void printResult() {
            if(stack.size() != 1) {
                System.err.println("The stack has an incorrect number of elements " + stack);
            }
            System.out.println(name + " : " + stack.getLast());
        }
    }


    public static class XmlVisiteur implements VisiteurArbre {

        private final Deque<List<String>> stack;
        private String name;

        public XmlVisiteur() {
            stack = new ArrayDeque<>();
        }

        @Override
        public void visiteArbre(Arbre a) {
            stack.clear();
            name = a.getName();
        }

        @Override
        public void visiteNoeudPlus(NoeudPlus n) {
            List<String> l1 = stack.removeLast();
            List<String> l2 = stack.removeLast();
            List<String> l = Stream.concat(l2.stream(), l1.stream())
                    .map(s -> "\t" + s)
                    .collect(Collectors.toList());
            l.add(0, "\t<plus>");
            l.add("\t</plus>");
            stack.addLast(l);
        }

        @Override
        public void visiteNoeudMoins(NoeudMoins n) {
            List<String> l1 = stack.removeLast();
            List<String> l2 = stack.removeLast();
            List<String> l = Stream.concat(l2.stream(), l1.stream())
                    .map(s -> "\t" + s)
                    .collect(Collectors.toList());
            l.add(0, "\t<moins>");
            l.add("\t</moins>");
            stack.addLast(l);
        }

        @Override
        public void visiteNoeudValeur(NoeudValeur n) {
            stack.addLast(List.of("\t<value val=\"" + n.getVal() + "\"/>"));
        }

        @Override
        public void printResult() {
            System.out.println("<formula name=\""+ name + "\">");
            for(String s : stack.getFirst()) {
                System.out.println(s);
            }
            System.out.println("</formula>");
        }
    }

}