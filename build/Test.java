import java.util.*;

public class Test {    
    static List<String[]> addDuelCombos(List<String> zoo) {
        List<String[]> rv = new ArrayList<String[]>();

        HashSet<String> zoo1 = new HashSet<String>(zoo);
        for (String c1 : zoo) {
            zoo1.remove(c1);
            for (String c2 : zoo1) {
                String[] as = new String[2];
                as[0] = c1;
                as[1] = c2;
                rv.add(as);
            }
        }
        return rv;
    }
    
    public static void main(String[] args) {
        System.out.println("HI");
        List<String> zoo = new ArrayList<String>();
               
        List<String[]> combos = addDuelCombos(zoo);
        
        for (String[] c : combos) {
            System.out.println(c[0] +" and "+c[1]);
        }
    }
}
