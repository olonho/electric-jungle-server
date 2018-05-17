<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="ejungle.web.*" %>

<h2><%=ssn.string("registration")%></h2>
<form method="post" action="do_session.jsp?action=register">
<table border=0 cellspacing=3 cellpadding=0>
  <tr><td align="right"><font color="red">*</font> <b><%=ssn.string("username")%>:&nbsp;</b></td><td><input name="nick" type="text" size=30></td></tr>
  <tr><td align="right"><font color="red">*</font> <b><%=ssn.string("password")%>:&nbsp;</b></td><td><input name="password" type="password" size=30></td></tr>
  <tr><td align="right"><font color="red">*</font> <b><%=ssn.string("password_again")%>:&nbsp;</b></td><td><input name="password2" type="password" size=30></td></tr>
  <tr><td>&nbsp;</td><td>&nbsp;</td></tr>
  <tr><td align="right"><font color="red">*</font> <b><%=ssn.string("full_name")%>:&nbsp;</b></td><td><input name="name" type="text" size=50></td></tr>
  <tr><td align="right"><b><%=ssn.string("e-mail")%>:&nbsp;</b></td><td><input name="email" type="text" size=50></td></tr>
  <tr><td align="right"><b><%=ssn.string("phone")%>:&nbsp;</b></td><td><input name="phone" type="text" size=50></td></tr>
  <tr><td align="right"><b><%=ssn.string("company_university")%>:&nbsp;</b></td><td><input name="work" type="text" size=50></td></tr>
  <tr><td>&nbsp;</td><td align="right"><font color="red">*</font> - <%=ssn.string("mandatory_fields")%> </td></tr>
  <tr><td>&nbsp;</td><td align="left"><input type="submit" value="<%=ssn.string("submit")%>" class="button"></td></td></tr>
</table>
</form>
