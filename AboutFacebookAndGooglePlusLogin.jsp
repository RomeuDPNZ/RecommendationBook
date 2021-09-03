
<jsp:include page="GetDevice.jsp" flush="true" />

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="Recommendation Book Facebook and Google Plus Login" />
<meta name="description" content="Recommendation Book Page Explaining the Facebook and Google Plus Login and Registration Buttons" />

<link rel="icon" href="./img/static/RBIcon.ico" type="image/x-icon">

<link href='http://fonts.googleapis.com/css?family=Roboto:500' rel='stylesheet' type='text/css'>

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
<div style="margin: 2.5em; margin-left: 5em; margin-right: 5em;"><span class="Nickname">Facebook and Google Plus Login and Registration:<br /><br />You can login with Facebook and/or Google Plus if you are already registered on Recommendation Book with the same email that you use to login on Facebook and/or Google Plus.<br /><br />If you are clicking those buttons for the first time, Facebook and Google Plus will give us your name, email, gender, birthday and locale (Facebook Only) so we can create your Recommendation Book with one click.<br /><br />First we get your name and take out all the white spaces and non a-z A-Z 0-9 characters, so something like this: Romeu -#- Prado will render a string like this: RomeuPrado. Then we see if there is already a Recommender with the same name on the database. If there is already a Recommender with the same name we get the ID from your future Recommendation Book and concatenate with your name which will render something like this: RomeuPrado1234. If your nickname is still not valid to our system we will give you a nickname like this: Recommender1234<br /><br />If you wanna choose your nickname register through the <a href="AddRecommender.jsp" target="_blank">Conventional Recommendation Book Registration Page</a>.<br /><br />Then we do the best that we can to set your gender, birthday and locale correctly but you can change these data anytime by clicking the link Update on your Recommendation Book Profile.<br /><br />If everything go fine we send you a Welcome email with a password for the Conventional Recommendation Book Login.<br /><br />Be advised that when logging with the Facebook and Google Plus buttons we log you into the Recommendation Book and the Facebook\Google Plus account at the same time. When logging out from Recommendation Book we don't log you out from your respective Facebook\Google Plus Profile.<br /><br />Don't worry, Recommendation Book won't change anything on your Facebook/Google Plus profile and we have absolutely no access to your password.</span></div>
	</div>
<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
	<jsp:include page="RodapeMobile.jsp" flush="true" />
<% } else { %>
	<jsp:include page="Rodape.jsp" flush="true" />
<% } %>
</div>

</body>
 
</html>


