<%
  String detailsPage = "finalinfo&tag=" + tag;
  boolean hasSave = true;
%>
<table border=0 cellspacing=1 cellpadding=3 bgcolor="#909030" class="cell">
  <tr>
    <th nowrap class="cell" align="center"><%=ssn.string("contest")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("turns")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("result")%></th>
<% if (hasSave) { %>
    <th nowrap class="cell" align="center"><%=ssn.string("view_replay")%></th>
<% } %>
  </tr>
<%
  rs = DB.query("SELECT turns, score, save FROM results" + tag + " AS results, contests" + tag + " AS contests" +
                "  WHERE contests.id = results.contest AND results.being = ?",
                being);
  int pos = 0;
  while (rs.next()) {
    String save = rs.getString(3);
%>
  <tr>
    <td nowrap class="cell" align="center"><%=++pos%></td>
    <td nowrap class="cell" align="center"><%=rs.getInt(1)%></td>
    <td nowrap class="cell" align="right"><%=rs.getInt(2)%></td>
<% if (hasSave) { %>
    <td class="cell" align="center">
      &nbsp;<a href="view_jnlp.jnlp?save=<%=save%>"><%=ssn.string("webstart")%></a>&nbsp;
      &nbsp;<a href="view_applet.jsp?save=<%=save%>"><%=ssn.string("applet")%></a>&nbsp;
      &nbsp;<a href="games/<%=save%>"><%=ssn.string("download")%></a>&nbsp;
    </td>
<% } %>
  </tr>
<%
  }
  DB.close(rs);
%>
  <ej:row colspan="<%=hasSave ? "4" : "3"%>" empty="<%=pos == 0%>" />
</table>
