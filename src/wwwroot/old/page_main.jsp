<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session"/>
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="ejungle.web.*" %>

<h2><%=ssn.string("electric_jungle")%></h2>
<p><%=ssn.string("ej_descr")%></p>
<h2><%=ssn.string("competition")%></h2>
<p><%=ssn.string("competition_descr")%></p>

<p>&nbsp;</p>

<h2><%=ssn.string("register_now")%></h2>
<p><%=ssn.string("to_become_participant")%><br>
<%=ssn.string("registration_allows")%></p>

<form method="post" action="do_session.jsp?action=logon">
<table align="center" border=0 cellspacing=10 cellpadding=0>
<tr>
  <td colspan=2><table border=0 cellspacing=1 cellpadding=3 class="bordered" bgcolor="#ffffcc">
    <tr>
      <th align="left" bgcolor="#808080" colspan=2><%=ssn.string("for_participants")%></th>
    </tr>
    <tr>
      <td align="right"><%=ssn.string("username")%>:</td>
      <td align="left"><input name="nick" type="text" size=30></td>
    </tr>
    <tr>
      <td align="right"><%=ssn.string("password")%>:</td>
      <td align="left"><input name="password" type="password" size=30></td>
    </tr>
    <tr>
      <td align="center" colspan=2><input type="submit" value="<%=ssn.string("enter")%>" class="button"></td>
    </tr>
  </table></td>
</tr>
<tr>
  <td align="left" width="50%"><a href="index.jsp?page=register"><%=ssn.string("register")%></a></td>
  <td align="right" width="50%"><a href="index.jsp?page=forgot"><%=ssn.string("forgot_passwd")%>?</a></td>
</tr>
</table>
</form>
