<%@ include file="Validation.jsp" %>
<%@ page import="recBook.ApacheCommons" %>
<%@ page import="org.apache.commons.fileupload.FileUploadException" %>
<%@ page import="recBook.FormValidation" %>

<%@ page import="java.util.*" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="javax.imageio.stream.*" %>
<%@ page import="javax.imageio.ImageWriter" %>
<%@ page import="javax.imageio.ImageWriteParam" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="java.io.ByteArrayInputStream" %>
<%@ page import="javax.imageio.ImageIO" %>
<%@ page import="javax.imageio.IIOImage" %>
<%@ page import="java.awt.Color" %>

<%@ page import="java.awt.Graphics2D" %>
<%@ page import="java.awt.RenderingHints" %>

<%@ page import="java.io.IOException" %>
<%@ page import="java.io.FileNotFoundException" %>
<%@ page import="recBook.RecordImage" %>

<%

	ApacheCommons ac = null;

	try {

		ac = new ApacheCommons(request);

	} catch(FileUploadException e) {
		System.err.println("FileUploadException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new FileUploadException(e.getMessage()+" Page: "+pageName);
		}
	} finally {}

	String pastaAtual = request.getSession().getServletContext().getRealPath("/").replace("\\","\\\\");

	String srcPath = pastaAtual+"\\img\\test\\test.jpg";  
	String destPath = pastaAtual+"\\img\\test\\test.jpg";  

	/*
	 *
	 * Convert to JPG
	 *
	 */

	Boolean converted = false;

	if(ac.getFileExtension("image") != "jpg" || ac.getFileExtension("image") != "jpeg") {
		InputStream in = new ByteArrayInputStream(ac.getFile("image"));
		BufferedImage input = ImageIO.read(in);

		BufferedImage newBufferedImage = new BufferedImage(input.getWidth(), input.getHeight(), input.TYPE_INT_RGB);
		newBufferedImage.createGraphics().drawImage(input, 0, 0, Color.WHITE, null);

		File output = new File(destPath);
		ImageIO.write(newBufferedImage, "jpg", output);
		in.close();

		converted = true;
	}

	/*
	 *
	 * Scale to Smaller Dimension
	 *
	 */

	Boolean scaled = false;

	if(new File(srcPath).getTotalSpace() > 51200l) {

	BufferedImage imageToScale = ImageIO.read(new File(srcPath));
	int type = imageToScale.getType() == 0 ? BufferedImage.TYPE_INT_ARGB : imageToScale.getType();
	int width = imageToScale.getWidth();
	int height = imageToScale.getHeight();

	int toWidth = 500;
	int toHeight = (toWidth * height) / width;

	if(width > toWidth) {
		if(imageToScale != null) {
			BufferedImage resizedImage = new BufferedImage(toWidth, toHeight, type);
			Graphics2D g = resizedImage.createGraphics();
			g.drawImage(imageToScale, 0, 0, toWidth, toHeight, null);

			g.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BILINEAR);
			g.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
			g.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);

			g.dispose();
			File output = new File(destPath);
			ImageIO.write(resizedImage, "jpg", output);

			scaled = true;
		}
	}

	}

	/*
	 *
	 * Compress to Smaller Size
	 *
	 */

	Integer compacted = 0;

	float quality = 0.95f;
	Long sizeBefore = 0l;
	Long sizeAfter = 0l;
	Boolean minimumReached = false;

	while((new File(srcPath).getTotalSpace() > 51200l) && (minimumReached == false)) {

		sizeBefore = new File(srcPath).getTotalSpace();

		Iterator iter = ImageIO.getImageWritersByFormatName("jpg");  
		ImageWriter writer = (ImageWriter)iter.next();  
		ImageWriteParam iwp = writer.getDefaultWriteParam();  
		iwp.setCompressionMode(ImageWriteParam.MODE_EXPLICIT);  
		iwp.setCompressionQuality(quality);  
		File file = new File(destPath);  
		FileImageOutputStream fios = new FileImageOutputStream(file);  
		writer.setOutput(fios);  
		FileInputStream inputStream = new FileInputStream(srcPath);  
		BufferedImage originalImage = ImageIO.read(inputStream);  
		IIOImage image = new IIOImage(originalImage, null, null);  
		writer.write(null, image, iwp);  
		writer.dispose();
		fios.close();
		inputStream.close();

		sizeAfter = new File(srcPath).getTotalSpace();

		if(sizeBefore.equals(sizeAfter)) { minimumReached = true; }

		++compacted;

	}

	System.gc();

	out.print("<img src=\"./img/test/test.jpg\" alt=\"test.jpg\" />");

	out.print("<br /><br />Converted = "+converted+" | Scaled = "+scaled+" | Compacted "+compacted+" Time(s)");

%>