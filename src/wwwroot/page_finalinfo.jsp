<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<%@ taglib prefix="ej" tagdir="/WEB-INF/tags" %>

<%
  String beingStr = request.getParameter("being");
  String opponentStr = request.getParameter("opponent");
  String tag = request.getParameter("tag");
  ResultSet rs = DB.query("SELECT beings.id, users.nick, beings.mainclass" +
                          "  FROM beings_FINAL AS beings, users_FINAL AS users" +
                          "  WHERE beings.id = ? AND users.id = beings.owner",
                          beingStr);
  if (!rs.next()) {
    DB.close(rs);
    return;
  }
  int being = rs.getInt(1);
  int opponent = 0;
  if (opponentStr != null) {
    try {
      opponent = Integer.parseInt(opponentStr);
    } catch (NumberFormatException e) {}
  }
%>
<ej:pageheader type="1" header="<%=ssn.string("statistics") + "&nbsp;&nbsp;<span class='hl'>" + rs.getString(2) + " :: " + rs.getString(3) + "</span>"%>" />
<div clear="right"></div>
<% DB.close(rs); %>
<% if ("_FINALSINGLE".equals(tag)) { %>
<%@ include file="inc_infosingle.jsp" %>
<% } else if (opponent == 0) { %>
<%@ include file="inc_infoduels.jsp" %>
<% } else { %>
<%@ include file="inc_infoduel.jsp" %>
<% } %>
<p><a href="javascript:history.back()"><%=ssn.string("back")%></a></p>
