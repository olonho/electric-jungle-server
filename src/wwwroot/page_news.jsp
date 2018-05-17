<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<%@ taglib prefix="ej" tagdir="/WEB-INF/tags" %>

<ej:pageheader type="1" header="<%=ssn.string("news")%>" />
<%
  ResultSet rs = DB.query("SELECT id, title_" + ssn.lang + ", contents_" + ssn.lang + ", type FROM news " +
                          "  WHERE title_" + ssn.lang + " IS NOT NULL " +
                          "ORDER BY id DESC");
  while (rs.next()) {
    String nType = rs.getString(4);
    String nClass = "1".equals(nType) ? "class=\"alt\"" : "";

%>
<a name="news<%=rs.getInt(1)%>"></a>
<ej:textfield tabs="<%=nType%>" />
  <h2 <%=nClass%>><%=rs.getString(2).replaceAll("<[^<]*>", "")%></h2>
  <%=rs.getString(3)%>
<ej:textfield />
<%
  }
  DB.close(rs);
%>
