<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="ejungle.web.*" %>
<%@ taglib prefix="ej" tagdir="/WEB-INF/tags" %>
<%
  java.io.File fDistr    = Util.getFile("files/ejungle_distr.jar");
  java.io.File fWhatsNew = Util.getFile("files/whatsnew.txt");
%>

<ej:pageheader type="1" header="<%=ssn.string("software")%>" />
<link rel="alternate" type="application/rss+xml" title="RSS" href="http://www.electricjungle.ru:8080/files/whatsnew.xml"> 
<ej:textfield tabs="1" />
  <%=ssn.string("rules_sdk")%>
  <p><%=ssn.string("version")%> <b class="alt"><%@ include file="inc_version.jsp" %></b> <%=ssn.string("updated")%> <%=Util.datetime(new java.util.Date(fWhatsNew.lastModified()), ssn.lang)%></p>
  <p>
    <a href="files/ejungle_distr.jar"><img align="absbottom" width=16 height=16 border=0 src="images/ico_download.gif"><%=ssn.string("download")%> (<%=fDistr.length() / 1024%> <%=ssn.string("kb")%>)</a>
    &nbsp;&nbsp;
    <a href="files/whatsnew.txt"><img align="absbottom" width=16 height=16 border=0 src="images/ico_info.gif"><%=ssn.string("view_changes")%></a>
    &nbsp;&nbsp;
    <a href="files/docs/index.html"><img align="absbottom" width=16 height=16 border=0 src="images/ico_doc.gif"><%=ssn.string("engine_docs")%></a>
  </p>
<ej:textfield />

<ej:textfield tabs="2" />
  <%=ssn.string("rules_coding")%>
<ej:textfield />

<ej:textfield tabs="22" />
  <%=ssn.string("rules_notes")%>
<ej:textfield />
  <%=ssn.string("rules_security")%>
<ej:textfield />
