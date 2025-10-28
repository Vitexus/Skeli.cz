package com.github.skeliit;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;

public class DbInit implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            System.out.println("[DbInit] Loaded org.mariadb.jdbc.Driver");
        } catch (Throwable t) {
            System.out.println("[DbInit] MariaDB driver not found: " + t.getMessage());
        }
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("[DbInit] Loaded com.mysql.cj.jdbc.Driver");
        } catch (Throwable t) {
            System.out.println("[DbInit] MySQL driver not found: " + t.getMessage());
        }
    }
}
