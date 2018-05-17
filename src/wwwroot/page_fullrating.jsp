<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<%@ taglib prefix="ej" tagdir="/WEB-INF/tags" %>

<%
  final int TOP_POSITIONS = 1000000000;
  final int SURROUND_POSITIONS = 0;
  String gameKind = request.getParameter("gamekind");
  if (!("SINGLE".equals(gameKind) || "DUEL".equals(gameKind) || "JUNGLE".equals(gameKind))) {
    return;
  }
%>
<%@ include file="inc_rating.jsp" %>
<p><a href="main.jsp?page=rating"><%=ssn.string("back")%></a></p>
