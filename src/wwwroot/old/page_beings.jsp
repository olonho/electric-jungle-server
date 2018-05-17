<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page contentType="text/html; charset=windows-1251" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<% ssn.ensureLoggedOn(); %>

<h2><%=ssn.string("beings")%></h2>
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
<table width=600 border=0 cellspacing=1 cellpadding=3 class="bordered">
  <tr>
    <th nowrap align="left"   bgcolor="#808080"><%=ssn.string("jar_file")%></th>
    <th nowrap align="center" bgcolor="#808080"><%=ssn.string("size")%></th>
    <th nowrap align="left"   bgcolor="#808080"><%=ssn.string("main_class")%></th>
    <th nowrap align="center" bgcolor="#808080"><%=ssn.string("access")%></th>
    <th nowrap align="center" bgcolor="#808080"><%=ssn.string("control")%></th>
  </tr>
<%
  ResultSet rs = DB.query("SELECT id, jarfile, jarsize, mainclass, permissions FROM beings " +
                          "  WHERE owner = ?", ssn.id);
  String[] ps = new String[] {
    "",
    "<font color=\"#800000\">"+ssn.string("private")+"</font>",
    "<font color=\"#808000\">"+ssn.string("friends_only")+"</font>",
    "<font color=\"#008000\">"+ssn.string("public")+"</font>"
  };
  while (rs.next()) {
    int id = rs.getInt(1);
    int permissions = rs.getInt(5);
    String mainClass = Util.encodeHTML(rs.getString(4));
%>
  <tr>
    <td align="left"   bgcolor="#dddddd"><%=Util.encodeHTML(rs.getString(2))%></td>
    <td align="right"  bgcolor="#dddddd"><%=(rs.getInt(3) / 1024) + "&nbsp;"+ssn.string("kb")%></td>
    <td align="left"   bgcolor="#dddddd"><%=mainClass%></td>
    <td align="center" bgcolor="#dddddd"><%=(permissions >= 0 && permissions < ps.length) ? ps[permissions] : "" %></td>
    <td align="center" bgcolor="#dddddd">
      <a href="#formstart" onclick='return frmEdit(<%=id%>, "<%=mainClass%>", <%=permissions%>)'><%=ssn.string("change")%></a>&nbsp;
      <a href="do_beings.jsp?action=delete&id=<%=id%>" onclick="return frmDelete()"><%=ssn.string("delete")%></a>
    </td>
  </tr>
<%
  }
  if (!rs.isAfterLast()) out.write(Util.emptyRow(ssn.lang, 5));
  DB.close(rs);
%>
</table>
<p>&nbsp;</p>

<a name="formstart"></a>
<h2 id="title"><%=ssn.string("add_being")%></h2>
<form name="frm" action="do_beings.jsp?action=edit" method="post" enctype="multipart/form-data">
<input type="hidden" name="id" value="">
<p>
<b><%=ssn.string("jar_file")%></b><br>
<input name="jarfile" type="file" size="64">
</p>
<p>
<b><%=ssn.string("main_class")%></b> (<%=ssn.string("empty_if_given_in_manifest")%>)<br>
<input name="mainclass" type="text" size="64">
</p>
<p>
<b><%=ssn.string("access")%></b><br>
<table border=0 cellspacing=5 cellpadding=0>
  <tr><td bgcolor="#ffa0a0"><input type="radio" class="checkbox" name="permissions" value="1"></td>        <td><b><%=ssn.string("private")%></b> (<%=ssn.string("hidden_from_others")%>)<td></tr>
  <tr><td bgcolor="#ffffa0"><input type="radio" class="checkbox" name="permissions" value="2" checked></td><td><b><%=ssn.string("friends_only")%></b> (<%=ssn.string("visible_to_friends")%>)<td></tr>
  <tr><td bgcolor="#a0ffa0"><input type="radio" class="checkbox" name="permissions" value="3"></td>        <td><b><%=ssn.string("public")%></b> (<%=ssn.string("visible_to_all")%>)<td></tr>
</table>
</p>
<p>
<input name="btnSubmit" type="submit" value="<%=ssn.string("upload_file")%>" class="button">&nbsp;
<input name="btnCancel" type="button" value="<%=ssn.string("cancel")%>" class="button" onclick="frmCancel()" style="display: none">
</p>
</form>
