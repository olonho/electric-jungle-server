<!-- Title string -->
<%@ tag body-content="empty" %>
<%@ attribute name="type" %>
<%@ attribute name="header" %>
<table border=0 cellspacing=0 cellpadding=0>
  <tr><td height=<%="1".equals(type) ? 75 : 35%> nowrap align="left" valign="bottom" background="images/plant<%=type%>.gif" style="padding-left: 20px; background-position: left top; background-repeat: no-repeat">
    <h2><%=header%></h2>
  </td></tr>
</table>
