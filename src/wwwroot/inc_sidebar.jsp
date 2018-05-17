<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>

<table width=140 border=0 cellspacing=0 cellpadding=0>
  <tr><td height=30>&nbsp;</td></tr>
  <tr><td height=44><img width=140 height=44 src="images/left_tiger.jpg" alt="Tiger"></td></tr>
  <tr><td height=22 align="center" bgcolor="#586a88" background="images/left_head.gif"><h5><%=ssn.string("sidebar_caption")%></h5></td></tr>
  <!-- Contents -->
  <tr><td bgcolor="#708299" class="info">
    <font color="#ffffff"><%=ssn.string("participants")%>:</font> <%=Util.cachedQuery("SELECT COUNT(*) FROM users")%><br>
    <font color="#ffffff"><%=ssn.string("new_participants")%>:</font> <%=Util.cachedQuery("SELECT COUNT(*) FROM users WHERE added >= SUBDATE(NOW(), 1)")%><br>
  </td></tr>
  <tr><td bgcolor="#ffffff" height=1></td></tr><tr><td bgcolor="#465a7c" height=1></td></tr>
  <tr><td bgcolor="#708299" class="info">
    <font color="#ffffff"><%=ssn.string("beings_total")%>:</font> <%=Util.cachedQuery("SELECT COUNT(*) FROM beings")%><br>
    <font color="#ffffff"><%=ssn.string("beings_public")%>:</font> <%=Util.cachedQuery("SELECT COUNT(*) FROM beings WHERE permissions >= 3")%><br>
    <font color="#ffffff"><%=ssn.string("jungle_king")%>:</font> <%=Util.cachedQuery("SELECT nick FROM ratingcache_DUEL_FINALDUEL WHERE position = 1")%><br>
  </td></tr>
  <tr><td bgcolor="#ffffff" height=1></td></tr><tr><td bgcolor="#465a7c" height=1></td></tr>
  <tr><td bgcolor="#708299" class="info">
    <font color="#ffffff"><%=ssn.string("software_version")%>:</font> <%@ include file="inc_version.jsp" %><br>
<%/*  <font color="#ffffff">=ssn.string("rating_age"):</font> =Util.cachedQuery("SELECT TIME_FORMAT(TIMEDIFF(NOW(), MAX(end)), '%H:%i') FROM rounds")<br>*/%>
  </td></tr>
  <!-- // Contents -->
  <tr><td height=7><img width=140 height=7 src="images/left_bottom.gif"></td></tr>
</table>

<%
  ResultSet rs = DB.query("SELECT id, title_" + ssn.lang + " FROM news " +
                          "  WHERE title_" + ssn.lang + " IS NOT NULL " +
                          "ORDER BY id DESC");
  while (rs.next()) {
%>
<br>
<a href="main.jsp?page=news#news<%=rs.getInt(1)%>" class="news"><div class="popup1"><div class="popup2">
<%=rs.getString(2)%>
</div></div></a>
<%
  }
  DB.close(rs);
%>

<%/*
<!-- Banners -->
<br><br>
<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="120" height="120" id="2" align="middle">
<param name="allowScriptAccess" value="sameDomain" />
<param name="movie" value="banners/ocs.swf" />
<param name="quality" value="high" />
<param name="bgcolor" value="#ffffff" />
<embed src="banners/ocs.swf" quality="high" bgcolor="#ffffff" width="120" height="120" name="2" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object>
*/%>
