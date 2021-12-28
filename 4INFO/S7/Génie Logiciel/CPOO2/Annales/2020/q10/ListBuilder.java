package fr.nperier.cpoo2.an2020.q10;

public class ListBuilder {
    private static final UnmutableList<?> EMPTY_UNMUTABLE = new UnmutableListImpl<>();

    @SuppressWarnings("unchecked")
    public <T> UnmutableList<T> emptyUnmutableList() {
        return (UnmutableList<T>) EMPTY_UNMUTABLE;
    }

    public <T> MutableList<T> emptyMutableList() {
        return new MutableListImpl<>();
    }


    public static void main(final String[] args) {
        ListBuilder builder = new ListBuilder();
        UnmutableList<String> ul1 = builder.emptyUnmutableList();
        System.out.println("ul1 : " + ul1);
        UnmutableList<String> ul2 = ul1.add("Hello");
        System.out.println("ul2 : " + ul2);
        UnmutableList<String> ul3 = ul2.add("Bonjour");
        System.out.println("ul3 : " + ul3);

        System.out.println("======================");

        MutableList<Integer> ml1  = builder.emptyMutableList();
        System.out.println("ml1 : " + ml1);
        ml1.add(1);
        ml1.add(2);
        System.out.println("ml1 : " + ml1);
        UnmutableList<Integer> ul4 = ml1.toUnmutableList();
        System.out.println("ul4 : " + ul4);
        UnmutableList<Integer> ul5 = ul4.add(3).add(4);
        System.out.println("ul5 : " + ul5);
        System.out.println("ml1 : " + ml1);
    }
}
