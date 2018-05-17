<%!
  public static final String[] GUEST_MENU = new String[] {
      "intro",
      "rules",
      "sdk",
      "forum",
      "rating",
      "final",
      "register"
  };
  
  public static final String[] MEMBER_MENU = new String[] {
      "intro",
      "rules",
      "sdk",
      "forum",
      "rating",
      "final",
      "beings",
      "contest",
      "profile"
  };

  public static final String[] HIDDEN_MENU = new String[] {
      "beinginfo",
      "contestinfo",
      "finalinfo",
      "fullrating",
      "news",
      "register",
      "applet"
  };

  boolean contains(String[] menu, String key) {
      for (String item : menu) {
          if (item.equals(key)) {
              return true;
          }
      }
      return false;
  }
%>
<%
  String[] menu = ssn.loggedOn() ? MEMBER_MENU : GUEST_MENU;
  if (!contains(menu, pageName)) {
      if (contains(HIDDEN_MENU, pageName)) {
          // do nothing
      } else if (menu == GUEST_MENU && contains(MEMBER_MENU, pageName)) {
          response.sendRedirect("/index.jsp?error=SESSION_EXPIRED");
          return;
      } else {
          pageName = menu[0];
      }
  }

  String requestURL = request.getRequestURI();
  String queryString = request.getQueryString();
  if (queryString == null) {
      requestURL += "?lang=";
  } else {
    int p = queryString.indexOf("lang=");
    requestURL += "?" + (p < 0 ? queryString + "&lang=" : queryString.substring(0, p + 5));
  }
%>
<table width="100%" height="100%" border=0 cellspacing=0 cellpadding=0>
  <tr><td align="right" valign="top" style="padding: 5px">
    <table border=0 cellspacing=0 cellpadding=0 class="menui"><tr>
<% if (ssn.loggedOn()) { %>
      <td><b><%=Util.encodeHTML(ssn.nick)%></b>&nbsp;&nbsp;<a href="do_session.jsp?action=logout" class="menui"><%=ssn.string("logout")%></a></td>
<% } else { %>
      <td><a href="index.jsp" class="menui"><%=ssn.string("home_page")%></a></td>
<% } %>
      <td width=30 nowrap>&nbsp;</td>
<% if ("ru".equals(ssn.lang)) { %>
      <td width=40 height=25 align="center" valign="middle" background="images/lang_hl.jpg">RUS</td>
      <td height=25 valign="middle"> | </td>
      <td width=40 height=25 align="center" valign="middle"><a href="<%=requestURL%>en" class="menui">ENG</a></td>
<% } else { %>
      <td width=40 height=25 align="center" valign="middle"><a href="<%=requestURL%>ru" class="menui">RUS</a></td>
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
      if (selected || menu[i].equals(pageName)) out.write(" style=\"padding-bottom: 0px\"");
      out.write("><div class=\"menuline\"></div></td>");
    }
    if (menu[i].equals(pageName)) {
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
