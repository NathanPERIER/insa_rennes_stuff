package fr.nperier.td5;

import java.util.Arrays;
import java.util.Optional;

public class ex2 {

    public static void main(String[] args ) {
        System.out.println(CardColour.forString("HEART"));
        System.out.println(CardColour.forString("LOL"));
    }

    public enum CardColour {
        SPADE, CLUB, HEART, DIAMOND;
        public static Optional<CardColour> forString(String s) {
            return Arrays.stream(CardColour.values())
                    .filter(cc -> cc.name().equals(s))
                    .findFirst();
        }
    }
}
