<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%
  String url = "http://" + request.getServerName() +
    (ssn.loggedOn() ? "/phpBB2/login.php?login=auto&username=" + ssn.nick + "&md5pass=" + ssn.md5pass
                    : "/phpBB2/index.php");
%>

<iframe frameborder=0 width="100%" height="100%" src="<%=url%>"></iframe>
