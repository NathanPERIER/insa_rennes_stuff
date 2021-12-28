package fr.nperier.cpoo2.an2020.q10;

import java.util.function.BiConsumer;

public class MutableListImpl<T> implements MutableList<T> {

    private T[] tab;
    private final UnmutableList<BiConsumer<List<T>, T>> fcts;

    @SuppressWarnings("unchecked")
    protected MutableListImpl() {
        tab = (T[]) new Object[0];
        fcts = new UnmutableListImpl<>();
    }

    @Override
    public int length() {
        return tab.length;
    }

    @Override
    public T get(final int i) {
        return tab[i];
    }

    @Override
    @SuppressWarnings("unchecked")
    public void add(final T t) {
        //tab = Arrays.add(tab, t); (n'existe pas pour de vrai en java 11)
        final T[] temp = (T[]) new Object[tab.length+1];
        System.arraycopy(tab, 0, temp, 0, tab.length);
        temp[tab.length] = t;
        tab = temp;
        for(int i = 0; i < fcts.length(); i++) {
            fcts.get(i).accept(this, t);
        }
    }

    @Override
    public void onNewElement(final BiConsumer<List<T>, T> f) {
        fcts.add(f);
    }


    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder("[");
        if(tab.length > 0) {
            builder.append(tab[0]);
            for(int i = 1; i < tab.length; i++) {
                builder.append(", ").append(tab[i]);
            }
        }
        return builder.append("]").toString();
    }
}
