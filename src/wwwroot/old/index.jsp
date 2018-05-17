<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page import="ejungle.web.*" %>
<%  
  String pageName = request.getParameter("page");
  if (pageName == null || pageName.equals("")) {
    pageName = "main";
  }
  String lang = request.getParameter("lang");
  if (lang == null) {
     lang = ssn.lang;
  } else {
    if ("toggle".equals(lang)) {
       if (ssn.lang == null) {
          lang = "en";
       } else {
          if ("ru".equals(ssn.lang)) {
             lang = "en";
          } else {
             lang = "ru";
          }
       }
    } else {
      if (!"ru".equals(lang) && !"en".equals(lang)) {
         lang="ru";
      }
    }
    ssn.setLang(lang);
  }
  String cs = ssn.string("charset");
%>
<%@ page contentType="text/html; charset=windows-1251" %>

<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=<%=cs%>">
  <title><%=ssn.string("page_title")%></title>
  <link rel="stylesheet" href="style.css" type="text/css">
</head>
<body leftmargin=0 topmargin=0 bgcolor="#ffffff" text="#000000">
  <table border=0 cellspacing=0 cellpadding=0 width="100%" height="100%">
    <tr>
      <td width="100%" height=90 bgcolor="#5080a0"><table border=0 cellspacing=0 cellpadding=10 width="100%" height="100%">
        <tr>
          <td align="left" valign="top"><a href="index.jsp"><img border=0 width=84 height=36 src="images/logo.gif" alt="Home"></a></td>
          <td width="100%" align="center" valign="middle"><img width=400 height=45 src="images/title.gif" alt="Electric Jungle"></td>
        </tr>
      </table></td>
      <td height=90 bgcolor="#5080a0">&nbsp;</td>
      <td height=90 bgcolor="#5080a0">&nbsp;</td>
    </tr>
    <tr>
      <td width="100%" bgcolor="#5080a0" align="left"><%@ include file="inc_menu.jsp" %></td>
      <td bgcolor="#5080a0">&nbsp;</td>
      <td bgcolor="#5080a0">&nbsp;</td>
    </tr>
    <tr>
      <td height="100%" align="left" valign="top" style="padding: 10px">
<%
        ErrorCode error = ErrorCode.forName(request.getParameter("error"));
        if (!COMMON_MENU.contains(pageName) && !GUEST_MENU.contains(pageName)) {
            if (MEMBER_MENU.contains(pageName)) {
                if (!ssn.loggedOn()) {
                    error = ErrorCode.SESSION_EXPIRED;
                    pageName = "main";
                }
            } else {
                error = ErrorCode.NO_SUCH_PAGE;
                pageName = "main";
            }
        }
        if (error != null) {
            out.write("<h4 align=\"center\">" + error.getMessage(ssn.lang) + "</h4>");
        }
        pageContext.include("page_" + pageName + ".jsp");
%>
      </td>
      <td height="100%" valign="top"><img width=40 height=145 src="images/duke1.gif"></td>
      <td height="100%" bgcolor="#5080a0" valign="top"><img width=100 height=145 src="images/duke2.gif"></td>
    </tr>
    <tr>
      <td align="center" valign="middle" class="small" style="padding: 5px">Copyright 2006 Sun Microsystems, Inc.</td>
      <td>&nbsp;</td>
      <td bgcolor="#5080a0" valign="top">&nbsp;</td>
    </tr>
  </table>
</body>
</html>
