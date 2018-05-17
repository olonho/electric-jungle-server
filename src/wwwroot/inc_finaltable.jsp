<%@ page contentType="text/html; charset=windows-1251" %>
<%@ taglib prefix="ej" tagdir="/WEB-INF/tags" %>

<%
  // Precache being names
  int SIZE = 5;
  String nick[] = new String[SIZE];
  ResultSet rs = DB.query("select nick from beings_FINAL as beings, users_FINAL as users" +
                          "  where beings.owner = users.id and beings.forcontest = 1" +
                          "  order by beings.id");
  for (int i = 0; rs.next(); i++) {
    nick[i] = rs.getString(1);
  }
  DB.close(rs);
%>
<ej:pageheader type="2" header="<%=ssn.string("summary")%>" />
<table border=0 cellspacing=1 cellpadding=3 bgcolor="#909030" class="cell">
  <tr>
    <th nowrap class="cell" align="left" width=70><%=ssn.string("competitor")%></th>
<% for (int i = 0; i < SIZE; i++) { %>
    <th nowrap class="cell" align="center" width=70><%=nick[i]%></th>
<% } %>
    <th nowrap class="cell" align="center" width=70><%=ssn.string("victories")%></th>
  </tr>
<%
  // Get score table
  rs = DB.query(
    "select r1.being, r2.being, sum(r1.victory), sum(r2.victory)" +
    "  from results" + tag + " r1, results" + tag + " r2," +
    "       beings_FINAL as beings, users_FINAL as users" +
    "  where r1.contest = r2.contest and r1.being <> r2.being and" +
    "        beings.id = r2.being and users.id = beings.owner" +
    "  group by r1.being, r2.being"
  );
  for (int i = 0; i < SIZE; i++) {
    out.write("<tr><th class=\"cell\" align=\"left\">" + nick[i] + "</th>");
    int victories = 0;
    for (int j = 0; j < SIZE; j++) {
      if (i == j) {
        out.write("<td class=\"cell\" align=\"center\">&nbsp;</td>");
      } else if (rs.next()) {
        int win = rs.getInt(3);
        int lose = rs.getInt(4);
        victories += win;
        out.write("<td class=\"cell\" align=\"center\" style=\"background-color: " + (win > lose ? "#bbffbb" : win < lose ? "#ffbbbb" : "#ffffbb") + "\">");
        out.write("<a class=\"news\" href=\"main.jsp?page=finalinfo&tag=" + tag + "&being=" + rs.getInt(1) + "&opponent=" + rs.getInt(2) + "\">" + rs.getInt(3) + " : " + rs.getInt(4) + "</a>");
        out.write("</td>");
      }
    }
    out.write("<td class=\"cell\" align=\"center\">" + victories + "</td></tr>");
  }
  DB.close(rs);
%>
  <ej:row colspan="<%=Integer.toString(SIZE + 2)%>" empty="false" />
</table>
