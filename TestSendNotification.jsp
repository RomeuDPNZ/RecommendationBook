
<%@ include file="SendNotification.jsp" %>

<%

	SendNotification sn = new SendNotification(1l, 1l, 37);

	try {
		sn.Send();
	} catch(Exception e) {
		System.err.println("EmailException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new Exception(e.getMessage()+" Page: "+pageName);
		}
	}

%>
