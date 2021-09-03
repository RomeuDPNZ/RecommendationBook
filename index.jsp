
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("index");

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

%>

<jsp:include page="GetDevice.jsp" flush="true" />

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>

<meta name="keywords" content="Recommendation Book Social Network" />
<meta name="description" content="A Statistical Social Network that Revolves Around the Recommendation Functionality Allowing you to Recommend Stuff." />

<link rel="icon" href="./img/static/RBIcon.ico" type="image/x-icon">

<link href='http://fonts.googleapis.com/css?family=Roboto:500' rel='stylesheet' type='text/css'>

<style type="text/css">

</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookMobileCSS.css" />

<% } %>

<script src="js/jquery-1.10.2.js"></script>
<script type="text/javascript"> 
<!--

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

<% } else { %>

/*

$(document).ready(function () {

	$("a.Recommended").on('mouseenter', function () {

		var id = $(this).attr("id");

		if($("div#"+id+"ForImage").is(":empty")) {

			$("div#"+id+"ForImage").load("getImage.jsp?img="+id+"");

		} else {

			$("div#"+id+"ForImage").show();
		}

	}).on('mouseleave', function () {

		var id = $(this).attr("id");

		$("div#"+id+"ForImage").hide();

	});

});

*/

<% } %>

//-->
</script>

<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-52208522-1', 'auto');
  ga('send', 'pageview');

</script>

</head>

<body>

<div class="Geral">

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

<jsp:include page="MiniMenuMobile.jsp" flush="true" />
<jsp:include page="AboutMini.jsp" flush="true" />
<jsp:include page="Search.jsp" flush="true" />
<jsp:include page="Stats.jsp" flush="true" />
<jsp:include page="FacebookGoogleInstructions.jsp" flush="true" />
<jsp:include page="CorpoWithImagesAndButtonsMobile.jsp" flush="true" />
<jsp:include page="RodapeMobile.jsp" flush="true" />

<% } else { %>

<jsp:include page="CabecalhoMenu.jsp" flush="true" />
<jsp:include page="Search.jsp" flush="true" />
<jsp:include page="AboutMini.jsp" flush="true" />
<jsp:include page="Stats.jsp" flush="true" />
<jsp:include page="FacebookGoogleInstructions.jsp" flush="true" />
<jsp:include page="CorpoWithImagesAndButtons.jsp" flush="true" />
<jsp:include page="Rodape.jsp" flush="true" />

<% } %>

</div>

</body>
 
</html>
