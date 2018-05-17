<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<% ssn.ensureLoggedOn(); %>

<h2><%=ssn.string("friends")%></h2>
<p><%=ssn.string("friends_descr")%></p>

<table border=0 cellspacing=1 cellpadding=3 class="bordered">
  <tr>
    <th nowrap bgcolor="#808080" align="left" width=100><%=ssn.string("username")%></th>
    <th nowrap bgcolor="#808080" align="left" width=100><%=ssn.string("full_name")%></th>
    <th nowrap bgcolor="#808080"><%=ssn.string("mutual_friends")%></th>
    <th nowrap bgcolor="#808080"><%=ssn.string("control")%></th>
  </tr>
<%
  ResultSet rs = DB.query("SELECT friends.id, users.nick, users.name, mutual.id FROM friends" +
                          "  INNER JOIN users ON friends.friend = users.id " +
                          "  LEFT OUTER JOIN friends AS mutual ON friends.friend = mutual.user AND friends.user = mutual.friend " +
                          "  WHERE friends.user = ?",
                          ssn.id);
  while (rs.next()) {
%>
  <tr>
    <td nowrap bgcolor="#dddddd" align="left"  ><%=Util.encodeHTML(rs.getString(2))%></td>
    <td nowrap bgcolor="#dddddd" align="left"  ><%=Util.encodeHTML(rs.getString(3))%></td>
    <td nowrap bgcolor="#dddddd" align="center"><%=ssn.string(rs.getInt(4) != 0 ? "yes" : "no")%></td>
    <td nowrap bgcolor="#dddddd" align="center"><a href="do_friends.jsp?action=delete&id=<%=rs.getInt(1)%>"><%=ssn.string("exclude")%></a></td>
  </tr> 
<%
  }
  if (!rs.isAfterLast()) out.write(Util.emptyRow(ssn.lang, 4));
  DB.close(rs);
%>
</table>
<br>
<form action="do_friends.jsp?action=add" method="post">
<p><%=ssn.string("add_friend")%>
<input type="text" name="nick" size=41>&nbsp;
<input type="submit" value="<%=ssn.string("add")%>">
</form>
<p>&nbsp;</p>

<h2><%=ssn.string("you_are_friend_of")%></h2>
<table border=0 cellspacing=1 cellpadding=3 class="bordered">
  <tr>
    <th nowrap bgcolor="#808080" align="left" width=100><%=ssn.string("username")%></th>
    <th nowrap bgcolor="#808080" align="left" width=100><%=ssn.string("full_name")%></th>
    <th nowrap bgcolor="#808080"><%=ssn.string("mutual_friends")%></th>
    <th nowrap bgcolor="#808080"><%=ssn.string("number_of_beings")%></th>
  </tr>
<%
  rs = DB.query("SELECT friends.user, users.nick, users.name, mutual.id, COUNT(DISTINCT beings2.id), COUNT(DISTINCT beings3.id) FROM friends" +
                "  INNER JOIN users ON friends.user = users.id " +
                "  LEFT OUTER JOIN beings AS beings2 ON friends.user = beings2.owner AND beings2.permissions = 2 " +
                "  LEFT OUTER JOIN beings AS beings3 ON friends.user = beings3.owner AND beings3.permissions = 3 " +
                "  LEFT OUTER JOIN friends AS mutual ON friends.friend = mutual.user AND friends.user = mutual.friend " +
                "  WHERE friends.friend = ? " +
                "  GROUP BY friends.user, users.nick, users.name, mutual.id",
                ssn.id);
  while (rs.next()) {
%>
  <tr>
    <td nowrap bgcolor="#dddddd" align="left"  ><%=Util.encodeHTML(rs.getString(2))%></td>
    <td nowrap bgcolor="#dddddd" align="left"  ><%=Util.encodeHTML(rs.getString(3))%></td>
    <td nowrap bgcolor="#dddddd" align="center"><%=rs.getInt(4) != 0 ? "да" : "<a href=\"do_friends.jsp?action=add&nick=" + Util.encodeURL(rs.getString(2)) + "\">"+ssn.string("add")+"</a>"%></td>
    <td nowrap bgcolor="#dddddd" align="center"><a href="index.jsp?page=contest#f<%=rs.getInt(1)%>"><%=rs.getInt(5)%> / <%=rs.getInt(6)%></a></td>
  </tr>
<%
  }
  if (!rs.isAfterLast()) out.write(Util.emptyRow(ssn.lang, 4));
  DB.close(rs);
%>
</table>
