
<%@ page errorPage="Error.jsp" %>

<jsp:include page="GetDevice.jsp" flush="true" />

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("MessageToRecommender");

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
	String id = request.getParameter("id");

	String message = "";

	if(id.equals("1")) {
		message = "Please, Verify Your e-mail For The Registration Code.";
	} else if(id.equals("2")) {
		message = "Your Password Has Been Reset. Check Your e-mail.";
	} else if(id.equals("3")) {
		message = "Your Need to Add at Least 2 Persons to Your Work With Table to Make a Group.";
	} else if(id.equals("4")) {
		message = "Log Out To See This Page.";
	} else if(id.equals("5")) {
		message = "Message Sent Successfully.";
	} else if(id.equals("6")) {
		message = "Please, Verify Your e-mail For The Verification Code.";
	} else {

	}

%>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="" />
<meta name="description" content="" />
 
<style type="text/css">
<!--
   @import url("RecommendationBookCSS.css");
-->
</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookMobileCSS.css" />

<% } %>

<script type="text/javascript"> 
<!--

//-->
</script>

</head>

<body>

<div class="Geral">

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
	<jsp:include page="MiniMenuMobile.jsp" flush="true" />
<% } else { %>
	<jsp:include page="MiniMenu.jsp" flush="true" />
<% } %>

	<div class="Corpo">
		<p class="MessageToRecommender"><%= message %></p>
	</div>

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
	<jsp:include page="RodapeMobile.jsp" flush="true" />
<% } else { %>
	<jsp:include page="Rodape.jsp" flush="true" />
<% } %>

</div>

</body>
 
</html>
