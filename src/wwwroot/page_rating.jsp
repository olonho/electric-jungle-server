<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<%@ taglib prefix="ej" tagdir="/WEB-INF/tags" %>

<%
  // Always show Top Ten in rating tables
  final int TOP_POSITIONS = 10;
  // Surround my being's rows with a few predecessors and successors
  final int SURROUND_POSITIONS = 2;

  String gameKind;
%>

<% gameKind = "DUEL"; %>
<%@ include file="inc_rating.jsp" %>
<% gameKind = "JUNGLE"; %>
<%@ include file="inc_rating.jsp" %>
<% gameKind = "SINGLE"; %>
<%@ include file="inc_rating.jsp" %>
