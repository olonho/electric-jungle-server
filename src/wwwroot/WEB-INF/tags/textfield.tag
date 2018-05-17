<!-- Colored field -->
<%@ tag body-content="empty" %>
<%@ attribute name="tabs" %>
<%@ attribute name="width" %>
<%@ attribute name="fieldwidth" %>
<%!
  static class TextField {
    int count;
    char[] bgImage;
    String[] bgColor;
    int current;

    TextField(String tabs) {
      count = tabs.length();
      bgImage = tabs.toCharArray();
      bgColor = new String[count];
      for (int i = 0; i < count; i++) {
        bgColor[i] = bgImage[i] == '1' ? "#c7ce46" : "#dee4b6";
      }
    }
  }
%>

<%
   TextField tf = (TextField)request.getAttribute("tf");
   if (tf == null) {
     tf = new TextField(tabs);
     request.setAttribute("tf", tf);
%>
  <table width="<%=fieldwidth == null ? "100%" : fieldwidth %>" border=0 cellspacing=0 cellpadding=0>
    <tr><td colspan=<%=tf.count * 4 - 1%> height=5></td></tr>
    <tr>
<%
     for (int i = 0; i < tf.count; i++) {
       if (i != 0) out.write("<td width=10 nowrap></td>");
%>
      <td width=10 height=10 nowrap background="images/tab<%=tf.bgImage[i]%>_ul.gif"></td>
      <td height=10 bgcolor="<%=tf.bgColor[i]%>" background="images/tab<%=tf.bgImage[i]%>_uc.gif"></td>
      <td width=10 height=10 nowrap background="images/tab<%=tf.bgImage[i]%>_ur.gif"></td>
<%   } %>
    </tr>
    <tr>
      <td width=10 bgcolor="<%=tf.bgColor[0]%>"></td>
      <td bgcolor="<%=tf.bgColor[0]%>" align="left" valign="top" <%=width == null ? "" : "width=\"" + width + "\""%>>
<% } else if (tf.current != tf.count - 1) { %>
      </td>
      <td width=10 bgcolor="<%=tf.bgColor[tf.current]%>"></td>
      <td width=10 nowrap></td>
      <td width=10 bgcolor="<%=tf.bgColor[++tf.current]%>"></td>
      <td bgcolor="<%=tf.bgColor[tf.current]%>" align="left" valign="top" <%=width == null ? "" : "width=\"" + width + "\""%>>
<% } else { %>
      </td>
      <td width=10 bgcolor="<%=tf.bgColor[tf.current]%>"></td>
    </tr>
    <tr>
<%
     for (int i = 0; i < tf.count; i++) {
       if (i != 0) out.write("<td width=10 nowrap></td>");
%>
      <td width=10 height=10 nowrap background="images/tab<%=tf.bgImage[i]%>_dl.gif"></td>
      <td height=10 bgcolor="<%=tf.bgColor[i]%>"></td>
      <td width=10 height=10 nowrap background="images/tab<%=tf.bgImage[i]%>_dr.gif"></td>
<%   } %>
    </tr>
    <tr><td colspan=<%=tf.count * 4 - 1%> height=5></td></tr>
  </table>
<% 
     request.removeAttribute("tf");
   }
%>
