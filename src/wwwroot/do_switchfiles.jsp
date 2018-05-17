<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="ejungle.web.*" %>
<%
  final String from = request.getParameter("from");
  final String to   = request.getParameter("to");
  if (from == null || to == null || !ssn.checkAccess(ssn.ACCESS_ADMIN)) {
    response.sendRedirect("/index.jsp?error=" + ErrorCode.INVALID_PARAMETER);
    return;
  }

  long now = new Date().getTime();
  File rootDir = Util.getFile("/");
  String[] varFiles = rootDir.list(new FilenameFilter() {
    public boolean accept(File dir, String name) {
      return name.endsWith(from);
    }
  });

  if (varFiles != null && varFiles.length > 0) {
    for (String name : varFiles) {
      File f  = new File(rootDir, name.replace(from, ""));
      File f0 = new File(rootDir, name);
      File f1 = new File(rootDir, name.replace(from, to));
      f.renameTo(f1);
      f0.renameTo(f);
      f.setLastModified(now);
    }
  }

  response.sendRedirect("/index.jsp?error=" + ErrorCode.CHANGE_SUCCESS);
%>
