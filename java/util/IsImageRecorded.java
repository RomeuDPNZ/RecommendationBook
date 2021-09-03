package recBook;

import java.io.File;
import java.lang.NullPointerException;
import java.lang.SecurityException;
import javax.servlet.http.HttpServletRequest;

/* javac -cp .;%CATALINA_HOME%\lib\servlet-api.jar RecordImage.java */

public class IsImageRecorded {

	private HttpServletRequest servletRequest;
	public String pastaAtual = "";
	public String imagem = "";
	
	public Boolean Exists(HttpServletRequest request, String relativePath, String imageName) throws NullPointerException, SecurityException {
		servletRequest = request;

		if(DetectOS.getOS().equals("win")) {
			pastaAtual = servletRequest.getSession().getServletContext().getRealPath("/").replace("\\","\\\\");
			imagem = ""+pastaAtual+""+relativePath+""+imageName+"";
		} else {
			pastaAtual = servletRequest.getSession().getServletContext().getRealPath("/");
			String unixpath = relativePath.replace("\\","/");
			imagem = ""+pastaAtual+""+unixpath+""+imageName+"";
		}
		
		return new File(imagem).exists();
	}

}