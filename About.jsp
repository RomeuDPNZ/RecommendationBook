
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {
		new PageViewsDAOOutro().incrementPageViews("About");

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

%>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>About</title>
 
<meta name="keywords" content="About Recommendation Book" />
<meta name="description" content="About Recommendation Book" />

<link rel="icon" href="./img/static/RBIcon.ico" type="image/x-icon">

<link href='http://fonts.googleapis.com/css?family=Roboto:500' rel='stylesheet' type='text/css'>

<style type="text/css">
<!--
   @import url("RecommendationBookCSS.css");

div.Logo {
	color: goldenrod;
	font-size: 60px;
	font-weight: bold;
	text-align: center;
	width: 100%;
	margin: 0em;
	padding: 0em;
}

span.Com {
	color: steelblue;
	font-size: 40px;
	font-weight: bold;
}

span.AboutOutro {
	color: gray;
	font-size: 25px;
	font-weight: bold;
}

-->
</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />

<jsp:include page="GetDevice.jsp" flush="true" />

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

	<div style="padding: 1em;">
		<div class="Logo">What's the RecommendationBook<span class="Com">.com</span>?<br /><span class="AboutOutro">A Statistical Social Network to Recommend Stuff.</span></div>
		<p class="Introduction"><jsp:include page="FacebookGoogleInstructions.jsp" flush="true" /><br/><fieldset><span class="Nickname"><a href="AddRecommendedNonLogged.jsp" target="_blank">You Can Recommend Now Without Login.</a></span></fieldset><br /><fieldset><span class="Nickname"><a href="AddRecommender.jsp" target="_blank">You Can Register Through The Conventional Registration Page To Get Your Recommendation Book so you can Personalize your Nickname.</a></span></fieldset><br/><br />The Recommendation Book is a Statistical Social Network that Revolves Around the Recommendation Functionality Allowing you to Recommend What you Read, Listen, Watch, Buy and Make a Recommendation Book with Things that you Recommend to People Interested in your Tastes. All the Information Who Other Social Networks Keep Closed, the Recommendation Book keeps Open. You Recommend and We Provide the Statistics for Everyone.<br /><br/>First Create your Recommedation Book by Registering Yourself <a href="AddRecommender.jsp" target="_blank">Here</a>. After that you Gonna get a Recommendation Book like <a href="Recommender.jsp?id=3" target="_blank">this</a> and you can Recommend: Persons, Groups, Books, Movies, Bands, Albums, Songs, Projects, Websites, Companies, Products, Places, Foods, Games, Guns, Knives, Cars and Motorcycles.<br /><br />If you are Interested in the Tastes of one Particular Recommender you can Subscribe to his Recommendation Book and you Gonna Receive his Recommendations on your Recommendation Book Which you can see Without Having to Login.<br /><br />The Recommendation Book Allows Redundancy of Information. For instance, If you don't like the way that one Recommender Added the Information for Let's say a Movie, you Can Add the Information for the Same Movie in Another Page with the Information that you Believe to be Truly Representative of the Movie.<br/ ><br />A person Enter in the Lets Say the Page for the Movie that you Recommended and if he Likes it he Can Recommend the Movie, Adding Another Recommender.<br/><br />All the Information Collected will be Used to Generate Statistics Like:<br /><br />Most Recommended Books<br />Most Recommended Movies<br />etc...<br/><br />It's Easy, Fast, Totally Free, Secure and Discreet.<br /><br />We Promise we are NOT Going to Fill your Inbox with Spam and we are NOT Going to Sell your Information.
		</p>
	</div>

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
	<jsp:include page="RodapeMobile.jsp" flush="true" />
<% } else { %>
	<jsp:include page="Rodape.jsp" flush="true" />
<% } %>

</div>

</body>
 
</html>
