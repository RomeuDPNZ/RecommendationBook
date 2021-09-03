
<%
	Cookie[] cookies = request.getCookies();

	Boolean isRecommenderLogged = false;

	if(cookies != null) {

	for(Cookie cookie:cookies) {
 		if(cookie.getName().equals("IsRecommenderLogged")) {
			if(cookie.getValue().equals("Yes")) {
				isRecommenderLogged = true;
			}
		}
	}

	}

%>

<div class="Rodape"><% if(isRecommenderLogged.equals(false)) { %><a href="Login.jsp">Login</a><br /><br /><a href="AddRecommender.jsp">Register Totally Free</a><br /><br /><a href="Login.jsp">Register with Facebook\Google Account</a><br /><br /><% } %><a href="index.jsp">10 Most Recommended</a><br /><br /><a href="AddRecommended.jsp">Recommend Something</a><br /><br /><a href="About.jsp">What's the Recommendation Book?</a><br /><br /><a href="Contact.jsp">Contact</a><br /><br /><a href="DoSearch.jsp">Search</a><br /><br /><a href="SiteMap.jsp">Site Map</a><br /><br />Recommendation Book<br /><br />2014-<jsp:include page="GetYear.jsp" flush="true" /><br /><br />Recommend your World</div>