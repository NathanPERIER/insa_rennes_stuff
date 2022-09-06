package fr.nperier.td2;

import java.util.ArrayDeque;
import java.util.Deque;

public class ex7 {

    // Q1
    // Commandes pour l'undoable (pour défaire et refaire)
    //

    public static void main(String[] args) {
        UndoRedoCollector urc = new UndoRedoCollector();
        urc.add(new MyUndoable("aaa"));
        urc.add(new MyUndoable("bbb"));
        urc.add(new MyUndoable("ccc"));
        urc.undo();
        urc.undo();
        urc.redo();
        urc.add(new MyUndoable("ddd"));
        urc.add(new MyUndoable("eee"));
        urc.redo();
        urc.undo();
        urc.redo();
        urc.undo();
        urc.undo();
    }


    // Q2

    public static class Undoable {

        private final Runnable undoFunction;
        private final Runnable redoFunction;

        public Undoable(Runnable u, Runnable r) {
            undoFunction = u;
            redoFunction = r;
        }

        public void undo() {
            undoFunction.run();
        }

        public void redo() {
            redoFunction.run();
        }
    }

    public static class MyUndoable extends Undoable {

        public MyUndoable(String name) {
            super(
                    () -> System.out.println(name + " undone"),
                    () -> System.out.println(name + " redone")
            );
        }

    }

    public static class UndoRedoCollector {
        private final Deque<Undoable> done;
        private final Deque<Undoable> undone;
        private final int maxLen;

        public UndoRedoCollector() {
            this(100);
        }

        public UndoRedoCollector(int max) {
            done = new ArrayDeque<>();
            undone = new ArrayDeque<>();
            maxLen = max;
        }

        public void add(Undoable u) {
            done.addFirst(u);
            undone.clear();
            if(done.size() > maxLen) {
                done.removeLast();
            }
        }

        public void undo() {
            if(!done.isEmpty()) {
                Undoable u = done.removeFirst();
                u.undo();
                undone.addFirst(u);
            }
        }

        public void redo() {
            if(!undone.isEmpty()) {
                Undoable u = undone.removeFirst();
                u.redo();
                done.addFirst(u);
            }
        }
    }

}
