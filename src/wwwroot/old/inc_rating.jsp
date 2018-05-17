<%@ page contentType="text/html; charset=windows-1251" %>
<%
  {
    final String ellipsis = "<tr><td height=21 colspan=4 background=\"images/torn.gif\" align=\"center\" style=\"\">&nbsp;</td></tr>";
    String ratingCriteria, query;

    // FIXME:
    // compute rating table only once after contest cycle
    // and store the results into temporary table
    // to increase the performance of this page

    if ("SINGLE".equals(gameKind)) {
      ratingCriteria = "result";
      query = "SELECT users.id, users.nick, beings.mainclass, results.score FROM results " +
              "  INNER JOIN contests ON contests.id = results.contest " +
              "  INNER JOIN beings ON beings.id = results.being " +
              "  INNER JOIN users ON users.id = beings.owner " +
              "  WHERE contests.kind = 2 AND contests.begin >= DATE_SUB(NOW(), INTERVAL " + RATING_INTERVAL + ") " +
              "  ORDER BY results.score DESC";
    } else {
      ratingCriteria = "victories";
      query = "SELECT users.id, users.nick, beings.mainclass, COUNT(maxscores.being) AS victories FROM beings " +
              "  LEFT OUTER JOIN ( " +
              "    SELECT results.being FROM results WHERE (results.contest, results.score) IN ( " +
              "      SELECT contests.id, MAX(results.score) FROM contests " +
              "        INNER JOIN results ON contests.id = results.contest " +
              "      WHERE contests.kind = " + ("DUEL".equals(gameKind) ? "3" : "1") +
              "        AND contests.begin > DATE_SUB(NOW(), INTERVAL " + RATING_INTERVAL + ") " +
              "      GROUP BY contests.id " +
              "    ) " +
              "  ) AS maxscores ON beings.id = maxscores.being " +
              "  INNER JOIN users ON users.id = beings.owner " +
              "  GROUP BY users.nick, beings.mainclass " +
              "  ORDER BY victories DESC";
    }
%>    

<h2><%=ssn.string("rating_" + gameKind)%></h2>
<table width=600 border=0 cellspacing=1 cellpadding=3 class="bordered">
  <tr>
    <th nowrap align="center" bgcolor="#808080"><%=ssn.string("rating")%></th>
    <th nowrap align="left"   bgcolor="#808080"><%=ssn.string("competitor")%></th>
    <th nowrap align="left"   bgcolor="#808080"><%=ssn.string("being")%></th>
    <th nowrap align="center" bgcolor="#808080" width=70><%=ssn.string(ratingCriteria)%></th>
  </tr>
<%
    ResultSet rs = DB.query(query);
    int position = 0;
    int lastPrintedPosition = 0;
    int lastVisiblePosition = TOP_POSITIONS;
    while (rs.next()) {
      ++position;
      String bgcolor = "#dddddd";
      if (rs.getInt(1) == ssn.id) {
        int delta = Math.max(-SURROUND_POSITIONS, lastVisiblePosition + 1 - position);
        lastVisiblePosition = Math.max(position + SURROUND_POSITIONS, lastVisiblePosition);
        if (delta >= 0) {
          bgcolor = "#a0ffa0";
        } else {
          rs.relative(delta);
          position += delta;
        }
      }
      if (position <= lastVisiblePosition) {
        if (position != lastPrintedPosition + 1) {
          out.write(ellipsis);
        }
        lastPrintedPosition = position;
%>
  <tr>
    <td nowrap bgcolor="<%=bgcolor%>" align="center"><%=position%></td>
    <td nowrap bgcolor="<%=bgcolor%>" align="left"  ><%=rs.getString(2)%></td>
    <td nowrap bgcolor="<%=bgcolor%>" align="left"  ><%=rs.getString(3)%></td>
    <td nowrap bgcolor="<%=bgcolor%>" align="right" ><%=rs.getInt(4)%>
  </tr>
<%
      }
    }
    DB.close(rs);
    if (position == 0) {
      out.write(Util.emptyRow(ssn.lang, 4));
    } else if (position != lastPrintedPosition) {
      out.write(ellipsis);
    }
  }
%>
</table>
