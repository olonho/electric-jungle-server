<table border=0 cellspacing=1 cellpadding=3 bgcolor="#909030" class="cell">
  <tr>
    <th nowrap class="cell" align="center" width=30>N</th>
    <th nowrap class="cell" align="left"  ><%=ssn.string("opponent")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("victories")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("defeats")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("all_contests")%></th>
  </tr>
<%
  String detailsPage = "".equals(tag) ? "beinginfo" : "finalinfo&tag=" + tag;
  rs = DB.query("SELECT beings.id, beings.mainclass, SUM(NOT victory) AS victories, SUM(victory) AS defeats, SUM((NOT victory) - victory) AS rank FROM ( " +
                "  SELECT contest FROM results" + tag + " AS results, contests" + tag + " AS contests " +
                "    WHERE being = ? AND results.contest = contests.id AND contests.kind = 2 " +
                ") AS mycontests, results" + tag + " AS results, beings_FINAL AS beings " +
                "WHERE mycontests.contest = results.contest AND results.being <> ? AND beings.id = results.being " +
                "GROUP BY beings.id, beings.mainclass " +
                "ORDER BY rank",
                being, being);

  String green = "style=\"background-color: #bbffbb\"";
  String red = "style=\"background-color: #ffbbbb\"";
  int pos = 0;
  while (rs.next()) {
    int r1 = rs.getInt(3);
    int r2 = rs.getInt(4);
%>
  <tr>
    <td nowrap class="cell" align="center"><%=++pos%></td>
    <td nowrap class="cell" align="left"><a style="text-decoration: none" href="main.jsp?page=<%=detailsPage%>&being=<%=rs.getInt(1)%>"><%=rs.getString(2)%></a></td>
    <td nowrap class="cell" align="right" <%=r1 > r2 ? green : ""%>><%=r1%></td>
    <td nowrap class="cell" align="right" <%=r1 < r2 ? red : ""%>><%=r2%></td>
    <td nowrap class="cell" align="center"><a href="main.jsp?page=<%=detailsPage%>&being=<%=being%>&opponent=<%=rs.getInt(1)%>"><%=ssn.string("details")%></a></td>
  </tr>
<%}%>
  <ej:row colspan="5" empty="<%=!rs.isAfterLast()%>" />
<% DB.close(rs); %>
</table>
