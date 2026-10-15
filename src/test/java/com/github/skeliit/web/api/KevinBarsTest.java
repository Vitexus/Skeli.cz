package com.github.skeliit.web.api;

import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class KevinBarsTest {

    @Test
    void picksTwoNeighbouringRealLines() {
        String text = "Refrén:\nhledám sebe sám a nevím kde mám začít\nnevím, co vše ze mě zbylo, jestli jsem to ještě já\n\nkrátké";
        List<String> bars = KevinBarsServlet.pickBars(text);
        assertEquals(List.of("hledám sebe sám a nevím kde mám začít", "nevím, co vše ze mě zbylo, jestli jsem to ještě já"), bars);
    }

    @Test
    void takesAWholeVerseOrFourLinesOfALongOne() {
        String verse = "první řádek sloky je dlouhý\ndruhý řádek sloky je dlouhý\ntřetí řádek sloky je dlouhý";
        assertEquals(3, KevinBarsServlet.pickBars(verse).size(), "a short verse whole");
        StringBuilder longVerse = new StringBuilder();
        for (int i = 1; i <= 9; i++) longVerse.append("řádek číslo ").append(i).append(" dlouhé sloky\n");
        for (int k = 0; k < 20; k++) {
            List<String> bars = KevinBarsServlet.pickBars(longVerse.toString());
            assertEquals(4, bars.size(), "four lines of a long verse");
            assertTrue(bars.get(0).startsWith("řádek číslo 1 "), "no sentence ends inside: from the verse start: " + bars.get(0));
        }
    }

    @Test
    void skipsRepeatsLabelsAndEscapedNewlines() {
        assertTrue(KevinBarsServlet.pickBars("stejný řádek se opakuje\nstejný řádek se opakuje").isEmpty());
        assertTrue(KevinBarsServlet.pickBars("[Sloka 1]\nčtrnáct znaků a víc tady").isEmpty());
        assertEquals(2, KevinBarsServlet.pickBars("první řádek je dost dlouhý\\ndruhý řádek taky dost dlouhý").size());
        assertTrue(KevinBarsServlet.pickBars(null).isEmpty());
    }
}
