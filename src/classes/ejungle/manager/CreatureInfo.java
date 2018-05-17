package ejungle.manager;

import java.sql.*;

class CreatureInfo {
    String mainClass, owner, jar;
    int group;
    
    CreatureInfo(ResultSet rs) throws SQLException {
        mainClass = rs.getString(4);
        owner =  rs.getString(5);
        jar = Manager.getInstance().getBeingJar(owner, rs.getString(3));
        group = rs.getInt(6);
    }
    
    CreatureInfo(String mainClass, String owner, String jar, int group) {
        this.mainClass = mainClass;
        this.owner = owner;
        this.jar = jar;
        this.group = group;            
    }
}
