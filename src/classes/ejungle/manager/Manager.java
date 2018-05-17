package ejungle.manager;

import javax.sql.*;
import javax.naming.*;
import java.util.concurrent.*;

public class Manager {
    private final ScheduledExecutorService cron;
    private Object waiter;
    private boolean ktulhuAwoke;
    public static boolean standalone=false;
    private DataSource dbDataSource;
    private String appRoot;
    private static Manager instance;

    public static final int ROUND_DELAY = 8 * 60 * 60; /* seconds */

    public static boolean isFinal() {
       return RatingComputeJob.FINAL;
    }

    public static boolean useGroupsInView() {
 	return RatingComputeJob.USE_GROUPS || RatingComputeJob.FINAL;
    }
    
    public static synchronized Manager getInstance() {
        if (instance == null) {
            System.out.println("Manager clinit");
            try { 
                instance = new Manager();
            } catch (Throwable t) {
                t.printStackTrace();
            }
        }
        return instance;
    }

    public void reportError(Throwable e) {
        System.err.println("contest exception: "+e);
        e.printStackTrace();
    }

    private Manager() {
        waiter = new Object();
        ktulhuAwoke = false;
        cron = Executors.newScheduledThreadPool(2);
        if (standalone) {
            //throw new RuntimeException("standalone no longer supported");
            dbDataSource = new DBDataSource();
            //appRoot = "c:/Program Files/Apache Software Foundation/Tomcat 5.5/webapps/ejungle/";
            appRoot = "/ed/tomcat/apache-tomcat-5.5.17/webapps/ejungle/";
        }  else {
            // catalina.home also would work
            appRoot = 
                (System.getProperty("catalina.home")+"/webapps/ejungle/").
                     replace('/', java.io.File.separatorChar);
        }
        if (false && !standalone) {
              cron.scheduleWithFixedDelay(new RatingComputeJob(),
                                        ROUND_DELAY, ROUND_DELAY,
                                        TimeUnit.SECONDS);
 	}
        System.out.println("Manager done");
    }

    public DataSource getDBDataSource() {
        if (dbDataSource == null) {
            try {
                InitialContext ic = new InitialContext();
                dbDataSource = (DataSource)ic.lookup("java:comp/env/jdbc/ejungle");
            } catch (javax.naming.NamingException e) {
                reportError(e);
            }
        }
        return dbDataSource;
    }

    void waitCompletion() {
        try {
            synchronized (waiter) {
                while (!ktulhuAwoke) {
                    waiter.wait();
                }
            }
        } catch (InterruptedException ie) {}
    }
    
    public void schedule(Runnable what, long delay) {
        cron.schedule(what, delay, TimeUnit.MILLISECONDS);
    }

    public static void main(String[] args) {        
        standalone = true;        
        Manager.getInstance().waitCompletion();
    }

    public String getBeingJar(String user, String file) {
        return appRoot + "beings/" + ejungle.web.Util.encodeURL(user) + 
            "_" + file;
    }
    
    public String getEngineJar() {
        return appRoot + "files/universum.jar";
    }

    public String getRealPath(String fileName) {
        return appRoot + fileName;
    }
}
