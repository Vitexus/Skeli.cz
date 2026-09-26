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

    /**
     * Sends an email using the SMTP configuration from environment variables.
     *
     * @param to      recipient email address
     * @param subject email subject
     * @param text    email body (plain text)
     * @throws Exception if email sending fails
     */
    public static void sendMail(String to, String subject, String text) throws Exception {
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
        Message msg = new MimeMessage(session);
        msg.setFrom(new InternetAddress(from, fromName));
        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
        msg.setSubject(subject);
        msg.setText(text);
        
        Transport.send(msg, user, pass);
    }
}
