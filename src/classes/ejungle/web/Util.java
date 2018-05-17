package ejungle.web;

import java.util.*;
import java.text.*;
import java.security.*;
import java.io.File;
import javax.servlet.http.*;
import java.sql.ResultSet;
import java.sql.SQLException;


class CachedRecord {
    String value;
    long stamp;

    CachedRecord(String value) {
        update(value);
    }

    boolean isRecent() {
        // record valid for 10 secs
        return stamp + 10000 > System.currentTimeMillis();
    }
    
    void update(String value) {
        this.value = value;
        this.stamp = System.currentTimeMillis();
    }
}

public class Util {
    private static MessageDigest MD5_ENGINE;
    private static SimpleDateFormat TIME_FORMAT, DATE_RU_FORMAT, DATE_EN_FORMAT;
    private static HashMap<String,ResourceBundle> locales;
    private static Map<String,CachedRecord> recordCache;

    private static char[] HEX_DIGIT = {
        '0', '1', '2', '3', '4', '5', '6', '7',
        '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
    };

    static {        
        try {
            MD5_ENGINE = MessageDigest.getInstance("MD5");
        } catch (NoSuchAlgorithmException e) {}
        TIME_FORMAT = new SimpleDateFormat("dd/MM HH:mm");
        DATE_RU_FORMAT = new SimpleDateFormat("dd.MM.yyyy");
        DATE_EN_FORMAT = new SimpleDateFormat("MM/dd/yyyy");
        locales = new HashMap<String,ResourceBundle>();
        recordCache = Collections.synchronizedMap(new HashMap<String,CachedRecord>());

        addLocale("ru");
        addLocale("en");
    }

    private static void addLocale(String lang) {
        locales.put(lang, ResourceBundle.getBundle("strings", new Locale(lang)));
    }

    public static ResourceBundle getLocale(String lang) {
        return locales.get(lang);
    }

    public static String encodeURL(String path) {
        try {
            return new java.net.URI(path).toASCIIString();
        } catch (Exception e) {
            return null;
        }
    }

    public static String encodeHTML(String s) {
        return s == null ? null : s.replace("<",  "&lt;").
                                    replace(">",  "&gt;").
                                    replace("\"", "&quot;");
    }

    public static File getFile(String fileName) {
        fileName = ejungle.manager.Manager.getInstance().getRealPath(fileName);
        return new File(fileName);
    }

    public static String md5(String s) {
        if (s == null) {
            return null;
        }
        byte[] result = MD5_ENGINE.digest(s.getBytes());
        int len = result.length;
        char[] chars = new char[len * 2];
        for (int i = 0; i < len; i++) {
            int c = result[i] & 0xff;
            chars[i * 2]     = HEX_DIGIT[c >> 4];
            chars[i * 2 + 1] = HEX_DIGIT[c & 15];
        }
        return new String(chars);
    }

    private static char[] map1 = new char[64];
    static {
        int i=0;
        for (char c='A'; c<='Z'; c++) map1[i++] = c;
        for (char c='a'; c<='z'; c++) map1[i++] = c;
        for (char c='0'; c<='9'; c++) map1[i++] = c;
        map1[i++] = '+'; map1[i++] = '/'; 
    }
    public static String base64(String in) {
        int len = in.length();
        char dest[] = new char[len];
        in.getChars(0, len, dest, 0);
        return new String(base64(dest));
    }
    public static char[] base64(char[] in) {
        int iLen = in.length;
        int oDataLen = (iLen*4+2)/3;       // output length without padding
        int oLen = ((iLen+2)/3)*4;         // output length including padding
        char[] out = new char[oLen];
        int ip = 0;
        int op = 0;
        while (ip < iLen) {
            int i0 = in[ip++] & 0xff;
            int i1 = ip < iLen ? in[ip++] & 0xff : 0;
            int i2 = ip < iLen ? in[ip++] & 0xff : 0;
            int o0 = i0 >>> 2;
            int o1 = ((i0 &   3) << 4) | (i1 >>> 4);
            int o2 = ((i1 & 0xf) << 2) | (i2 >>> 6);
            int o3 = i2 & 0x3F;
            out[op++] = map1[o0];
            out[op++] = map1[o1];
            out[op] = op < oDataLen ? map1[o2] : '='; op++;
            out[op] = op < oDataLen ? map1[o3] : '='; op++; 
        }
        return out; 
    }

    public static String datetime(Date d, String lang) {
        SimpleDateFormat fmt = "en".equals(lang) ? DATE_EN_FORMAT : DATE_RU_FORMAT;
        return fmt.format(d);
    }

    public static String datetime(Date d) {
        return TIME_FORMAT.format(d);
    }

    public static String getRequestPath(HttpServletRequest request) {
      StringBuilder url = new StringBuilder();
      url.append(!request.isSecure() ? "http://" : "https://");
      url.append(request.getLocalAddr());
      int port = request.getServerPort();
      if (port != 80) {
        url.append(':');
        url.append(port);
      }
      url.append(request.getContextPath());
      return url.toString();
    }
    
