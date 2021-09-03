
<%@ page errorPage="Error.jsp" %>

<jsp:include page="GetDevice.jsp" flush="true" />

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("AddRecommender");

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

<%@ page import="net.tanesha.recaptcha.ReCaptcha" %>
<%@ page import="net.tanesha.recaptcha.ReCaptchaFactory" %>

<!DOCTYPE htm>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="Registering on Recommendation Book" />
<meta name="description" content="Registering on Recommendation Book" />

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
<script src="js/jquery-ui.js"></script>
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

	$("#CheckAvailabilityLink").click(function(event) {
		event.preventDefault();

		var term = $("input[name='nickName']").val();
		var url = "CheckAvailability.jsp";

		if(term == "") {

			alert("Type something on the Nickname field.");

		} else {

			var posting = $.post(url, {s: term});
 
			posting.done(function(data) {
				$("#ShowAvailability").empty().append(data);
			});

		}

	});

	$("#PreviewImage").change(function(){
		if(!isMSIE()) {
			readURL(this, "DivImagePreview", "ImagePreview");
		}
	});

	TextAreaCounter("#TAAbout", "div.TextAreaCounter", 750);

var rules = {
	'nickName': { required: true, maxlength: '50', regex: "^[\\w]+$" },
	'officialWebsite': { required: false, maxlength: '100', regex: "^([a-zA-Z0-9_.-]{1,100})$" },
	'about': { required: false, maxlength: '750', hasMoreThanNLineBreaks: '15', checkForInvalidCharacters: true },
	'email': { required: true, maxlength: '100', regex: "^([a-zA-Z0-9_.-]+)@([a-z0-9_.-]+)$" },
	'remail': { required: true, maxlength: '100', regex: "^([a-zA-Z0-9_.-]+)@([a-z0-9_.-]+)$", checkIfMatch: 'email' },
	'password': { required: true, maxlength: '50', isPasswordValid: true },
	'rpassword': { required: true, maxlength: '50', isPasswordValid: true, checkIfMatch: 'password' },
	'image': { required: false, extension: "jpg", imageCantBeBiggerThanNBytes: '50000' }
};

var messages = {
	'nickName': { required: "NickName Field Cannot Be Empty!", maxlength: "Nickname Field Cannot Be Bigger Than 50 Characters!",
		 regex: "Choose a Valid Nickname With a-z A-Z 0-9 _ Characters!" },
	'sex': { required: "Sex Field Cannot be Empty!" },
	'country': { required: "Country Field Cannot Be Empty!" },
	'year': { required: "Year Field Cannot Be Empty!" },
	'month': { required: "Month Field Cannot Be Empty!" },
	'day': { required: "Day Field Cannot Be Empty!" },
	'about': { maxlength: "About Field Cannot Be Bigger Than 750 Characters!", hasMoreThanNLineBreaks: "About Field Cannot Have More Than 15 Line Breaks!" },
	'officialWebsite': { maxlength: "Official Website Field Cannot Be Bigger Than 100 Characters!", regex: "Choose a valid Official Website With a-z A-Z 0-9 . _ -  Characters!" },
	'email': { required: "E-mail Field Cannot Be Empty!", maxlength: "E-mail Field Cannot Be Bigger Than 100 Characters!", regex: "Type a Valid E-mail!" },
	'remail': { required: "Retype E-mail Field Cannot Be Empty!", maxlength: "Retype E-mail Field Cannot Be Bigger Than 100 Characters!", 
		regex: "Type a Valid E-mail!", checkIfMatch: "The Emails Are Not Equal!" },
	'password': { required: "Password Field Cannot Be Empty!", maxlength: "Password Field Cannot Be Bigger Than 50 Characters!" },
	'rpassword': { required: "Retype Password Field Cannot Be Empty!", maxlength: "Retype Password Field Cannot Be Bigger Than 50 Characters!", 
		checkIfMatch: "The Passwords Are Not Equal!"  },
	'image': { extension: "Only .jpg File Extensions Are Accepted" }
};

	$("#AddRecommender").validate({rules:rules, messages:messages});

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

		<form method="post" action="AddRecommenderValidation.jsp" id="AddRecommender" enctype="multipart/form-data">
				<table style="border-spacing: 0px;">
				<thead>
				<tr>
				<td>
