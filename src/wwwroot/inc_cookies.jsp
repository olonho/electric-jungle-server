<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<%  
  String lang = request.getParameter("lang");
  if (lang != null && (lang.equals("en") || lang.equals("ru"))) {
    ssn.setLang(lang);
  }
  Cookie[] cookies;
  if (!ssn.loggedOn() && (cookies = request.getCookies()) != null) {
    for (int i = 0; i < cookies.length; i++) {
      if ("autologon".equals(cookies[i].getName())) {
        String value = cookies[i].getValue();
        // Try autologon
        try {
          int p = value.indexOf(',');
          int id = Integer.parseInt(value.substring(0, p));
          ResultSet rs = DB.query(
            "SELECT users.nick, users.name, users.rights, users.password, phpbb_users.user_lang FROM users" +
            "  LEFT OUTER JOIN phpbb_users ON users.nick = phpbb_users.username" +
            "  WHERE users.id = ? AND users.cookie = ?",
            id, value.substring(p + 1));
          if (!rs.next()) {
            DB.close(rs);
            cookies[i].setMaxAge(0);
            response.addCookie(cookies[i]);
            if ("/index.jsp".equals(request.getServletPath())) {
              break;
            }
            response.sendRedirect("/");
            return;
          }
          ssn.logon(id, rs.getString(1), rs.getString(2), rs.getInt(3), rs.getString(4));
          lang = rs.getString(5);
          DB.close(rs);
          if ("english".equals(lang)) {
            ssn.setLang("en");
          }
          Util.updateCookie(ssn, response);
          if ("/index.jsp".equals(request.getServletPath()) &&
              request.getParameter("error") == null) {
            response.sendRedirect("/main.jsp?page=profile");
          }
        } catch (Exception e) {}
        break;
      }
    }
  }
%>
