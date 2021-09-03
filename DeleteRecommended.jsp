
<%@ page import="net.tanesha.recaptcha.ReCaptcha" %>
<%@ page import="net.tanesha.recaptcha.ReCaptchaFactory" %>

<%
	Cookie[] cookies = request.getCookies();

	Boolean isRecommenderLogged = false;
	Long recommenderIdLogged = 0l;

	if(cookies != null) {

	for(Cookie cookie:cookies) {
 		if(cookie.getName().equals("IsRecommenderLogged")) {
			if(cookie.getValue().equals("Yes")) {
				isRecommenderLogged = true;
			}
		}
	}

	for(Cookie cookie:cookies) {
 		if(cookie.getName().equals("RecommenderId")) {
			if(isRecommenderLogged) {
				recommenderIdLogged = Long.valueOf((String) cookie.getValue());
			}
		}
	}

	}

%>

<% if(!isRecommenderLogged) { %>

	<jsp:forward page="/Login.jsp" />

<% } else { %>

<!DOCTYPE htm>

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

<script type="text/javascript"> 
<!--

//-->
</script>

</head>

<body>

<div class="Geral">
	<jsp:include page="CabecalhoMenu.jsp" flush="true" />
	<div class="Corpo">
		<form method="post" action="DeleteRecommendedValidation.jsp" enctype="multipart/form-data">
				<table class="listras">
				<thead>
				<tr>
				<td colspan="3">
					<span class="Bold">Are You Sure You Want To Delete The Following Recommended Page?</span>
				</td>
				</tr>
				</thead>
				<tbody>

				<tr>
					<td class="tdRight" style="width: 10%"><span class="Bold">Name</span></td>
					<td class="tdLeft">
						<% if(session.getAttribute("nameS") != null) { out.print(session.getAttribute("nameS")); } %>
					</td>
					<td></td>

				<tr>
					<td class="tdRight">Current Image</td>
					<td class="tdLeft"><img class="RecommenderImage" width="200" height="100" src="./img/user/<% if(session.getAttribute("imageNome") != null) { out.print(session.getAttribute("imageNome")); } %>" alt="Current Image" /></td>
					<td></td>
				</tr>

				<tr>
					<td class="tdRight"><span class="Bold">Enter Captcha</span></td>
					<td class="tdLeft">
<%

	ReCaptcha c = ReCaptchaFactory.newReCaptcha("6LdQqvwSAAAAAMNiEciF2_Sp1xndgsleTvtiz7jV", "6LdQqvwSAAAAABKN8ktbyXwzsOsXzFHHCucctMcY", false);
	out.print(c.createRecaptchaHtml(null, null));

%>
					</td>
				</tr>
<% if("true".equals(session.getAttribute("CaptchaIsWrong")))  { %>
				<tr>
					<td></td><td><span class="error">Incorrect Captcha! Enter Captcha Again!</span></td>
				</tr>
<% } %>

				<tr><td class="tdRight"></td><td class="tdLeft"><input type="submit" value="Delete" /> - <a href="Recommended.jsp?id=<% if(session.getAttribute("IdS") != null) { out.print(session.getAttribute("IdS")); } %>">Cancel</a></td><td></td></tr>

				</tbody>
				</table>
		</form>
	</div>
	<jsp:include page="Rodape.jsp" flush="true" />
</div>

</body>
 
</html>

<% } %>

