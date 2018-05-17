<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<% ssn.ensureLoggedOn(); %>

<%
  // Take into account contests which are not older than RATING_INTERVAL
  final String RATING_INTERVAL = "100 DAY"; // <-- FIXME: should be 1 DAY
  // Always show Top Ten in rating tables
  final int TOP_POSITIONS = 1;              // <-- FIXME: should be 10
  // Surround my being's rows with a few predecessors and successors
  final int SURROUND_POSITIONS = 1;         // <-- FIXME: 2 is better

  String gameKind;
%>

<% gameKind = "DUEL"; %>
<%@ include file="inc_rating.jsp" %>
<p>&nbsp;</p>
<% gameKind = "JUNGLE"; %>
<%@ include file="inc_rating.jsp" %>
<p>&nbsp;</p>
<% gameKind = "SINGLE"; %>
<%@ include file="inc_rating.jsp" %>
