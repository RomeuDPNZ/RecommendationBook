
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("Login");

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

	session.setAttribute("RecommenderIdLogged", ""+recommenderIdLogged+"");

/*
		name = "Romeu";
		email = "teste10teste123456789@gmail.com";
		gender = "male";
		locale = "en-US";
		birthday = "30-09-1995";
*/

%>

<% if(isRecommenderLogged) { %>

	<jsp:forward page="/MessageToRecommender.jsp?id=4" />

<% } else { %>

<%@ page import="net.tanesha.recaptcha.ReCaptcha" %>
<%@ page import="net.tanesha.recaptcha.ReCaptchaFactory" %>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="Recommendation Book Login" />
<meta name="description" content="Recommendation Book Login Page" />

<meta name="google-signin-client_id" content="204765091953-vt1lr5p937vol4dgt7gub3tsrrrnlvgj.apps.googleusercontent.com"></meta>

<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
<meta http-equiv="Pragma" content="no-cache" />
<meta http-equiv="Expires" content="0" />

<link rel="icon" href="./img/static/RBIcon.ico" type="image/x-icon">

<link href='http://fonts.googleapis.com/css?family=Roboto:500' rel='stylesheet' type='text/css'>

<style type="text/css">
<!--
   @import url("RecommendationBookCSS.css");
-->
</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />

<script src="js/jquery-1.10.2.js"></script>

<script type="text/javascript" src="js/jquery.validate.js"></script>
<script type="text/javascript" src="js/jquery.validate.min.js"></script>
<script type="text/javascript" src="js/additional-methods.js"></script>
<script type="text/javascript" src="js/additional-methods.min.js"></script>

<script type="text/javascript" src="js/ValidateMethods.js"></script>

<script type="text/javascript"> 
<!--

$(document).ready(function(){

	$("#SpinnerTR").hide();

});

$(document).ready(function(){

var rules = {
	'email': { required: true, maxlength: '100', regex: "^([a-zA-Z0-9_.-]+)@([a-z0-9_.-]+)$" },
	'password': { required: true, maxlength: '50' }
};

var messages = {
	'email': { required: "E-mail Field Cannot Be Empty!", maxlength: "E-mail Field Cannot Be Bigger Than 100 Characters!", regex: "Type a Valid E-mail!" },
	'password': { required: "Password Field Cannot Be Empty!", maxlength: "Password Field Cannot Be Bigger Than 50 Characters!" }
};

	$("#Login").validate({rules:rules, messages:messages});

});

function myTrim(x) {
	return x.replace(/^\s+|\s+$/gm,'');
}

function setCookiesRB(id) {
	var date = new Date();
	date.setTime(date.getTime() + (365 * 24 * 60 * 60 * 1000));
	document.cookie = "IsRecommenderLogged=Yes; expires="+date.toGMTString()+"";
	document.cookie = "RecommenderId="+id+"; expires="+date.toGMTString()+"";
}

$(document).ready(function(){

	$("#signin-button1").click(function() {

		name = "Romeu";
		email = "teste2teste123456789@gmail.com";
		gender = "male";
		locale = "en-US";
		birthday = "30-09-1995";

		var posting = $.post("LoginFacebook.jsp", {name: name, email: email, gender: gender, locale: locale, birthday: birthday});

		posting.done(function(data) {

			setCookiesRB(""+myTrim(data)+"");

			window.location.href = "http://localhost:8989/Recommender.jsp?id="+myTrim(data)+"";
		});

	});

	$("#signin-button2").click(function() {

		name = "Romeu";
		email = "teste3teste123456789@gmail.com";
		gender = "male";
		locale = "en-US";
		birthday = "30-09-1995";

		var posting = $.post("LoginGooglePlus.jsp", {name: name, email: email, gender: gender, birthday: birthday});

		posting.done(function(data) {

			setCookiesRB(""+myTrim(data)+"");

			window.location.href = "http://localhost:8989/Recommender.jsp?id="+myTrim(data)+"";
		});

	});

});

//-->
</script>

</head>

<body>

<div class="Geral">
	<jsp:include page="MiniMenu.jsp" flush="true" />
	<div class="Corpo">
		<form method="post" id="Login" action="DoLogin.jsp" enctype="multipart/form-data">
				<table>
				<thead>
				<tr>
				<td colspan="3">
<h1 class="Action">You Are Now Logging On Recommendation Book...</h1><br />
<span class="Action Bold">Fields in Bold Are Required / Cookies Need To Be Enabled To Navigate Through Recommendation Book</span>
				</td>
				</tr>
				</thead>
				<tbody>

				<tr>
				<td colspan="3">
<fieldset><span class="Nickname">Facebook and Google Plus Login and Registration</fieldset>
				</td>
				</tr>

				<tr class="GoogleFacebookButtons"><td class="tdRight">Facebook Login</td>
				<td class="tdLeft">
<a href="#" id="signin-button1">Test Facebook Login</a>
				</td>
				</tr>

				<tr class="GoogleFacebookButtons"><td class="tdRight">Google Plus Login</td>
				<td class="tdLeft">
<a id="signin-button2">Test Google Plus Login</a>
				</td>
				</tr>

				<tr id="SpinnerTR" style="visibility: hidden; display: none;"><td class="tdRight">Wait...</td>
				<td class="tdLeft">
<div id="Spinner" class="Spinner"><img width="100" height="100" src="./img/static/ajax-loader-GoldenRod.gif" alt="" /></div>
				</td>
				</tr>

				<tr>
				<td colspan="3">
<span class="Nickname"><br /><a href="AboutFacebookAndGooglePlusLogin.jsp" target="_blank">Click Here To Know More About Facebook and Google Plus Login</a><br /><br />If You Cannot See the Facebook/Google Plus button make sure the JavaScript and the Pop-Up are Enabled on Your Browser.</span>
				</td>
				</tr>

				<tr>
				<td colspan="3">
<fieldset><span class="Nickname">Recommendation Book Conventional Login</fieldset>
				</td>
				</tr>

				<tr><td class="tdRight" style="width: 35%"><span class="Bold">E-mail</span></td><td class="tdLeft"><input type="text" class="required" name="email" size="25" value=""></td></tr>
<% if("true".equals(session.getAttribute("EmailCantBeEmpty")) || "true".equals(session.getAttribute("EmailIsBiggerThan100Characters"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("EmailCantBeEmpty"))) { out.print("Email field can't be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("EmailIsBiggerThan100Characters"))) { out.print("E-mail field can't be bigger than 100 Characters!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdRight"><span class="Bold">Password</span></td><td class="tdLeft"><input type="password" class="required" name="password" size="25" value=""></td></tr>
<% if("true".equals(session.getAttribute("PasswordCantBeEmpty")) || "true".equals(session.getAttribute("PasswordIsBiggerThan50Characters")) || "true".equals(session.getAttribute("WrongEmailOrPassword"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("PasswordCantBeEmpty"))) { out.print("Password field can't be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("PasswordIsBiggerThan50Characters"))) { out.print("Password field can't be bigger than 50 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("WrongEmailOrPassword"))) { out.print("Wrong E-mail Or Password!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td></td><td class="tdLeft"><input type="checkbox" name="KeepMeConnected" value="true" />Keep Me Connected</label></td></tr>

<% if("true".equals("false")) { %>

				<tr><td class="tdRight"><span class="Bold">Enter Captcha</span></td>
				<td><input type="hidden" name="WithCaptcha" value="true" />
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

<% } else { %>

<input type="hidden" name="WithCaptcha" value="false" />

<% } %>

				<tr><td></td><td class="tdLeft"><input type="submit" value="Login" /></td></tr>

				<tr><td></td><td class="tdLeft"><a href="ResetPassword.jsp">I Forgot My Password</a></td></tr>

				</tbody>
				</table>
		</form>
	</div>
	<jsp:include page="Rodape.jsp" flush="true" />
</div>

</body>
 
</html>

<% } %>


