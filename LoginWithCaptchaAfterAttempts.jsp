
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

<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="recBook.DB" %>

<%@ page import="net.tanesha.recaptcha.ReCaptcha" %>
<%@ page import="net.tanesha.recaptcha.ReCaptchaFactory" %>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="Recommendation Book Login" />
<meta name="description" content="Recommendation Book Login Page" />

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

var rules = {
	'email': { required: true, maxlength: '100', regex: "^([a-zA-Z0-9_.-]+)@([a-zA-Z0-9_.-]+)$" },
	'password': { required: true, maxlength: '50' }
};

var messages = {
	'email': { required: "E-mail Field Cannot Be Empty!", maxlength: "E-mail Field Cannot Be Bigger Than 100 Characters!", regex: "Type a Valid E-mail!" },
	'password': { required: "Password Field Cannot Be Empty!", maxlength: "Password Field Cannot Be Bigger Than 50 Characters!" }
};

	$("#Login").validate({rules:rules, messages:messages});

});

//-->
</script>

<script type="text/javascript">
      (function() {
       var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
       po.src = 'https://apis.google.com/js/client:plusone.js';
       var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
     })();

     function signinCallback(authResult) {
        if (authResult['status']['signed_in']) {
            console.log(authResult);
            /* document.getElementById('signinButton').setAttribute('style', 'display: none'); */
             /* get google plus id */
            $.ajax({
                type: "GET",
                url: "https://www.googleapis.com/oauth2/v2/userinfo?access_token="+access_token
            })
            .done(function( data ){
                alert(data);
            });
        } else {
            console.log('Sign-in state: ' + authResult['error']);
        }
     }
</script> 

</head>

<body>

<div class="Geral">
	<jsp:include page="MiniMenu.jsp" flush="true" />
	<div class="Corpo">
		<form method="post" id="Login" action="DoLogin.jsp" enctype="multipart/form-data">
				<table cellspacing="0" cellpadding="12" width="100%" style="padding-top: 10%; padding-bottom: 10%;">
				<thead>
				<tr>
				<td colspan="3" align="center" valign="middle">
<h1 class="Action">You Are Now Logging On Recommendation Book...</h1><br />
<span class="Action Bold">Fields in Bold Are Required / Cookies Need To Be Enabled To Navigate Through Recommendation Book</span>
				</td>
				</tr>
				</thead>
				<tbody align="left" valign="middle">

<!--
				<tr><td align="right" width="40%">Google Plus Login</td>
				<td>
<span id="signinButton">
  <span
    class="g-signin"
    data-callback="signinCallback"
    data-clientid="990394207696-44kdrp5siq2f6hld2tqrb3ms5d5q6uqn.apps.googleusercontent.com"
    data-cookiepolicy="single_host_origin"
    data-requestvisibleactions="http://schema.org/AddAction"
    data-scope="https://www.googleapis.com/auth/plus.login">
  </span>
</span>
				</td>
				</tr>
-->

				<tr><td align="right" width="40%"><span class="Bold">E-mail</span></td><td><input type="text" class="required" name="email" size="50" value=""></td></tr>
<% if("true".equals(session.getAttribute("EmailCantBeEmpty")) || "true".equals(session.getAttribute("EmailIsBiggerThan100Characters"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("EmailCantBeEmpty"))) { out.print("Email field can't be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("EmailIsBiggerThan100Characters"))) { out.print("E-mail field can't be bigger than 100 Characters!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td align="right"><span class="Bold">Password</span></td><td><input type="password" class="required" name="password" size="50" value=""></td></tr>
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

<% if("true".equals(session.getAttribute("TooManyWrongAttemptsMade")))  { %>

				<tr><td align="right"><span class="Bold">Enter Captcha</span></td>
				<td><input type="hidden" name="AttemptsMade" value="true" />
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

<input type="hidden" name="AttemptsMade" value="false" />

<% } %>

				<tr><td align="right"></td><td><input type="submit" value="Login" /></td></tr>

				<tr><td align="right"></td><td><a href="ResetPassword.jsp">I Forgot My Password</a></td></tr>

				</tbody>
				</table>
		</form>
	</div>
	<jsp:include page="Rodape.jsp" flush="true" />
</div>

</body>
 
</html>

<% } %>


