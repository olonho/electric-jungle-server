<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<%@ taglib prefix="ej" tagdir="/WEB-INF/tags" %>
<% ssn.ensureLoggedOn(); %>

<ej:pageheader type="1" header="<%=ssn.string("beings")%>" />
<table width=640 border=0 cellspacing=1 cellpadding=3 bgcolor="#909030" class="cell">
  <tr>
    <th nowrap class="cell" align="left"  ><%=ssn.string("jar_file")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("size")%></th>
    <th nowrap class="cell" align="left"  ><%=ssn.string("main_class")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("access")%></th>
    <th nowrap class="cell" align="center"><%=ssn.string("control")%></th>
  </tr>
<%
   String title = "<span id=\"title\">" + ssn.string("add_being") + "</span>";
   ResultSet rs = DB.query("SELECT id, jarfile, jarsize, mainclass, permissions FROM beings " +
                           "  WHERE owner = ?", ssn.id);
   String[] ps = new String[] {
     "",
     ssn.string("private"),
     ssn.string("friends_only"),
     ssn.string("public")
   };
   String[] color = new String[] {
     "",
     "#ffbbbb",
     "#ffff88",
     "#bbffbb"
   };
   while (rs.next()) {
     int id = rs.getInt(1);
     int permissions = rs.getInt(5);
     if (permissions <= 0 || permissions >= ps.length) { permissions = 1; }
     String mainClass = Util.encodeHTML(rs.getString(4));
%>
  <tr>
    <td align="left"   class="cell"><%=Util.encodeHTML(rs.getString(2))%></td>
    <td align="right"  class="cell"><%=(rs.getInt(3) / 1024) + "&nbsp;"+ssn.string("kb")%></td>
    <td align="left"   class="cell"><%=mainClass%></td>
    <td align="center" class="cell" style="background-color: <%=color[permissions]%>"><%=ps[permissions]%></td>
<% if (ejungle.manager.Manager.isFinal()) {%>
   <td align="center" class="celle" nowrap><%=ssn.string("unavailable")%></td>
<% } else { %>
   <td align="center" class="cell" nowrap>
      <a href="#formstart" onclick="frmEdit(<%=id%>, '<%=mainClass%>', <%=permissions%>)"><%=ssn.string("change")%></a>&nbsp;
      <a href="do_beings.jsp?action=delete&id=<%=id%>" onclick="return frmDelete()"><%=ssn.string("delete")%></a>
    </td>
<% } %>
  </tr>
<% } %>
  <ej:row colspan="5" empty="<%=!rs.isAfterLast()%>" />
</table>
<% DB.close(rs); %>
<script language="JavaScript">
  function frmCancel() {
    frm.elements["id"].value = "";
    frm.elements["mainclass"].value = "";
    frm.elements["permissions"][1].checked = true;
    frm.elements["btnSubmit"].value = "<%=ssn.string("upload_file")%>";
    frm.elements["btnCancel"].style.display = "none";
    title.innerHTML = "<%=ssn.string("add_being")%>";
    return true;
  }
  function frmEdit(id, mainClass, permissions) {
    frm.elements["id"].value = id;
    frm.elements["mainclass"].value = mainClass;
    frm.elements["permissions"][permissions - 1].checked = true;
    frm.elements["btnSubmit"].value = "<%=ssn.string("change")%>";
    frm.elements["btnCancel"].style.display = "";
    title.innerHTML = "<%=ssn.string("change_being")%>";
    return true;
  }
  function frmDelete() {
    return window.confirm("<%=ssn.string("remove_jar_file")%>");
  }
</script>
<br>
<% if (ejungle.manager.Manager.isFinal()) { %>
<ej:pageheader type="2" header="<%=ssn.string("notice")%>" />
<ej:textfield tabs="1" fieldwidth="640" />
  <%=ssn.string("beings_restriction")%>
<ej:textfield />
<% } else { %> 
<a name="formstart"></a>
<ej:pageheader type="2" header="<%=title%>" />
<ej:textfield tabs="1" fieldwidth="640" />
  <form name="frm" action="do_beings.jsp?action=edit" method="post" enctype="multipart/form-data">
  <input type="hidden" name="id" value="">
  <p>
  <b class="hl"><%=ssn.string("jar_file")%></b><br>
  <input name="jarfile" type="file" size="64" style="width: 400px">
  </p>
  <p>
  <b class="hl"><%=ssn.string("main_class")%></b> (<%=ssn.string("empty_if_given_in_manifest")%>)<br>
  <input name="mainclass" type="text" size="64" style="width: 400px">
  </p>
  <p>
  <b class="hl"><%=ssn.string("access")%></b><br>
  <table width=400 border=0 cellspacing=1 cellpadding=1 class="lowered">
    <tr><td width=120 align="left" valign="middle" bgcolor="<%=color[1]%>" nowrap><input type="radio" class="checkbox" name="permissions" value="1">         <%=ssn.string("private")%></td>     <td align="left" valign="middle" bgcolor="#dee4b6" width="100%">&nbsp;<%=ssn.string("hidden_from_others")%></td></tr>
    <tr><td width=120 align="left" valign="middle" bgcolor="<%=color[2]%>" nowrap><input type="radio" class="checkbox" name="permissions" value="2" checked> <%=ssn.string("friends_only")%></td><td align="left" valign="middle" bgcolor="#dee4b6" width="100%">&nbsp;<%=ssn.string("visible_to_friends")%></td></tr>
    <tr><td width=120 align="left" valign="middle" bgcolor="<%=color[3]%>" nowrap><input type="radio" class="checkbox" name="permissions" value="3">         <%=ssn.string("public")%></td>      <td align="left" valign="middle" bgcolor="#dee4b6" width="100%">&nbsp;<%=ssn.string("visible_to_all")%></td></tr>
  </table>
  </p>
  <p>
  <input name="btnSubmit" type="submit" value="<%=ssn.string("upload_file")%>" class="button">&nbsp;
  <input name="btnCancel" type="button" value="<%=ssn.string("cancel")%>" class="button" onclick="frmCancel()" style="display: none">
  </p>
  </form>
<ej:textfield />
<% } %>
