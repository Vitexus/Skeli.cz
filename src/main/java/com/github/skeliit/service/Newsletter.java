package com.github.skeliit.service;

import com.github.skeliit.Db;
import com.github.skeliit.EmailUtil;
import com.github.skeliit.WebUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * News by e-mail: the e-mail itself (text and HTML in the site's look, an optional clip with its thumbnail, the
 * unsubscribe link) and sending it to every confirmed subscriber one after another in the background, so the
 * admin page does not wait. Each issue is kept in newsletter_issues with how many went out.
 */
public final class Newsletter {
    private Newsletter() {}

    private static final ExecutorService SENDER = Executors.newSingleThreadExecutor(r -> {
        Thread t = new Thread(r, "newsletter");
        t.setDaemon(true);
        return t;
    });

    public static final class Issue {
        public final int id; public final String subject; public final Timestamp created, finished; public final int total, sent, failed;
        Issue(int id, String subject, Timestamp created, Timestamp finished, int total, int sent, int failed) {
            this.id = id; this.subject = subject; this.created = created; this.finished = finished;
            this.total = total; this.sent = sent; this.failed = failed;
        }
        public int getId() { return id; }
        public String getSubject() { return subject; }
        public Timestamp getCreated() { return created; }
        public boolean isFinished() { return finished != null; }
        public int getTotal() { return total; }
        public int getSent() { return sent; }
        public int getFailed() { return failed; }
    }

