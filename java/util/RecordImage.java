package recBook;

import java.io.File;
import java.io.RandomAccessFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.io.FileNotFoundException;

public class RecordImage {

	private HttpServletRequest servletRequest;
	public String imagem = "";

	public RecordImage(HttpServletRequest request, byte[] image, String relativePath, String imageName) throws IOException, FileNotFoundException {
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

		if(new File(imagem).exists() == false) {
			RandomAccessFile raf = new RandomAccessFile(imagem, "rw");
			raf.write(image, 0, image.length);
			raf.close();
		}
	}

	public RecordImage(HttpServletRequest request, String relativePath, String imageName){
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
	}
	
	public String RecordImageByte(byte[] image) throws IOException, FileNotFoundException {
		if(new File(imagem).exists() == false) {
			RandomAccessFile raf = new RandomAccessFile(imagem, "rw");
			raf.write(image, 0, image.length);
			raf.close();
		}
		
		return imagem;
	}
	
	public String RecordImagePart(Part image) throws IOException, FileNotFoundException {
		if(new File(imagem).exists() == false) {
			image.write(imagem);
		}
		
		return imagem;
	}

}