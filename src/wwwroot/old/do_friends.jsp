<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<%!
  ErrorCode performAdd(HttpServletRequest request, Session ssn)
    throws SQLException
  {
    
    String nick = request.getParameter("nick");
    String friends = "";
    ResultSet rs = DB.query("SELECT users.id, friends.id, nick = ? AS exact FROM users " +
                            "  LEFT OUTER JOIN friends ON friends.user = ? AND friends.friend = users.id " +
                            "  WHERE users.id <> ? AND (nick = ? OR name = ? OR email = ?) " +
                            "  ORDER BY exact DESC",
                            nick, ssn.id, ssn.id, nick, nick, nick);
    if (!rs.next()) {
      DB.close(rs);
      return ErrorCode.USER_NOT_FOUND;
    } else if (rs.getBoolean(3)) {
      if (rs.getInt(2) == 0) {
        friends = ", (" + ssn.id + ", " + rs.getInt(1) + ")";
      }
    } else {
      do {
        if (rs.getInt(2) == 0) {
          friends += ", (" + ssn.id + ", " + rs.getInt(1) + ")";
        }
      } while (rs.next());
    }
    DB.close(rs);
    if (friends.equals("")) {
      return ErrorCode.ALREADY_FRIEND;
    }
    DB.update("INSERT INTO friends (friends.user, friends.friend) VALUES " +
              friends.substring(2));
    return null;
  }

  ErrorCode performDelete(HttpServletRequest request, Session ssn)
    throws SQLException
  {
    DB.update("DELETE FROM friends WHERE friends.id = ? AND friends.user = ?",
              request.getParameter("id"), ssn.id);
    return null;
  }
%>
<%
  ssn.ensureLoggedOn();
  ErrorCode error = null;
  String action = request.getParameter("action");
  if ("add".equals(action)) {
    error = performAdd(request, ssn);
  } else if ("delete".equals(action)) {
    error = performDelete(request, ssn);
  }
  String redirectPage = "index.jsp?page=friends";
  if (error != null) {
    redirectPage += "&error=" + error;
  }
  response.sendRedirect(redirectPage);
%>
