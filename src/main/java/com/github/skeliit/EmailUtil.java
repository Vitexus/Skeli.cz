package com.github.skeliit;

import jakarta.mail.Message;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

/**
 * Utility class for sending emails using SMTP configuration from environment variables.
 */
public class EmailUtil {
    private static String getEnv(String key, String defaultValue) {
        return Config.get(key, defaultValue);
    }

    /** True when SMTP_HOST, SMTP_USERNAME and SMTP_PASSWORD are set, i.e. e-mails can go out. */
    public static boolean isConfigured() {
        return getEnv("SMTP_HOST", null) != null && getEnv("SMTP_USERNAME", null) != null
                && getEnv("SMTP_PASSWORD", null) != null;
    }

    /**
     * Sends an email using the SMTP configuration from environment variables.
     *
     * @param to      recipient email address
     * @param subject email subject
     * @param text    email body (plain text)
     * @throws Exception if email sending fails
     */
    public static void sendMail(String to, String subject, String text) throws Exception {
        sendMail(to, subject, text, null, null);
    }

    /**
     * Sends an e-mail with a plain-text and, when {@code html} is given, an HTML version (mail apps show the one
     * they can); {@code unsubscribeUrl} adds the List-Unsubscribe header (the app's own unsubscribe button).
     */
    public static void sendMail(String to, String subject, String text, String html, String unsubscribeUrl) throws Exception {
        if (to == null || to.isBlank()) return;
        
        String host = getEnv("SMTP_HOST", null);
        String user = getEnv("SMTP_USERNAME", null);
        String pass = getEnv("SMTP_PASSWORD", null);
        String port = getEnv("SMTP_PORT", "587");
        String from = getEnv("SMTP_FROM", user);
        String fromName = getEnv("SMTP_FROM_NAME", "Skeli");
        String encryption = getEnv("SMTP_ENCRYPTION", "tls");
        
        // Not configured - skip sending
        if (host == null || user == null || pass == null) return;
        
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.host", host);
        props.put("mail.smtp.port", port);
        
        if ("tls".equalsIgnoreCase(encryption)) {
            props.put("mail.smtp.starttls.enable", "true");
        } else if ("ssl".equalsIgnoreCase(encryption)) {
            props.put("mail.smtp.ssl.enable", "true");
        }
        
        Session session = Session.getInstance(props);
        MimeMessage msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(from, fromName));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        msg.setSubject(subject, "UTF-8");
        if (unsubscribeUrl != null) msg.setHeader("List-Unsubscribe", "<" + unsubscribeUrl + ">");
        if (html == null) {
            msg.setText(text);
        } else {
            jakarta.mail.internet.MimeMultipart alt = new jakarta.mail.internet.MimeMultipart("alternative");
            jakarta.mail.internet.MimeBodyPart plain = new jakarta.mail.internet.MimeBodyPart();
            plain.setText(text, "UTF-8");
            jakarta.mail.internet.MimeBodyPart rich = new jakarta.mail.internet.MimeBodyPart();
            rich.setContent(html, "text/html; charset=UTF-8");
            alt.addBodyPart(plain);
            alt.addBodyPart(rich);
            msg.setContent(alt);
        }
        
        Transport.send(msg, user, pass);
    }
}
