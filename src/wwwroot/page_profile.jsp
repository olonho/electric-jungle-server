<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<%@ taglib prefix="ej" tagdir="/WEB-INF/tags" %>
<% ssn.ensureLoggedOn(); %>

<%
  ResultSet rs = DB.query("SELECT users.email, users.phone, users.work, users.place," +
                          "  COUNT(DISTINCT beings.id), COUNT(DISTINCT friends.id)," +
                          "  MIN(rd.position), MIN(rd.group) FROM users " +
                          "  LEFT OUTER JOIN beings ON users.id = beings.owner" +
                          "  LEFT OUTER JOIN friends ON users.id = friends.user" +
                          "  LEFT OUTER JOIN ratingcache_DUEL AS rd ON users.id = rd.owner" +
                          "  WHERE users.id = ? " +
                          "  GROUP BY users.email, users.phone, users.work, users.place",
                          ssn.id);
  if (!rs.next()) {
    DB.close(rs);
    return;
  }
%>

<ej:pageheader type="1" header="<%=ssn.string("profile") + " " + Util.encodeHTML(ssn.nick)%>" />
<ej:textfield tabs="12" />
  <form method="post" action="do_session.jsp?action=update">
  <table border=0 cellspacing=3 cellpadding=0>
    <tr><td align="right"><b class="hl"><%=ssn.string("old_password")%>:&nbsp;</b></td><td><input name="oldpassword" type="password" size=30></td></tr>
    <tr><td align="right"><b class="hl"><%=ssn.string("new_password")%>:&nbsp;</b></td><td><input name="password" type="password" size=30></td></tr>
    <tr><td align="right"><b class="hl"><%=ssn.string("password_again")%>:&nbsp;</b></td><td><input name="password2" type="password" size=30></td></tr>
    <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
<% if (ssn.name.matches("[\\? ]*")) { %>
    <tr><td>&nbsp;</td><td class="alt"><%=ssn.string("change_name")%></td></tr>
<% } %>
    <tr><td align="right"><b class="hl"><%=ssn.string("full_name")%>:&nbsp;</b></td><td><input name="name" type="text" value="<%=Util.encodeHTML(ssn.name)%>" size=50></td></tr>
    <tr><td align="right"><b class="hl"><%=ssn.string("e-mail")%>:&nbsp;</b></td><td><input name="email" type="text" value="<%=Util.encodeHTML(rs.getString(1))%>" size=50></td></tr>
    <tr><td align="right"><b class="hl"><%=ssn.string("phone")%>:&nbsp;</b></td><td><input name="phone" type="text" value="<%=Util.encodeHTML(rs.getString(2))%>" size=50></td></tr>
    <tr><td align="right"><b class="hl"><%=ssn.string("company_university")%>:&nbsp;</b></td><td><input name="work" type="text" value="<%=Util.encodeHTML(rs.getString(3))%>" size=50></td></tr>
    <tr><td align="right"><b class="hl"><%=ssn.string("where_from")%>:&nbsp;</b></td><td><input name="place" type="text" value="<%=Util.encodeHTML(rs.getString(4))%>" size=50></td></tr>
    <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
    <tr><td>&nbsp;</td><td align="left"><input type="submit" value="<%=ssn.string("change")%>" class="button"></td></td></tr>
  </table>
  </form>
<ej:textfield />
  <h2><%=ssn.string("statistics")%></h2>
  <table border=0 cellspacing=1 cellpadding=3>
    <tr>
      <td align="right"><a href="main.jsp?page=beings"><%=ssn.string("different_creatures")%>:</a>&nbsp;</td>
      <td align="left"><%=rs.getInt(5)%></td>
    </tr>
    <tr>
      <td align="right"><a href="#friends"><%=ssn.string("friends")%></a>&nbsp;</td>
      <td align="left"><%=rs.getInt(6)%></td>
    </tr>
    <tr>
      <td align="right"><a href="main.jsp?page=contest"><%=ssn.string("active_contests")%>:</a>&nbsp;</td>
      <td align="left"><%=Contest.count(ssn.id)%></td>
    </tr>
    <tr>
      <td align="right"><a href="main.jsp?page=rating"><%=ssn.string("current_rating")%>:</a>&nbsp;</td>
      <td align="left"><%
        String pos = rs.getString(7);
        if (pos == null) {
          out.write("<b class=\"hl\">" + ssn.string("no") + "</b>");
        } else {
          int league = rs.getInt(8);
          out.write("<b class=\"hl\">" + pos + "</b>&nbsp;&nbsp;(");
          out.write(league == 0 ? ssn.string("major_league") : Integer.toString(league));
          out.write(" " + ssn.string("league") + ")");
        }
      %></td>
    </tr>
  </table>
<ej:textfield />
<% DB.close(rs); %>

