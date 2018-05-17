<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<%!
  static boolean isEmpty(String s) {
      return s == null || s.equals("");
  }
  
  String performLogout(HttpServletRequest request, HttpServletResponse response, Session ssn)
    throws SQLException
  {
    int id = ssn.id;
    ssn.logout();
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
      for (int i = 0; i < cookies.length; i++) {
        if ("autologon".equals(cookies[i].getName())) {
          cookies[i].setMaxAge(0);
          response.addCookie(cookies[i]);
          DB.update("UPDATE users SET cookie = NULL WHERE id = ?", id);
          break;
        }
      }
    }
    return "/index.jsp";
  }

  String performLogon(HttpServletRequest request, HttpServletResponse response, Session ssn)
    throws SQLException
  {
    if (Util.checkAuthAndLogon(request.getParameter("nick"), 
                               request.getParameter("password"),
                               ssn)) {
      if ("on".equals(request.getParameter("autologon"))) {
        Util.updateCookie(ssn, response);
      }
      return "/main.jsp?page=profile";
    } else {
      return "/index.jsp?error=" + ErrorCode.LOGON_FAILURE;
    }
  }

  String performRegister(HttpServletRequest request, Session ssn)
    throws SQLException
  {
    ErrorCode error = null;
    String nick, password, name;
    String captchaKey = (String)
        request.getSession().
                getAttribute(nl.captcha.servlet.Constants.SIMPLE_CAPCHA_SESSION_KEY);
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
    } else if (captchaKey == null ||
               !captchaKey.equals(request.getParameter("captcha"))) {
      error = ErrorCode.INVALID_CAPTCHA;
    } else {
      error = Util.addLocalRecord(nick, password, Session.ACCESS_MEMBER, name, 
                                  request.getParameter("email"), 
                                  request.getParameter("phone"), 
                                  request.getParameter("work"),
                                  request.getParameter("place"),
                                  ssn);
    }
    return error == null ? "/main.jsp?page=profile" :
                           "/main.jsp?page=register&error=" + error;
  }

  String performUpdate(HttpServletRequest request, Session ssn)
    throws SQLException
  {
    ErrorCode error = null;
    String password, name;
    if (isEmpty(name = request.getParameter("name"))) {
      return "/main.jsp?page=profile&error=" + ErrorCode.NO_NAME;
    }
    String oldpassword = request.getParameter("oldpassword");
    oldpassword = Util.md5(oldpassword == null ? "" : oldpassword);
    if (!oldpassword.equals(ssn.md5pass)) {
      return "/main.jsp?page=profile&error=" + ErrorCode.BAD_PASSWORD;
    }

    if (isEmpty(password = request.getParameter("password"))) {
      DB.update("UPDATE users SET name = ?, email = ?, phone = ?, work = ?, place = ?" +
                "  WHERE id = ?",
                name,
                request.getParameter("email"), request.getParameter("phone"),
                request.getParameter("work"), request.getParameter("place"), ssn.id);
      ssn.name = name;
    } else if (!password.equals(request.getParameter("password2"))) {
      return "/main.jsp?page=profile&error=" + ErrorCode.PASSWORD_MISMATCH;
    } else {
      password = Util.md5(password);
      DB.update("UPDATE users SET password = ?, name = ?, email = ?, phone = ?, work = ?, place= ?" +
                "  WHERE id = ?",
                password, name,
                request.getParameter("email"), request.getParameter("phone"),
                request.getParameter("work"), request.getParameter("place"), ssn.id);
      DB.update("UPDATE phpbb_users SET user_password = ? WHERE username = ?",
                password, ssn.nick);
      ssn.name = name;
      ssn.md5pass = password;
    }
    return "/main.jsp?page=profile&error=" + ErrorCode.CHANGE_SUCCESS;
  }
%>
<%
  request.setCharacterEncoding(ssn.string("charset"));

  String redirectPage;
  String action = request.getParameter("action");
  if ("logout".equals(action)) {
    redirectPage = performLogout(request, response, ssn);
  } else if ("logon".equals(action)) {
    redirectPage = performLogon(request, response, ssn);
  } else if ("register".equals(action)) {
    redirectPage = performRegister(request, ssn);
  } else if ("update".equals(action)) {
    ssn.ensureLoggedOn();
    redirectPage = performUpdate(request, ssn);
  } else {
    redirectPage = "/index.jsp";
  }

  String lang = request.getParameter("lang");
  if (lang != null && (lang.equals("en") || lang.equals("ru"))) {
    ssn.setLang(lang);
  }
  response.sendRedirect(redirectPage);
%>
