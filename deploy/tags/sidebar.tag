<!-- Left part of the page -->
<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ attribute name="caption" %>
<table width=140 border=0 cellspacing=0 cellpadding=0>
  <tr><td height=30>&nbsp;</td></tr>
  <tr><td height=44><img width=140 height=44 src="images/left_tiger.jpg" alt="Tiger"></td></tr>
  <tr><td height=22 bgcolor="#586a88" background="images/left_head.gif"><h5><%=caption%></h5></td></tr>
  <!-- Contents -->
  <tr><td bgcolor="#708299" class="info">
    <font color="#ffffff"><%=ssn.string("participants")%>:</font> xxx<br>
    <font color="#ffffff"><%=ssn.string("new_participants")%>:</font> xxx<br>
  </td></tr>
  <tr><td bgcolor="#ffffff" height=1></td></tr><tr><td bgcolor="#465a7c" height=1></td></tr>
  <tr><td bgcolor="#708299" class="info">
    <font color="#ffffff"><%=ssn.string("beings_total")%>:</font> xxx<br>
    <font color="#ffffff"><%=ssn.string("beings_public")%>:</font> xxx<br>
  </td></tr>
  <!-- // Contents -->
  <tr><td height=7><img width=140 height=7 src="images/left_bottom.gif"></td></tr>
</table>
