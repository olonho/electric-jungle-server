<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<%@ taglib prefix="ej" tagdir="/WEB-INF/tags" %>

<%!
  String cell(int value, int total) {
    return "<table border=0 cellspacing=0 cellpadding=0 width=\"100%\" height=\"100%\" style=\"margin: 0px\">" +
           "<tr><td align=\"left\" valign=\"top\" class=\"gray\">" + 
           (total == 0 ? 0 : (value * 100 + (total>>1)) / total) +
           "%</td><td align=\"right\" valign=\"center\">" + value + "&nbsp;</td></tr></table>";
  }
%>
<%
  String being = request.getParameter("being");
  ResultSet rs = DB.query(
    "SELECT users.nick, beings.mainclass, beings.jarsize, rs.position, rd.position, rj.position " +
    "  FROM beings " +
    "  INNER JOIN users ON users.id = beings.owner " +
    "  LEFT OUTER JOIN ratingcache_SINGLE AS rs ON rs.being = beings.id " +
    "  LEFT OUTER JOIN ratingcache_DUEL   AS rd ON rd.being = beings.id " +
    "  LEFT OUTER JOIN ratingcache_JUNGLE AS rj ON rj.being = beings.id " +
    "  WHERE beings.id = ?",
    being
  );
  if (!rs.next()) {
    DB.close(rs);
    return;
  }
  int scoreSingle = rs.getInt(4);
  int scoreDuel = rs.getInt(5);
  int scoreJungle = rs.getInt(6);
%>
<table align="right" border=0 cellspacing=0 cellpadding=0 height=75>
  <tr>
    <td valign="bottom" height="100%" align="right"><h2 style="margin-bottom: 3px"><%=ssn.string("author")%>:&nbsp;&nbsp;</h2></td>
    <td valign="bottom" height="100%" align="left"><h2 style="margin-bottom: 3px" class="hl"><%=rs.getString(1)%></h2></td>
  </tr>
  <tr>
    <td valign="bottom" align="right"><h2><%=ssn.string("size")%>:&nbsp;&nbsp;</h2></td>
    <td valign="bottom" align="left"><h2 class="hl"><%=rs.getInt(3) / 1024 + "&nbsp;" + ssn.string("kb")%></h2></td>
  </tr>
</table>
<ej:pageheader type="1" header="<%=ssn.string("statistics") + "&nbsp;&nbsp;<span class='hl'>" + rs.getString(2) + "</span>"%>" />
<div clear="right"></div>
<% DB.close(rs); %>

<ej:textfield tabs="222" width="33%" />
  <table width="100%" border=0 cellspacing=0 cellpadding=0>
    <tr>
      <td align="left" valign="top"><h2><%=ssn.string("title_SINGLE")%></h2></td>
      <td align="right" valign="top"><b class="hl"><%=scoreSingle == 0 ? "" : scoreSingle + "&nbsp;" + ssn.string("place")%></b></td>
    </tr>
  </table>
