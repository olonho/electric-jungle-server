<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="ejungle.web.*" %>
<%@ include file="inc_cookies.jsp" %>

<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=<%=ssn.string("charset")%>">
  <title><%=ssn.string("page_title")%></title>
  <link rel="stylesheet" href="style.css" type="text/css">
</head>
<body leftmargin=0 topmargin=0 bgcolor="#ffffff" text="#000000">

<table border=0 cellspacing=0 cellpadding=5 width="100%" height="100%">
  <tr><td align="center" valign="middle"><table width=800 height=600 border=0 cellspacing=0 cellpadding=0>
    <tr>
      <td width=354 rowspan=2 align="left" valign="top"><a href="http://www.sun.com" target="_blank"><img border=0 src="images/logo.gif" width=95 height=48 alt="Sun" hspace=10 vspace=0></a></td>
      <td width=446 height=35 align="right" valign="bottom">
        <table border=0 cellspacing=0 cellpadding=3>
          <tr>
            <td class="menu"><a href="index.jsp?lang=ru" class="menu">RUS</a></td>
            <td class="menu">|</td>
            <td class="menu"><a href="index.jsp?lang=en" class="menu">ENG</a></td>
            <td class="menu" width=10>&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <!-- rowspan -->
      <td width=446 height=25 align="right" valign="bottom">
        <table border=0 cellspacing=0 cellpadding=3>
          <tr>
            <td class="menu"><a href="main.jsp?page=intro"    class="menu"><%=ssn.string("menu_intro")%></a></td>
            <td class="menu">|</td>
            <td class="menu"><a href="main.jsp?page=rules"    class="menu"><%=ssn.string("menu_rules")%></a></td>
            <td class="menu">|</td>
            <td class="menu"><a href="main.jsp?page=sdk"      class="menu"><%=ssn.string("menu_sdk")%></a></td>
            <td class="menu">|</td>
            <td class="menu"><a href="main.jsp?page=forum"    class="menu"><%=ssn.string("menu_forum")%></a></td>
            <td class="menu">|</td>
            <td class="menu"><a href="main.jsp?page=rating"   class="menu"><%=ssn.string("menu_rating")%></a></td>
            <td class="menu">|</td>
            <td class="menu"><a href="main.jsp?page=final"    class="menu"><%=ssn.string("menu_final")%></a></td>
            <td class="menu">|</td>
            <td class="menu"><a href="main.jsp?page=register" class="menu"><%=ssn.string("menu_register")%></a></td>
            <td class="menu" width=10>&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td height=5></td>
      <td height=5></td>
    </tr>
<%
          ErrorCode error = ErrorCode.forName(request.getParameter("error"));
          if (error != null) {
              out.write("<tr><td colspan=2 align=\"center\"><h4>" + ssn.enumString(error) + "</h4></td></tr>");
          }
%>
    <tr>
      <td width=354 height=503 bgcolor="#406800"><img width=354 height=503 src="images/main_ej.jpg" alt="Electric Jungle"></td>
      <td width=446 height=503 bgcolor="#b6b660" background="images/main_bg.jpg" align="left" valign="top" style="padding: 20px 20px 0px 125px" class="small">
        <p><b><%=ssn.string("electric_jungle")%></b><br>
        <%=ssn.string("ej_descr")%></p>
        <p><b><%=ssn.string("competition")%></b><br>
        <%=ssn.string("competition_descr")%></p>
        <p><b><%=ssn.string("register_now")%></b><br>
        <%=ssn.string("to_become_participant")%><br>
        <%=ssn.string("registration_allows")%>
        <a href="main.jsp?page=register" class="splash"><%=ssn.string("register")%></a></p>
        <p><b><%=ssn.string("for_participants")%></b></p>
        <form method="post" action="do_session.jsp?action=logon">
        <table border=0 cellspacing=0 cellpadding=0 class="small">
          <tr>
            <td align="left"> <%=ssn.string("username")%>:&nbsp;</td>
            <td align="left"><input type="text" name="nick" size=30></td>
          </tr>
          <tr><td colspan=2 height=3></td></tr>
          <tr>
            <td align="left"> <%=ssn.string("password")%>:&nbsp;</td>
            <td align="left"><input type="password" name="password" size=30></td>
          </tr>
          <tr><td colspan=2 height=3></td></tr>
          <tr>
            <td align="left"  valign="bottom">&nbsp;</td>
            <td align="left"  valign="bottom"><input type="submit" value="   <%=ssn.string("enter")%>   " class="buttonsmall">&nbsp;&nbsp;<input type="checkbox" name="autologon" value="on" class="checkbox"> <%=ssn.string("autologon")%></td>
          </tr>
        </table>
        </form>
      </td>
    </tr>
    <tr>
      <td colspan=2 height=25 bgcolor="#f0f0c7" background="images/main_bottom.gif" align="left"  valign="middle" class="small">&nbsp;&nbsp; <%=ssn.string("link_about")%> &nbsp;|&nbsp; <%=ssn.string("link_trademarks")%> &nbsp;|&nbsp; Copyright 2006 Sun Microsystems Inc.</td>
    </tr>
    <tr>
      <td height=7></td>
      <td height=7></td>
    </tr>
  </table></td></tr>
</table>

</body>
</html>
