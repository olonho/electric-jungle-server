<%@ page contentType="text/html; charset=windows-1251" %>
<%
   {
    final String ellipsis = "<tr><td height=21 colspan=4 bgcolor=\"#dee4b6\" background=\"images/torn.gif\" align=\"center\">&nbsp;</td></tr>";
    String ratingCriteria = "SINGLE".equals(gameKind) ? "result" : "victories";
    boolean useGroups = ejungle.manager.Manager.useGroupsInView() && "DUEL".equals(gameKind);
    java.util.HashSet<String> hs = new java.util.HashSet<String>();
%>    

<ej:pageheader type="2" header="<%=ssn.string("rating_" + gameKind)%>" />
<table width=640 border=0 cellspacing=1 cellpadding=3 bgcolor="#909030" class="cell">
  <tr>
    <th nowrap class="cell" align="center" width=60><%=ssn.string("rating")%></th>
    <th nowrap class="cell" align="left"  ><%=ssn.string("competitor")%></th>
    <th nowrap class="cell" align="left"  ><%=ssn.string("being")%></th>
    <th nowrap class="cell" align="center" width=70><%=ssn.string(ratingCriteria)%></th>
  </tr>
<%
    ResultSet rs = DB.query(
      "SELECT owner, nick, being, mainclass, score, `group` FROM ratingcache_" + gameKind +
      "  ORDER BY position"
    );
    int position = 0;
    int lastGroup = -1;
    int lastPrintedPosition = 0;
    int lastVisiblePosition = TOP_POSITIONS;
    while (rs.next()) {
      ++position;
      String color = "cell";
      if (rs.getInt(1) == ssn.id) {
        int delta = Math.max(-SURROUND_POSITIONS, lastVisiblePosition + 1 - position);
        lastVisiblePosition = Math.max(position + SURROUND_POSITIONS, lastVisiblePosition);
        if (delta >= 0) {
          color = "cella";
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
        if (useGroups && rs.getInt(6) != lastGroup) {
          lastGroup = rs.getInt(6);
          out.write("<tr><td colspan=4 class=\"cell\" style=\"background-color: #bbffbb\" align=\"center\"><b class=\"hl\">");
          out.write(lastGroup == 0 ? ssn.string("major_league") : Integer.toString(lastGroup));
          out.write(" " + ssn.string("league") + "</b></td></tr>");
        }
%>
  <tr>
    <td nowrap class="<%=color%>" align="center">
<%      if (useGroups && hs.size() < 40 && hs.add(rs.getString(2))) { %>
          <img src="images/circle.gif" width=10 height=10 border=0 hspace=0 vspace=0 style="position: absolute; left: 179px" title="<%=ssn.string("reaches_final")%>">
<%      } %>
        <b class="hl"><%=position%></b>
    </td>
    <td nowrap class="<%=color%>" align="left"  ><%=rs.getString(2)%></td>
    <td nowrap class="<%=color%>" align="left"  ><a style="text-decoration: none" href="main.jsp?page=beinginfo&being=<%=rs.getInt(3)%>"><%=rs.getString(4)%></a></td>
    <td nowrap class="<%=color%>" align="right" ><%=rs.getInt(5)%></td>
  </tr>
<%
      }
    }
    DB.close(rs);
    if (position > TOP_POSITIONS) {
      out.write("<tr><td colspan=4 class=\"cella\" align=\"center\"><a href=\"main.jsp?page=fullrating&gamekind=" + gameKind + "\">" + ssn.string("complete_table") + "</a></td></tr>");
    }
%>
  <ej:row colspan="4" empty="<%=position == 0%>" />
</table>
<% } %>
