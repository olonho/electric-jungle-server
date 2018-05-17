<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<% ssn.ensureLoggedOn(); %>

<%
  ResultSet rs = DB.query("SELECT users.email, users.phone, users.work, COUNT(DISTINCT beings.id), COUNT(DISTINCT friends.id) FROM users " +
                          "  LEFT OUTER JOIN beings ON users.id = beings.owner" +
                          "  LEFT OUTER JOIN friends ON users.id = friends.user" +
                          "  WHERE users.id = ? " +
                          "  GROUP BY users.email, users.phone, users.work ",
                          ssn.id);
  rs.next();
%>

<h2><%=ssn.string("profile")+" "+Util.encodeHTML(ssn.nick)%></h2>
<form method="post" action="do_session.jsp?action=update">
<table border=0 cellspacing=3 cellpadding=0>
  <tr><td align="right"><b><%=ssn.string("old_password")%>:&nbsp;</b></td><td><input name="oldpassword" type="password" size=30></td></tr>
  <tr><td align="right"><b><%=ssn.string("new_password")%>:&nbsp;</b></td><td><input name="password" type="password" size=30></td></tr>
  <tr><td align="right"><b><%=ssn.string("password_again")%>:&nbsp;</b></td><td><input name="password2" type="password" size=30></td></tr>
  <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
  <tr><td align="right"><b><%=ssn.string("full_name")%>:&nbsp;</b></td><td><%=Util.encodeHTML(ssn.name)%></td></tr>
  <tr><td align="right"><b><%=ssn.string("e-mail")%>:&nbsp;</b></td><td><input name="email" type="text" value="<%=Util.encodeHTML(rs.getString(1))%>" size=50></td></tr>
  <tr><td align="right"><b><%=ssn.string("phone")%>:&nbsp;</b></td><td><input name="phone" type="text" value="<%=Util.encodeHTML(rs.getString(2))%>" size=50></td></tr>
  <tr><td align="right"><b><%=ssn.string("company_university")%>:&nbsp;</b></td><td><input name="work" type="text" value="<%=Util.encodeHTML(rs.getString(3))%>" size=50></td></tr>
  <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
  <tr><td>&nbsp;</td><td align="left"><input type="submit" value="<%=ssn.string("change")%>" class="button"></td></td></tr>
</table>
</form>
<p>&nbsp;</p>

<h2><%=ssn.string("statistics")%></h2>
<table border=0 cellspacing=1 cellpadding=3>
  <tr>
    <td align="right"><a>></a>&nbsp; <a href="index.jsp?page=beings"><%=ssn.string("different_creatures")%>:</a>&nbsp;</td>
    <td align="left"><b><%=rs.getInt(4)%></b></td>
  </tr>
  <tr>
    <td align="right"><a>></a>&nbsp; <a href="index.jsp?page=friends"><%=ssn.string("friends")%></a>&nbsp;</td>
    <td align="left"><b><%=rs.getInt(5)%></b></td>
  </tr>
  <tr>
    <td align="right"><a>></a>&nbsp; <a href="index.jsp?page=contest">
<%=ssn.string("active_contests")%>:</a>&nbsp;</td>
    <td align="left"><b><%=Contest.count(ssn.id)%></b></td>
  </tr>
  <tr>
    <td align="right"><a>></a>&nbsp; <a href="index.jsp?page=rating">
<%=ssn.string("current_rating")%>:</a>&nbsp;</td>
    <td align="left"><b>1</b></td>
  </tr>
</table>
<% DB.close(rs); %>
