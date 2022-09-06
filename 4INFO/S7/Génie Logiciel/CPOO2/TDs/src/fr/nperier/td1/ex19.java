package fr.nperier.td1;

import java.util.function.Function;

public class ex19 {

    public static class Optional<T> {
        private final T val;

        private Optional(final T t) {
            val = t;
        }

        public static <T> Optional<T> empty() {
            return new Optional<>(null);
        }

        public static <T> Optional<T> of(final T t) {
            return new Optional<>(t);
        }

        public boolean isPresent() {
            return val != null;
        }

        public <R> Optional<R> map(Function<T, R> f) {
            return isPresent() ? Optional.of(f.apply(val)) : empty();
        }

        public T orElse(T t) {
            return isPresent() ? val : t;
        }
    }


    public static void main(String[] args) {
        Optional<String> foo = Optional.of(null); //of("foo");
        System.out.println(foo.isPresent() ? "Present !" : "Not present :(");
        System.out.println(foo.map(s -> s.indexOf('f')).orElse(-1));
    }

}
