package ejungle.web;

import java.io.*;
import java.util.*;
import javax.servlet.http.*;
import org.apache.commons.fileupload.*;
import org.apache.commons.fileupload.disk.*;
import org.apache.commons.fileupload.servlet.*;

public class MultipartForm {
    protected HashMap<String,String> params;
    protected HashMap<String,FileItem> files;

    public MultipartForm(HttpServletRequest request) throws FileUploadException {
        params = new HashMap<String,String>();
        files = new HashMap<String,FileItem>();
        for (Enumeration<String> e = request.getParameterNames(); e.hasMoreElements(); ) {
            String key = e.nextElement();
            String value = request.getParameter(key);
            if (!value.equals("")) {
                params.put(key, value);
            }
        }
        if (ServletFileUpload.isMultipartContent(request)) {
            ServletFileUpload upload =
                new ServletFileUpload(new DiskFileItemFactory());
            upload.setSizeMax(2 * 1024 * 1024);
            List<FileItem> items = upload.parseRequest(request);
            for (FileItem item : items) {
                String key = item.getFieldName();
                String value;
                if (item.isFormField()) {
                    if (!(value = item.getString()).equals("")) {
                        params.put(key, value);
                    }
                } else {
                    if (!(value = item.getName()).equals("")) {
                        params.put(key, value);
                        files.put(key, item);
                    }
                }
            }
        }
    }

    public File saveFile(String field, String filename) {
        FileItem item = files.get(field);
        return item == null ? null : saveFile(item, filename);
    }

    public File saveFile(FileItem item, String filename) {
        File f = new File(filename);
        try {
            item.write(f);
        } catch (Exception e) {
            return null;
        }
        return f;
    }

    public int fileCount() {
        return files.size();
    }

    public String param(String key) {
        return params.get(key);
    }

    public String paramString(String key) {
        String result = params.get(key);
        return result == null ? "" : result;
    }

}
