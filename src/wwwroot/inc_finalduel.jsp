<%@ page contentType="text/html; charset=windows-1251" %>
<%@ taglib prefix="ej" tagdir="/WEB-INF/tags" %>

<table border=0 cellspacing=1 cellpadding=3 bgcolor="#909030" class="cell" width=620>
  <tr>
    <th nowrap class="cell" align="center" width=60><%=ssn.string("position")%></th>
    <th nowrap class="cell" align="left"  ><%=ssn.string("competitor")%></th>
    <th nowrap class="cell" align="left"  ><%=ssn.string("being")%></th>
    <th nowrap class="cell" align="center" width=70><%=ssn.string("victories")%></th>
  </tr>
<%
    final String ellipsis = "<tr><td height=21 colspan=4 bgcolor=\"#dee4b6\" background=\"images/torn.gif\" align=\"center\">&nbsp;</td></tr>";
    ResultSet rs = DB.query(
      "SELECT owner, nick, being, mainclass, score FROM ratingcache_DUEL" + tag +
      "  ORDER BY position"
    );
    int position = 0;
    boolean lineBreak = false;
    int lastScore = 0;
    while (rs.next()) {
      String color = rs.getInt(1) == ssn.id ? "cella" : "cell";
      ++position;
      if (!lineBreak && position > breakCount && rs.getInt(5) != lastScore) {
        out.write(ellipsis);
        lineBreak = true;
      }
%>
  <tr>
    <td nowrap class="<%=color%>" align="center"><b class="hl"><%=position%></b></td>
    <td nowrap class="<%=color%>" align="left"><%=rs.getString(2)%></td>
    <td nowrap class="<%=color%>" align="left"><a style="text-decoration: none" href="main.jsp?page=finalinfo&being=<%=rs.getInt(3)%>&tag=<%=tag%>"><%=rs.getString(4)%></a></td>
    <td nowrap class="<%=color%>" align="right" ><%=(lastScore = rs.getInt(5))%></td>
  </tr>
<%
    }
    DB.close(rs);
%>
  <ej:row colspan="4" empty="<%=position == 0%>" />
</table>
