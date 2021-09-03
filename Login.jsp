
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
%>

<% if(isRecommenderLogged) { %>

	<jsp:forward page="/MessageToRecommender.jsp?id=4" />

<% } else { %>

<jsp:include page="GetDevice.jsp" flush="false" />

<% String url = request.getRequestURL().toString(); %>

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

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookMobileCSS.css" />

<% } %>

<script src="js/jquery-1.10.2.js"></script>

<script type="text/javascript" src="js/jquery.validate.js"></script>
<script type="text/javascript" src="js/jquery.validate.min.js"></script>
<script type="text/javascript" src="js/additional-methods.js"></script>
<script type="text/javascript" src="js/additional-methods.min.js"></script>

<script type="text/javascript" src="js/ValidateMethods.js"></script>

<script src="https://apis.google.com/js/client:platform.js?onload=startApp" async defer></script>

<script type="text/javascript"> 
<!--

var emailRegex = new RegExp("^([a-zA-Z0-9_.-]+)@([a-z0-9_.-]+)$");

$(document).ready(function(){

	$(".SpinnerTR").hide();
	$(".ProposeConventionalLogin").hide();

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

	var url = "<%= url %>";

	if(url.toLowerCase().indexOf("localhost:8989") >= 0) {
		document.cookie = "IsRecommenderLogged=Yes; expires="+date.toGMTString()+"";
		document.cookie = "RecommenderId="+id+"; expires="+date.toGMTString()+"";
	} else {
		document.cookie = "IsRecommenderLogged=Yes; expires="+date.toGMTString()+"; domain=recommendationbook.com;path=/";
		document.cookie = "RecommenderId="+id+"; expires="+date.toGMTString()+"; domain=recommendationbook.com;path=/";
	}
}

/*
 *
 * Facebook Login
 *
 */

function statusChangeCallback(response) {
	if(response.status === 'connected') {
		$(document).ready(function(){
			$(".GoogleFacebookButtons").hide();
			$(".SpinnerTR").show();
		});
		register();
	} else if(response.status === 'not_authorized') {
		
	} else {
		// The person is not logged into Facebook, so we're not sure if they are logged into this app or not.
	}
}

function checkLoginState() {
<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
	FB.login( function(response) {
		FB.getLoginStatus(function(response) {
			statusChangeCallback(response);
		});
	}, { scope: 'public_profile,email,user_birthday' } );
<% } else { %>
		FB.getLoginStatus(function(response) {
			statusChangeCallback(response);
		});
<% } %>
}

window.fbAsyncInit = function() {
	FB.init({
		appId : '1054429214574465',
		cookie : true,
		xfbml : true,
		version : 'v2.2'
	});

	FB.getLoginStatus(function(response) {
		// statusChangeCallback(response);
	});
};

