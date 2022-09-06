package fr.nperier.td7;

import fr.nperier.td6.ex8;

import java.util.*;

public class ex3 {

    public static void main(String[] args) {
        List<String> l = singletonList("Bonjour");
        l.forEach(System.out::println);
    }

    public static <T> List<T> singletonList(T elt) {
        return new SingletonList<>(elt);
    }

    private static class SingletonList<T> implements List<T> {

        private final T elt;

        public SingletonList(T t) {
            elt = t;
        }

        @Override
        public int size() {
            return 1;
        }

        @Override
        public boolean isEmpty() {
            return false;
        }

        @Override
        public boolean contains(Object o) {
            if(o == null) {
                return elt == null;
            }
            return o.equals(elt);
        }

        @Override
        public Iterator<T> iterator() {
            return new Iterator<>(){
                private int i = 0;

                @Override
                public boolean hasNext() {
                    return i == 0;
                }

                @Override
                public T next() {
                    if(i==0) {
                        i++;
                        return elt;
                    }
                    throw new NoSuchElementException("SingletonList has only one element");
                }

                @Override
                public void remove() {

                }
            };
        }

        @Override
        public Object[] toArray() {
            return new Object[]{elt};
        }

        @Override
        public <T1> T1[] toArray(T1[] t1s) {
            if(t1s.length == 0) {
                return (T1[]) new Object[]{elt};
            }
            t1s[0] = (T1) elt;
            if(t1s.length > 1) {
                t1s[1] = null;
            }
            return t1s;
        }

        @Override
        public boolean add(T t) {
            throw new UnsupportedOperationException("SingletonList is not mutable");
        }

        @Override
        public boolean remove(Object o) {
            throw new UnsupportedOperationException("SingletonList is not mutable");
        }

        @Override
        public boolean containsAll(Collection<?> collection) {
            if(elt == null) {
                return collection.stream().allMatch(Objects::isNull);
            }
            return collection.stream().allMatch(elt::equals);
        }

        @Override
        public boolean addAll(Collection<? extends T> collection) {
            throw new UnsupportedOperationException("SingletonList is not mutable");
        }

        @Override
        public boolean addAll(int i, Collection<? extends T> collection) {
            throw new UnsupportedOperationException("SingletonList is not mutable");
        }

        @Override
        public boolean removeAll(Collection<?> collection) {
            throw new UnsupportedOperationException("SingletonList is not mutable");
        }

        @Override
        public boolean retainAll(Collection<?> collection) {
            throw new UnsupportedOperationException("SingletonList is not mutable");
        }

        @Override
        public void clear() {
            throw new UnsupportedOperationException("SingletonList is not mutable");
        }

        @Override
        public T get(int i) {
            if(i==0) {
                return elt;
            }
            throw new IndexOutOfBoundsException("SingletonList has only one element");
        }

        @Override
        public T set(int i, T t) {
            throw new UnsupportedOperationException("SingletonList is not mutable");
        }

        @Override
        public void add(int i, T t) {
            throw new UnsupportedOperationException("SingletonList is not mutable");
        }

        @Override
        public T remove(int i) {
            throw new UnsupportedOperationException("SingletonList is not mutable");
        }

        @Override
        public int indexOf(Object o) {
            if(o == null) {
                return (elt == null) ? 0 : -1;
            }
            return (o.equals(elt)) ? 0 : -1;
        }

        @Override
        public int lastIndexOf(Object o) {
            return indexOf(0);
        }

        @Override
        public ListIterator<T> listIterator() {
            return new ListIterator<>() {
                private int i = 0;

                @Override
                public boolean hasNext() {
                    return i == 0;
                }

                @Override
                public T next() {
                    if(i==0) {
                        i++;
                        return elt;
                    }
                    throw new IndexOutOfBoundsException("SingletonList has only one element");
                }

                @Override
                public boolean hasPrevious() {
                    return i == 1;
                }

                @Override
                public T previous() {
                    if(i==1) {
                        i--;
                        return elt;
                    }
                    return null;
                }

                @Override
                public int nextIndex() {
                    return i;
                }

                @Override
                public int previousIndex() {
                    return i-1;
                }

                @Override
                public void remove() {
                    throw new UnsupportedOperationException("SingletonList is not mutable");
                }

                @Override
                public void set(T t) {
                    throw new UnsupportedOperationException("SingletonList is not mutable");
                }

                @Override
                public void add(T t) {
                    throw new UnsupportedOperationException("SingletonList is not mutable");
                }
            };
        }

        @Override
        public ListIterator<T> listIterator(int i) {
            if(i > 0) {
                throw new IndexOutOfBoundsException("SingletonList has only one element");
            }
            return listIterator();
        }

        @Override
        public List<T> subList(int i, int j) {
            if(i == 0 && j == 1) {
                return List.of(elt);
            }
            if(i == 0 && j == 0) {
                return List.of();
            }
            throw new IndexOutOfBoundsException("SingletonList has only one element");
        }
    }

}
