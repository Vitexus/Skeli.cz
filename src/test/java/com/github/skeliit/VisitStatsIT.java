package com.github.skeliit;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/** The visit counter (VisitStats): signing in during a visit doesn't make a second person of the visitor. */
class VisitStatsIT extends UiTestSupport {
    private static int peopleToday() throws Exception {
        return queryInt("SELECT COUNT(*) FROM visit_days WHERE day = CURRENT_DATE");
    }

    @Test
    @DisplayName("Someone who signs in during the visit is still one person today")
    void signingInKeepsOnePerson() throws Exception {
        driver.get(BASE_URL + "/");
        Thread.sleep(3000);   // js/presence.js counts the page
        int before = peopleToday();
        registerAndLogin("vs" + uniq());   // the form (not signed in yet), then home signed in
        Thread.sleep(3000);
        assertEquals(before, peopleToday(), "the browser's count before signing in became the account's");
    }
}