(function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

function register() {
	FB.api('/me', function(response) {

		var name = "";
		var email = "";
		var gender = "";
		var locale = "";
		var birthday = "";

		if(typeof response.name != "undefined") {
			name = ""+response.name+"";
		}

		if(typeof response.email != "undefined") {
			email = ""+response.email+"";
		}

		if(typeof response.gender != "undefined") {
			gender = ""+response.gender+"";
		}

		if(typeof response.birthday != "undefined") {
			birthday = ""+response.birthday+"";
		}

		if(typeof response.locale != "undefined") {
			locale = ""+ response.locale+"";
		}

		if(!emailRegex.test(email) || email.toLowerCase().indexOf("facebook.com") >= 0 || email === "") {

			$(".SpinnerTR").hide();
			$(".ProposeConventionalLogin").show();

		} else {

			var posting = $.post("LoginFacebook.jsp", {name: name, email: email, gender: gender, locale: locale, birthday: birthday});

			posting.done(function(data) {

				setCookiesRB(""+myTrim(data)+"");

				window.location.href = "http://recommendationbook.com/Recommender.jsp?id="+myTrim(data)+"";
			});

		}
	});
}

/*
 *
 * Google Plus Login
 *
 */

var auth2 = {};

var helper = (function() {
	return {
		onSignInCallback: function(authResult) {
			if (authResult.isSignedIn.get()) {
				$(document).ready(function(){
					$(".GoogleFacebookButtons").hide();
					$(".SpinnerTR").show();
				});
				helper.profile();
			} else if (authResult['error'] || authResult.currentUser.get().getAuthResponse() == null) {

			}
		},
		disconnect: function() {
			auth2.disconnect();
		},
		profile: function(){
			gapi.client.plus.people.get({
				'userId': 'me'
			}).then(function(res) {
				var profile = res.result;

				var name = "";
				var email = "";
				var gender = "";
				var birthday = "";

				if(typeof profile.displayName != "undefined") {
					name = ""+profile.displayName+"";
				}

				if(typeof profile.emails[0].value != "undefined") {
					email = ""+profile.emails[0].value+"";
				}

				if(typeof profile.gender != "undefined") {
					gender = ""+profile.gender+"";
				}

				if(typeof profile.birthday != "undefined") {
					birthday = ""+profile.birthday+"";
				}

				if(!emailRegex.test(email) || email === "") {

					$(".SpinnerTR").hide();
					$(".ProposeConventionalLogin").show();

				} else {

					var posting = $.post("LoginGooglePlus.jsp", {name: name, email: email, gender: gender, birthday: birthday});

					posting.done(function(data) {

						setCookiesRB(""+myTrim(data)+"");

						window.location.href = "http://recommendationbook.com/Recommender.jsp?id="+myTrim(data)+"";
					});

				}

			}, function(err) {
				var error = err.result;
				alert(error.message);
			});
		}
	};
})();

var updateSignIn = function() {
	if (auth2.isSignedIn.get()) {
		helper.onSignInCallback(gapi.auth2.getAuthInstance());
	} else {
		helper.onSignInCallback(gapi.auth2.getAuthInstance());
	}
}

function startApp() {
	gapi.load('auth2', function() {
		gapi.client.load('plus','v1').then(function() {
			gapi.signin2.render('signin-button', {
				scope: 'https://www.googleapis.com/auth/plus.login',
				fetch_basic_profile: true<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>, width: 800, height: 80, theme: 'dark'<% } %> });
			gapi.auth2.init({fetch_basic_profile: true,
				scope:'https://www.googleapis.com/auth/plus.login'}).then(
					function (){
						$(document).ready(function(){
							$("#signin-button").click(function() {
								auth2 = gapi.auth2.getAuthInstance();
								auth2.isSignedIn.listen(updateSignIn);
								auth2.then(updateSignIn());
							});
						});
			});
		});
	});
}

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
		<form method="post" id="Login" action="DoLogin.jsp" enctype="multipart/form-data">
				<table>
				<thead>
				<tr>
				<td>
<h1 class="Action">You Are Now Logging On Recommendation Book...</h1><br />
<span class="Action Bold">Fields in Bold Are Required / Cookies Need To Be Enabled To Navigate Through Recommendation Book</span>
				</td>
				</tr>
				</thead>
				<tbody>

				<tr>
				<td>
<fieldset><span class="Nickname">Facebook and Google Plus Login and Registration</fieldset>
				</td>
				</tr>

<!--
style="visibility: hidden; display: none;"
-->

<!--
				<tr class="GoogleFacebookButtons"><td class="tdLeft">
<div class="RecommendedLeftRightColumn">
Facebook Login<br />
<fb:login-button scope="public_profile,email,user_birthday" data-size="xlarge" onlogin="checkLoginState();"></fb:login-button>
</div>
<div class="RecommendedRightRightColumn">
Google Plus Login<br />
<div id="gConnect"><div id="signin-button"></div></div>
</div>
				</td></tr>
-->

				<tr class="GoogleFacebookButtons"><td class="tdLeft">
<div style="width: 100%; text-align: center">
Facebook Login and Registration<br />
<a href="#" onclick="checkLoginState();"><img src="./img/static/FacebookButtonBig.PNG" border="0" alt=""></a>
</div>
<div style="width: 100%; text-align: center; margin-top: 1.5em;">
Google Plus Login and Registration<br />
<div id="gConnect"><div align="center" id="signin-button"></div></div>
</div>
				</td></tr>

				<tr class="SpinnerTR"><td>Wait... <div id="Spinner" class="Spinner" style="display: inline;"><img width="200" height="200" src="./img/static/ajax-loader-GoldenRod.gif" alt="" /></div></td></tr>

				<tr class="ProposeConventionalLogin">
				<td>
