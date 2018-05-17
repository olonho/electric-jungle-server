<%@ page contentType="text/html; charset=windows-1251" %>
<%@ taglib prefix="ej" tagdir="/WEB-INF/tags" %>

<table border=0 cellspacing=1 cellpadding=3 bgcolor="#909030" class="cell" width=620>
  <tr>
    <th nowrap class="cell" align="center" width=60><%=ssn.string("position")%></th>
    <th nowrap class="cell" align="left"><%=ssn.string("competitor")%></th>
    <th nowrap class="cell" align="left"><%=ssn.string("being")%></th>
    <th nowrap class="cell" align="center" width=70><%=ssn.string("maxscore")%></th>
    <th nowrap class="cell" align="center" width=70><%=ssn.string("avgscore")%></th>
  </tr>
<%
    ResultSet rs = DB.query(
      "SELECT users.id, users.nick, beings.id, beings.mainclass," +
      "       MAX(results.score) AS maxscore, AVG(results.score) AS avgscore" +
      "  FROM results" + tag + " AS results, beings_FINAL AS beings, users_FINAL AS users" +
      "  WHERE beings.id = results.being AND users.id = beings.owner" +
      "  GROUP BY users.nick, beings.id, beings.mainclass" +
      "  ORDER BY maxscore DESC"
    );
    int position = 0;
    while (rs.next()) {
      String color = rs.getInt(1) == ssn.id ? "cella" : "cell";
      ++position;
%>
  <tr>
    <td nowrap class="<%=color%>" align="center"><b class="hl"><%=position%></b></td>
    <td nowrap class="<%=color%>" align="left"><%=rs.getString(2)%></td>
    <td nowrap class="<%=color%>" align="left"><a style="text-decoration: none" href="main.jsp?page=finalinfo&being=<%=rs.getInt(3)%>&tag=<%=tag%>"><%=rs.getString(4)%></a></td>
    <td nowrap class="<%=color%>" align="right" ><%=rs.getInt(5)%></td>
    <td nowrap class="<%=color%>" align="right" ><%=rs.getInt(6)%></td>
  </tr>
<%
    }
    DB.close(rs);
%>
  <ej:row colspan="5" empty="<%=position == 0%>" />
</table>
