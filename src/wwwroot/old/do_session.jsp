<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<%!
  static boolean isEmpty(String s) {
      return s == null || s.equals("");
  }
  
  String performLogout(HttpServletRequest request, Session ssn) {
    ssn.logout();
    return "index.jsp";
  }

  String performLogon(HttpServletRequest request, Session ssn)
  {
     if (Util.checkAuthAndLogon(request.getParameter("nick"), 
                                request.getParameter("password"),
                                ssn)) {
         return "index.jsp?page=profile";
     } else {
         return "index.jsp?error=" + ErrorCode.LOGON_FAILURE;
     }
  }

  String performRegister(HttpServletRequest request, Session ssn)
    throws SQLException
  {
    ErrorCode error = null;
    String nick, password, name;
    if (isEmpty(nick = request.getParameter("nick"))) {
      error = ErrorCode.NO_NAME;
    } else if (!nick.matches("[a-zA-Z0-9@\\-]+")) {
      error = ErrorCode.INVALID_CHARS;
    } else if (isEmpty(password = request.getParameter("password"))) {
      error = ErrorCode.NO_PASSWORD;
    } else if (!password.equals(request.getParameter("password2"))) {
      error = ErrorCode.PASSWORD_MISMATCH;
    } else if (isEmpty(name = request.getParameter("name"))) {
      error = ErrorCode.NO_NAME;
    } else {
      error = Util.addLocalRecord(nick, password, Session.ACCESS_MEMBER, name, 
                                  request.getParameter("email"), 
                                  request.getParameter("phone"), 
                                  request.getParameter("work"),
                                  ssn);  
    }
    return error == null ? "index.jsp?page=profile" :
                           "index.jsp?page=register&error=" + error;
  }

  String performUpdate(HttpServletRequest request, Session ssn)
    throws SQLException
  {
    ErrorCode error = null;
    int result;
    String password;
    if (isEmpty(password = request.getParameter("password"))) {
      result = DB.update("UPDATE users SET email = ?, phone = ?, work = ?" +
                         "  WHERE id = ? AND password = ?",
                         request.getParameter("email"), request.getParameter("phone"),
                         request.getParameter("work"), ssn.id,
                         Util.md5(request.getParameter("oldpassword")));
    } else if (!password.equals(request.getParameter("password2"))) {
      return "index.jsp?page=profile&error=" + ErrorCode.PASSWORD_MISMATCH;
    } else {
      result = DB.update("UPDATE users SET password = ?, email = ?, phone = ?, work = ?" +
                         "  WHERE id = ? AND password = ?",
                         password, request.getParameter("email"), request.getParameter("phone"),
                         request.getParameter("work"), ssn.id,
                         Util.md5(request.getParameter("oldpassword")));
    }
    return "index.jsp?page=profile&error=" +
           (result == 0 ? ErrorCode.BAD_PASSWORD : ErrorCode.CHANGE_SUCCESS);
  }
%>
<%
  String redirectPage;
  String action = request.getParameter("action");
  if ("logout".equals(action)) {
    redirectPage = performLogout(request, ssn);
  } else if ("logon".equals(action)) {
    redirectPage = performLogon(request, ssn);
  } else if ("register".equals(action)) {
    redirectPage = performRegister(request, ssn);
  } else if ("update".equals(action)) {
    ssn.ensureLoggedOn();
    redirectPage = performUpdate(request, ssn);
  } else {
    redirectPage = "index.jsp";
  }
  response.sendRedirect(redirectPage);
%>
