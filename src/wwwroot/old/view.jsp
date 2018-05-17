<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>

<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=windows-1251">
  <title>Electric Jungle - Sun Microsystems</title>
  <link rel="stylesheet" href="style.css" type="text/css">
</head>
<body leftmargin=0 topmargin=0 bgcolor="#ffffff" text="#000000">
  <table border=0 cellspacing=0 cellpadding=10 width="100%" height="100%">
    <tr>
      <td width=104 bgcolor="#5080a0" align="left" valign="top">
        <a href="index.jsp"><img align="left" border=0 hspace=0 vspace=0 width=84 height=36 src="images/logo.gif" alt="Home"></a>
      </td>
      <td align="center" valign="middle" bgcolor="#5080a0"><img width=400 height=45 src="images/title.gif" alt="Electric Jungle"></td>
      <td width=104 bgcolor="#5080a0" align="right" valign="top">&nbsp;</td>
    </tr>
    <tr>
      <td colspan=3 width="100%" height="100%" align="center" valign="middle">
<%
  String key = request.getParameter("key");
  Contest contest = key == null ? null : Contest.all.get(key);
%>
<% if (contest != null) { %>
        <jsp:plugin type="applet" code="universum.EJApplet" archive="universum.jar" codebase="files" jreversion="1.5" width="780" height="500">
          <jsp:params>
            <jsp:param name="host" value="<%=request.getServerName()%>" />
            <jsp:param name="port" value="<%=contest.getListenPort()%>" />
          </jsp:params>
        </jsp:plugin>
<% } else { %>
        <h4 align="center"><%=ErrorCode.INVALID_PARAMETER.getMessage()%></h4>
<% } %>
      </td>
    </tr>
    <tr>
      <td colspan=3 width="100%" align="center" valign="middle" class="small" style="padding: 5px">Copyright 2006 Sun Microsystems, Inc.</td>
    </tr>
  </table>
</body>
</html>
