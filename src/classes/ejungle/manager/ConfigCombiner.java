package ejungle.manager;

import java.sql.SQLException;
import java.util.*;
import java.io.*;

public class ConfigCombiner {
    String dir;
    private static final boolean TEST = false;

    public static void main(String[] args) throws Exception {
	Manager.standalone = true;
        new ConfigCombiner("configs").start();
    }


    ConfigCombiner(String dir) {
        this.dir = dir;
    }

    private void cleanupZoo(List<CreatureInfo> zoo) {
        Set<String> ownerz = new HashSet<String>();
        for (Iterator<CreatureInfo> i = zoo.iterator(); i.hasNext(); ) {
            CreatureInfo ci = i.next();
            if (!ownerz.add(ci.owner)) {                
                i.remove();
            }
        }
    }

    private  List<CreatureInfo> makeTestZoo() {
        List<CreatureInfo> zoo = new ArrayList<CreatureInfo>(2);
        zoo.add(new CreatureInfo("universum.beings.Life", "me", 
                                 "Putnik_life.jar", 0));
        zoo.add(new CreatureInfo("universum.beings.PypoksMonkey", "you", 
                                 "trooper_pypok.jar", 0)); 
        zoo.add(new CreatureInfo("universum.beings.Cheburator", "who", 
                                 "riite_cheburator.jar", 0)); 
        
        return zoo;
    }

    public void start() throws IOException, SQLException {        
        List<CreatureInfo> zooAll = 
            TEST ? makeTestZoo() : RatingComputeJob.makeZoo(true);
         List<CreatureInfo> zooElite = 
            TEST ? makeTestZoo() : RatingComputeJob.makeZoo(false);
        cleanupZoo(zooAll);

        File dir = new File(this.dir);
        dir.mkdirs();

        //createSingleConfigs(dir, 5, zooAll);
        createJungleConfigs(dir, zooAll);
        //createDuelConfigs(dir, 10, zooElite);
    }


    private Integer[] makeSeeds(int numSeeds) {
        Integer seeds[] = new Integer[numSeeds];
        Random rnd = new Random();
        for (int i=0; i<numSeeds; i++) {
            seeds[i] = rnd.nextInt(10000000)+1;
        }
        return seeds;
    }

    private void createSingleConfigs(File dir, int numSeeds, List<CreatureInfo> zoo) 
        throws IOException {
        Integer num = 0, id = 0;
        Integer seeds[] = makeSeeds(numSeeds);

        for (CreatureInfo ci : zoo) {
            for (int i = 0; i<numSeeds; i++) {
                createSingleConfig(new File(dir, "cfg-single-"+
                                            num+"-"+i+".properties"), 
                                   ci, seeds[i], id++);
            }
            num++;
        }
    }

    private void createSingleConfig(File f, CreatureInfo ci, 
                                    int seed, int id)
        throws IOException {
        
        List<CreatureInfo> cis = new ArrayList<CreatureInfo>(1);
        cis.add(ci);
        createConfig(f, "SINGLE", seed, cis, 
                     "single-"+id+".ej", "single-"+id+".sql");
    }


    private void shift(List<CreatureInfo> zoo) {
        Collections.rotate(zoo, 1);
    }

    private void createJungleConfigs(File dir, List<CreatureInfo> zoo) 
        throws IOException {
        final int elems = 8;
        Integer id = 0;
        Iterator<CreatureInfo> i = zoo.iterator();
        Integer seeds[] = makeSeeds(3);

        while (i.hasNext()) {
            List<CreatureInfo> cis = new ArrayList<CreatureInfo>();
            for (int j=0; j<elems && i.hasNext(); j++) {
                cis.add(i.next());
            }
            int n = cis.size();            
            for (int si = 0; si < seeds.length; si++) {
                Integer seed = seeds[si];
                File seededDir = new File(dir, "seed"+si);
                seededDir.mkdir();
                for (int j=0; j<n; j++) {
                    shift(cis);
                    createJungleConfig(new File(seededDir,"cfg-jungle-"+id+".properties"),
                                       cis, seed, id++);
                }
            }
        }
    }

    private void createJungleConfig(File f, List<CreatureInfo> cis, 
                                    int seed, int id) 
        throws IOException {
        createConfig(f, "JUNGLE", seed, cis, 
                     "jungle-"+id+".ej", "jungle-"+id+".sql");       
    }

    private void createDuelConfigs(File dir, int numSeeds, 
                                   List<CreatureInfo> zoo) 
        throws IOException {        
        Integer id = 0;
        Integer seeds[] = makeSeeds(numSeeds);
        Random rnd = new Random();

        for (int i = 0; i < seeds.length; i++) {
            seeds[i] = rnd.nextInt(1000)+1;
        }

        for (int i = 0; i<numSeeds; i++) {
            Set<CreatureInfo>  g = new HashSet<CreatureInfo>(zoo);
            HashSet<CreatureInfo> g1 = new HashSet<CreatureInfo>(g);
            for (CreatureInfo c1 : g) {
                g1.remove(c1);
                for (CreatureInfo c2 : g1) {
                    List<CreatureInfo> cis = new ArrayList<CreatureInfo>();
                    cis.add(c1); cis.add(c2);
                    createDuelConfig(new File(dir, "cfg-duel-"+
                                              id+".properties"), 
                                     cis, seeds[i], id++);
                    cis = new ArrayList<CreatureInfo>();
                    cis.add(c2); cis.add(c1);
                    createDuelConfig(new File(dir, "cfg-duel-"+
                                              id+".properties"), 
                                     cis, seeds[i], id++);
                }
            }
        }
    }

    private void createDuelConfig(File f, List<CreatureInfo> cis, 
                                  int seed, int id) 
        throws IOException {
        createConfig(f, "DUEL", seed, cis, 
                     "duel-"+id+".ej", "duel-"+id+".sql");     
    }

    private String transform(String jar) {
      int lastSlash = jar.lastIndexOf('/');
      if (lastSlash > -1) {
          jar = jar.substring(lastSlash+1);  
      }
      //return "../beings/"+jar;
      return jar;
    }

    private void createConfig(File f, String kind, int seed, 
                              List<CreatureInfo> cis,
                              String save, String sql) throws IOException {
        PrintStream ps = new PrintStream(f);
        ps.println("beings: \\");
        for (CreatureInfo ci: cis) {
            ps.println("   "+ci.mainClass+"@"+transform(ci.jar)+" \\");
        }
        ps.println(" ");
        ps.println("kind: "+kind);
        ps.println("autostart: "+!TEST);
        ps.println("turnDelay: 0");      
        ps.println("randomSeed: "+seed);       
        ps.println("recordGameFilePath: "+save);
        ps.println("sqlResultFilePath: "+sql);
        ps.close();
    }
}
