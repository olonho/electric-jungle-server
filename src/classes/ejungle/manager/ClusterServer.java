package ejungle.manager;

import java.io.*;
import java.nio.*;
import java.nio.channels.*;
import java.net.*;
import java.util.*;
import java.text.*;

class ClusterTaskRecord {
    String[] combo;
    String tag;
    Date start;
    ClusterTaskRecord(String tag, String[] combo) {
        this.tag = tag;
        this.combo = combo == null ? new String[0] : combo;
        this.start = new Date();
    }
}

public class ClusterServer implements Runnable {
    private RatingComputeJob owner;
    private List<String[]> combos;
    private Thread job;
    private ServerSocketChannel ssChannel;
    private ByteBuffer buf;
    private int numReported, numCombos;
    private Map<String, ClusterTaskRecord> requested = 
        new HashMap<String, ClusterTaskRecord>();    

    ClusterServer(RatingComputeJob owner, List<String[]> combos) {
        this.owner = owner;
        this.combos = combos;
        // 640K is enough for everybody
        buf = ByteBuffer.allocate(640*1024);
        numCombos = combos.size();
        numReported = 0;
    }

    void start() {
        job = new Thread(this);
        job.start();
    }


    public void run() {
        System.out.println("started server");
        try {
            ssChannel = ServerSocketChannel.open();
            ssChannel.socket().setReuseAddress(true);
            ssChannel.configureBlocking(true);	    	    
            ssChannel.socket().bind(new InetSocketAddress(61000));
            
            while (hasMoreCombos()) {
                try {
                    SocketChannel sc = ssChannel.accept();
                    processRequest(sc);
                } catch (Throwable t) {
                    t.printStackTrace();
                    // show must go on
                }
                }
            ssChannel.close();
        } catch (IOException ioe) {
            if (ssChannel != null) {
                try { ssChannel.close(); } catch (IOException ioe1) {}
            }
        }
    }


    boolean hasMoreCombos() {
        return numReported < numCombos;
    }

    void processRequest(SocketChannel sc) {
        try {
            buf.clear();
            buf.limit(8);
            int r = sc.read(buf);
            if (r < 8) {
                throw new IOException("no header");
            }
            buf.flip();
            int magic = buf.getInt();
            if (magic != 0x12345678) {
                throw new IOException("inconsistent magic: "+magic);
            }
            int len = buf.getInt();
            if (len < 8 || len > 635 * 1024) {
                throw new IOException("bad frame: "+len);
            }
            buf.flip();
            buf.limit(len-8);
            int read = 8;
            do {
                r = sc.read(buf);
                if (r < 0) {
                    throw new IOException("cut frame");
                }
                read += r;
            } while (read < len);
            buf.flip();           
            
            String auth = getString();
            if (!auth.equals("JungleClusterSecretWord")) {
                return;
            }
            String cmd = getString();
            int argc = buf.getInt();
            String[] args = new String[argc];
            for (int i = 0; i<argc; i++) {
                args[i] = getString();
            }
            processCmd(cmd, args);
            sc.write(buf);
        } catch (Exception e) {
            owner.reportContestException(e);
        } finally {
             try { sc.close(); } catch (IOException ioe) {}
        }
    }

    void processCmd(String cmd, String[] args) {
        startPacket();

        System.out.println("cmd="+cmd);
        for (String a : args) {
            System.out.println("   "+a);
        }
        if ("GETCONFIG".equals(cmd)) {
            ClusterTaskRecord task = getNextTask();
            putString(task.tag); // tag
            buf.putInt(task.combo.length);
            for (String s : task.combo) {
                putString(s);
            }
        } else if ("RESULT".equals(cmd)) {
            reportResult(true, args);
        } else if ("DEAD".equals(cmd)) {
            reportResult(false, args);
        } else if ("GETJAR".equals(cmd)) {
            getJar(args[0]);
        } else {
            System.out.println("Command "+cmd+" isn't known");
        }

        endPacket();
    }

    private void startPacket() {
        buf.clear();
        buf.putInt(0x34125678);
        buf.putInt(0); // size placeholder
    }

    private void endPacket() {
        int pos = buf.position();
        buf.position(4);
        buf.putInt(pos); // fill in size
        buf.position(pos);
        buf.flip();       
    }

    private void putString(String s) {
        int len = s.length();
        buf.putInt(len);
        for (int i=0; i<len; i++) {
            buf.putChar(s.charAt(i));
        }
    }

    private String getString() {
        int len = buf.getInt();
        char[] data = new char[len];
        for (int i=0; i<len; i++) {
            data[i] = buf.getChar();
        }
        return new String(data);
    }

     private void putBytes(byte[] data) {
         int len = data.length;
         buf.putInt(len);
         buf.put(data);
    }

    void waitCompletion() {
        try {
            job.join();
        } catch (InterruptedException ie) {}      
        System.out.println("COMPLETED");
    }

    private int tagger;
    private String newTag() {
        return "tag-"+System.currentTimeMillis()+"-"+(tagger++);
    }
    private Random rnd = new Random();

    synchronized ClusterTaskRecord getNextTask() {
        // easy path
        if (combos.size() > 0) {
            String tag = newTag();
            ClusterTaskRecord rv = 
                new ClusterTaskRecord(tag, combos.remove(0));
            requested.put(tag, rv);
            return rv;
        }

        // if requested, and there are some pending - select random pending
        // and give it to the client
        if (requested.size() > 0) {
            Collection<ClusterTaskRecord> vals = requested.values();
            int size = vals.size();
            int elem = rnd.nextInt(size);
            for (ClusterTaskRecord rec : vals) {
                if (elem-- == 0) {
                    return rec;
                }
            }            
        }
        
        // nothing more - done
        return new ClusterTaskRecord("DONE", null);
    }

    private static DateFormat FULL_DATE = 
        DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.MEDIUM,
	                               Locale.US);

    synchronized void reportResult(boolean success, String[] args) {
        String tag = args[0];
        ClusterTaskRecord ctr = requested.get(tag);
        if (ctr == null) {
            // someone else already did it
            System.out.println("task "+tag+" already finished");
            return;
        }        
        requested.remove(tag);
        numReported++;

        System.out.println("processed "+numReported+"/"+numCombos);
        
        int resultsLength = args.length - 5;
        if (resultsLength < 0) {
            // probably protocol error
            return;
        }
        String[] results = new String[resultsLength];
        System.arraycopy(args, 5, results, 0, resultsLength);
        //printArray("RESULTS", results);

        try {
            ContestResult cr = new ContestResult(
                                                 /*owner*/ Integer.parseInt(args[1]),
                                                 ctr.start,
                                                 new Date(),
                                                 /*turns*/ Integer.parseInt(args[4]),
                                                 /*host*/ args[2],
                                                 /*took*/Integer.parseInt(args[3]),
                                                 results);
            owner.report(success, cr, ctr.combo);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    static void printArray(String name, String[] array) {
        System.out.println(name);        
        for (String s : array) {
            System.out.println("  "+s);
        }
    }

    void getJar(String name) {
        try {
            // kinda securty check
            if (!name.endsWith(".jar")) {
               throw new IOException("not a jar: "+name);
            }
            File f = new File(name);
            FileInputStream fis = new FileInputStream(f);
            byte[] data = new byte[(int)f.length()];
            fis.read(data);
            putBytes(data);
        } catch (IOException ioe) {
            ioe.printStackTrace();
            putBytes(new byte[0]);
        }
    }    
}
