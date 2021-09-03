
<%@ include file="SendMail.jsp" %>

<%

	String from = "recommendationbook@gmail.com";
	String email = "lovehungryman@gmail.com";
	String subject = "User A Recommended B on Recommendation Book";

	String text = "<span style=\"font-family: verdana, sans-serif; font-size: 18px; color: gray;\"><a href=\"http://recommendationbook.com/\"><img style=\"border: none; outline: none;\" width=\"110\" height=\"60\" src=\"http://recommendationbook.com/img/static/LogoTransparencia.png\" alt=\"Recommendation Book\" /></a><br /><br /><a style=\"color: GoldenRod; text-decoration: none;\" href=\"http://recommendationbook.com/Recommender.jsp?id=2\">OnlyMetalIsReal</a> Recommended the Recommender <a style=\"color: GoldenRod; text-decoration: none;\" href=\"http://recommendationbook.com/Recommender.jsp?id=19\">MyronHappywaxHladyniuk</a> on <a style=\"color: GoldenRod; text-decoration: none;\" href=\"http://recommendationbook.com/\">Recommendation Book</a>";

	SendMail sm = new SendMail(email, from, subject, text);

	try {
		sm.Send();
	} catch(Exception e) {
		System.err.println("EmailException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new Exception(e.getMessage()+" Page: "+pageName);
		}
	}

%>