<%
  int firstContest   = ejungle.manager.RatingComputeJob.firstContest;
  int recentContest  = ejungle.manager.RatingComputeJob.recentContest;
  int lastContest    = ejungle.manager.RatingComputeJob.lastContest;
  int regroupContest = ejungle.manager.RatingComputeJob.regroupContest;
  rs = DB.query("SELECT MAX(score), MIN(score), AVG(score), " +
                "       MAX(score * (contests.id > ?)) FROM results, contests " +
                "WHERE contests.id = results.contest AND contests.kind = 1 AND " +
                "      contests.id <= ? AND being = ?",
                recentContest, lastContest, being);
  if (rs.next()) {
%>
  <table width="100%" border=0 cellspacing=1 cellpadding=3 bgcolor="#909030" class="cell">
    <tr>
      <th nowrap class="cell" align="center" width="33%">&nbsp;</th>
      <th nowrap class="cell" align="center" width="33%"><%=ssn.string("in_rating")%></th>
      <th nowrap class="cell" align="center" width="33%"><%=ssn.string("latest")%></th>
    </tr>
    <tr>
      <td nowrap class="cell" align="left" style="background-color: #bbffbb"><%=ssn.string("max")%></td>
      <td nowrap class="cell" align="right" style="background-color: #bbffbb"><%=rs.getInt(1)%></td>
      <td nowrap class="cell" align="center" style="background-color: #bbffbb" rowspan=3><%=rs.getInt(4)%></td>
    </tr>
    <tr>
      <td nowrap class="cell" align="left" style="background-color: #ffbbbb"><%=ssn.string("min")%></td>
      <td nowrap class="cell" align="right" style="background-color: #ffbbbb"><%=rs.getInt(2)%></td>
    </tr>
    <tr>
      <td nowrap class="cell" align="left" style="background-color: #ffff88"><%=ssn.string("avg")%></td>
      <td nowrap class="cell" align="right" style="background-color: #ffff88"><%=rs.getInt(3)%></td>
    </tr>
    <tr><td height=11 colspan=3></td></tr>
<% if (false) { %>
    <tr>
      <td></td>
      <td height=11 align="center" valign="top" style="padding: 0px">
        <a href="main.jsp?page=contestinfo&info=single&being=<%=being%>"><img width=20 height=11 border=0 alt="<%=ssn.string("details")%>" src="images/more.gif"></a>
      </td>
      <td></td>
    </tr>
<% } %>
  </table>
<%
  }
  DB.close(rs);
%>
<ej:textfield width="33%" />
  <table width="100%" border=0 cellspacing=0 cellpadding=0>
    <tr>
      <td align="left" valign="top"><h2><%=ssn.string("title_DUEL")%></h2></td>
      <td align="right" valign="top"><b class="hl"><%=scoreDuel == 0 ? "" : scoreDuel + "&nbsp;" + ssn.string("place")%></b></td>
    </tr>
  </table>
<%
  rs = DB.query("SELECT COUNT(*), SUM(victory), SUM(contests.id > ?), " +
                "       SUM(victory AND contests.id > ?) FROM results, contests " +
                "WHERE contests.id = results.contest AND contests.kind = 2 AND " +
                "      contests.id <= ? AND contests.id > ? AND being = ?",
                recentContest, recentContest, lastContest, regroupContest, being);
  if (rs.next()) {
    int matches = rs.getInt(1);
    int won = rs.getInt(2);
    int matchesLatest = rs.getInt(3);
    int wonLatest = rs.getInt(4);
%>
  <table width="100%" border=0 cellspacing=1 cellpadding=3 bgcolor="#909030" class="cell">
    <tr>
      <th nowrap class="cell" align="center" width="33%">&nbsp;</th>
      <th nowrap class="cell" align="center" width="33%"><%=ssn.string("in_rating")%></th>
      <th nowrap class="cell" align="center" width="33%"><%=ssn.string("latest")%></th>
    </tr>
    <tr>
      <td nowrap class="cell" align="left" style="background-color: #bbffbb"><%=ssn.string("won")%></td>
      <td nowrap class="cell" style="background-color: #bbffbb; padding: 0px" height="100%"><%=cell(won, matches)%></td>
      <td nowrap class="cell" style="background-color: #bbffbb; padding: 0px" height="100%"><%=cell(wonLatest, matchesLatest)%></td>
    </tr>
    <tr>
      <td nowrap class="cell" align="left" style="background-color: #ffbbbb"><%=ssn.string("lost")%></td>
      <td nowrap class="cell" style="background-color: #ffbbbb; padding: 0px" height="100%"><%=cell(matches-won, matches)%></td>
      <td nowrap class="cell" style="background-color: #ffbbbb; padding: 0px" height="100%"><%=cell(matchesLatest-wonLatest, matchesLatest)%></td>
    </tr>
    <tr>
      <td nowrap class="cell" align="left" style="background-color: #ffff88"><%=ssn.string("total")%></td>
      <td nowrap class="cell" align="right" style="background-color: #ffff88"><%=matches%></td>
      <td nowrap class="cell" align="right" style="background-color: #ffff88"><%=matchesLatest%></td>
    </tr>
    <tr><td height=11 colspan=3></td></tr>
<% if (false) { %>
    <tr>
      <td></td>
      <td height=11 align="center" valign="top" style="padding: 0px"><a href="main.jsp?page=contestinfo&info=duels&being=<%=being%>"><img width=20 height=11 border=0 alt="<%=ssn.string("details")%>" src="images/more.gif"></a></td>
      <td height=11 align="center" valign="top" style="padding: 0px"><a href="main.jsp?page=contestinfo&info=duel&being=<%=being%>"><img width=20 height=11 border=0 alt="<%=ssn.string("details")%>" src="images/more.gif"></a></td>
    </tr>
<% } %>
  </table>
<%
  }
  DB.close(rs);
