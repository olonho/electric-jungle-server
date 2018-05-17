<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<% ssn.ensureLoggedOn(); %>
<div id="updateFront"><%@ include file="inc_contest.jsp" %></div>
<iframe id="updateBack" style="display:none" onload="updateData()"></iframe>
<script language="JavaScript">
  var remoteDoc;

  function updateData() {
    remoteDoc = updateBack.contentWindow ? updateBack.contentWindow.document : updateBack.document;
    var newData = remoteDoc.body.innerHTML;
    if (newData && updateFront.innerHTML != newData) updateFront.innerHTML = newData;
    window.setTimeout("remoteDoc.location = 'update_contest.jsp'", 10000);
  }

  function ask() {
    return window.confirm("<%=ssn.string("cancel_contest")%>");
  }
</script>
<p>&nbsp;</p>
