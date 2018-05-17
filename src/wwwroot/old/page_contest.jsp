<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>

<h2><%=ssn.string("contests")%></h2>
<div id="updateFront"><%@ include file="inc_contest.jsp" %></div>
<iframe id="updateBack" style="display:none" onload="updateData()"></iframe>
<script language="JavaScript">
  var remoteDoc;

  function updateData() {
    remoteDoc = updateBack.contentWindow ? updateBack.contentWindow.document : updateBack.document;
    var newData = remoteDoc.body.innerHTML;
    if (newData && updateFront.innerHTML != newData) updateFront.innerHTML = newData;
    window.setTimeout("remoteDoc.location = 'update_contest.jsp'", 10000);
  }

  function ask() {
    return window.confirm("<%=ssn.string("cancel_contest")%>");
  }
</script>
<p>&nbsp;</p>

<h2><%=ssn.string("begin_new_contest")%></h2>
<form action="do_contest.jsp?action=launch" method="post">
<table width=600 border=0 cellspacing=1 cellpadding=3 class="bordered">
  <tr>
    <th nowrap align="center" bgcolor="#808080">&nbsp;</th>
    <th nowrap align="left"   bgcolor="#808080"><%=ssn.string("author")%></th>
    <th nowrap align="left"   bgcolor="#808080"><%=ssn.string("jar_file")%></th>
    <th nowrap align="center" bgcolor="#808080"><%=ssn.string("size")%></th>
    <th nowrap align="left"   bgcolor="#808080"><%=ssn.string("main_class")%></th>
  </tr>
<%
  ResultSet rs = DB.query("SELECT beings.id, beings.owner, beings.jarfile, beings.jarsize, beings.mainclass, beings.permissions, users.nick, friends.id FROM beings " +
                          "  INNER JOIN users ON users.id = beings.owner " +
                          "  LEFT OUTER JOIN friends ON friends.user = beings.owner AND friends.friend = ? " +
                          "  WHERE beings.owner = ? OR beings.permissions + (friends.id IS NOT NULL) >= 3 " +
                          "  ORDER BY beings.owner = ? DESC, beings.owner, beings.permissions",
                          ssn.id, ssn.id, ssn.id);
  int lastOwner = 0;
  while (rs.next()) {
    int owner = rs.getInt(2);
    if (owner != lastOwner) {
      out.write("<tr><td colspan=5 height=1 bgcolor=\"#0099ff\" style=\"padding: 0px\"><a name=\"f" + owner + "\"></a></td></tr>\n");
      lastOwner = owner;
    }
    String color;
    if (owner == ssn.id) {
      color = "#ffdddd";
    } else if (rs.getInt(6) == 2) {
      color = "#ffffdd";
    } else {
      color = "#ddffdd";
    }
%>
  <tr>
    <td align="center" bgcolor="<%=color%>" width=20><input type="checkbox" name="id" value="<%=rs.getInt(1)%>" class="checkbox"></td>
    <td align="left"   bgcolor="#dddddd"><%=Util.encodeHTML(rs.getString(7))%></td>
    <td align="left"   bgcolor="#dddddd"><%=Util.encodeHTML(rs.getString(3))%></td>
    <td align="right"  bgcolor="#dddddd"><%=(rs.getInt(4) / 1024) + "&nbsp;"+ssn.string("kb")%></td>
    <td align="left"   bgcolor="#dddddd"><%=Util.encodeHTML(rs.getString(5))%></td>
  </tr>
<%
  }
  if (!rs.isAfterLast()) out.write(Util.emptyRow(ssn.lang, 5));
  DB.close(rs);
%>
</table>
<br>
<table border=0 cellspacing=1 cellpadding=3>  
<% if (ssn.checkAccess(ssn.ACCESS_ADMIN)) { %>
  <tr>
    <td colspan=7 align="left"><input type="checkbox" name="--tournament" value="true"> <b>“урнир</b> (результаты сохран€ютс€ и вли€ют на общий рейтинг)</td>
  </tr>
<% } %>
  <tr><td colspan=7 height=5></td></tr>
  <tr>
    <td colspan=7 align="left"><input type="submit" value="<%=ssn.string("begin_contest")%>" class="button"></td>
  </tr>
</table>
</form>
