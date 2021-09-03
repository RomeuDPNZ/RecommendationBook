
<jsp:include page="GetDevice.jsp" flush="true" />

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="SiteMap Recommendation Book" />
<meta name="description" content="SiteMap for Recommendation Book" />
 
<style type="text/css">

div.SiteMapLeft {
	float: left;
	width: 50%;
}

div.SiteMapRight {
	float: right;
	width: 50%;
}

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

<% } else { %>
a.SiteMapLink {
	font-size: 25px;
}
<% } %>

</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookMobileCSS.css" />

<% } %>

<link href='http://fonts.googleapis.com/css?family=Roboto:500' rel='stylesheet' type='text/css'>

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

	<fieldset><legend>Site Map for Recommendation Book</legend>

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

<% } else { %>
	<div class="SiteMapLeft">
<% } %>

<a href="index.jsp" target="_blank" class="SiteMapLink">index.jsp</a>
<br /><br />Shows the 10 Most Recommended Entities for Each Type of Entity<br /><br /><br /><br /><br />

<a href="AddRecommender.jsp" target="_blank" class="SiteMapLink">AddRecommender.jsp</a>
<br /><br />Registration Page for Getting your Recommendation Book Totally Free<br /><br /><br /><br /><br />

<a href="Login.jsp" target="_blank" class="SiteMapLink">Login.jsp</a>
<br /><br />Authentication Page for your Recommendation Book Account<br /><br /><br /><br /><br />

<a href="Contact.jsp" target="_blank" class="SiteMapLink">Contact.jsp</a>
<br /><br />Page for Contacting Recommendation Book Administrators<br /><br /><br /><br /><br />

<a href="#" class="SiteMapLink">Recommender.jsp?id=[Insert Id]</a><br /><br />
<a href="Recommender.jsp?id=3" target="_blank" class="SiteMapLink">Example: Recommender.jsp?id=3</a>
<br /><br />Shows the Recommendation Book From a Recommender Given the Id<br /><br /><br /><br /><br />

<a href="MoreStats.jsp" target="_blank" class="SiteMapLink">MoreStats.jsp</a>
<br /><br />Shows More Stats for Recommendation Book<br /><br /><br /><br /><br />

<a href="#" class="SiteMapLink">MostRecommendedByCountry.jsp?country=[Insert Id]</a><br /><br />
<a href="MostRecommendedByCountry.jsp?country=187" target="_blank" class="SiteMapLink">Example: MostRecommendedByCountry.jsp?country=187</a>
<br /><br />Shows the 1000 Most Recommended Entities by Country Given the Country Id<br /><br /><br /><br /><br />

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

<% } else { %>
	</div>

	<div class="SiteMapRight">
<% } %>

<a href="About.jsp" target="_blank" class="SiteMapLink">About.jsp</a>
<br /><br />Explains What is the Recommendation Book Website for New Recommenders<br /><br /><br /><br /><br />

<a href="AddRecommended.jsp" target="_blank" class="SiteMapLink">AddRecommended.jsp</a>
<br /><br />Page for Recommending Entities Like Books, Movies, etc...<br /><br /><br /><br /><br />

<a href="ResetPassword.jsp" target="_blank" class="SiteMapLink">ResetPassword.jsp</a>
<br /><br />Page to Reset Password for Recommenders Who Forgot Their Password<br /><br /><br /><br /><br />

<a href="DoSearch.jsp" target="_blank" class="SiteMapLink">DoSearch.jsp</a>
<br /><br />Page for Searching Recommended Entities on Recommendation Book<br /><br /><br /><br /><br />

<a href="#" class="SiteMapLink">Recommended.jsp?id=[Insert Id]</a><br /><br />
<a href="Recommended.jsp?id=1" target="_blank" class="SiteMapLink">Example: Recommended.jsp?id=1</a>
<br /><br />Shows the Page for a Recommended Entity Given the Id<br /><br /><br /><br /><br />

<a href="#" class="SiteMapLink">MostRecommended.jsp?type=[Insert Type]</a><br /><br />
<a href="MostRecommended.jsp?type=Movie" target="_blank" class="SiteMapLink">Example: MostRecommended.jsp?type=Movie</a>
<br /><br />Shows the 1000 Most Recommended Entities for Each Type of Entity<br />
To See All the Entities that Can Be Recommended See index.jsp, About.jsp or MoreStats.jsp<br /><br /><br /><br /><br />

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

<% } else { %>
	</div>
<% } %>

	</fieldset>

	</div>

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
	<jsp:include page="RodapeMobile.jsp" flush="true" />
<% } else { %>
	<jsp:include page="Rodape.jsp" flush="true" />
<% } %>

</div>

</body>
 
</html>
