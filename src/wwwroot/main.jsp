<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ taglib prefix="ej" tagdir="/WEB-INF/tags" %>
<%@ page import="ejungle.web.*" %>
<%@ include file="inc_cookies.jsp" %>
<%  
  String pageName = request.getParameter("page");
  if (pageName == null || pageName.equals("")) {
    pageName = "intro";
  }
  ErrorCode error = ErrorCode.forName(request.getParameter("error"));
%>

<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=<%=ssn.string("charset")%>">
  <title><%=ssn.string("page_title")%></title>
  <link rel="stylesheet" href="style.css" type="text/css">
</head>
<body leftmargin=0 topmargin=0 bgcolor="#ffffff" text="#000000">

<table width="100%" height="100%" border=0 cellspacing=0 cellpadding=0>

<tr><td height=79><table width="100%" border=0 cellspacing=0 cellpadding=0>
  <tr>
    <td width=150 height=79 align="left" valign="middle"><a href="http://www.sun.com" target="_blank"><img border=0 src="images/logo.gif" width=95 height=48 alt="Sun" hspace=20 vspace=0></a></td>
    <td width=44 height=79 bgcolor="#586a88"><img width=44 height=79 src="images/head_wave.jpg"></td>
    <td height=79 bgcolor="#586a88" background="images/head_bg.jpg">
      <%@ include file="inc_menu.jsp" %>
    </td>
  </tr>
</td></tr></table>

<tr><td valign="top"><table width="100%" height="100%" border=0 cellspacing=0 cellpadding=0>
  <tr>
    <td width=170 align="center" valign="top">
      <%@ include file="inc_sidebar.jsp" %>
    </td>
    <td align="left" valign="top" style="padding: 5px 20px 5px 5px">
<%
      if (error != null) {
          out.write("<h4 align=\"center\">" + ssn.enumString(error) + "</h4>");
      }
      pageContext.include("page_" + pageName + ".jsp");
%>
    </td>
  </tr>
</td></tr></table>

<tr><td height=5></td></tr>
<tr><td height=25 bgcolor="#f0f0c7" background="images/main_bottom.gif" align="center" valign="middle" class="small">
    <%=ssn.string("link_about")%> &nbsp;|&nbsp; <%=ssn.string("link_trademarks")%> &nbsp;|&nbsp; Copyright 2006 Sun Microsystems Inc.
</td></tr>

</table>

</body>
</html>
