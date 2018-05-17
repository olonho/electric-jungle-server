package ejungle.web;

import java.sql.*;
import javax.sql.*;
import javax.naming.*;

public class DB {
    private static DataSource ds;
    private static int openConnections = 0;

    static {
        ds = ejungle.manager.Manager.getInstance().getDBDataSource();
    }

    private static void setParameters(PreparedStatement stmt, Object ... args)
        throws SQLException
    {
        if (args != null) {
            for (int i = 0; i < args.length; i++) {
                stmt.setObject(i + 1, args[i]);
            }
        }
    }
    
    public static ResultSet query(String format, Object ... args)
        throws SQLException
    {
        openConnections++;
        Connection conn = ds.getConnection();
        PreparedStatement stmt = conn.prepareStatement(format);
        setParameters(stmt, args);
        return stmt.executeQuery();
    }

    public static int update(String format, Object ... args)
        throws SQLException
    {
        Connection conn = ds.getConnection();
        PreparedStatement stmt = conn.prepareStatement(format);
        setParameters(stmt, args);
        try {
            return stmt.executeUpdate();
        } finally {
            stmt.close();
            conn.close();
        }
    }

    public static int insertID(String format, Object ... args)
        throws SQLException
    {
        Connection conn = ds.getConnection();
        PreparedStatement stmt = conn.prepareStatement(format);
        setParameters(stmt, args);
        try {
            stmt.executeUpdate();
            ResultSet rs = stmt.executeQuery("SELECT LAST_INSERT_ID()");
            int result = rs.next() ? rs.getInt(1) : -1;
            rs.close();
            return result;
        } finally {
            stmt.close();
            conn.close();
        }
    }

    public static void close(ResultSet rs) {
        openConnections--;
        try {
            Statement stmt = rs != null ? rs.getStatement() : null;
            Connection conn = stmt != null ? stmt.getConnection() : null;
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {}
    }

    public static Statement getStatement() throws SQLException {
        openConnections++;
        return ds.getConnection().createStatement();
    }

    public static void closeStatement(Statement stmt) throws SQLException {
        openConnections--;
        if (stmt != null) {
            Connection conn = stmt.getConnection();
            stmt.close();
            if (conn != null) conn.close();
        }
    }

    public static int getOpenConnections() {
        return openConnections;
    }

}
