package fr.nperier.td2;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class exDs {

    public static void main(String[] args) {
        List<String> l = List.of("aa", "llll", "bonjour", "lol", "mdr");
        System.out.println(bar(l));
        System.out.println(foo(l));
    }


    public static String bar_stupid(final List<String> data) {
        final int size = data.size();
        String result = null;
        int i = 0;
        while(result == null && i < size) {
            if(data.get(i).length() == 3) {
                result = data.get(i);
            }
            i++;
        }
        if(result == null) {
            result = "foo";
        }
        return result;
    }

    public static String bar(final List<String> data) {
        return data.stream().filter(s -> s.length() == 3).findFirst().orElse("foo");
    }


    public static List<Integer> foo_stupid(List<String> data) {
        final List<Integer> sizes = new ArrayList<>();
        for(final String str: data) {
            sizes.add(str.length());
        }
        return sizes;
    }

    public static List<Integer> foo(List<String> data) {
        return data.stream().map(String::length).collect(Collectors.toList());
    }

}
