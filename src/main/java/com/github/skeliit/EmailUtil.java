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
        
        String host = System.getenv("SMTP_HOST");
        String user = System.getenv("SMTP_USERNAME");
        String pass = System.getenv("SMTP_PASSWORD");
        String port = System.getenv("SMTP_PORT");
        if (port == null) port = "587";
        
        String from = System.getenv("SMTP_FROM");
        if (from == null) from = user;
        
        String fromName = System.getenv("SMTP_FROM_NAME");
        if (fromName == null) fromName = "Skeli";
        
        String encryption = System.getenv("SMTP_ENCRYPTION");
        if (encryption == null) encryption = "tls";
        
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
