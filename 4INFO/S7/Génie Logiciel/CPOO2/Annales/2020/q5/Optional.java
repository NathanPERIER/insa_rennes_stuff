package fr.nperier.cpoo2.an2020.q5;

import java.util.List;
import java.util.function.Function;

public class Optional<T> {

    private final T val;

    private Optional(final T t) {
        val = t;
    }

    public static <V> Optional<V> ofNullable(final V v) {
        return new Optional<>(v);
    }

    public static <V> Optional<V> empty() {
        return new Optional<>(null);
    }

    public boolean isPresent() {
        return val != null;
    }

    public T orElse(T t) {
        return isPresent() ? val : t;
    }

    public <V> Optional<V> map(final Function<T, V> f) {
        return isPresent() ? Optional.ofNullable(f.apply(val)) : Optional.empty();
    }

    
    public static void main(final String[] args) {
        for(String s : new String[]{"Hello", null}) {
            Optional<String> opt = Optional.ofNullable(s);
            System.out.println(opt.isPresent() ? "Present" : "Not present");
            System.out.println(opt.map(str -> str + " !").orElse("[empty]"));
            System.out.println();
        }
    }
}
