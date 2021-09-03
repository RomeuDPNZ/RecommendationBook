
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("LogOut");

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

%>

<%

	Cookie[] cookies = request.getCookies();

	if(cookies != null) {

	String url = request.getRequestURL().toString();

	for(Cookie cookie:cookies) {
 		if(cookie.getName().equals("IsRecommenderLogged")) {
			cookie.setMaxAge(0);
			cookie.setValue("");
			if(url.contains("recommendationbook.com")) {
				cookie.setDomain("recommendationbook.com");
			}
			response.addCookie(cookie);
		}
	}

	for(Cookie cookie:cookies) {
 		if(cookie.getName().equals("RecommenderId")) {
			cookie.setMaxAge(0);
			cookie.setValue("");
			if(url.contains("recommendationbook.com")) {
				cookie.setDomain("recommendationbook.com");
			}
			response.addCookie(cookie);
		}
	}

	}

	response.sendRedirect("index.jsp");
%>