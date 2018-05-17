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

    // Check for limit of public beings
    if ("3".equals(permissions)) {
      ResultSet rs = DB.query("SELECT COUNT(*) FROM beings " +
                              "  WHERE owner = ? AND permissions = 3 AND id <> ?",
                              ssn.id, id == null ? "" : id);
      if (rs.next() && rs.getInt(1) >= 2) {
        DB.close(rs);
        return ErrorCode.TOO_MANY_BEINGS;
      }
      DB.close(rs);
    }

    if (frm != null && frm.fileCount() > 0) {
      String fName = frm.param("jarfile").replace('\\', '/');      
      int lastSlash = fName.lastIndexOf('/');
      if (lastSlash > -1) {
          fName = lastSlash + 1 < fName.length() ? 
              fName.substring(lastSlash+1) :  
              "CorruptedName";
      }
      if (fName.length() > 0 && fName.charAt(0) == '.') {
         fName = "CorruptedName";
      }
      // Modify existing being with new JAR file
      if (id != null) {      
           ResultSet rs = DB.query("SELECT id FROM beings "+
                                  "WHERE jarfile = ? AND owner = ? AND id <> ?",
                                  fName, ssn.id, id);
           boolean duplicated = rs.next();
           DB.close(rs);
           if (duplicated) { 
               return ErrorCode.DUPLICATED_BEING;
           }
      }
      String jarFile = new File(fName).getName();
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
        int lastGroup = ejungle.manager.RatingComputeJob.getLastGroup();
        // Add new being
        DB.update("DELETE FROM beings WHERE jarfile = ? AND owner = ?",
                  jarFile, ssn.id);
        DB.update("INSERT INTO beings (owner, jarfile, jarsize, mainclass, permissions, `group`) " +
                  "  VALUES (?, ?, ?, ?, ?, ?)",
                  ssn.id, jarFile, jarSize, mainClass, permissions, lastGroup);
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
  if (ejungle.manager.Manager.isFinal()) {
    response.sendRedirect("/main.jsp?page=beings&error=" + ErrorCode.CURRENTLY_UNAVAILABLE);
  } else {
   ssn.ensureLoggedOn();
   request.setCharacterEncoding(ssn.string("charset"));

   ErrorCode error = null;
   String action = request.getParameter("action");
   if ("edit".equals(action)) {
     error = performEdit(request, ssn, application);
   } else if ("delete".equals(action)) {
     error = performDelete(request, ssn, application);
   }
   String redirectPage = "/main.jsp?page=beings";
   if (error != null) {
     redirectPage += "&error=" + error;
   }
   response.sendRedirect(redirectPage);
  }
%>
