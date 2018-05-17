<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<% ssn.ensureLoggedOn(); %>

<table width=600 border=0 cellspacing=1 cellpadding=3 class="bordered">
  <tr>
    <th nowrap align="center" bgcolor="#808080"><%=ssn.string("start_date")%></th>
    <th nowrap align="center" bgcolor="#808080"><%=ssn.string("status")%></th>
    <th nowrap align="center" bgcolor="#808080"><%=ssn.string("players")%></th>
    <th nowrap align="center" bgcolor="#808080"><%=ssn.string("control")%></th>
  </tr>
<%
  boolean hasRows = false;
  for (Contest c : Contest.all.values()) {
    if (c.getOwner() == ssn.id) {
      hasRows = true;
      Contest.State state = c.getState();
%>
  <tr><td colspan=4 height=1 bgcolor="#0099ff" style="padding: 0px"></td></tr>
  <tr>
    <td align="center" bgcolor="#dddddd"><%=Util.datetime(c.getStartTime())%></td>
    <td align="center" bgcolor="#dddddd"><%=ssn.enumString(state)%></td>
    <td style="padding: 0px"><table width="100%" border=0 cellspacing=1 cellpadding=3>
<%    for (String[] info : c.getBeingInfo()) { %>
        <tr>
          <td align="left"  bgcolor="#dddddd"><%=info[2]%></td>
          <td align="right" bgcolor="#dddddd"><%=info[3]%></td>
        </tr>
<%    } %>
    </table></td>
    <td align="center" bgcolor="#dddddd">
<%    if (state == Contest.State.FINISHED) { %>
      <a><%=ssn.string("view")%></a>&nbsp;
      <a href="do_contest.jsp?action=delete&key=<%=c.getKey()%>"><%=ssn.string("delete")%></a>
<%    } else { %>
      <a href="view_jnlp.jsp?key=<%=c.getKey()%>"><%=ssn.string("view")%></a>&nbsp;
      <a href="do_contest.jsp?action=delete&key=<%=c.getKey()%>" onclick="return ask();"><%=ssn.string("delete")%></a>
<%    } %>
    </td>
  </tr>
<%
    }
  }
  if (!hasRows) out.write(Util.emptyRow(ssn.lang, 4));
%>
</table>
