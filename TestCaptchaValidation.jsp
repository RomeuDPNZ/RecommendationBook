<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>

<%@ page import="java.net.URL" %>
<%@ page import="java.net.URLConnection" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>

<%@ include file="Validation.jsp" %>
<%@ page import="recBook.ApacheCommons" %>
<%@ page import="org.apache.commons.fileupload.FileUploadException" %>
<%@ page import="recBook.FormValidation" %>

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

	FormValidation fv = new FormValidation(request);
	Boolean containError = false;

	String recaptcha_response_field = ac.getField("g-recaptcha-response");

	URLConnection connection = new URL("https://www.google.com/recaptcha/api/siteverify?response="+recaptcha_response_field+"&secret=6LdQqvwSAAAAABKN8ktbyXwzsOsXzFHHCucctMcY").openConnection();
	connection.setDoOutput(true);

	BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()));

	String inputLine = "";
	String result = "";

	while((inputLine = in.readLine()) != null) 
		result = result + inputLine;

	in.close();

	out.print(result);

	if(containError) {
		// response.sendRedirect("TestCaptcha.jsp");
	} else {

	}

%>