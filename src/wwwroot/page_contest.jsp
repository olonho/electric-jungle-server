<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<%@ taglib prefix="ej" tagdir="/WEB-INF/tags" %>
<% ssn.ensureLoggedOn(); %>

<%!
   String scoreString(int score) {
     return score > 0 ? Integer.toString(score) : "-";
   }

   String sortString(int order, int sort, String title) {
     StringBuilder sb = new StringBuilder(128);
     sb.append("<a class=\"alt\" onclick=\"href+=rowStyle\" href=\"main.jsp?page=contest&sort=");
     sb.append(sort == order ? order ^ 1 : order);
     sb.append("&rowstyle=\">");
     sb.append(title);
     if (sort == (order & 254)) {
       sb.append("<img border=0 align=\"absmiddle\" width=16 height=16 src=\"images/sort_up.gif\">");
     } else if (sort == (order | 1)) {
       sb.append("<img border=0 align=\"absmiddle\" width=16 height=16 src=\"images/sort_down.gif\">");
     }
     sb.append("</a>");
     return sb.toString();
   }

   static String[] ORDER_BY = new String[] {
     "beings.id",
     "beings.id DESC",
     "users.nick",
     "users.nick DESC",
     "beings.mainclass",
     "beings.mainclass DESC",
     "rd.position IS NULL, rd.position",
     "rd.position IS NULL, rd.position DESC",
     "rj.position IS NULL, rj.position",
     "rj.position IS NULL, rj.position DESC",
     "rs.position IS NULL, rs.position",
     "rs.position IS NULL, rs.position DESC"
   };
%>
<%
   String s = request.getParameter("sort");
   int sort = 6;
   if (s != null) {
     try {
       sort = Integer.parseInt(s);
       if (sort < 0 || sort >= ORDER_BY.length) sort = 6;
     } catch (NumberFormatException e) {}
   }
   String rowstyle = request.getParameter("rowstyle");
   String stylestring = "id=\"rbeing\"";
   if (!"".equals(rowstyle)) {
     rowstyle = "none";
     stylestring += " style=\"display: none\"";
   }
%>
<ej:pageheader type="1" header="<%=ssn.string("contests")%>" />
<div id="updateFront"><%@ include file="inc_contest.jsp" %></div>
<iframe id="updateBack" style="display:none" onload="updateData()"></iframe>
<script language="JavaScript">
  var remoteDoc;
  var rowStyle = "<%=rowstyle%>";

  function updateData() {
    remoteDoc = updateBack.contentWindow ? updateBack.contentWindow.document : updateBack.document;
    var newData = remoteDoc.body.innerHTML;
    if (newData && updateFront.innerHTML != newData) updateFront.innerHTML = newData;
    window.setTimeout("remoteDoc.location = 'update_contest.jsp'", 10000);
  }

  function ask() {
    return window.confirm("<%=ssn.string("cancel_contest")%>");
  }

  function showTable() {
    if (rowStyle == "none") {
      rswitch.innerHTML = "<%=ssn.string("shrink_table")%>";
      rowStyle = "";
    } else {
      rswitch.innerHTML = "<%=ssn.string("complete_table")%>";
      rowStyle = "none";
    }
    for (i = 0; i < tbeing.rows.length; i++) {
      var row = tbeing.rows[i];
      if (row.id == "rbeing") {
        row.style.display = rowStyle;
      }
    }
    tbeing.scrollIntoView();
  }
</script>
<br>

<form action="do_contest.jsp?action=launch" method="post">
<ej:pageheader type="2" header="<%=ssn.string("begin_contest")%>" />
<table id="tbeing" width=640 border=0 cellspacing=1 cellpadding=3 bgcolor="#909030" class="cell">
  <tr>
    <th nowrap class="cell" align="center" width=20><%=sortString(1, sort, sort < 2 ? "" : "&nbsp;&nbsp;&nbsp;&nbsp;")%></th>
    <th nowrap class="cell" align="left"><%=sortString(2, sort, ssn.string("author"))%></th>
    <th nowrap class="cell" align="left" width="100%"><%=sortString(4, sort, ssn.string("being"))%></th>
    <th nowrap class="cell" align="center"><%=sortString( 6, sort, ssn.string("title_DUEL"))%></th>
    <th nowrap class="cell" align="center"><%=sortString( 8, sort, ssn.string("title_JUNGLE"))%></th>
    <th nowrap class="cell" align="center"><%=sortString(10, sort, ssn.string("title_SINGLE"))%></th>
  </tr>
  <tr><td colspan=6 height=1 bgcolor="#ffffff" style="padding: 0px"></td></tr>
<%
   ResultSet rs = DB.query(
     "SELECT beings.id, beings.owner, beings.permissions, users.nick, beings.mainclass, rd.position, rj.position, rs.position FROM beings " +
     "  INNER JOIN users ON users.id = beings.owner " +
     "  LEFT OUTER JOIN friends ON friends.user = beings.owner AND friends.friend = ? " +
     "  LEFT OUTER JOIN ratingcache_DUEL   AS rd ON rd.being = beings.id " +
     "  LEFT OUTER JOIN ratingcache_JUNGLE AS rj ON rj.being = beings.id " +
     "  LEFT OUTER JOIN ratingcache_SINGLE AS rs ON rs.being = beings.id " +
     "  WHERE beings.owner = ? OR beings.permissions + (friends.id IS NOT NULL) >= 3 " +
     "  ORDER BY beings.owner = ? DESC, " + ORDER_BY[sort],
     ssn.id, ssn.id, ssn.id
   );
   int rows = 0;
   while (rs.next()) {
     int owner = rs.getInt(2);
     String color;
     if (owner == ssn.id) {
       color = "#ffbbbb";
       rows = -1;
     } else {
       if (rs.getInt(2) == 2) {
         color = "#ffff88";
       } else {
         color = "#bbffbb";
       }
       if (rows < 0) {
         out.write("<tr><td colspan=6 height=1 bgcolor=\"#ffffff\" style=\"padding: 0px\"></td></tr>\n");
         rows = 0;
       }
       rows++;
     }
%>
  <tr <%=rows > 10 ? stylestring : ""%>>
    <td align="center" class="cell" style="background-color: <%=color%>" width=20><input type="checkbox" name="id" value="<%=rs.getInt(1)%>" class="checkbox"></td>
    <td align="left"   class="cell"><h2 style="margin: 0px"><%=Util.encodeHTML(rs.getString(4))%></h2></td>
    <td align="left"   class="cell"><a href="main.jsp?page=beinginfo&being=<%=rs.getInt(1)%>" style="text-decoration: none"><%=Util.encodeHTML(rs.getString(5))%></a></td>
    <td align="center" class="cell"><%=scoreString(rs.getInt(6))%></td>
    <td align="center" class="cell"><%=scoreString(rs.getInt(7))%></td>
    <td align="center" class="cell"><%=scoreString(rs.getInt(8))%></td>
  </tr>
<%
   }
   DB.close(rs);
   if (rows > 10) {
     out.write("<tr><td colspan=6 class=\"cella\" align=\"center\"><a id=\"rswitch\" href=\"javascript:showTable()\">" + ssn.string("".equals(rowstyle) ? "shrink_table" : "complete_table") + "</a></td></tr>");
   }
%>
  <ej:row colspan="6" empty="false" />
</table>
<p><input type="submit" class="button" value="<%=ssn.string("begin_contest")%>"></p>
</form>
