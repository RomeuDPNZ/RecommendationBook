
<%@ page isErrorPage="true" %>

<jsp:include page="GetDevice.jsp" flush="true" />

<%@ page import="java.io.StringWriter" %>
<%@ page import="java.io.PrintWriter" %>
<%@ include file="SaveError.jsp" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	new PageViewsDAOOutro().incrementPageViews("Error");

%>

<%

	String id = request.getParameter("id");

	String pageName = "";
	if(pageContext.getErrorData().getRequestURI() != null) {
		pageName = pageContext.getErrorData().getRequestURI();
	}

	String error = "";

	if(id != null) {		

		if(id.equals("1")) {
			error = "Email Not Found!";
		} else if(id.equals("2")) {
			error = "Id Not Found!";
		}  else if(id.equals("3")) {
			error = "Code Not Found!";
		}  else if(id.equals("4")) {
			error = "Invalid Id!";
		}  else if(id.equals("5")) {
			error = "Invalid Code!";
		}  else if(id.equals("6")) {
			error = "Invalid Parameter!";
		}  else if(id.equals("7")) {
			error = "Permission Denied!";
		} else if(id.equals("8")) {
			error = "Invalid Email!";
		}

	} else {

		String e = "";
		String c = "";
		String m = "";

		if(exception.toString() != null) { e = exception.toString(); }
		//if(exception.getCause().toString() != null) { c = exception.getCause().toString(); }
		//if(exception.getMessage().toString() != null) { m = exception.getMessage().toString(); }

		error = e + " Cause: " + c + " Message: " + m + " Page: " + pageName;

		StringWriter sw = new StringWriter();
		exception.printStackTrace(new PrintWriter(sw));
		String stackTraceAsString = sw.toString();

		new SaveError(error, stackTraceAsString);

	}

%>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="" />
<meta name="description" content="" />
 
<style type="text/css">

</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookMobileCSS.css" />

<% } %>

</head>

<body>

<div class="Geral">

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
	<jsp:include page="MiniMenuMobile.jsp" flush="true" />
<% } else { %>
	<jsp:include page="MiniMenu.jsp" flush="true" />
<% } %>

	<div class="Corpo">
		<p class="MessageToRecommender"><span class="red">Error - <%= error %></span></p>
	</div>

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
	<jsp:include page="RodapeMobile.jsp" flush="true" />
<% } else { %>
	<jsp:include page="Rodape.jsp" flush="true" />
<% } %>

</div>

</body>
 
</html>
