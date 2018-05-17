<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="ejungle.web.Util" %>

<h2>SDK</h2>
<p><%=ssn.string("sdk_description")%></p>
<p><%=ssn.string("current_version")%></p>
<p><a href="files/ejungle_distr.jar"><%=ssn.string("download")%></a></p>
