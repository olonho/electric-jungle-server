package ejungle.manager;

import ejungle.web.*;
import java.util.*;
import java.sql.*;
import java.io.*;

public class RatingComputeJob implements Runnable {    
    static final boolean FINAL = true;
    static final boolean USE_GROUPS = !FINAL;
    static final String TAG = FINAL ? "_FINAL" : "";

    static HashMap<String, Integer> kindsMap;

    static {
        kindsMap = new HashMap<String, Integer>();
        kindsMap.put("SINGLE", 1);
        kindsMap.put("DUEL",   2);
        kindsMap.put("JUNGLE", 3);
    }

    public void run() {
        System.out.println("computing rating!!!");
        try {
            updateContestArchive();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        List<String[]> combinations;
        try {
            combinations = computeCombinations();
        } catch (SQLException se) {
            reportContestException(se);
            return;
        }
        Collections.shuffle(combinations);
        if (false) {
            for (String[] c : combinations) {
                for (String s : c) {
                    System.out.print(" "+s);
                }
                System.out.println();
            }
        }
        
        String cp = Manager.getInstance().getEngineJar();
        Hashtable<Contest,String[]> contestInfo = 
            new Hashtable<Contest,String[]>();

        System.out.println("WILL RUN "+combinations.size()+ " GAMES");
        java.util.Date startTime = new java.util.Date();
        // we'll start ratings in small groups, to avoid VM abuse
        if (false) {
            final int num = 4;
            int total = combinations.size(), current = 0;
            for (Iterator<String[]> i = combinations.iterator(); i.hasNext(); ) {
                Contest running[] = new Contest[num];
                for (int j=0; j<num && i.hasNext(); j++) {                
                    String[] combo = i.next();
                    try {
                        running[j] = Contest.create(0, combo, cp);
                        contestInfo.put(running[j], combo);
                        running[j].start();
                    } catch (Exception e) {
                        reportContestException(e);
                    }
                }
                for (int j=0; j<num; j++) {
                    current++;
                    System.out.println("WAITING "+current+"/"+total);
                    if (running[j] != null && running[j].waitCompletion()) {
                        try {
                            report(true,
                                   new ContestResult(running[j]), 
                                   contestInfo.get(running[j]));
                        } catch (Exception e) {
                            e.printStackTrace();
                            reportContestException(e);
                        }
                    }
                    running[j] = null;
                }
            }
        } else {
            ClusterServer cs = new ClusterServer(this, combinations);
            cs.start();
            // to make sure thread really started
            Util.sleep(10000);
            cs.waitCompletion();
        }
        java.util.Date endTime = new java.util.Date();
        System.out.println("took: " + (endTime.getTime() - startTime.getTime()));
        try {
            DB.update("INSERT INTO rounds"+TAG+" (begin, end, lastcontest) VALUES (?, ?, " +
                      "  (SELECT MAX(id) FROM contests"+TAG+"))",
                      startTime, endTime);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        // now update rating DB with results
        updateRatingCache();
    }

    public static final int REGROUP_ROUNDS = 5;
    public static final int RATING_ROUNDS = 10;
    public static int firstContest = 0, recentContest = 0, lastContest = 0;
    public static int regroupContest = 0;

    public static void updateRatingCache() {
        try {
            updateContestArchive();
            updateRatingCache("DUEL");
            if (!FINAL) {
                updateRatingCache("JUNGLE");
                updateRatingCache("SINGLE");
            }
            if (USE_GROUPS) {
                performGrouping("ratingcache_DUEL");
            }
        } catch (Exception e) {
            e.printStackTrace();
            reportContestException(e);
        }       
    }

    private static void updateContestArchive() throws SQLException {
        Statement stmt = DB.getStatement();
        try {
            // Obtain contest IDs of the last round and the last 10 rounds
            ResultSet rs = stmt.executeQuery(
                "SELECT lastcontest FROM rounds ORDER BY begin DESC LIMIT " + (RATING_ROUNDS + 1));
            if (rs.next()) lastContest = rs.getInt(1);
            if (rs.next()) recentContest = rs.getInt(1);
            if (rs.last()) firstContest = rs.getInt(1);
            rs.close();
            rs = stmt.executeQuery("SELECT MAX(lastcontest) FROM rounds" +
                                   "  WHERE regroup = 1 AND lastcontest <> " + lastContest);
            if (rs.next()) regroupContest = rs.getInt(1);
            rs.close();

            System.out.println("Relevant contest ranges:");
            System.out.println("  Last round:        [" + recentContest  + " - " + lastContest + "]");
            System.out.println("  Group cycle:       [" + regroupContest + " - " + lastContest + "]");
            System.out.println("  Full rating cycle: [" + firstContest   + " - " + lastContest + "]");

            // Move outdated results to the archive
            if (!FINAL) {
                stmt.executeUpdate("INSERT INTO results_archive " +
                                   "  SELECT * FROM results WHERE contest <= " + firstContest);
                stmt.executeUpdate("INSERT INTO contests_archive " +
                                   "  SELECT * FROM contests WHERE id <= " + firstContest);
                stmt.executeUpdate("DELETE FROM results WHERE contest <= " + firstContest);
                stmt.executeUpdate("DELETE FROM contests WHERE id <= " + firstContest);
            }
        } finally {
            DB.closeStatement(stmt);
        }
    }

    private static void updateRatingCache(String gameKind) throws SQLException {
        String table = "ratingcache_" + gameKind+TAG;
        System.out.println("CACHING " + table);
        String valueField = null;
        String groupSort = "";
        String keyContest = "";
        if ("SINGLE".equals(gameKind)) {
            valueField = "MAX(results.score)";
        } else if ("JUNGLE".equals(gameKind)) {
            valueField = "SUM(results.victory)";
        } else if ("DUEL".equals(gameKind)) {
            valueField = "SUM(results.victory)";
            if (USE_GROUPS) {
                groupSort = "beings.group,";
                keyContest = " AND contests.id > " + regroupContest;
            }
        } else {
            fatal("unsupported game kind: "+gameKind);
        }

        DB.update("TRUNCATE TABLE " + table);
        DB.update(
            "INSERT INTO " + table + " (owner, nick, being, mainclass, score, `group`) " +
            "  SELECT users.id, users.nick, beings.id, beings.mainclass, " + valueField + " AS value, beings.group " +
            "    FROM beings, users, results" + TAG + " AS results, contests" + TAG + " AS contests " +
            "  WHERE users.id = beings.owner AND beings.permissions = 3 " +
            "    AND contests.kind = " + kindsMap.get(gameKind) +
            "    AND results.being = beings.id AND contests.id = results.contest " +
            "    AND contests.id <= " + (FINAL ? 999999 : lastContest) + keyContest +
            "  GROUP BY users.id, users.nick, beings.id, beings.mainclass, beings.group " +
            "  ORDER BY " + groupSort + " value DESC"
        );
    }

    private static void fatal(String msg) {
        throw new RuntimeException("Fatal: "+msg);
    }

    private static final int LEAGUE_SIZE = 40;
    private static final int MOVE_SIZE = 5;

    public static int getLastGroup() throws SQLException {
        ResultSet rs = DB.query("SELECT COUNT(*) FROM beings WHERE permissions = 3");
        int count = rs.next() ? rs.getInt(1) : 0;
        DB.close(rs);
        return (count - 1) / LEAGUE_SIZE;
    }
            
    private static void performGrouping(String table) throws SQLException {
        ResultSet rs = DB.query("SELECT COUNT(id), MAX(id) FROM rounds WHERE id > " +
                                "  (SELECT CONCAT_WS('', MAX(id)) FROM rounds WHERE regroup = 1)");
        if (!rs.next()) {
            DB.close(rs);
            return;
        }
        int freeRounds = rs.getInt(1);
        int maxRound = rs.getInt(2);
        DB.close(rs);
        if (freeRounds < REGROUP_ROUNDS) {
            return;
        }

        int lastGroup = getLastGroup();
        // New beings and beings with no rating go into the last group
        DB.update("UPDATE beings SET `group` = " + lastGroup);
        // Update group field according to current rating position
        DB.update(
            "UPDATE beings, "+table+" AS rd " +
            "LEFT OUTER JOIN ( " +
            "  SELECT rd.being FROM "+table+" AS rd, "+table+" AS tmp " +
            "  WHERE rd.group > 0 AND rd.group = tmp.group AND rd.position >= tmp.position " +
            "  GROUP BY rd.being " +
            "  HAVING COUNT(*) <= ? " +
            ") AS move_up ON rd.being = move_up.being " +
            "LEFT OUTER JOIN ( " +
            "  SELECT rd.being FROM "+table+" AS rd, "+table+" AS tmp " +
            "  WHERE rd.group < ? AND rd.group = tmp.group AND rd.position <= tmp.position " +
            "  GROUP BY rd.being " +
            "  HAVING COUNT(*) <= ? " +
            ") AS move_down ON rd.being = move_down.being " +
            "SET beings.group = (rd.position + ? * ((move_down.being IS NOT NULL) - (move_up.being IS NOT NULL)) - 1) DIV ? " +
            "WHERE beings.id = rd.being",
            MOVE_SIZE, lastGroup, MOVE_SIZE, MOVE_SIZE, LEAGUE_SIZE
        );
/* old variant
        DB.update("UPDATE beings, " + table + " AS rc " +
                  "  SET beings.group = ((rc.position-1) DIV ?) " +
                  "                   + ((rc.position-1) % ? >= ? AND rc.position <= ?) " +
                  "                   - ((rc.position-1) % ? <  ? AND rc.position >  ?) " +
                  "WHERE beings.id = rc.being",
                  LEAGUE_SIZE,
                  LEAGUE_SIZE, LEAGUE_SIZE - MOVE_SIZE, lastGroup * LEAGUE_SIZE,
                  LEAGUE_SIZE, MOVE_SIZE, LEAGUE_SIZE);
*/
        DB.update("UPDATE rounds SET regroup = 1 WHERE id = ?", maxRound);
    }

    // be smarter on error handling
    static void reportContestException(Exception e) {
        Manager.getInstance().reportError(e);        
    }
   
    void report(boolean success, ContestResult c, String[] args)
        throws SQLException
    {
        int kind = kindsMap.get(args[1]);
        int contestID = DB.insertID(
            "INSERT INTO contests"+TAG+" (owner, begin, end, took, turns, kind, host, dead) " +
            "  VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            c.owner, c.begin, c.end, c.took, c.turns, kind, c.host, success ? 0 : 1);

        String[] res = c.results;
        float maxScore = 0.0f;
        float[] scores = new float[res.length / 2];
        for (int i = 0; i < scores.length; i++) {
            try {
                if ((scores[i] = Float.parseFloat(res[i*2+1])) > maxScore) {
                    maxScore = scores[i];
                }
            } catch (NumberFormatException e) {}
        }
        if (maxScore == 0.0f) {
            maxScore = -1.0f; // 0 is not a victory
        }

        StringBuilder insertValues = new StringBuilder();
        for (int i = 0; i < res.length; i += 2) {
            String fullName = res[i];
            String score = res[i + 1];
            int p0 = fullName.lastIndexOf('/');
            int p1 = fullName.indexOf('_');
            String ownerName = fullName.substring(p0 + 1, p1);
            String jarName = fullName.substring(p1 + 1);           
            ResultSet rs = 
                DB.query("SELECT beings.id FROM beings " +
                         "  INNER JOIN users ON users.id = beings.owner " +
                         "  WHERE users.nick = ? AND beings.jarfile = ?",
                         ownerName, jarName);
            if (rs.next()) {
                insertValues.append(", (");
                insertValues.append(contestID);
                insertValues.append(", ");
                insertValues.append(rs.getInt(1));
                insertValues.append(", '");
                insertValues.append(score);
                insertValues.append("', ");
                insertValues.append(scores[i>>1] == maxScore ? "true" : "false");
                insertValues.append(")");
            }
            DB.close(rs);
        }
        if (insertValues.length() > 2) {
           DB.update("INSERT INTO results"+TAG+" (contest, being, score, victory) VALUES " +
                     insertValues.substring(2));
        }
    }

    List<String> makeArgsList(String kind) {
         List<String> args = new ArrayList<String>();
         // to let them run fast
         args.add("--game-kind"); args.add(kind);
         args.add("--batch"); 
         return args;
    }

    void addSinglePlayerCombos(List<String[]> rv, List<CreatureInfo> zoo) {
        for (CreatureInfo ci : zoo) {
            List<String> args = makeArgsList("SINGLE");
            args.add(ci.mainClass); args.add(ci.jar);
            rv.add(args.toArray(new String[args.size()]));
        }
    }

    // for now do rather expensive n * (n-1) / 2 all possible pairs
    // later may need to to refine
    void addDuelCombos(List<String[]> rv, List<CreatureInfo> zoo, 
                       boolean useGroups) {
        // create groups set
        Map<Integer,Set<CreatureInfo>> groups 
            = new HashMap<Integer,Set<CreatureInfo>>();
        for (CreatureInfo z : zoo) {
            int gn =  useGroups ? z.group : 0;
            Set<CreatureInfo> g = groups.get(gn);
            if (g == null) {
                g = new HashSet<CreatureInfo>();
                groups.put(gn, g);
            }
            g.add(z);
        }

        System.out.println("has "+groups.size()+" groups");
        for (Integer gn : groups.keySet()) {
            Set<CreatureInfo> g = groups.get(gn);
            System.out.println("group "+gn+" has "+g.size()+" elements");
            HashSet<CreatureInfo> g1 = new HashSet<CreatureInfo>(g);
            for (CreatureInfo c1 : g) {
                g1.remove(c1);
                for (CreatureInfo c2 : g1) {
                    List<String> args = makeArgsList("DUEL");
                    args.add(c1.mainClass); args.add(c1.jar);
                    args.add(c2.mainClass); args.add(c2.jar);                
                    rv.add(args.toArray(new String[args.size()]));
                }
            }
        }
    }

    public static void main(String[] args) {
        RatingComputeJob rcj = new RatingComputeJob();
        List<String[]> combos = new ArrayList<String[]>();
        List<CreatureInfo> zoo = new ArrayList<CreatureInfo>();
        zoo.add(new CreatureInfo("ant1", null, null, 12));
        zoo.add(new CreatureInfo("ant2", null, null, 12));
        zoo.add(new CreatureInfo("lion1", null, null, 1));
        zoo.add(new CreatureInfo("lion2", null, null, 1));
        zoo.add(new CreatureInfo("lion3", null, null, 1));
        
        rcj.addDuelCombos(combos, zoo, true);
        for (String[] c : combos) {
            System.out.print("COMBO: ");
            for (String e : c) {
                System.out.print(e+" ");
            }
            System.out.println();
        }
    }

    // here we just split everyone in groups by 8, and throw them in jungle
    void addJungleCombos(List<String[]> rv, List<CreatureInfo> zoo) {
        final int num = 8;
        Iterator<CreatureInfo> i = zoo.iterator();
        while (i.hasNext()) {
            List<String> args = makeArgsList("JUNGLE");
            for (int j=0; j<num && i.hasNext(); j++) {
                CreatureInfo c = i.next();
                args.add(c.mainClass); args.add(c.jar);
            }
            rv.add(args.toArray(new String[args.size()]));
        }
    }


    public static List<CreatureInfo> makeZoo(boolean full) 
        throws SQLException {
        ResultSet rs = null;
        ArrayList<CreatureInfo> zoo = new ArrayList<CreatureInfo>();
        try {
            rs  = DB.query("SELECT beings.id, beings.owner, beings.jarfile, "+
                           "       beings.mainclass, users.nick, beings.group "+ 
                           "  FROM beings INNER JOIN users ON beings.owner = users.id "+
                           "  WHERE beings.permissions = 3"+
                           ((!full && FINAL) ? " AND forcontest = 1" : ""));
            while (rs.next()) {
                CreatureInfo ci = new CreatureInfo(rs);
                System.out.println(ci.jar);
                if (new File(ci.jar).exists() && ci.jar.endsWith(".jar") ) {
                    zoo.add(ci);
                }
            }
                        
        }  finally {
            if (rs != null) {
                DB.close(rs);
            }
        }
        // add some shuffling so that different creatures fight
        // on different days
        Collections.shuffle(zoo);
        System.out.println("zoo size = " + zoo.size());

        return zoo;
    }

    List<String[]> computeCombinations() throws SQLException {
        List<String[]> rv = new ArrayList<String[]>();
        List<CreatureInfo> zoo = makeZoo(false);
        
        addDuelCombos(rv, zoo, USE_GROUPS);
        if (!FINAL) {
            addSinglePlayerCombos(rv, zoo);
            addJungleCombos(rv, zoo);
        }

        return rv;
    }
}
