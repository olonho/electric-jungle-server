<jsp:useBean id="ssn" scope="session" class="ejungle.web.Session" />
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.jar.*" %>
<%@ page import="javax.servlet.http.HttpServletRequest" %>
<%@ page import="java.sql.*" %>
<%@ page import="ejungle.web.*" %>
<%!
  static String getMainClassFromManifest(File f) {
    String result = null;
    try {
      JarFile jar = new JarFile(f);
      Manifest mf = jar.getManifest();
      if (mf != null) {
        result = mf.getMainAttributes().getValue(Attributes.Name.MAIN_CLASS);
      }
      jar.close();
    } catch (Exception e) {}
    return result;
  }

  ErrorCode performDelete(HttpServletRequest request, Session ssn, ServletContext application)
    throws SQLException
  {
    String delete = request.getParameter("id");
    ResultSet rs = DB.query("SELECT jarfile FROM beings WHERE id = ? AND owner = ?",
                            delete, ssn.id);
    if (rs.next()) {
      File f = new File(ssn.getBeingJar(rs.getString(1)));
      f.delete();
    }
    DB.close(rs);
    DB.update("DELETE FROM beings WHERE id = ? AND owner = ?",
              delete, ssn.id);
    return null;
  }
  
  ErrorCode performEdit(HttpServletRequest request, Session ssn, ServletContext application)
    throws SQLException
  {
    MultipartForm frm = null;
    try {
      frm = new MultipartForm(request);
    } catch (Exception e) {
      return ErrorCode.LIMIT_EXCEEDED;
    }
    String id = frm.param("id");
    String mainClass = frm.param("mainclass");
    String permissions = frm.param("permissions");

    if (frm != null && frm.fileCount() > 0) {
      String jarFile = new File(frm.param("jarfile")).getName();
      String targetFile = ssn.getBeingJar(jarFile);
      File f = frm.saveFile("jarfile", targetFile);
      if (f == null) {
        return ErrorCode.STORAGE_ERROR;
      }
      if (mainClass == null) {
        mainClass = getMainClassFromManifest(f);
      }
      if (mainClass == null) {
        f.delete();
        return ErrorCode.INVALID_JAR;
      }
      long jarSize = f.length();

      if (id == null) {
        // Add new being
        DB.update("DELETE FROM beings WHERE jarfile = ? AND owner = ?",
                  jarFile, ssn.id);
        DB.update("INSERT INTO beings (owner, jarfile, jarsize, mainclass, permissions) " +
                  "  VALUES (?, ?, ?, ?, ?)",
                  ssn.id, jarFile, jarSize, mainClass, permissions);
      } else {
        // Modify existing being with new JAR file
        ResultSet rs = DB.query("SELECT jarfile FROM beings WHERE id = ? AND owner = ?",
                                id, ssn.id);
        String oldJarFile = rs.next() ? rs.getString(1) : null;
        if (oldJarFile != null && !jarFile.equals(oldJarFile)) {
          File oldf = new File(ssn.getBeingJar(oldJarFile));
          oldf.delete();
        }
        DB.close(rs);
        DB.update("UPDATE beings SET jarfile = ?, jarsize = ?, mainclass = ?, permissions = ? " +
                  "  WHERE id = ? AND owner = ?",
                  jarFile, jarSize, mainClass, permissions, id, ssn.id);
      }
    } else if (id != null) {
      // Modify existing being without changing JAR file
      DB.update("UPDATE beings SET mainclass = ?, permissions = ? WHERE id = ? AND owner = ?",
                mainClass, permissions, id, ssn.id);
    } else {
      return ErrorCode.INVALID_PARAMETER;
    }
    return null;
  }
%>
<%
  ssn.ensureLoggedOn();
  ErrorCode error = null;
  String action = request.getParameter("action");
  if ("edit".equals(action)) {
    error = performEdit(request, ssn, application);
  } else if ("delete".equals(action)) {
    error = performDelete(request, ssn, application);
  }
  String redirectPage = "index.jsp?page=beings";
  if (error != null) {
    redirectPage += "&error=" + error;
  }
  response.sendRedirect(redirectPage);
%>
