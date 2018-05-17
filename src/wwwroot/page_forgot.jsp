<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ taglib prefix="ej" tagdir="/WEB-INF/tags" %>

<ej:pageheader type="1" header="<%=ssn.string("recover_password")%>" />
<ej:textfield tabs="1" />
  <%=ssn.string("no_such_page")%>
<ej:textfield />