<a name="friends"></a>
<script language="JavaScript">
  var defvalue = "<%=ssn.string("add_friend")%>";
  function gotFocus(box) {
    if (box.value == defvalue) {
      box.value = "";
    }
  }
  function lostFocus(box) {
    if (box.value == "") {
      box.value = defvalue;
    }
  }
</script>
<ej:textfield tabs="2" />
  <h2><%=ssn.string("friends")%></h2>
  <p><%=ssn.string("friends_descr")%></p>
  <table border=0 cellspacing=0 cellpadding=0 width="100%">
  <tr><td align="left" valign="top" width="50%">
    <table border=0 cellspacing=1 cellpadding=3 bgcolor="#909030" class="cell" width="100%">
      <tr>
        <th nowrap colspan=2 class="cell" align="left"><%=ssn.string("your_friends")%></th>
        <th nowrap class="cell" align="center"><%=ssn.string("control")%></th>
      </tr>
<%
       rs = DB.query("SELECT friends.id, users.nick, users.name, mutual.id FROM friends" +
                     "  INNER JOIN users ON friends.friend = users.id " +
                     "  LEFT OUTER JOIN friends AS mutual ON friends.friend = mutual.user AND friends.user = mutual.friend " +
                     "  WHERE friends.user = ? " +
                     "  ORDER BY mutual.id IS NULL, users.nick, users.name",
                     ssn.id);
       while (rs.next()) {
         String color = rs.getInt(4) == 0 ? "cell" : "cella";
%>
      <tr>
        <td nowrap class="<%=color%>" align="left"><%=Util.encodeHTML(rs.getString(2))%></td>
        <td nowrap class="<%=color%>" align="left"><%=Util.encodeHTML(rs.getString(3))%></td>
        <td nowrap class="<%=color%>" align="center"><a href="do_friends.jsp?action=delete&id=<%=rs.getInt(1)%>"><%=ssn.string("exclude")%></a></td>
      </tr>
<%     } %>
      <form id="frmAdd" name="frmAdd" method="post" action="do_friends.jsp?action=add">
      <tr>
        <td nowrap colspan=2 class="cell" align="left"><input type="text" name="nick" value="<%=ssn.string("add_friend")%>" size=30 style="width: 100%" onfocus="gotFocus(this)" onblur="lostFocus(this)"></td>
        <td nowrap class="cell" align="center"><a href="javascript:frmAdd.submit()"><%=ssn.string("add")%></a></td>
      </tr>
      </form>
      <ej:row colspan="3" empty="false" />
    </table>
<% DB.close(rs); %>
  </td><td width=10 nowrap>&nbsp;</td><td align="left" valign="top" width="50%">
    <table border=0 cellspacing=1 cellpadding=3 bgcolor="#909030" class="cell" width="100%">
      <tr>
        <th nowrap colspan=2 class="cell" align="left"><%=ssn.string("you_are_friend_of")%></th>
        <th nowrap class="cell" align="center"><%=ssn.string("number_of_beings")%></th>
      </tr>
<%
       rs = DB.query("SELECT friends.user, users.nick, users.name, mutual.id, COUNT(DISTINCT beings2.id), COUNT(DISTINCT beings3.id) FROM friends" +
                     "  INNER JOIN users ON friends.user = users.id " +
                     "  LEFT OUTER JOIN beings AS beings2 ON friends.user = beings2.owner AND beings2.permissions = 2 " +
                     "  LEFT OUTER JOIN beings AS beings3 ON friends.user = beings3.owner AND beings3.permissions = 3 " +
                     "  LEFT OUTER JOIN friends AS mutual ON friends.friend = mutual.user AND friends.user = mutual.friend " +
                     "  WHERE friends.friend = ? " +
                     "  GROUP BY friends.user, users.nick, users.name, mutual.id " +
                     "  ORDER BY mutual.id IS NULL, users.nick, users.name",
                     ssn.id);
       while (rs.next()) {
         String color = rs.getInt(4) == 0 ? "cell" : "cella";
%>
      <tr>
        <td nowrap class="<%=color%>" align="left"  ><%=Util.encodeHTML(rs.getString(2))%></td>
        <td nowrap class="<%=color%>" align="left"  ><%=Util.encodeHTML(rs.getString(3))%></td>
        <td nowrap class="<%=color%>" align="center"><a href="main.jsp?page=contest#f<%=rs.getInt(1)%>"><%=rs.getInt(5) + " " + ssn.string("b_friendly") + ", " + rs.getInt(6) + " " + ssn.string("b_public")%></a></td>
      </tr>
<%     } %>
      <ej:row colspan="3" empty="<%=!rs.isAfterLast()%>" />
    </table>
<% DB.close(rs); %>
  </tr>
  </table>
<ej:textfield />
