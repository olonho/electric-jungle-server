<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<%@ taglib prefix="ej" tagdir="/WEB-INF/tags" %>
<%
  String tag = request.getParameter("tag");
  int breakCount = 999999;
  int blocks = 0;
  if ("_FINAL".equals(tag)) {
    blocks = 1;
    breakCount = 20;
  } else if ("_FINAL2".equals(tag)) {
    blocks = 1;
    breakCount = 5;
  } else if ("_FINALDUEL".equals(tag)) {
    blocks = 3;
  } else {
    blocks = 4;
    tag = "_FINALSINGLE";
  }
%>
<div style="width: 620px">
<br>
<object align="right" classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="468" height="60" id="2">
<param name="allowScriptAccess" value="sameDomain" />
<param name="movie" value="banners/techdays.swf" />
<param name="quality" value="high" />
<param name="bgcolor" value="#ffffff" />
<embed src="banners/techdays.swf" quality="high" bgcolor="#ffffff" width="468" height="60" name="2" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object>
<ej:pageheader type="1" header="<%=ssn.string("title" + tag)%>" />
</div>
<table width=140 border=0 cellspacing=0 cellpadding=0 align="right">
  <tr><td height=22 align="center" bgcolor="#586a88" background="images/left_head.gif"><h5><%=ssn.string("program")%></h5></td></tr>
  <tr><td bgcolor="#708299" class="info">
    <ul class="itemc"><li><a class="news" href="main.jsp?page=final&tag=_FINAL">
      <font color="#ffffff"><%=ssn.string("final_duel40")%></font><br>
      <%=ssn.string("finished")%>
    </a></li></ul>
  </td></tr>
  <tr><td bgcolor="#ffffff" height=1></td></tr><tr><td bgcolor="#465a7c" height=1></td></tr>
  <tr><td bgcolor="#708299" class="info"><a class="news" href="main.jsp?page=final&tag=_FINAL2">
    <ul class="itemc"><li>
      <font color="#ffffff"><%=ssn.string("final_duel20")%></font><br>
      <%=ssn.string("finished")%>
    </a></li></ul>
  </td></tr>
  <tr><td bgcolor="#ffffff" height=1></td></tr><tr><td bgcolor="#465a7c" height=1></td></tr>
  <tr><td bgcolor="#708299" class="info">
    <ul class="itemc"><li><a class="news" href="main.jsp?page=final&tag=_FINALDUEL">
      <font color="#ffffff"><%=ssn.string("final_duel5")%></font><br>
      <%=ssn.string("finished")%>
    </a></li></ul>
  </td></tr>
  <tr><td bgcolor="#ffffff" height=1></td></tr><tr><td bgcolor="#465a7c" height=1></td></tr>
  <tr><td bgcolor="#708299" class="info">
    <ul class="itema"><li><a class="news" href="main.jsp?page=final&tag=_FINALSINGLE">
      <font color="#ffffff"><%=ssn.string("final_single")%></font><br>
      <%=ssn.string("round_of")%>: 5 <%=ssn.string("of")%> 5
    </a></li></ul>
  </td></tr>
  <tr><td bgcolor="#cccccc" height=1></td></tr><tr><td bgcolor="#465a7c" height=1></td></tr>
  <tr><td bgcolor="#708299" class="info">
    <ul class="itemi"><li>
      <%=ssn.string("final_junglegroups")%><br>
      <%=ssn.string("contest_of")%>: 0 <%=ssn.string("of")%> 14
    </li></ul>
  </td></tr>
  <tr><td bgcolor="#cccccc" height=1></td></tr><tr><td bgcolor="#465a7c" height=1></td></tr>
  <tr><td bgcolor="#708299" class="info">
    <ul class="itemi"><li>
      <%=ssn.string("final_junglesemi")%><br>
      <%=ssn.string("contest_of")%>: 0 <%=ssn.string("of")%> 3
    </li></ul>
  </td></tr>
  <tr><td bgcolor="#cccccc" height=1></td></tr><tr><td bgcolor="#465a7c" height=1></td></tr>
  <tr><td bgcolor="#708299" class="info">
    <ul class="itemi"><li>
      <%=ssn.string("final_junglefinal")%>
    </li></ul>
  </td></tr>
  <tr><td height=7><img width=140 height=7 src="images/left_bottom.gif"></td></tr>
</table>

<% if ((blocks & 1) != 0) { %>
<%@  include file="inc_finalduel.jsp" %>
<% } %>
<% if ((blocks & 2) != 0) { %>
<%@  include file="inc_finaltable.jsp" %>
<% } %>
<% if ((blocks & 4) != 0) { %>
<%@  include file="inc_finalsingle.jsp" %>
<% } %>
