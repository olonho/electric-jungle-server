package ejungle.manager;

import java.sql.*;
import javax.sql.*;
import java.io.*;

class DBDataSource implements javax.sql.DataSource {
    String user, pass;

    public DBDataSource() {
        user = "root";
        pass = "Maugli";
        try {
            Class.forName("com.mysql.jdbc.Driver");                
        } catch (Exception e) {
            //Manager.getInstance().reportError(e);            
            e.printStackTrace(); // infinite recursion possible
        }
    }

    public Connection getConnection() throws SQLException {
        return getConnection(user, pass);
    }

    public Connection getConnection(String user, String pass) throws SQLException {
        return DriverManager.getConnection("jdbc:mysql://localhost/ejungle", user, pass);
    }
    
    public int getLoginTimeout() {
        return 1;
    }

    public PrintWriter getLogWriter() {
        return null;
    }
     
    public void setLoginTimeout(int to) {
        return;
    }

    public void setLogWriter(PrintWriter pw) {
        return;
    }          

    public boolean isWrapperFor(Class iface) throws SQLException {
        return false;
    }
    
    public Object unwrap(Class iface) {
        return null;
    }
}
