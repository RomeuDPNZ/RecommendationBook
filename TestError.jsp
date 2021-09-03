
<%@ page errorPage="Error.jsp" %>

<%

	try {

		throw new Exception("Test");

	} catch(Exception e) {

		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new Exception(e.getMessage()+" Page: "+pageName);
		}

	} finally {}

%>
