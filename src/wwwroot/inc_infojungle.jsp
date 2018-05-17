<%
  String detailsPage = "".equals(tag) ? "beinginfo" : "finalinfo&tag=" + tag;
  rs = DB.query("SELECT contests.id, contests.turns, results.being FROM results, contests " +
                "  WHERE results.being = ? AND contests.id = results.contest AND " +
                "        contests.kind = 3 AND contests.id > ? AND contests.id <= ? " +
                "  ORDER BY contests.begin DESC LIMIT 1",
                being, MIN_CONTEST, MAX_CONTEST);
  int contest = 0, turns = 0, myself = 0;
  if (rs.next()) {
    contest = rs.getInt(1);
    turns = rs.getInt(2);
    myself = rs.getInt(3);
  }
  DB.close(rs);
  
%>
<ej:pageheader type="2" header="<%=ssn.string("num_turns") + ":&nbsp;&nbsp;<span class='hl'>" + turns + "</span>"%>" />
<table border=0 cellspacing=1 cellpadding=3 bgcolor="#909030" class="cell">
  <tr>
    <th nowrap class="cell" align="center">&nbsp;N&nbsp;</th>
    <th nowrap class="cell" align="center"><%=ssn.string("competitor")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("result")%></th>
  </tr>
<%
  rs = DB.query("SELECT beings.id, beings.mainclass, results.score FROM results, beings " +
                "  WHERE results.contest = ? AND beings.id = results.being " +
                "  ORDER BY results.score DESC",
                contest);
  int pos = 0;
  String green = "style=\"background-color: #bbffbb\"";
  String red = "style=\"background-color: #ffbbbb\"";
  while (rs.next()) {
    pos++;
    int id = rs.getInt(1);
    String style = id == myself ? (pos == 1 ? green : red) : "";
%>
  <tr>
    <td nowrap class="cell" align="center" <%=style%>><%=pos%></td>
    <td nowrap class="cell" align="left" <%=style%>><a style="text-decoration: none" href="main.jsp?page=<%=detailsPage%>&being=<%=id%>"><%=rs.getString(2)%></a></td>
    <td nowrap class="cell" align="right" <%=style%>><%=rs.getInt(3)%></td>
  </tr>
<%
  }
  DB.close(rs);
%>
  <ej:row colspan="3" empty="<%=pos == 0%>" />
</table>
