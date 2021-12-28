package fr.nperier.cpoo2.an2020.q10;

import java.util.function.BiConsumer;

public interface MutableList<T> extends List<T> {
    void add(final T t);
    void onNewElement(final BiConsumer<List<T>, T> f);

    default UnmutableList<T> toUnmutableList() {
        return new UnmutableListAdapter<>(this);
    }
}
