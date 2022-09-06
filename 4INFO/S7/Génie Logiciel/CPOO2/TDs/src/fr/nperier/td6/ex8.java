package fr.nperier.td6;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.Random;

public class ex8 {

    public static void main(String[] args) {
        GenericFactory f = new GenericFactory();
        f.addClassToBuild(A.class, 3);
        f.addClassToBuild(B.class, 2);
        f.addClassToBuild(Integer.class, 0);
        System.out.println(f.createInstance(A.class));
        System.out.println(f.createInstance(A.class));
        System.out.println(f.createInstance(B.class));
        System.out.println(f.createInstance(B.class));
        System.out.println(f.createInstance(B.class));
        System.out.println(f.createInstance(String.class));
        System.out.println(f.createInstance(Integer.class));
    }


    public static class GenericFactory {
        private final Map<String, Object[]> instances;
        private static final Random RAND = new Random();

        public GenericFactory() {
            instances = new HashMap<>();
        }

        public void addClassToBuild(Class<?> clazz, int quota) {
            instances.put(clazz.getCanonicalName(), new Object[quota]);
        }

        public <T> Optional<T> createInstance(Class<T> clazz) {
            String class_name = clazz.getCanonicalName();
            if(!instances.containsKey(class_name) || instances.get(class_name).length == 0) {
                return Optional.empty();
            }
            Object[] arr = instances.get(class_name);
            for(int i = 0; i < arr.length; i++) {
                if(arr[i] == null) {
                    try {
                        arr[i] = clazz.getConstructor().newInstance();
                    } catch(NoSuchMethodException | IllegalAccessException | InvocationTargetException | InstantiationException e) {
                        e.printStackTrace();
                        return Optional.empty();
                    }
                    return Optional.of((T)arr[i]);
                }
            }
            return Optional.of((T)arr[RAND.nextInt(arr.length)]);
        }
    }


    public static class Factory {
        private final Map<String, Object[]> instances;
        private static final Random RAND = new Random();

        public Factory() {
            instances = new HashMap<>();
        }

        public void addClassToBuild(Class<?> clazz, int quota) {
            System.out.println(clazz.getCanonicalName());
            instances.put(clazz.getCanonicalName(), new Object[quota]);
        }

        public Optional<Object> createInstance(Class<?> clazz) {
            String class_name = clazz.getCanonicalName();
            if(!instances.containsKey(class_name) || instances.get(class_name).length == 0) {
                return Optional.empty();
            }
            Object[] arr = instances.get(class_name);
            for(int i = 0; i < arr.length; i++) {
                if(arr[i] == null) {
                    try {
                        arr[i] = clazz.getConstructor().newInstance();
                    } catch(NoSuchMethodException | IllegalAccessException | InvocationTargetException | InstantiationException e) {
                        e.printStackTrace();
                        return Optional.empty();
                    }
                    return Optional.of(arr[i]);
                }
            }
            return Optional.of(arr[RAND.nextInt(arr.length)]);
        }
    }


    public static class A {
        private static int CPT = 0;
        private final int id;

        public A() {
            id = ++CPT;
        }

        public String toString() {
            return "A" + id;
        }
    }

    public static class B {
        private static int CPT = 0;
        private final int id;

        public B() {
            id = ++CPT;
        }

        public String toString() {
            return "B" + id;
        }
    }

}
