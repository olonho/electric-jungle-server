<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<%!
  ErrorCode performLaunch(HttpServletRequest request, Session ssn, ServletContext application)
    throws Exception
  {
    if (Contest.count(ssn.id) >= 3) {
      return ErrorCode.TOO_MANY_CONTESTS;
    }
    if (Contest.all.size() >= 50 && Contest.count() >= 50) {
      return ErrorCode.SERVER_OVERLOADED;
    }

    String[] ids = request.getParameterValues("id");
    if (ids == null || ids.length > 16) {
      return ErrorCode.BAD_BEING_LIST;
    }
    // Build the string "(id1,id2,id3...)"
    StringBuilder idlist = new StringBuilder();
    for (String s : ids) {
      if (!s.matches("\\d+")) {
        return ErrorCode.INVALID_PARAMETER;
      }
      idlist.append(',');
      idlist.append(s);
    }
    idlist.append(')');
    idlist.setCharAt(0, '(');

    ArrayList<String> args = new ArrayList<String>();
    args.add("--turn-delay");
    args.add("200");
    args.add("--wait-before");
    // more than refresh time in page_contest.jsp
    args.add("30000");
    args.add("--game-kind");
    args.add(ids.length == 1 ? "SINGLE" : (ids.length == 2 ? "DUEL" : "JUNGLE"));
    args.add("--no-log");
    args.add("--record-file");
    args.add(ejungle.manager.Manager.getInstance().getRealPath("games/<key>.ej"));
    // Additional parameters allowed to Administrator
    if (ssn.checkAccess(ssn.ACCESS_ADMIN)) {
      for (Enumeration<String> e = request.getParameterNames(); e.hasMoreElements(); ) {
        String name = e.nextElement();
        if (name.startsWith("--")) {
          args.add(name);
          args.add(request.getParameter(name));
        }
      }
    }

    ResultSet rs = DB.query("SELECT beings.id, beings.jarfile, beings.mainclass, users.nick, friends.id FROM beings " +
                            "  INNER JOIN users ON beings.owner = users.id " +
                            "  LEFT OUTER JOIN friends ON friends.user = beings.owner AND friends.friend = ? " +
                            "  WHERE beings.id IN " + idlist +
                            "  AND (beings.owner = ? OR beings.permissions + (friends.id IS NOT NULL) >= 3)",
                            ssn.id, ssn.id);
    while (rs.next()) {
      args.add(rs.getString(3));
      args.add(ssn.getBeingJar(rs.getString(2), rs.getString(4)));
    }
    DB.close(rs);

    String classpath = ssn.getEngineJar();
    Contest c = Contest.create(ssn.id, args.toArray(ids), classpath);
    c.start();
    return null;
  }
  
  ErrorCode performDelete(HttpServletRequest request, Session ssn, ServletContext application)
    throws SQLException
  {
    Contest c = Contest.all.get(request.getParameter("key"));
    if (c == null || c.getOwner() != ssn.id) {
      return ErrorCode.INVALID_PARAMETER;
    }
    c.destroy();
    return null;
  }
%>
<%
  ssn.ensureLoggedOn();
  request.setCharacterEncoding(ssn.string("charset"));

  ErrorCode error = null;
  String action = request.getParameter("action");
  if ("launch".equals(action)) {
    error = performLaunch(request, ssn, application);
  } else if ("delete".equals(action)) {
    error = performDelete(request, ssn, application);
  }
  String redirectPage = "/main.jsp?page=contest";
  if (error != null) {
    redirectPage += "&error=" + error;
  }
  response.sendRedirect(redirectPage);
%>
