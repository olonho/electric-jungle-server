<!-- Empty row -->
<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ tag body-content="empty" %>
<%@ attribute name="colspan" %>
<%@ attribute name="empty" type="java.lang.Boolean" %>
<% if (empty != null && empty) { %>
<tr><td colspan="<%=colspan%>" class="celle" align="center"><%=ssn.string("no_recs")%></td></tr>
<% } %>
<tr><td colspan="<%=colspan%>" height=11></td></tr>
