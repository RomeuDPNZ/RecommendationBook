
package recBook;

import java.io.File;
import javax.servlet.http.HttpServletRequest;

public class DeleteImage {

	private HttpServletRequest servletRequest;
	public String pastaAtual = "";
	public String imagem = "";

	public DeleteImage(HttpServletRequest request, String relativePath, String imageName) {
		servletRequest = request;
		String pastaAtual = "";
		
		if(DetectOS.getOS().equals("win")) {
			pastaAtual = servletRequest.getSession().getServletContext().getRealPath("/").replace("\\","\\\\");
			imagem = ""+pastaAtual+""+relativePath+""+imageName+"";
		} else {
			pastaAtual = servletRequest.getSession().getServletContext().getRealPath("/");
			String unixpath = relativePath.replace("\\","/");
			imagem = ""+pastaAtual+""+unixpath+""+imageName+"";
		}

		File img = new File(imagem);

		if(img.exists() == true) {
			img.delete();
		}
	}

}