
package recBook;

import java.util.Iterator;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

import org.apache.commons.fileupload.*;
import org.apache.commons.fileupload.disk.*;
import org.apache.commons.fileupload.servlet.*;
import org.apache.commons.io.output.*;

/* javac -cp .;%CATALINA_HOME%\webapps\ImageUpload-ApacheCommons\WEB-INF\lib\commons-fileupload-1.3.jar;%CATALINA_HOME%\webapps\ImageUpload-ApacheCommons\WEB-INF\lib\commons-io-2.4.jar;%CATALINA_HOME%\lib\servlet-api.jar ApacheCommons.java */

public class ApacheCommons {

	Map<String, String> hm = new HashMap<String, String>();
	Map<String, byte[]> files = new HashMap<String, byte[]>();
	Map<String, String> filesName = new HashMap<String, String>();
	Map<String, String> filesExtension = new HashMap<String, String>();
	Map<String, Long> filesSize = new HashMap<String, Long>();

	public ApacheCommons(HttpServletRequest request) throws FileUploadException {
		FileItemFactory factory = new DiskFileItemFactory();
		ServletFileUpload upload = new ServletFileUpload(factory);
		List items = upload.parseRequest(request);

		Iterator iter = items.iterator();
		while(iter.hasNext()) {
			FileItem item = (FileItem) iter.next();

			if(item.isFormField()) {
	
				String name = item.getFieldName();
				String value = item.getString();
	
				if(hm.containsKey(name)) {
					hm.put(name, hm.get(name)+"---"+value);
				} else {
					hm.put(name, value);
				}
			}

			if(!item.isFormField()) {
				String fieldName = item.getFieldName();
				String fileName = item.getName();
				String contentType = item.getContentType();
				boolean isInMemory = item.isInMemory();
				long sizeInBytes = item.getSize();

				byte[] file = item.get();

				String fileExtension = "";
				int index = fileName.lastIndexOf(".");
				if(index > 0){
					fileExtension = fileName.substring(index+1);
					fileExtension = fileExtension.toLowerCase();
				}

				files.put(fieldName, file);
				filesName.put(fieldName, fileName);
				filesExtension.put(fieldName, fileExtension);
				filesSize.put(fieldName, sizeInBytes);
			}
		}
	}

	public String getField(String fieldName) {
		String field = "";
		if(hm.containsKey(fieldName)) {
			if(hm.get(fieldName) != null) {
				field = hm.get(fieldName);
			}
		}
		return field;
	}

	public byte[] getFile(String fieldName) {
		byte[] file = {};
		if(files.containsKey(fieldName)) {
			if(files.get(fieldName) != null) {
				file = files.get(fieldName);
			}
		}
		return file;
	}

	public String getFileName(String fieldName) {
		String name = "";
		if(filesName.containsKey(fieldName)) {
			if(filesName.get(fieldName) != null) {
				name = filesName.get(fieldName);
			}
		}
		return name;
	}

	public String getFileExtension(String fieldName) {
		String extension = "";
		if(filesExtension.containsKey(fieldName)) {
			if(filesExtension.get(fieldName) != null) {
				extension = filesExtension.get(fieldName);
			}
		}
		return extension;
	}

	public Long getFileSize(String fieldName) {
		long size = 0l;
		if(filesSize.containsKey(fieldName)) {
			if(filesSize.get(fieldName) != null) {
				size = filesSize.get(fieldName);
			}
		}
		return size;
	}

}