<h1 class="Action">You Are Now Creating Your Recommendation Book...</h1><br />
<jsp:include page="FacebookGoogleInstructions.jsp" flush="true" />
				</td>
				</tr>
				</thead>
				<tbody>

				<tr>
					<td class="tdLeft SpaceForFields"><span class="Bold">Nickname</span></td>
				</tr>
				<tr>
					<td class="tdLeft">
						<input type="text" class="required" id="nickName" name="nickName" value="<% if(session.getAttribute("nickNameS") != null) { out.print(session.getAttribute("nickNameS")); } %>">
						<br />
						<br />
						<div class="BeforeShowAvailability">
						<a href="#" class="CheckAvailability" id="CheckAvailabilityLink">Check Nickname Availability</a>
						</div>
						<div class="ShowAvailability" id="ShowAvailability"></div>
					</td>
				</tr>
				<tr>
					<td class="tdLeft">
<span class="Nickname">You Will Be Identified on the Recommendation Book by your Nickname and it Will Be Unique.</span><br />
<span class="CantBeChanged">Attention. You Cannot Change the Nickname Later. Type Carefully.</span>
					</td>
				</tr>
<% if("true".equals(session.getAttribute("NickNameCantBeEmpty")) || "true".equals(session.getAttribute("NickNameIsBiggerThan50Characters")) || "true".equals(session.getAttribute("NickNameIsInvalid")) || "true".equals(session.getAttribute("NickNameAlreadyTaken"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("NickNameCantBeEmpty"))) { out.print("Nickname Field Cannot Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("NickNameIsBiggerThan50Characters"))) { out.print("Nickname Field Cannot Be Bigger Than 50 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("NickNameIsInvalid"))) { out.print("<br />Choose a Valid Nickname With a-z A-Z 0-9 _ Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("NickNameAlreadyTaken"))) { out.print("<br />Nickname Already Taken!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr>
					<td class="tdLeft SpaceForFields">Avatar (Optional)</td>
				</tr>
				<tr>
					<td class="tdLeft"><input type="file" class="required" name="image" accept="image/*" id="PreviewImage" /><div id="DivImagePreview"></div></td>
				</tr>
				<tr>
					<td class="tdLeft"><span class="Nickname">Image Cannot Be Bigger Than 50Kb and Only .jpg File Extensions Are Accepted</span></td>
				</tr>
<% if("true".equals(session.getAttribute("ImageIsBiggerThan50KBytes")) || "true".equals(session.getAttribute("ImageExtensionIsNotAccepted"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("ImageIsBiggerThan50KBytes"))) { out.print("Image Cannot Be Bigger Than 50Kb!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("ImageExtensionIsNotAccepted"))) { out.print("Only .jpg File Extensions Are Accepted!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">Sex</span></td></tr>
				<tr><td class="tdLeft"><select class="required" id="sex" name="sex">
				<jsp:include page="Sex.jsp" flush="true" />
				</select></td></tr>
				<tr><td class="tdLeft"><span class="Nickname">The Field Sex is Being Asked for Statistical Purposes. You Can Change it Later Anytime.</span></td></tr>
<% if("true".equals(session.getAttribute("SexIsNotSelected"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("SexIsNotSelected"))) { out.print("Sex Field Cannot be Empty!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">Country</span></td></tr>
				<tr><td class="tdLeft"><select class="required" id="country" name="country">
				<jsp:include page="Countries.jsp?withWWE=Yes" flush="true" />
				</select></td></tr>
				<tr><td class="tdLeft"><span class="Nickname">The Field Country is Being Asked for Statistical Purposes. You Can Change it Later Anytime.</span></td></tr>
<% if("true".equals(session.getAttribute("CountryIsNotSelected"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("CountryIsNotSelected"))) { out.print("Country Field Cannot Be Empty!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">Birth Date</span></td></tr>
				<tr><td class="tdLeft"><select class="required" id="year" name="year">
				<jsp:include page="Years.jsp?from=now&to=1900&timeline=false" flush="true" />
				</select>
				</td></tr><tr><td class="tdLeft">
				<select class="required" id="month" name="month">
				<jsp:include page="Months.jsp" flush="true" />
				</select>
				</td></tr><tr><td class="tdLeft">
				<select class="required" id="day" name="day">
				<jsp:include page="Days.jsp" flush="true" />
				</select>
				</td>
				</tr>
				<tr><td class="tdLeft"><span class="Nickname">The Field Birth Date is Being Asked for Statistical Purposes. You Can Change it Later Anytime.</span></td></tr>
<% if("true".equals(session.getAttribute("YearIsNotSelected")) || "true".equals(session.getAttribute("MonthIsNotSelected")) || "true".equals(session.getAttribute("DayIsNotSelected")) || "true".equals(session.getAttribute("DateIsInvalid"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("YearIsNotSelected"))) { out.print("Year Field Cannot Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("MonthIsNotSelected"))) { out.print("<br />Month Field Cannot Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("DayIsNotSelected"))) { out.print("<br />Day Field Cannot Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("DateIsInvalid"))) { out.print("<br />Choose a valid Birth Date!"); } %></span>
					</td>
				</tr>
<% } %>

<tr style="visibility: hidden;"><td>
<input type="hidden" name="officialWebsite" value="" />
<input type="hidden" name="about" value="" />
</td></tr>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">E-mail</span></td></tr>
				<tr><td class="tdLeft"><input type="email" class="required" id="email" name="email" value="<% if(session.getAttribute("emailS") != null) { out.print(session.getAttribute("emailS")); } %>"></td></tr>
<% if("true".equals(session.getAttribute("EmailCantBeEmpty")) || "true".equals(session.getAttribute("EmailIsBiggerThan100Characters")) || "true".equals(session.getAttribute("EmailIsInvalid"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("EmailCantBeEmpty"))) { out.print("Email Field Cannot Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("EmailIsBiggerThan100Characters"))) { out.print("Email Field Cannot Be Bigger Than 100 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("EmailIsInvalid"))) { out.print("<br />Type a Valid Email!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">Retype E-mail</span></td></tr>
				<tr><td class="tdLeft"><input type="email" class="required" id="remail" name="remail" value="<% if(session.getAttribute("remailS") != null) { out.print(session.getAttribute("remailS")); } %>"></td></tr>
				<tr><td class="tdLeft"><span class="CantBeChanged">Attention. You Cannot Change the E-mail Later. Type Carefully.</span></td></tr>
<% if("true".equals(session.getAttribute("REmailCantBeEmpty")) || "true".equals(session.getAttribute("REmailIsBiggerThan100Characters")) || "true".equals(session.getAttribute("REmailIsInvalid")) || "true".equals(session.getAttribute("EmailsAreNotEqual")) || "true".equals(session.getAttribute("EmailAlreadyRegistered"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("REmailCantBeEmpty"))) { out.print("Retype Email Field Cannot Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("REmailIsBiggerThan100Characters"))) { out.print("Retype Email Field Cannot Be Bigger Than 100 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("REmailIsInvalid"))) { out.print("<br />Type a Valid Email!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("EmailsAreNotEqual"))) { out.print("<br />The Emails Are Not Equal!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("EmailAlreadyRegistered"))) { out.print("<br />Email Already Registered!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">Password</span></td></tr>
				<tr><td class="tdLeft"><input type="password" class="required" id="password" name="password" value=""></td></tr>
<% if("true".equals(session.getAttribute("PasswordCantBeEmpty")) || "true".equals(session.getAttribute("PasswordIsBiggerThan50Characters"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("PasswordCantBeEmpty"))) { out.print("Password Field Cannot Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("PasswordIsBiggerThan50Characters"))) { out.print("Password Field Cannot Be Bigger Than 50 Characters!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">Retype Password</span></td></tr>
				<tr><td class="tdLeft"><input type="password" class="required" id="rpassword" name="rpassword" value=""></td></tr>
<tr><td class="tdLeft"><span class="Nickname">The Password Must Have at Least 6 Letters: a-z A-Z, at Least 2 Numbers: 0-9 and at Least 1 Punctuation From The Following: # + - _</span></td></tr>
<% if("true".equals(session.getAttribute("RPasswordCantBeEmpty")) || "true".equals(session.getAttribute("RPasswordIsBiggerThan50Characters")) || "true".equals(session.getAttribute("PasswordsAreNotEqual")) || "true".equals(session.getAttribute("PasswordsAreInvalid"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("RPasswordCantBeEmpty"))) { out.print("Retype Password Field Cannot Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("RPasswordIsBiggerThan50Characters"))) { out.print("Retype Password Field Cannot Be Bigger Than 50 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("PasswordsAreNotEqual"))) { out.print("<br />The Passwords Are Not Equal!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("PasswordsAreInvalid"))) { out.print("<br />The Password Must Have at Least 6 Letters: a-z A-Z, at Least 2 Numbers: 0-9 and at Least 1 Punctuation From The Following: # + - _"); } %></span>

					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">Enter Captcha</span></td></tr>
				<tr><td class="tdLeft">
<%

	ReCaptcha c = ReCaptchaFactory.newReCaptcha("6LdQqvwSAAAAAMNiEciF2_Sp1xndgsleTvtiz7jV", "6LdQqvwSAAAAABKN8ktbyXwzsOsXzFHHCucctMcY", false);
	out.print(c.createRecaptchaHtml(null, null));

%>
				</td>
				</tr>
				<tr>
<td class="tdLeft"><span class="Nickname">This is the Only Time Recommendation Book Will Request You to Insert Captcha. For Login and Recommendations When Logged You Wont Need to Insert Captcha.</span></td>
				</tr>
<% if("true".equals(session.getAttribute("CaptchaIsWrong")))  { %>
				<tr>
					<td class="tdLeft"><span class="error">Incorrect Captcha! Enter Captcha Again!</span></td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields"><input type="submit" value="Create My Recommendation Book" /></td></tr>

				</tbody>
				</table>
		</form>

<% } else { %>

		<form method="post" action="AddRecommenderValidation.jsp" id="AddRecommender" enctype="multipart/form-data">
				<table class="listras" style="border-spacing: 0px;">
				<thead>
				<tr>
				<td colspan="3">
<h1 class="Action">You Are Now Creating Your Recommendation Book...</h1><br />
<span class="Action Bold">Fields in Bold Are Required</span><br/>
<jsp:include page="FacebookGoogleInstructions.jsp" flush="true" />
				</td>
				</tr>
				</thead>
				<tbody>

				<tr>
					<td class="tdRight" style="width: 10%"><span class="Bold">Nickname</span></td>
					<td class="tdLeft">
						<input type="text" class="required" id="nickName" name="nickName" size="50" value="<% if(session.getAttribute("nickNameS") != null) { out.print(session.getAttribute("nickNameS")); } %>">
						<br />
						<br />
						<div class="BeforeShowAvailability">
						<a href="#" class="CheckAvailability" id="CheckAvailabilityLink">Check Nickname Availability</a>
						</div>
						<div class="ShowAvailability" id="ShowAvailability"></div>
					</td>
					<td>
<span class="Nickname">You Will Be Identified on the Recommendation Book by your Nickname and it Will Be Unique.</span><br /><br />
<span class="CantBeChanged">Attention. You Cannot Change the Nickname Later. Type Carefully.</span>
</td>
				</tr>
<% if("true".equals(session.getAttribute("NickNameCantBeEmpty")) || "true".equals(session.getAttribute("NickNameIsBiggerThan50Characters")) || "true".equals(session.getAttribute("NickNameIsInvalid")) || "true".equals(session.getAttribute("NickNameAlreadyTaken"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("NickNameCantBeEmpty"))) { out.print("Nickname Field Cannot Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("NickNameIsBiggerThan50Characters"))) { out.print("Nickname Field Cannot Be Bigger Than 50 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("NickNameIsInvalid"))) { out.print("<br />Choose a Valid Nickname With a-z A-Z 0-9 _ Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("NickNameAlreadyTaken"))) { out.print("<br />Nickname Already Taken!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr>
					<td class="tdRight">Avatar</td>
					<td class="tdLeft"><input type="file" class="required" name="image" accept="image/*" id="PreviewImage" /><div id="DivImagePreview"></div></td>
					<td><span class="Nickname">Image Cannot Be Bigger Than 50Kb and Only .jpg File Extensions Are Accepted</span></td>
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
				</select></td>
				<td><span class="Nickname">The Field Sex is Being Asked for Statistical Purposes. You Can Change it Later Anytime.</span></td></tr>
<% if("true".equals(session.getAttribute("SexIsNotSelected"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("SexIsNotSelected"))) { out.print("Sex Field Cannot be Empty!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight"><span class="Bold">Country</span></td><td class="tdLeft"><select class="required" id="country" name="country">
				<jsp:include page="Countries.jsp?withWWE=Yes" flush="true" />
				</select></td>
				<td><span class="Nickname">The Field Country is Being Asked for Statistical Purposes. You Can Change it Later Anytime.</span></td></tr>
<% if("true".equals(session.getAttribute("CountryIsNotSelected"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("CountryIsNotSelected"))) { out.print("Country Field Cannot Be Empty!"); } %></span>
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
				</td><td><span class="Nickname">The Field Birth Date is Being Asked for Statistical Purposes. You Can Change it Later Anytime.</span></td></tr>
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

<input type="hidden" name="officialWebsite" value="" />
<input type="hidden" name="about" value="" />

<!--

				<tr><td class="tdRight">Official Website</td><td class="tdLeft"><input type="text" class="required" id="officialWebsite" name="officialWebsite" size="50" value="<% if(session.getAttribute("officialWebsiteS") != null) { out.print(session.getAttribute("officialWebsiteS")); } %>"></td><td></td></tr>
<% if("true".equals(session.getAttribute("OfficialWebsiteIsBiggerThan100Characters")) || "true".equals(session.getAttribute("OfficialWebsiteIsInvalid"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("OfficialWebsiteIsBiggerThan100Characters"))) { out.print("<br />Official Website field can't be bigger than 100 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("OfficialWebsiteIsInvalid"))) { out.print("<br />Choose a valid Official Website With a-z A-Z 0-9 . _ -  Characters!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight">About Yourself</td>
				<td class="tdLeft"><textarea class="required" id="TAAbout" name="about" cols="50" style="height: 250px; max-height: 250px;"><% if(session.getAttribute("aboutS") != null) { out.print(session.getAttribute("aboutS")); } %></textarea></td><td><div class="TextAreaCounter"></div></td></tr>
<% if("true".equals(session.getAttribute("AboutIsBiggerThan750Characters")) || "true".equals(session.getAttribute("AboutHasMoreThan15LineBreaks")) || "true".equals(session.getAttribute("HasHTMLInjection"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("AboutIsBiggerThan750Characters"))) { out.print("About Field Cannot Be Bigger Than 750 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("AboutHasMoreThan15LineBreaks"))) { out.print("About Field Cannot Have More Than 15 Line Breaks!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("HasHTMLInjection"))) { out.print("<br />The Characters < and > Are Not Allowed In The About Field!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

-->

				<tr><td class="tdRight"><span class="Bold">E-mail</span></td><td class="tdLeft"><input type="email" class="required" id="email" name="email" size="50" value="<% if(session.getAttribute("emailS") != null) { out.print(session.getAttribute("emailS")); } %>"></td><td></td></tr>
<% if("true".equals(session.getAttribute("EmailCantBeEmpty")) || "true".equals(session.getAttribute("EmailIsBiggerThan100Characters")) || "true".equals(session.getAttribute("EmailIsInvalid"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("EmailCantBeEmpty"))) { out.print("Email Field Cannot Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("EmailIsBiggerThan100Characters"))) { out.print("Email Field Cannot Be Bigger Than 100 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("EmailIsInvalid"))) { out.print("<br />Type a Valid Email!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight"><span class="Bold">Retype E-mail</span></td><td class="tdLeft"><input type="email" class="required" id="remail" name="remail" size="50" value="<% if(session.getAttribute("remailS") != null) { out.print(session.getAttribute("remailS")); } %>"><td><span class="CantBeChanged">Attention. You Cannot Change the E-mail Later. Type Carefully.</span></td></tr>
<% if("true".equals(session.getAttribute("REmailCantBeEmpty")) || "true".equals(session.getAttribute("REmailIsBiggerThan100Characters")) || "true".equals(session.getAttribute("REmailIsInvalid")) || "true".equals(session.getAttribute("EmailsAreNotEqual")) || "true".equals(session.getAttribute("EmailAlreadyRegistered"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("REmailCantBeEmpty"))) { out.print("Retype Email Field Cannot Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("REmailIsBiggerThan100Characters"))) { out.print("Retype Email Field Cannot Be Bigger Than 100 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("REmailIsInvalid"))) { out.print("<br />Type a Valid Email!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("EmailsAreNotEqual"))) { out.print("<br />The Emails Are Not Equal!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("EmailAlreadyRegistered"))) { out.print("<br />Email Already Registered!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight"><span class="Bold">Password</span></td>
				<td class="tdLeft"><input type="password" class="required" id="password" name="password" size="20" value=""></td><td></td></tr>
<% if("true".equals(session.getAttribute("PasswordCantBeEmpty")) || "true".equals(session.getAttribute("PasswordIsBiggerThan50Characters"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("PasswordCantBeEmpty"))) { out.print("Password Field Cannot Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("PasswordIsBiggerThan50Characters"))) { out.print("Password Field Cannot Be Bigger Than 50 Characters!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight"><span class="Bold">Retype Password</span></td>
				<td class="tdLeft"><input type="password" class="required" id="rpassword" name="rpassword" size="20" value=""></td>
<td><span class="Nickname">The Password Must Have at Least 6 Letters: a-z A-Z, at Least 2 Numbers: 0-9 and at Least 1 Punctuation From The Following: # + - _</span></td></tr>
<% if("true".equals(session.getAttribute("RPasswordCantBeEmpty")) || "true".equals(session.getAttribute("RPasswordIsBiggerThan50Characters")) || "true".equals(session.getAttribute("PasswordsAreNotEqual")) || "true".equals(session.getAttribute("PasswordsAreInvalid"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("RPasswordCantBeEmpty"))) { out.print("Retype Password Field Cannot Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("RPasswordIsBiggerThan50Characters"))) { out.print("Retype Password Field Cannot Be Bigger Than 50 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("PasswordsAreNotEqual"))) { out.print("<br />The Passwords Are Not Equal!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("PasswordsAreInvalid"))) { out.print("<br />The Password Must Have at Least 6 Letters: a-z A-Z, at Least 2 Numbers: 0-9 and at Least 1 Punctuation From The Following: # + - _"); } %></span>

<!--

Only the Following Characters are valid: a-z A-Z 0-9 !\"#$%&\'()*+,-./\\:;<=>?@[]^_`{|}~

-->

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
<td><span class="Nickname">This is the Only Time Recommendation Book Will Request You to Insert Captcha. For Login and Recommendations When Logged You Wont Need to Insert Captcha.</span></td>
				</tr>
<% if("true".equals(session.getAttribute("CaptchaIsWrong")))  { %>
				<tr>
					<td></td><td><span class="error">Incorrect Captcha! Enter Captcha Again!</span></td><td></td>
				</tr>
<% } %>

				<tr><td class="tdRight"></td><td class="tdLeft"><input type="submit" value="Create My Recommendation Book" /></td><td></td></tr>

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