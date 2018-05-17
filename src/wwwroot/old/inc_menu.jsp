<%@ page contentType="text/html; charset=windows-1251" %>
<%!
   public static final Menu COMMON_MENU = new Menu(
      new MenuItem("en",       "change_language", "index.jsp?lang=toggle"),
      new MenuItem("main",     "about_contest"),
      new MenuItem("rules",    "rules"),
      new MenuItem("sdk",      "download_sdk")
  );
  
  public static final Menu GUEST_MENU = new Menu(
      new MenuItem("register", "registration"),
      new MenuItem()
  );

  public static final Menu MEMBER_MENU = new Menu(
      new MenuItem("profile",  "profile"),
      new MenuItem("beings",   "beings"),
      new MenuItem("friends",  "friends"),
      new MenuItem("contest",  "contests"),
      new MenuItem("rating",   "rating"),
      new MenuItem(),
      new MenuItem("logout",   "logout", "do_session.jsp?action=logout")
  );

%>
<table width="100%" border=0 cellspacing=0 cellpadding=5>
  <tr>
    <td width=20>&nbsp;</td>
<%
      COMMON_MENU.draw(out, pageName, lang);
      Menu extra = ssn.loggedOn() ? MEMBER_MENU : GUEST_MENU;
      extra.draw(out, pageName, lang);
%>
  </tr>
</table>
