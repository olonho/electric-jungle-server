package ejungle.web;

import java.net.*;
import java.util.*;

public abstract class Contest implements Runnable {
    public static enum State {
        NEW,
        ACTIVE,
        FINISHED;
    }

    private static final String IMPLEMENTATION_CLASS = "universum.ContestRunner";
    private static int num = 0;
    public static Map<String,Contest> all =
        Collections.synchronizedMap(new TreeMap<String,Contest>());

    protected int owner;
    protected String key;
    protected Date startTime;
    protected Date endTime;
    protected State state;
    protected int port;
    protected Thread job;

    private static ClassLoader createClassLoaderFor(String classpath)
        throws MalformedURLException
    {
        if (classpath == null) {
            return new URLClassLoader(new URL[0]);
        }
        if (classpath.indexOf("://") < 0) {
            classpath = "file:" + classpath;
        }
        return new URLClassLoader(new URL[] {new URL(classpath)},
                                  Contest.class.getClassLoader());
    }

    public static Contest create(int owner, String[] args, String classpath)
        throws Exception
    {
        // before doing anything else we must load class JungleSecurity
        universum.engine.JungleSecurity.setCheckSecurity(true);
        
        ClassLoader loader = createClassLoaderFor(classpath);
        Contest instance =
          (Contest)loader.loadClass(IMPLEMENTATION_CLASS).newInstance();
        instance.owner = owner;
        instance.startTime = new Date();
        instance.state = State.NEW;
        // if in batch mode - no reason to provide network interface
        instance.port = owner == 0 ? -1 : 0;
        instance.key = Long.toHexString(instance.startTime.getTime()) + "-" +
                       Integer.toHexString(instance.hashCode());

        ThreadGroup isolate = new ThreadGroup("Isolate-" + num++);
        isolate.setDaemon(true);
        instance.job = new Thread(isolate, instance);
        instance.job.setContextClassLoader(loader);

        instance.parseArgs(args);
        all.put(instance.key, instance);
        return instance;
    }

    public int getOwner() {
        return owner;
    }

    public String getKey() {
        return key;
    }

    public Date getStartTime() {
        return startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public State getState() {
        return state;
    }

    public void setListenPort(int port) {
        this.port = port;
    }
    
    public int getListenPort() {
        return port;
    }

    public void start() {
        job.start();
        job = null;
    }

    protected abstract void stop();
    
    public void destroy() {        
        all.remove(key);
	job = null;
        stop();
    }

    public static int count(int owner) {
        int result = 0;
        synchronized (all) { 
            for (Contest c : all.values()) {
                if (c.getOwner() == owner && c.state != State.FINISHED) {
                    result++;
                }
            }
        }
        return result;
    }

    public static int count() {
        int result = 0;
        synchronized (all) { 
            for (Contest c : all.values()) {
                if (c.state != State.FINISHED) {
                    result++;
                }
            }
        }
        return result;
    }

    public abstract void parseArgs(String[] args);
    
    public abstract String[][] getBeingInfo();

    public abstract boolean waitCompletion();    

    public abstract int numTurns();

    public abstract String[] results();    

}
