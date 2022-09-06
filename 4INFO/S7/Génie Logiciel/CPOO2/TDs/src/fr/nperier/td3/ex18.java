package fr.nperier.td3;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

public class ex18 {

    public static void main(String[] args) {
        Injector injector = new Injector();
        Optional<B> b = injector.getInstance(B.class);
        System.out.println("Class B : " + (b.isPresent() ? "ok" : "nope"));
        Optional<A> a = injector.getInstance(A.class);
        System.out.println("Class A : " + (a.isPresent() && a.get().b != null ? "ok" : "nope"));
        Optional<C> c = injector.getInstance(C.class);
        System.out.println("Class C : " + (c.isPresent() && c.get().a != null && c.get().a.b != null ? "ok" : "nope"));
        Optional<F> f = injector.getInstance(F.class);
        System.out.println("Class F : " + (f.isPresent() && f.get().e != null && f.get().e.f == null ? "ok" : "nope"));
    }

    public static class Injector {

        public <T> Optional<T> getInstance(Class<T> tClass) {
            return getInstance(tClass, new ArrayList<>());
        }

        public <T> Optional<T> getInstance(Class<T> tClass, List<Class<?>> classes) {
            T t;
            if(classes.contains(tClass)) {
                System.out.println("Loop detected");
                return Optional.empty();
            }
            List<Class<?>> finalClasses = new ArrayList<>(classes);
            finalClasses.add(tClass);
            try {
                t = tClass.getConstructor().newInstance();
            } catch (InstantiationException | IllegalAccessException | InvocationTargetException | NoSuchMethodException e) {
                return Optional.empty();
            }
            Arrays.stream(t.getClass().getDeclaredFields())
                    .filter(f -> !f.getType().isPrimitive() && f.canAccess(t) && f.isAnnotationPresent(Inject.class))
                    .forEach(f -> {
                        try {
                            f.set(t, getInstance(f.getType(), finalClasses).orElse(null));
                        } catch (IllegalAccessException ignored) {}
                    });
            return Optional.of(t);
        }

    }

    @Retention(RetentionPolicy.RUNTIME)
    public @interface Inject {}

    public static class A {
        @Inject
        B b;
    }

    public static class B {}

    public static class C {
        @Inject
        A a;
    }

    public static class E {
        @Inject
        F f;
    }

    public static class F {
        @Inject
        E e;
    }

}
