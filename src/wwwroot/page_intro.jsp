<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ taglib prefix="ej" tagdir="/WEB-INF/tags" %>

<ej:pageheader type="1" header="<%=ssn.string("announce")%>" />
<ej:textfield tabs="1" />
  <h2 class="alt"><%=ssn.string("electric_jungle")%></h2>
  <p><%=ssn.string("rules_1")%></p>
<ej:textfield />

<ej:pageheader type="2" header="<%=ssn.string("game_kinds")%>" />
<ej:textfield tabs="222" width="33%" />
  <%=ssn.string("rules_single")%>
<ej:textfield width="33%" />
  <%=ssn.string("rules_duel")%>
<ej:textfield width="33%" />
  <%=ssn.string("rules_jungle")%>
<ej:textfield />
&nbsp;

<ej:textfield tabs="2" />
  <%=ssn.string("rules_winner")%>
<ej:textfield />
