
<%@ page errorPage="Error.jsp" %>

<jsp:include page="GetDevice.jsp" flush="true" />

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("ResetPassword");

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

%>

<%@ page import="net.tanesha.recaptcha.ReCaptcha" %>
<%@ page import="net.tanesha.recaptcha.ReCaptchaFactory" %>

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

<link href='http://fonts.googleapis.com/css?family=Roboto:500' rel='stylesheet' type='text/css'>

<script src="js/jquery-1.10.2.js"></script>

<script type="text/javascript" src="js/jquery.validate.js"></script>
<script type="text/javascript" src="js/jquery.validate.min.js"></script>
<script type="text/javascript" src="js/additional-methods.js"></script>
<script type="text/javascript" src="js/additional-methods.min.js"></script>

<script type="text/javascript" src="js/ValidateMethods.js"></script>

<script type="text/javascript"> 
<!--

$(document).ready(function(){

var rules = {
	'email': { required: true, maxlength: '100', regex: "^([a-zA-Z0-9_.-]+)@([a-z0-9_.-]+)$" }
};

var messages = {
	'email': { required: "E-mail Field Cannot Be Empty!", maxlength: "E-mail Field Cannot Be Bigger Than 100 Characters!", regex: "Type a Valid E-mail!" }
};

	$("#ResetPassword").validate({rules:rules, messages:messages});

});

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

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
		<form method="post" id="ResetPassword" action="DoSendVerificationCode.jsp" enctype="multipart/form-data">
				<table style="padding-top: 5%; padding-bottom: 5%;">
				<thead>
				<tr>
				<td>
<h1 class="Action">You Are Now Resetting Your Password...</h1><br />
<span class="Action Bold">Fields in Bold Are Required</span>
				</td>
				</tr>
				</thead>
				<tbody>

				<tr><td class="tdLeft SpaceForFields" style="width: 40%"><span class="Bold">E-mail</span></td></tr>
				<tr><td class="tdLeft"><input type="email" class="required" name="email" value=""></td></tr>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("EmailCantBeEmpty"))) { out.print("Email field can't be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("EmailIsBiggerThan100Characters"))) { out.print("Email field can't be bigger than 100 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("EmailNotFound"))) { out.print("Email Not Found!"); } %></span>
					</td>
				</tr>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">Enter Captcha</span></td></tr>
				<tr><td class="tdLeft">
<%

	ReCaptcha c = ReCaptchaFactory.newReCaptcha("6LdQqvwSAAAAAMNiEciF2_Sp1xndgsleTvtiz7jV", "6LdQqvwSAAAAABKN8ktbyXwzsOsXzFHHCucctMcY", false);
	out.print(c.createRecaptchaHtml(null, null));

%>
				</td></tr>
<% if("true".equals(session.getAttribute("CaptchaIsWrong")))  { %>
				<tr>
					<td><span class="error">Incorrect Captcha! Enter Captcha Again!</span></td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields"><input type="submit" value="Reset Password" /></td></tr>

				<tr><td class="tdLeft SpaceForFields">A Verification Code Will Be Sent To Your Email</td></tr>

				</tbody>
				</table>
		</form>
<% } else { %>
		<form method="post" id="ResetPassword" action="DoSendVerificationCode.jsp" enctype="multipart/form-data">
				<table style="padding-top: 5%; padding-bottom: 5%;">
				<thead>
				<tr>
				<td colspan="3">
<h1 class="Action">You Are Now Resetting Your Password...</h1><br />
<span class="Action Bold">Fields in Bold Are Required</span>
				</td>
				</tr>
				</thead>
				<tbody>

				<tr><td class="tdRight" style="width: 40%"><span class="Bold">E-mail</span></td><td class="tdLeft"><input type="email" class="required" name="email" size="50" value=""></td></tr>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("EmailCantBeEmpty"))) { out.print("Email field can't be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("EmailIsBiggerThan100Characters"))) { out.print("Email field can't be bigger than 100 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("EmailNotFound"))) { out.print("Email Not Found!"); } %></span>
					</td>
				</tr>

				<tr><td class="tdRight"><span class="Bold">Enter Captcha</span></td>
				<td class="tdLeft">
<%

	ReCaptcha c = ReCaptchaFactory.newReCaptcha("6LdQqvwSAAAAAMNiEciF2_Sp1xndgsleTvtiz7jV", "6LdQqvwSAAAAABKN8ktbyXwzsOsXzFHHCucctMcY", false);
	out.print(c.createRecaptchaHtml(null, null));

%>
				</td>
				<td></td>
				</tr>
<% if("true".equals(session.getAttribute("CaptchaIsWrong")))  { %>
				<tr>
					<td></td><td><span class="error">Incorrect Captcha! Enter Captcha Again!</span></td><td></td>
				</tr>
<% } %>

				<tr><td class="tdRight"></td><td class="tdLeft"><input type="submit" value="Reset Password" /></td></tr>

				<tr><td class="tdRight"></td><td class="tdLeft">A Verification Code Will Be Sent To Your Email</td></tr>

				</tbody>
				</table>
		</form>
<% } %>

	</div>

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
	<jsp:include page="RodapeMobile.jsp" flush="true" />
<% } else { %>
	<jsp:include page="Rodape.jsp" flush="true" />
<% } %>

</div>

</body>
 
</html>
