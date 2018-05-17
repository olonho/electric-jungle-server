<%
  String detailsPage = "".equals(tag) ? "beinginfo" : "finalinfo&tag=" + tag;
  boolean hasSave = "_FINALDUEL".equals(tag);
%>
<table border=0 cellspacing=1 cellpadding=3 bgcolor="#909030" class="cell">
  <tr>
    <th nowrap class="cell" align="center"><%=ssn.string("contest")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("opponent")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("turns")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("result")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("result")%></th>
<% if (hasSave) { %>
    <th nowrap class="cell" align="center"><%=ssn.string("view_replay")%></th>
<% } %>
  </tr>
<%
  rs = DB.query("SELECT results1.score, results2.score, beings.id, beings.mainclass, contests.turns, contests.save " +
                "  FROM results" + tag + " AS results1, results" + tag + " AS results2, " +
                "       contests" + tag + " AS contests, beings_FINAL AS beings " +
                "  WHERE contests.id = results1.contest AND contests.id = results2.contest AND " +
                "        results1.being = ? AND results2.being = ? AND " +
                "        contests.kind = 2 AND beings.id = results2.being " +
                "  ORDER BY results1.score - results2.score",
                being, opponent);
  int pos = 0;
  String green = "style=\"background-color: #bbffbb\"";
  String red = "style=\"background-color: #ffbbbb\"";
  while (rs.next()) {
    float r1 = rs.getFloat(1);
    float r2 = rs.getFloat(2);
    String save = rs.getString(6);
%>
  <tr>
    <td nowrap class="cell" align="center"><%=++pos%></td>
    <td nowrap class="cell" align="left"><a style="text-decoration: none" href="main.jsp?page=<%=detailsPage%>&being=<%=rs.getInt(3)%>"><%=rs.getString(4)%></a></td>
    <td nowrap class="cell" align="center"><%=rs.getInt(5)%></td>
    <td nowrap class="cell" align="right" <%=r1 > r2 ? green : ""%>><%=(int)r1%></td>
    <td nowrap class="cell" align="right" <%=r1 < r2 ? red : ""%>><%=(int)r2%></td>
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
  <ej:row colspan="<%=hasSave ? "6" : "5"%>" empty="<%=pos == 0%>" />
</table>
