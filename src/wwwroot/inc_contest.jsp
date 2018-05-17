<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>

<table width=640 border=0 cellspacing=1 cellpadding=3 bgcolor="#909030" class="cell">
  <tr>
    <th nowrap class="cell" align="center"><%=ssn.string("start_date")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("status")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("players")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("view")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("control")%></th>
  </tr>
<%
  boolean hasRows = false;
  for (Contest c : Contest.all.values()) {
    if (c.getOwner() == ssn.id) {
      hasRows = true;
      Contest.State state = c.getState();
%>
  <tr><td colspan=5 height=1 bgcolor="#ffffff" style="padding: 0px"></td></tr>
  <tr>
    <td align="center" class="cell"><%=Util.datetime(c.getStartTime())%></td>
    <td align="center" class="cell"><%=ssn.enumString(state)%></td>
    <td class="cell" style="padding: 0px" height="100%"><table width="100%" height="100%" border=0 cellspacing=1 cellpadding=3>
<%    for (String[] info : c.getBeingInfo()) { %>
        <tr>
          <td align="left" class="cell"><%=info[2]%></td>
          <td width=1 bgcolor="#909030" style="padding: 0px" nowrap></td>
          <td align="right" class="cell"><%=info[3]%></td>
        </tr>
        <tr><td colspan=3 height=1 bgcolor="#909030" style="padding: 0px"></td></tr>
<%    } %>
    </table></td>
<%    if (state == Contest.State.FINISHED) { %>
    <td align="center" class="cell">
      <a href="games/<%=c.getKey()%>.ej"><%=ssn.string("recorded_game")%></a>
    </td>
    <td align="center" class="cell">
      <a href="do_contest.jsp?action=delete&key=<%=c.getKey()%>"><%=ssn.string("delete")%></a>
    </td>
<%    } else { %>
    <td align="center" class="cell">
      <a href="view_jnlp.jnlp?key=<%=c.getKey()%>"><%=ssn.string("webstart")%></a><br>
      <a href="view_applet.jsp?key=<%=c.getKey()%>"><%=ssn.string("applet")%></a>
    </td>
    <td align="center" class="cell">
      <a href="do_contest.jsp?action=delete&key=<%=c.getKey()%>" onclick="return ask();"><%=ssn.string("delete")%></a>
    </td>
<%    } %>
  </tr>
<%
    }
  }
%>
  <ej:row colspan="5" empty="<%=!hasRows%>" />
</table>