%>
<ej:textfield width="33%" />
  <table width="100%" border=0 cellspacing=0 cellpadding=0>
    <tr>
      <td align="left" valign="top"><h2><%=ssn.string("title_JUNGLE")%></h2></td>
      <td align="right" valign="top"><b class="hl"><%=scoreJungle == 0 ? "" : scoreJungle + "&nbsp;" + ssn.string("place")%></b></td>
    </tr>
  </table>
<%
  rs = DB.query("SELECT COUNT(*), SUM(victory), SUM(contests.id > ?), " +
                "       SUM(victory AND contests.id > ?) FROM results, contests " +
                "WHERE contests.id = results.contest AND contests.kind = 3 AND " +
                "      contests.id <= ? AND being = ?",
                recentContest, recentContest, lastContest, being);
  if (rs.next()) {
    int matches = rs.getInt(1);
    int won = rs.getInt(2);
    int matchesLatest = rs.getInt(3);
    int wonLatest = rs.getInt(4);
%>
  <table width="100%" border=0 cellspacing=1 cellpadding=3 bgcolor="#909030" class="cell">
    <tr>
      <th nowrap class="cell" align="center" width="33%">&nbsp;</th>
      <th nowrap class="cell" align="center" width="33%"><%=ssn.string("in_rating")%></th>
      <th nowrap class="cell" align="center" width="33%"><%=ssn.string("latest")%></th>
    </tr>
    <tr>
      <td nowrap class="cell" align="left" style="background-color: #bbffbb"><%=ssn.string("won")%></td>
      <td nowrap class="cell" style="background-color: #bbffbb; padding: 0px" height="100%"><%=cell(won, matches)%></td>
      <td nowrap class="cell" style="background-color: #bbffbb; padding: 0px" height="100%"><%=cell(wonLatest, matchesLatest)%></td>
    </tr>
    <tr>
      <td nowrap class="cell" align="left" style="background-color: #ffbbbb"><%=ssn.string("lost")%></td>
      <td nowrap class="cell" style="background-color: #ffbbbb; padding: 0px" height="100%"><%=cell(matches-won, matches)%></td>
      <td nowrap class="cell" style="background-color: #ffbbbb; padding: 0px" height="100%"><%=cell(matchesLatest-wonLatest, matchesLatest)%></td>
    </tr>
    <tr>
      <td nowrap class="cell" align="left" style="background-color: #ffff88"><%=ssn.string("total")%></td>
      <td nowrap class="cell" align="right" style="background-color: #ffff88"><%=matches%></td>
      <td nowrap class="cell" align="right" style="background-color: #ffff88"><%=matchesLatest%></td>
    </tr>
    <tr><td height=11 colspan=3></td></tr>
<% if (false) { %>
    <tr>
      <td></td>
      <td height=11 align="center" valign="top" style="padding: 0px"><a href="main.jsp?page=contestinfo&info=jungles&being=<%=being%>"><img width=20 height=11 border=0 alt="<%=ssn.string("details")%>" src="images/more.gif"></a></td>
      <td height=11 align="center" valign="top" style="padding: 0px"><a href="main.jsp?page=contestinfo&info=jungle&being=<%=being%>"><img width=20 height=11 border=0 alt="<%=ssn.string("details")%>" src="images/more.gif"></a></td>
    </tr>
<% } %>
  </table>
<%
  }
  DB.close(rs);
%>
<ej:textfield />

<p><a href="javascript:history.back()"><%=ssn.string("back")%></a></p>
