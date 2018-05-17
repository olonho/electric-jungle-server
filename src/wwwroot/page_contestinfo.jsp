<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<%@ taglib prefix="ej" tagdir="/WEB-INF/tags" %>

<%
  String being = request.getParameter("being");
  String info = request.getParameter("info");
  String tag = "";
  ResultSet rs = DB.query("SELECT mainclass FROM beings WHERE id = ?", being);
  if (!rs.next()) {
    DB.close(rs);
    return;
  }
%>
<ej:pageheader type="1" header="<%=ssn.string("statistics") + "&nbsp;&nbsp;<span class='hl'>" + rs.getString(1) + "</span>"%>" />
<% DB.close(rs); %>
<% if ("single".equals(info)) { %>
<%@    include file="inc_infosingle.jsp" %>
<% } else if ("duel".equals(info)) {
       final int MIN_CONTEST = ejungle.manager.RatingComputeJob.recentContest;
       final int MAX_CONTEST = ejungle.manager.RatingComputeJob.lastContest; %>
<%@    include file="inc_infoduel.jsp" %>
<% } else if ("duels".equals(info)) {
       final int MIN_CONTEST = ejungle.manager.RatingComputeJob.regroupContest;
       final int MAX_CONTEST = ejungle.manager.RatingComputeJob.lastContest; %>
<%@    include file="inc_infoduels.jsp" %>
<% } else if ("jungle".equals(info)) {
       final int MIN_CONTEST = ejungle.manager.RatingComputeJob.recentContest;
       final int MAX_CONTEST = ejungle.manager.RatingComputeJob.lastContest; %>
<%@    include file="inc_infojungle.jsp" %>
<% } else if ("jungles".equals(info)) {
       final int MIN_CONTEST = ejungle.manager.RatingComputeJob.firstContest;
       final int MAX_CONTEST = ejungle.manager.RatingComputeJob.lastContest; %>
<%@    include file="inc_infojungles.jsp" %>
<% } %>
<p><a href="javascript:history.back()"><%=ssn.string("back")%></a></p>
