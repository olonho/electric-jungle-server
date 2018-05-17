package ejungle.web;

import java.net.*;
import java.io.*;

class SDNAuth {    
    public static void main(String[] args) {
        SDNAuth auth = new SDNAuth(null, 3128);
        System.out.println("doAuth() gave "+auth.doAuth(args[0], args[1])); 
    }

    private String proxyHost;
    private int    proxyPort;
    
    SDNAuth(String proxyHost, int proxyPort) {
        this.proxyHost = proxyHost;
        this.proxyPort = proxyPort;
    }
    
    boolean doAuth(String username, String password) {
        try {
            URL url = new URL("https://identity.sun.com/amserver/UI/Login" +
                              "?IDToken1=" + username + "&IDToken2=" + password);
            HttpURLConnection conn;
            if (proxyHost != null) {
                Proxy proxy = new Proxy(Proxy.Type.HTTP,
                    new InetSocketAddress(proxyHost, proxyPort));
                conn = (HttpURLConnection)url.openConnection(proxy);
            } else {
                conn = (HttpURLConnection)url.openConnection();
            }
            int code = conn.getResponseCode();
            conn.disconnect();
            return code == HttpURLConnection.HTTP_MOVED_TEMP;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
