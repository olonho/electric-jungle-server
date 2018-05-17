package ejungle.manager;

import java.util.Date;

class ContestResult {
    int owner;
    Date begin, end;
    int turns, took;
    String[] results;
    String host;

    ContestResult(int owner, Date begin, Date end, int turns, 
                  String host, int took, String[] results) {
        this.owner = owner;
        this.begin = begin;
        this.end = end;
        this.turns = turns;
        this.host = host;
        this.took = took;
        this.results = results;
    }

    ContestResult(ejungle.web.Contest c) {
        this.owner = c.getOwner();
        this.begin = c.getStartTime();
        this.end = c.getEndTime();
        this.turns = c.numTurns();
        this.results = c.results();
        this.took = (int)(end.getTime() - begin.getTime());
        this.host = "localbox";
    }
    
}
