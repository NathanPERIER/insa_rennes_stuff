package fr.nperier.cpoo2.an2020.q10;


public class UnmutableListImpl<T> implements UnmutableList<T> {

    private final T[] tab;

    @SuppressWarnings("unchecked")
    protected UnmutableListImpl() {
        tab = (T[]) new Object[0];
    }

    @SuppressWarnings("unchecked")
    protected UnmutableListImpl(final List<T> l) {
        tab = (T[]) new Object[l.length()];
        for(int i = 0; i < l.length(); i++) {
            tab[i] = l.get(i);
        }
    }

    @SuppressWarnings("unchecked")
    protected UnmutableListImpl(final List<T> l, final T t) {
        tab = (T[]) new Object[l.length()+1];
        for(int i = 0; i < l.length(); i++) {
            tab[i] = l.get(i);
        }
        tab[l.length()] = t;
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
    public UnmutableList<T> add(final T t) {
        return new UnmutableListImpl<>(this, t);
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
