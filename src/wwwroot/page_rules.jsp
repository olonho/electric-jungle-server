<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ taglib prefix="ej" tagdir="/WEB-INF/tags" %>

<ej:pageheader type="1" header="<%=ssn.string("jungle_laws")%>" />
<ej:textfield tabs="1" />
  <%=ssn.string("rules_notation")%>
<ej:textfield />

<ej:textfield tabs="2" />
  <%=ssn.string("rules_concepts")%>
<ej:textfield />

<ej:textfield tabs="2" />
  <%=ssn.string("rules_actions")%>
<ej:textfield />

<ej:textfield tabs="22" width="50%" />
  <%=ssn.string("rules_game")%>
<ej:textfield width="50%" />
  <%=ssn.string("rules_gamekind")%>
<ej:textfield />
