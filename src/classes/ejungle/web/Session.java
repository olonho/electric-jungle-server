package ejungle.web;
import java.util.ResourceBundle;

public class Session {
    public static final int ACCESS_MEMBER = 0x0001;
    public static final int ACCESS_ADMIN  = 0xffff;

    public static final String DEFAULT_LANG = "ru";

    public int id;
    public String nick;
    public String name;
    public String md5pass;
    public String lang;
    public int rights;
    
    private ResourceBundle rb;

    public Session() {
        id = 0;
        rights = 0;
        lang = DEFAULT_LANG;
        rb = Util.getLocale(lang);
    }

    public void logon(int id, String nick, String name, int rights, String md5pass) {
        this.id = id;
        this.nick = nick;
        this.name = name;
        this.rights = rights;
        this.md5pass = md5pass;
    }

    public void setLang(String lang) {
        if (lang == null || lang.equals(this.lang)) {
            return;
        }
        this.lang = lang;
        rb = Util.getLocale(lang);
        if (loggedOn()) {
            try {
                DB.update("UPDATE phpbb_users SET user_lang = ? WHERE username = ?",
                          "en".equals(lang) ? "english" : "russian", nick);
            } catch (Exception e) {}
        }
    }

    public void logout() {
        id = 0;
        rights = 0;
    }

    public boolean loggedOn() {
        return id != 0;
    }

    public void ensureLoggedOn() {
        if (!loggedOn()) {
            throw new SecurityException("Authorized access only");
        }
    }

    public boolean checkAccess(int access) {
        return (rights & access) == access;
    }

    public String getBeingJar(String file, String user) {
        return ejungle.manager.Manager.getInstance().getBeingJar(user, file);
    }


    public String getBeingJar(String file) {
        return getBeingJar(file, nick);
    }

    public String getEngineJar() {
        return ejungle.manager.Manager.getInstance().getEngineJar();  
    }

    public String string(String key) {
        try {
            return rb.getString(key);
        } catch (Exception e) {
            return  "missing resource: "+key+" in lang "+lang;
        }
    }

    public String enumString(Enum key) {
        return rb.getString("enum_"+key.name());
    }
}
