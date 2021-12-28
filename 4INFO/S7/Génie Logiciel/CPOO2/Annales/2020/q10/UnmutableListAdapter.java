package fr.nperier.cpoo2.an2020.q10;

public class UnmutableListAdapter<T> implements UnmutableList<T> {

    private final MutableList<T> list;

    public UnmutableListAdapter(MutableList<T> l) {
        list = l;
    }

    @Override
    public int length() {
        return list.length();
    }

    @Override
    public T get(final int i) {
        return list.get(i);
    }

    @Override
    public UnmutableList<T> add(final T t) {
        return new UnmutableListImpl<>(list, t);
    }


    @Override
    public String toString() {
        return list.toString();
    }
}
