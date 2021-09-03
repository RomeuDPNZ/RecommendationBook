
<%
	Cookie[] cookies = request.getCookies();

	Boolean isRecommenderLogged = false;
	Long recommenderIdLogged = 0l;

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
%>

<% if(!isRecommenderLogged) { %>

	<jsp:forward page="/Login.jsp" />

<% } else { %>

<%@ page import="net.tanesha.recaptcha.ReCaptcha" %>
<%@ page import="net.tanesha.recaptcha.ReCaptchaFactory" %>

<!DOCTYPE htm>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="" />
<meta name="description" content="" />

<link href='http://fonts.googleapis.com/css?family=Roboto:500' rel='stylesheet' type='text/css'>

<style type="text/css">
<!--
   @import url("RecommendationBookCSS.css");
-->
</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />

<script src="js/jquery-1.10.2.js"></script>
<script type="text/javascript" src="js/ImagePreview.js"></script>
<script type="text/javascript" src="js/TextAreaCounter.js"></script>

<script type="text/javascript" src="js/jquery.validate.js"></script>
<script type="text/javascript" src="js/jquery.validate.min.js"></script>
<script type="text/javascript" src="js/additional-methods.js"></script>
<script type="text/javascript" src="js/additional-methods.min.js"></script>

<script type="text/javascript" src="js/ValidateMethods.js"></script>

<script type="text/javascript"> 
<!--

$(document).ready(function(){

	$("#PreviewImage").change(function(){
		if(!isMSIE()) {
			readURL(this, "DivImagePreview", "ImagePreview");
		}
	});

	TextAreaCounter("#TAAbout", "div.TextAreaCounter", 750);

var rules = {
	'officialWebsite': { required: false, maxlength: '100', regex: "^([a-zA-Z0-9_.-]{1,100})$" },
	'about': { required: false, maxlength: '750', hasMoreThanNLineBreaks: '15', checkForInvalidCharacters: true },
	'password': { required: false, maxlength: '50', isPasswordValid: true },
	'rpassword': { required: false, maxlength: '50', isPasswordValid: true, checkIfMatch: 'password' },
	'image': { required: false, extension: "jpg", imageCantBeBiggerThanNBytes: '51200' }
};

var messages = {
	'sex': { required: "Sex Field Cannot be Empty!" },
	'country': { required: "Country Field Cannot Be Empty!" },
	'year': { required: "Year Field Cannot Be Empty!" },
	'month': { required: "Month Field Cannot Be Empty!" },
	'day': { required: "Day Field Cannot Be Empty!" },
	'about': { maxlength: "About Field Cannot Be Bigger Than 750 Characters!", hasMoreThanNLineBreaks: "About Field Cannot Have More Than 15 Line Breaks!" },
	'officialWebsite': { maxlength: "Official Website Field Cannot Be Bigger Than 100 Characters!", regex: "Choose a valid Official Website With a-z A-Z 0-9 . _ -  Characters!" },
	'password': { required: "Password Field Cannot Be Empty!", maxlength: "Password Field Cannot Be Bigger Than 50 Characters!" },
	'rpassword': { required: "Retype Password Field Cannot Be Empty!", maxlength: "Retype Password Field Cannot Be Bigger Than 50 Characters!",
		checkIfMatch: "The Passwords Are Not Equal!" },
	'image': { extension: "Only .jpg File Extensions Are Accepted" }
};

	$("#UpdateRecommender").validate({rules:rules, messages:messages});

});

//-->
</script>

</head>

<body>

<div class="Geral">
	<jsp:include page="CabecalhoMenu.jsp" flush="true" />
	<div class="Corpo">
		<form method="post" id="UpdateRecommender" action="UpdateRecommenderValidation.jsp" enctype="multipart/form-data">
				<table class="listras" style="border-spacing: 0px;">
				<thead>
				<tr>
				<td colspan="3">
<h1 class="Action">You Are Now Updating A Recommender...</h1>
				</td>
				</tr>
				</thead>
				<tbody>

				<tr>
					<td class="tdRight" style="width: 10%"><span class="Bold">Nickname</span></td>
					<td class="tdLeft">
						<% if(session.getAttribute("nickNameS") != null) { out.print(session.getAttribute("nickNameS")); } %>
					</td>
					<td></td>

				<tr>
					<td class="tdRight">Current Image</td>
					<td class="tdLeft"><img class="RecommenderImage" width="200" height="100" src="./img/user/<% if(session.getAttribute("imageNome") != null) { out.print(session.getAttribute("imageNome")); } %>" alt="Current Image" /></td>
					<td></td>
				</tr>

				<tr>
					<td class="tdRight">New Image</td>
					<td class="tdLeft"><input type="file" class="required" name="image" accept="image/*" id="PreviewImage" /><div id="DivImagePreview"></div></td>
					<td>Image can't be Bigger Than 50Kb and Only .jpg File Extensions Are Accepted!</td>
				</tr>
<% if("true".equals(session.getAttribute("ImageIsBiggerThan50KBytes")) || "true".equals(session.getAttribute("ImageExtensionIsNotAccepted"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("ImageIsBiggerThan50KBytes"))) { out.print("Image Cannot Be Bigger Than 50Kb!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("ImageExtensionIsNotAccepted"))) { out.print("Only .jpg File Extensions Are Accepted!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight"><span class="Bold">Sex</span></td><td class="tdLeft"><select class="required" id="sex" name="sex">
				<jsp:include page="Sex.jsp" flush="true" />
				</select></td><td></td></tr>
<% if("true".equals(session.getAttribute("SexIsNotSelected"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("SexIsNotSelected"))) { out.print("Sex Field Cannot be Empty!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight"><span class="Bold">Country</span></td><td class="tdLeft"><select class="required" name="country">
				<jsp:include page="Countries.jsp?withWWE=Yes" flush="true" />
				</select></td><td></td></tr>
<% if("true".equals(session.getAttribute("CountryIsNotSelected"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("CountryIsNotSelected"))) { out.print("Country field can't be Empty!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight"><span class="Bold">Birth Date</span></td><td class="tdLeft"><select class="required" id="year" name="year">
				<jsp:include page="Years.jsp?from=now&to=1900&timeline=false" flush="true" />
				</select>

				<select class="required" id="month" name="month">
				<jsp:include page="Months.jsp" flush="true" />
				</select>

				<select class="required" id="day" name="day">
				<jsp:include page="Days.jsp" flush="true" />
				</select>
				</td><td></td></tr>
<% if("true".equals(session.getAttribute("YearIsNotSelected")) || "true".equals(session.getAttribute("MonthIsNotSelected")) || "true".equals(session.getAttribute("DayIsNotSelected")) || "true".equals(session.getAttribute("DateIsInvalid"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("YearIsNotSelected"))) { out.print("Year Field Cannot Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("MonthIsNotSelected"))) { out.print("<br />Month Field Cannot Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("DayIsNotSelected"))) { out.print("<br />Day Field Cannot Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("DateIsInvalid"))) { out.print("<br />Choose a valid Birth Date!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight">Official Website</td><td class="tdLeft"><input type="text" class="required" name="officialWebsite" size="50" value="<% if(session.getAttribute("officialWebsiteS") != null) { out.print(session.getAttribute("officialWebsiteS")); } %>"></td><td></td></tr>
<% if("true".equals(session.getAttribute("OfficialWebsiteIsBiggerThan100Characters")) || "true".equals(session.getAttribute("OfficialWebsiteIsInvalid"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("OfficialWebsiteIsBiggerThan100Characters"))) { out.print("<br />Official Website field can't be bigger than 100 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("OfficialWebsiteIsInvalid"))) { out.print("<br />Choose a valid Official Website with a-z A-Z 0-9 . _ -  characters!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight">About Yourself</td><td class="tdLeft"><textarea id="TAAbout" class="required" name="about" cols="50" style="height: 250px; max-height: 250px;"><% if(session.getAttribute("aboutS") != null) { out.print(session.getAttribute("aboutS")); } %></textarea></td><td><div class="TextAreaCounter"></div></td></tr>
<% if("true".equals(session.getAttribute("AboutIsBiggerThan750Characters")) || "true".equals(session.getAttribute("AboutHasMoreThan15LineBreaks")) || "true".equals(session.getAttribute("HasHTMLInjection"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("AboutIsBiggerThan750Characters"))) { out.print("About field can't be bigger than 750 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("AboutHasMoreThan15LineBreaks"))) { out.print("About field can't Have More than 15 Line Breaks!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("HasHTMLInjection"))) { out.print("<br />The Characters < and > Are Not Allowed In The About Field!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight">Password</td>
				<td class="tdLeft"><input type="password" class="required" id="password" name="password" size="20" value=""></td>
				<td>If You Don't Wanna Change Your Password Leave the Password Fields Empty.</td></tr>
<% if("true".equals(session.getAttribute("PasswordIsBiggerThan50Characters"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("PasswordIsBiggerThan50Characters"))) { out.print("Password field can't be bigger than 50 Characters!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight">Retype Password</td>
				<td class="tdLeft"><input type="password" class="required" id="rpassword" name="rpassword" size="20" value=""></td>
				<td>The Password Must Have at Least 6 Letters: a-z A-Z, at Least 2 Numbers: 0-9 and at Least 1 Punctuation From The Following: # + - _</td></tr>
<% if("true".equals(session.getAttribute("RPasswordIsBiggerThan50Characters")) || "true".equals(session.getAttribute("PasswordsAreNotEqual")) || "true".equals(session.getAttribute("PasswordsAreInvalid"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("RPasswordIsBiggerThan50Characters"))) { out.print("Retype Password field can't be bigger than 50 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("PasswordsAreNotEqual"))) { out.print("<br />The Passwords are not equal!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("PasswordsAreInvalid"))) { out.print("<br />The Password Must Have at Least 6 Letters: a-z A-Z, at Least 2 Numbers: 0-9 and at Least 1 Punctuation From The Following: # + - _"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

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

				<tr><td class="tdRight"></td><td class="tdLeft"><input type="submit" value="Update" /></td><td></td></tr>

				</tbody>
				</table>
		</form>
	</div>
	<jsp:include page="Rodape.jsp" flush="true" />
</div>

</body>
 
</html>

<% } %>
