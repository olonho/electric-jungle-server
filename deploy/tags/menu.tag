<!-- Main menu -->
<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%!
  public static final String[] GUEST_MENU = new String[] {
      "intro",
      "rules",
      "sdk",
      "forum",
      "register"
  };
  
  public static final String[] MEMBER_MENU = new String[] {
      "intro",
      "rules",
      "sdk",
      "forum",
      "profile",
      "beings",
      "friends",
      "contest",
      "rating"
  };
%>
<%@ attribute name="page" %>
<% String[] menu = ssn.loggedOn() ? MEMBER_MENU : GUEST_MENU; %>
<table width="100%" height="100%" border=0 cellspacing=0 cellpadding=0>
  <tr><td align="right" valign="top" style="padding: 5px">
    <table border=0 cellspacing=0 cellpadding=0 class="menui"><tr>
<% if ("ru".equals(ssn.lang)) { %>
      <td width=40 height=25 align="center" valign="middle" background="images/lang_hl.jpg">RUS</td>
      <td height=25 valign="middle"> | </td>
      <td width=40 height=25 align="center" valign="middle"><a href="main.jsp?page=<%=page%>&lang=en" class="menui">ENG</a></td>
<% } else { %>
      <td width=40 height=25 align="center" valign="middle"><a href="main.jsp?page=<%=page%>&lang=ru" class="menui">RUS</a></td>
      <td height=25 valign="middle"> | </td>
      <td width=40 height=25 align="center" valign="middle" background="images/lang_hl.jpg">ENG</td>
<% } %>
    </tr></table>
  </td></tr>
  <tr><td align="left" valign="bottom">
    <table border=0 cellspacing=0 cellpadding=0><tr>
<%
  boolean selected = false;
  for (int i = 0; i < menu.length; i++) {
    String caption = ssn.string("menu_" + menu[i]);
    String href = "main.jsp?page=" + menu[i];
    if (i != 0) {
      out.write("<td class=\"menui\" valign=\"bottom\" width=1 height=24");
      if (selected || menu[i].equals(page)) out.write(" style=\"padding-bottom: 0px\"");
      out.write("><div class=\"menuline\"></div></td>");
    }
    if (menu[i].equals(page)) {
      out.write("<td nowrap class=\"menui\" valign=\"bottom\" height=24 width=80 align=\"center\" bgcolor=\"#6b7d96\" background=\"images/menua.gif\"><b>" + caption + "</b></td>");
      selected = true;
    } else {
      out.write("<td nowrap class=\"menui\" valign=\"bottom\" height=24 width=80 align=\"center\"><a href=\"" + href + "\" class=\"menui\">" + caption + "</a></td>");
      selected = false;
    }
  }
%>
    </tr></table>
  </td></tr>
</table>