    static SDNAuth sndAuth = new SDNAuth(null, 0);
    public static boolean checkAuthAndLogon(String user, String pass, 
                                            Session ssn) {
        String md5pass = Util.md5(pass);
        ResultSet rs = null;
        try {
            rs = DB.query("SELECT users.id, users.nick, users.name, users.rights" +
                          " FROM users " +
                          " WHERE nick = ? AND password = ?",
                          user, md5pass);
            if (rs.next()) {
                ssn.logon(rs.getInt(1), rs.getString(2), 
                          rs.getString(3), rs.getInt(4), md5pass);
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DB.close(rs);
        }

        // we failed to authenticate with local DB - try with SDN authentication
        if (sndAuth.doAuth(user, pass)) {
            // wow, user has SDN access - cache it locally
            return addLocalRecord(user, pass, 
                                  Session.ACCESS_MEMBER,
                                  "SDN user: "+user,
                                  user, "", "", "", ssn) == null;
        }

        return false;
    }

    public static void updateCookie(Session ssn, HttpServletResponse response) {
        String value = Long.toHexString(new Date().getTime() + response.hashCode());
        try {
            if (DB.update("UPDATE users SET cookie = ? WHERE id = ?", value, ssn.id) > 0) {
              Cookie cookie = new Cookie("autologon", ssn.id + "," + value);
              cookie.setMaxAge(7 * 24 * 3600 /* 7 days */);
              response.addCookie(cookie);
            }
        } catch (SQLException e) {}
    }

    public static ErrorCode addLocalRecord(String username, String password, 
                                           int rights, String name,
                                           String email, String phone,
                                           String work, String place,
                                           Session ssn) {
        
        ResultSet rs = null;        
        try {
            rs = DB.query("SELECT * FROM users WHERE nick = ?", username);
            if (rs.next()) {
                return ErrorCode.DUPLICATE_NAME;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return ErrorCode.INTERNAL_ERROR;
        } finally {
            DB.close(rs);
        }
        
        password = Util.md5(password);
        try {
            int newId = DB.insertID("INSERT INTO users (nick, password, rights, name, email, phone, work, place, added) " +
                                    "  VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW())",
                                    username, password, rights, name, email, phone, work, place);
            ssn.logon(newId, username, name, rights, password);


            int maxId = 0;
            rs = DB.query("SELECT MAX(user_id) FROM phpbb_users");
            if (rs.next()) {
                maxId = rs.getInt(1);
            }
            DB.close(rs);

            DB.update("INSERT INTO phpbb_users (user_id, username, user_regdate, user_password, user_email, user_icq, user_website, user_occ, user_from, user_interests, user_sig, user_sig_bbcode_uid, user_avatar, user_avatar_type, user_viewemail, user_aim, user_yim, user_msnm, user_attachsig, user_allowsmile, user_allowhtml, user_allowbbcode, user_allow_viewonline, user_notify, user_notify_pm, user_popup_pm, user_timezone, user_dateformat, user_lang, user_style, user_level, user_allow_pm, user_active, user_actkey) " +
                      "  VALUES (?, ?, ?, ?, ?, '', '', '', '', '', '', '', '', 0, 0, '', '', '', 0, 1, 0, 1, 1, 0, 1, 1, '3.00', 'd M Y h:i a', ?, 1, 0, 1, 1, '')",
                      maxId + 1, username, (new Date().getTime()) / 1000, password, email,
                      "en".equals(ssn.lang) ? "english" : "russian");
        } catch (SQLException e) {
            e.printStackTrace();
            return ErrorCode.INTERNAL_ERROR;
        } finally {
            DB.close(rs);
        }
        return null;
    }
    
    // to minimize DB requests do in memory caching
    public static String cachedQuery(String query) {
        CachedRecord cr = recordCache.get(query);
        if (cr != null && cr.isRecent()) {
            return cr.value;
        }

        ResultSet rs = null;
        String rv = "";
        try {
            rs = DB.query(query);
            if (rs.next()) {
                rv = rs.getString(1);
            }
            if (cr == null) {
                recordCache.put(query, new CachedRecord(rv));
            } else {
                cr.update(rv);
            }
        } catch (SQLException e) {
        } finally {            
            DB.close(rs);
        }
        return rv;
    }
    
    static String[] buildArgs() {
        List<String> elems = new ArrayList<String>();
        String root = "/net/electricjungle/ed/universum/beings/";
        elems.add("--batch");
        elems.add("universum.beings.SimpleBeing");
        elems.add(root+"simple.jar");
        elems.add("universum.beings.hive.Hornet");
        elems.add(root+"hive.jar");        
        return elems.toArray(new String[1]);
    }

    public static void main(String[] e) throws Exception {
        for (int j=0; j<100; j++) {
            String[] args = buildArgs();        
            for (int i = 0; i<10; i++) {
                Contest c = Contest.create(0, args, 
                                           "/net/electricjungle/ed/universum/bld/universum.jar");
                c.start();
            }
            System.out.println("Done!: "+j);
            //System.in.read();
            System.gc();
            //sleep(1000);        
            Runtime.getRuntime().runFinalization();
            System.gc();
        }
        sleep(100000000);
    }

    public static void sleep(long ms) {
        try {
            Thread.sleep(ms);
        } catch (InterruptedException ie) {}
    }
}
