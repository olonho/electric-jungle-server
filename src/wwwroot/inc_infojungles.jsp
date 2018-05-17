<table border=0 cellspacing=1 cellpadding=3 bgcolor="#909030" class="cell">
  <tr>
    <th nowrap class="cell" align="center"><%=ssn.string("contest")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("turns")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("result")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("winner")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("result")%></th>
  </tr>
<%
  String detailsPage = "".equals(tag) ? "beinginfo" : "finalinfo&tag=" + tag;
  rs = DB.query("SELECT results1.score, results2.score, beings.id, beings.mainclass, contests.turns, results1.being = results2.being " +
                "  FROM results AS results1, results AS results2, contests, beings " +
                "  WHERE contests.id = results1.contest AND contests.id = results2.contest AND " +
                "        contests.kind = 3 AND beings.id = results2.being AND " +
                "        results1.being = ? AND results2.victory = true AND " +
                "        contests.id > ? AND contests.id <= ? " +
                "  ORDER BY contests.begin",
                being, MIN_CONTEST, MAX_CONTEST);
  int pos = 0;
  while (rs.next()) {
    String style = rs.getBoolean(6) ? "style=\"background-color: #bbffbb\"" : "";
%>
  <tr>
    <td nowrap class="cell" align="center" <%=style%>><%=++pos%></td>
    <td nowrap class="cell" align="center" <%=style%>><%=rs.getInt(5)%></td>
    <td nowrap class="cell" align="right" <%=style%>><%=rs.getInt(1)%></td>
    <td nowrap class="cell" align="left" <%=style%>><a style="text-decoration: none" href="main.jsp?page=<%=detailsPage%>&being=<%=rs.getInt(3)%>"><%=rs.getString(4)%></a></td>
    <td nowrap class="cell" align="right" <%=style%>><%=rs.getInt(2)%></td>
  </tr>
<%
  }
  DB.close(rs);
%>
  <ej:row colspan="5" empty="<%=pos == 0%>" />
</table>