    /** The confirmed subscribers who have not left: {e-mail, unsubscribe token} */
    public static List<String[]> recipients() throws SQLException {
        List<String[]> out = new ArrayList<>();
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(
                "SELECT email, unsubscribe_token FROM newsletter_emails WHERE confirmed_at IS NOT NULL AND unsubscribed_at IS NULL ORDER BY id");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) out.add(new String[] { rs.getString(1), rs.getString(2) });
        }
        return out;
    }

    public static List<Issue> issues() throws SQLException {
        List<Issue> out = new ArrayList<>();
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(
                "SELECT id, subject, created_at, finished_at, total, sent, failed FROM newsletter_issues ORDER BY id DESC LIMIT 30");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) out.add(new Issue(rs.getInt(1), rs.getString(2), rs.getTimestamp(3), rs.getTimestamp(4), rs.getInt(5), rs.getInt(6), rs.getInt(7)));
        }
        return out;
    }

    /** Sends one copy (a test for the admin); the unsubscribe link in it goes nowhere. */
    public static void sendTest(String to, String subject, String body, String youtubeId, String clipTitle) throws Exception {
        EmailUtil.sendMail(to, "[TEST] " + subject, text(body, youtubeId, null), html(subject, body, youtubeId, clipTitle, null), null);
    }

    /** Records the issue and sends it to all subscribers in the background; returns how many it goes to. */
    public static int sendToAll(String subject, String body, String youtubeId, String clipTitle) throws SQLException {
        List<String[]> to = recipients();
        int id;
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(
                "INSERT INTO newsletter_issues (subject, body, youtube_id, total) VALUES (?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, subject); ps.setString(2, body); ps.setString(3, youtubeId); ps.setInt(4, to.size());
            ps.executeUpdate();
            try (ResultSet k = ps.getGeneratedKeys()) { k.next(); id = k.getInt(1); }
        }
        SENDER.submit(() -> {
            int sent = 0, failed = 0;
            for (String[] r : to) {
                String unsub = WebUtils.baseUrl() + "/newsletter/unsubscribe?token=" + r[1];
                try {
                    EmailUtil.sendMail(r[0], subject, text(body, youtubeId, unsub), html(subject, body, youtubeId, clipTitle, unsub), unsub);
                    sent++;
                } catch (Exception e) {
                    failed++;
                }
                progress(id, sent, failed, false);
                try { Thread.sleep(400); } catch (InterruptedException ie) { Thread.currentThread().interrupt(); break; }   // gently, mail servers don't like bursts
            }
            progress(id, sent, failed, true);
        });
        return to.size();
    }

    private static void progress(int id, int sent, int failed, boolean done) {
        try (Connection c = Db.get(); PreparedStatement ps = c.prepareStatement(
                "UPDATE newsletter_issues SET sent = ?, failed = ?" + (done ? ", finished_at = NOW()" : "") + " WHERE id = ?")) {
            ps.setInt(1, sent); ps.setInt(2, failed); ps.setInt(3, id);
            ps.executeUpdate();
        } catch (SQLException ignored) {
            // the count only shows progress in the admin
        }
    }

    static String clipUrl(String youtubeId) { return WebUtils.baseUrl() + "/music.jsp?clip=" + youtubeId; }

    /** The plain-text version. */
    static String text(String body, String youtubeId, String unsubscribeUrl) {
        StringBuilder b = new StringBuilder(body.strip()).append("\n\n");
        if (youtubeId != null) b.append("▶ ").append(clipUrl(youtubeId)).append("\n\n");
        b.append("Skeli · ").append(WebUtils.baseUrl()).append("\n");
        if (unsubscribeUrl != null) b.append("\nOdhlásit odběr novinek: ").append(unsubscribeUrl).append("\n");
        return b.toString();
    }

    /** The HTML version: dark, gold, simple tables (what every mail app understands). */
    static String html(String subject, String body, String youtubeId, String clipTitle, String unsubscribeUrl) {
        String base = WebUtils.baseUrl();
        StringBuilder paras = new StringBuilder();
        for (String p : body.strip().split("\\n\\s*\\n")) {
            paras.append("<p style=\"margin:0 0 16px;font-size:16px;line-height:1.6;color:#e8e8ea\">")
                    .append(WebUtils.escapeHtml(p.strip()).replace("\n", "<br>")).append("</p>");
        }
        String clip = "";
        if (youtubeId != null) {
            String url = WebUtils.escapeHtml(clipUrl(youtubeId));
            clip = "<a href=\"" + url + "\" style=\"display:block;margin:8px 0 18px;text-decoration:none\">"
                    + "<img src=\"https://i.ytimg.com/vi/" + WebUtils.escapeHtml(youtubeId) + "/hqdefault.jpg\" width=\"520\" alt=\""
                    + WebUtils.escapeHtml(clipTitle == null ? "" : clipTitle) + "\" style=\"display:block;width:100%;max-width:520px;border-radius:12px;border:1px solid #6b5313\"></a>"
                    + "<a href=\"" + url + "\" style=\"display:inline-block;padding:12px 26px;border-radius:999px;background:#e6b730;color:#141414;"
                    + "font-weight:bold;font-size:15px;text-decoration:none\">▶ Pustit si to</a>";
        }
        String unsub = unsubscribeUrl == null ? "" : "<br><a href=\"" + WebUtils.escapeHtml(unsubscribeUrl)
                + "\" style=\"color:#8a8a90\">Odhlásit odběr novinek</a>";
        return "<!doctype html><html lang=\"cs\"><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width\">"
                + "<title>" + WebUtils.escapeHtml(subject) + "</title></head>"
                + "<body style=\"margin:0;padding:0;background:#0b0b0d;font-family:Arial,Helvetica,sans-serif\">"
                + "<table role=\"presentation\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"background:#0b0b0d\"><tr><td align=\"center\" style=\"padding:28px 12px\">"
                + "<table role=\"presentation\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" style=\"max-width:560px;background:#141416;border:1px solid #3a2f12;border-radius:16px\">"
                + "<tr><td style=\"padding:26px 22px 8px;text-align:center\"><a href=\"" + WebUtils.escapeHtml(base) + "\" style=\"text-decoration:none;color:#e6b730;"
                + "font-size:24px;letter-spacing:4px;font-weight:bold\">SKELO SQUAD</a></td></tr>"
                + "<tr><td style=\"padding:8px 24px 6px\"><h1 style=\"margin:0 0 16px;font-size:22px;line-height:1.3;color:#ffffff\">" + WebUtils.escapeHtml(subject) + "</h1>"
                + paras + clip + "</td></tr>"
                + "<tr><td style=\"padding:22px 24px 26px;font-size:12px;line-height:1.6;color:#8a8a90;text-align:center\">"
                + "Tenhle e-mail ti přišel, protože odebíráš novinky z <a href=\"" + WebUtils.escapeHtml(base) + "\" style=\"color:#e6b730\">skeli.cz</a>." + unsub
                + "</td></tr></table></td></tr></table></body></html>";
    }
}
