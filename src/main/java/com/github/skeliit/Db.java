package com.github.skeliit;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class Db {
    private static final String URL = "jdbc:mariadb://localhost:3306/skeliweb?useUnicode=true&characterEncoding=utf8mb4";
    private static final String USER = "Skeli";
    private static final String PASS = "skeli";
    private Db() {}
    public static Connection get() throws SQLException { return DriverManager.getConnection(URL, USER, PASS); }
}
