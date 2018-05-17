<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="ejungle.web.*" %>
<%@ include file="inc_cookies.jsp" %>
<%
  String key = request.getParameter("key");
  Contest contest = key == null ? null : Contest.all.get(key);
%>

<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=<%=ssn.string("charset")%>">
  <title><%=ssn.string("page_title")%></title>
  <link rel="stylesheet" href="style.css" type="text/css">
</head>
<body leftmargin=0 topmargin=0 bgcolor="#ffffff" text="#000000">

<table width="100%" height="100%" border=0 cellspacing=0 cellpadding=0>
  <tr>
    <td nowrap width=150 height=79 align="left" valign="middle"><a href="http://www.sun.com" target="_blank"><img border=0 src="images/logo.gif" width=95 height=48 alt="Sun" hspace=20 vspace=0></a></td>
    <td nowrap width=44 height=79 bgcolor="#586a88"><img width=44 height=79 src="images/head_wave.jpg"></td>
    <td width="100%" height=79 bgcolor="#586a88" background="images/head_bg.jpg">
      <% String pageName = "applet"; %>
      <%@ include file="inc_menu.jsp" %>
    </td>
  </tr>
  <tr>
    <td nowrap width=150 height="100%"></td>
    <td colspan=2 height="100%" align="left" valign="top" style="padding: 5px">
<% if (contest != null) { %>
      <jsp:plugin type="applet" code="universum.EJApplet" archive="universum.jar" codebase="files" jreversion="1.5" width="780" height="500">
        <jsp:params>
          <jsp:param name="host" value="<%=request.getLocalAddr()%>" />
          <jsp:param name="port" value="<%=contest.getListenPort()%>" />
        </jsp:params>
      </jsp:plugin>
<% } else if ((key = request.getParameter("save")) != null) { %>
      <jsp:plugin type="applet" code="universum.EJApplet" archive="universum.jar" codebase="files" jreversion="1.5" width="780" height="500">
        <jsp:params>
          <jsp:param name="save" value="<%=Util.getRequestPath(request) + "/games/" + key%>" />
        </jsp:params>
      </jsp:plugin>
<% } else { %>
      <h4 align="center"><%=ssn.enumString(ErrorCode.INVALID_PARAMETER)%></h4>
<% } %>
    </td>
  </tr>
  <tr>
    <td colspan=3 height=25 bgcolor="#f0f0c7" background="images/main_bottom.gif" align="center" valign="middle" class="small">
      <%=ssn.string("link_about")%> &nbsp;|&nbsp; <%=ssn.string("link_trademarks")%> &nbsp;|&nbsp; Copyright 2006 Sun Microsystems Inc.
    </td>
  </tr>
</table>

</body>
</html>
