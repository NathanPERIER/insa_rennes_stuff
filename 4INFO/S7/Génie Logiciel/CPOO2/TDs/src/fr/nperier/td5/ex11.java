package fr.nperier.td5;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.function.BiFunction;
import java.util.function.Supplier;

public class ex11 {
    private static final Map<String, Supplier<ExpressionArithm>> FUNCTIONS;

    static {
        FUNCTIONS = new HashMap<>();
        FUNCTIONS.put("mult", () -> (a,b) -> a*b);
        FUNCTIONS.put("plus", () -> Integer::sum);
        FUNCTIONS.put("min",  () -> (a,b) -> a>b ? b : a);
        FUNCTIONS.put("mod",  () -> (a,b) -> a%b);
    }

    public static void main(String[] args) {
        System.out.println("5 * 4 = " + createExpr("mult").map(expr -> expr.apply(5, 4)).orElse(0));
        System.out.println(createExpr("lol").map(expr -> expr.apply(5, 4)));
    }

    public static Optional<ExpressionArithm> createExpr(String s) {
        return Optional.ofNullable(FUNCTIONS.get(s)).map(Supplier::get);
    }

    public interface ExpressionArithm extends BiFunction<Integer, Integer, Integer> {}

}
