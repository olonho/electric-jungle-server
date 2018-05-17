<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="application/x-java-jnlp-file" %>
<%@ page import="ejungle.web.*" %>
<%
  String codebase = Util.getRequestPath(request);
  String key = request.getParameter("key");
  Contest contest = key == null ? null : Contest.all.get(key);
%>

<!-- JNLP File for EJungles -->
<jnlp spec="1.0+"
      codebase="<%=codebase%>"
      href="<%=codebase%>/view_jnlp.jsp?key=<%=contest.getKey()%>">
    <information>
        <title>EJungle WebStart app</title>
        <vendor>Sun Microsystems, Inc.</vendor>
        <description>Electric Jungle</description>
        <description kind="short">Description should be here</description>
    </information>
    <resources>
        <jar href="<%=codebase%>/files/universum.jar"/>    
        <j2se version="1.5+" href="http://java.sun.com/products/autodl/j2se"/>
<% if (contest != null) { %>
        <property name="javaws.ejungle.host" value="<%=request.getServerName()%>"/>
        <property name="javaws.ejungle.port" value="<%=contest.getListenPort()%>"/>             
<% } %>
    </resources>
    <application-desc main-class="universum.EJApplet"/>
    <security>
        <j2ee-application-client-permissions/>
    </security>
</jnlp>