<a href="AddRecommender.jsp">We Cannot Create Your Recommendation Book Profile Because We Were Unable to Get Your Email. You Will Need to Register by the Conventional Registration Page to get your Recommendation Book by Clicking Here.</a>
				</td>
				</tr>

				<tr>
				<td>
<span class="Nickname"><br /><a href="AboutFacebookAndGooglePlusLogin.jsp" target="_blank">Click Here To Know More About Facebook and Google Plus Login</a><br /><br />If You Cannot See the Facebook/Google Plus button make sure the JavaScript and the Pop-Up are Enabled on Your Browser.</span>
				</td>
				</tr>

				<tr>
				<td>
<fieldset><span class="Nickname">Recommendation Book Conventional Login</fieldset>
				</td>
				</tr>

				<tr><td class="tdLeft"><span class="Bold">E-mail</span></td><tr>
				<tr><td class="tdLeft"><input type="email" class="required" name="email" value=""></td></tr>
<% if("true".equals(session.getAttribute("EmailCantBeEmpty")) || "true".equals(session.getAttribute("EmailIsBiggerThan100Characters"))) { %>
				<tr>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("EmailCantBeEmpty"))) { out.print("Email field can't be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("EmailIsBiggerThan100Characters"))) { out.print("E-mail field can't be bigger than 100 Characters!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft"><span class="Bold">Password</span></td></tr>
				<tr><td class="tdLeft"><input type="password" class="required" name="password" value=""></td></tr>
<% if("true".equals(session.getAttribute("PasswordCantBeEmpty")) || "true".equals(session.getAttribute("PasswordIsBiggerThan50Characters")) || "true".equals(session.getAttribute("WrongEmailOrPassword"))) { %>
				<tr>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("PasswordCantBeEmpty"))) { out.print("Password field can't be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("PasswordIsBiggerThan50Characters"))) { out.print("Password field can't be bigger than 50 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("WrongEmailOrPassword"))) { out.print("Wrong E-mail Or Password!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields"><label for="forLabel"><input type="checkbox" style="width: auto;" name="KeepMeConnected" value="true" id="forLabel" />Keep Me Connected</label></td></tr>

<% if("true".equals("false")) { %>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">Enter Captcha</span></td></tr>
				<tr><td><input type="hidden" name="WithCaptcha" value="true" />
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

<% } else { %>

<input type="hidden" name="WithCaptcha" value="false" />

<% } %>

				<tr><td class="tdLeft SpaceForFields"><input type="submit" value="Login" /></td></tr>

				<tr><td class="tdLeft SpaceForFields"><a href="ResetPassword.jsp">I Forgot My Password</a></td></tr>

				</tbody>
				</table>
		</form>
<% } else { %>
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
<fb:login-button scope="public_profile,email,user_birthday" data-size="xlarge" onlogin="checkLoginState();"></fb:login-button>
				</td>
				</tr>

				<tr class="GoogleFacebookButtons"><td class="tdRight">Google Plus Login</td>
				<td class="tdLeft">
<div id="gConnect"><div id="signin-button"></div></div>
				</td>
				</tr>

				<tr class="SpinnerTR"><td class="tdRight">Wait...</td>
				<td class="tdLeft">
<div id="Spinner" class="Spinner"><img width="100" height="100" src="./img/static/ajax-loader-GoldenRod.gif" alt="" /></div>
				</td>
				</tr>

				<tr class="ProposeConventionalLogin">
				<td colspan="3">
<a href="AddRecommender.jsp">We Cannot Create Your Recommendation Book Profile Because We Were Unable to Get Your Email. You Will Need to Register by the Conventional Registration Page to get your Recommendation Book by Clicking Here.</a>
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

				<tr><td class="tdRight" style="width: 35%"><span class="Bold">E-mail</span></td><td class="tdLeft"><input type="email" class="required" name="email" size="25" value=""></td></tr>
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

				<tr><td></td><td class="tdLeft"><label><input type="checkbox" name="KeepMeConnected" value="true" />Keep Me Connected</label></td></tr>

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

<% } %>


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           