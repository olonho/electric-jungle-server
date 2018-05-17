<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page import="ejungle.web.*" %>
<%
  if (!ssn.checkAccess(ssn.ACCESS_ADMIN)) {
    return;
  }
%>
<html>
<body>
Contests: total = <%=Contest.all.size()%>, active = <%=Contest.count()%><br>
DB connections: open = <%=DB.getOpenConnections()%>
</body>
</html>
