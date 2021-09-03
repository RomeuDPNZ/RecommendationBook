
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

<jsp:include page="GetDevice.jsp" flush="false" />

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

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookMobileCSS.css" />

<% } %>

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

	TextAreaCounter("#TAAbout", "div.TextAreaCounter", 20000);

var rules = {
	'officialWebsite': { required: false, maxlength: '100', regex: "^([a-zA-Z0-9_.-]{1,100})$" },
	'about': { required: false, maxlength: '20000', hasMoreThanNLineBreaks: '100', checkForInvalidCharacters: true },
	'image': { required: false, extension: "jpg", imageCantBeBiggerThanNBytes: '51200' },
	'description': { required: false, maxlength: '50', regex: "^[a-zA-Z0-9\\s]+$" }
};

var messages = {
	'description': { required: "Description Field Cannot Be Empty!", maxlength: "Description Field Cannot Be Bigger Than 50 Characters!",
		 regex: "Choose a Valid Description With a-z A-Z 0-9 Characters!" },
	'country': { required: "Country Field Cannot Be Empty!" },
	'about': { maxlength: "About Field Cannot Be Bigger Than 20000 Characters!", hasMoreThanNLineBreaks: "About Field Cannot Have More Than 100 Line Breaks!" },
	'officialWebsite': { maxlength: "Official Website Field Cannot Be Bigger Than 100 Characters!", regex: "Choose a valid Official Website With a-z A-Z 0-9 . _ -  Characters!" },
	'image': { extension: "Only .jpg File Extensions Are Accepted" }
};

	$("#UpdateRecommended").validate({rules:rules, messages:messages});

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
		<form method="post" id="UpdateRecommended" action="UpdateRecommendedValidation.jsp" enctype="multipart/form-data">
				<table style="border-spacing: 0px;">
				<thead>
				<tr>
				<td>
<h1 class="Action">You Are Now Updating Something Recommended...</h1>
				</td>
				</tr>
				</thead>
				<tbody>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">Name</span></td></tr>
				<tr><td class="tdLeft"><% if(session.getAttribute("nameS") != null) { out.print(session.getAttribute("nameS")); } %></td></tr>
				
				<tr><td class="tdLeft SpaceForFields">Current Image</td></tr>
				<tr><td class="tdLeft"><img class="RecommenderImage" width="300" height="200" src="./img/user/<% if(session.getAttribute("imageNome") != null) { out.print(session.getAttribute("imageNome")); } %>" alt="Current Image" /></td></tr>

				<tr><td class="tdLeft SpaceForFields">New Image</td></tr>
				<tr><td class="tdLeft"><input type="file" class="required" name="image" accept="image/*" id="PreviewImage" /></td></tr>
				<tr><td class="tdLeft"><div id="DivImagePreview"></div></td></tr>
				<tr><td class="tdLeft">Image can't be Bigger Than 50Kb and Only .jpg File Extensions Are Accepted!</td></tr>
<% if("true".equals(session.getAttribute("ImageIsBiggerThan50KBytes")) || "true".equals(session.getAttribute("ImageExtensionIsNotAccepted"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("ImageIsBiggerThan50KBytes"))) { out.print("Image can't be Bigger Than 50Kb!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("ImageExtensionIsNotAccepted"))) { out.print("Only .jpg File Extensions Are Accepted!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields">Image Description</td></tr>
				<tr><td class="tdLeft"><input type="text" class="required" name="description" size="50" value="<% if(session.getAttribute("descriptionS") != null) { out.print(session.getAttribute("descriptionS")); } %>"></td></tr>
<% if("true".equals(session.getAttribute("DescriptionIsBiggerThan50Characters")) || "true".equals(session.getAttribute("DescriptionIsInvalid"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("DescriptionIsBiggerThan50Characters"))) { out.print("Description Field Can't Be Bigger Than 50 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("DescriptionIsInvalid"))) { out.print("<br />Choose a Valid Description with a-z A-Z 0-9 Characters!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields">Country</td></tr>
				<tr><td class="tdLeft"><select class="required" name="country"><jsp:include page="Countries.jsp?withWWE=Yes" flush="true" /></select></td></tr>
<% if("true".equals(session.getAttribute("CountryIsNotSelected"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("CountryIsNotSelected"))) { out.print("Country field can't be Empty!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields">Official Website</td></tr>
				<tr><td class="tdLeft"><input type="text" class="required" name="officialWebsite" size="50" value="<% if(session.getAttribute("officialWebsiteS") != null) { out.print(session.getAttribute("officialWebsiteS")); } %>"></td></tr>
<% if("true".equals(session.getAttribute("OfficialWebsiteIsBiggerThan100Characters")) || "true".equals(session.getAttribute("OfficialWebsiteIsInvalid"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("OfficialWebsiteIsBiggerThan100Characters"))) { out.print("<br />Official Website field can't be bigger than 100 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("OfficialWebsiteIsInvalid"))) { out.print("<br />Choose a valid Official Website with a-z A-Z 0-9 . _ -  characters!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields">About <div class="TextAreaCounter"></div></td></tr>
				<tr><td class="tdLeft"><textarea id="TAAbout" class="required" name="about" cols="80" style="height: 800px; max-height: 800px;"><% if(session.getAttribute("aboutS") != null) { out.print(session.getAttribute("aboutS")); } %></textarea></td></tr>
				<tr><td class="tdLeft"><jsp:include page="AboutInstructions.jsp" flush="true" /></td></tr>
<% if("true".equals(session.getAttribute("AboutIsBiggerThanNCharacters")) || "true".equals(session.getAttribute("AboutHasMoreThanNLineBreaks"))
 || "true".equals(session.getAttribute("HasHTMLInjection"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("AboutIsBiggerThanNCharacters"))) { out.print("<br />About field can't be bigger than 20000 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("AboutHasMoreThanNLineBreaks"))) { out.print("<br />About field can't Have More than 100 Line Breaks!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("HasHTMLInjection"))) { out.print("<br />The Characters < and > Are Not Allowed In The About Field!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">Enter Captcha</span></td></tr>
				<tr><td class="tdLeft">
<%

	ReCaptcha c = ReCaptchaFactory.newReCaptcha("6LdQqvwSAAAAAMNiEciF2_Sp1xndgsleTvtiz7jV", "6LdQqvwSAAAAABKN8ktbyXwzsOsXzFHHCucctMcY", false);
	out.print(c.createRecaptchaHtml(null, null));

%>
				</td></tr>
<% if("true".equals(session.getAttribute("CaptchaIsWrong")))  { %>
				<tr>
					<td class="tdLeft"><span class="error">Incorrect Captcha! Enter Captcha Again!</span></td>
				</tr>
<% } %>

				<tr><td class="SpaceForFields"><input type="submit" value="Update" /></td></tr>

				</tbody>
				</table>
		</form>
<% } else { %>
		<form method="post" id="UpdateRecommended" action="UpdateRecommendedValidation.jsp" enctype="multipart/form-data">
				<table class="listras" style="border-spacing: 0px;">
				<thead>
				<tr>
				<td colspan="3">
<h1 class="Action">You Are Now Updating Something Recommended...</h1>
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
					<td class="tdRight">New Image</td>
					<td class="tdLeft"><input type="file" class="required" name="image" accept="image/*" id="PreviewImage" /><div id="DivImagePreview"></div></td>
					<td>Image can't be Bigger Than 50Kb and Only .jpg File Extensions Are Accepted!</td>
				</tr>
<% if("true".equals(session.getAttribute("ImageIsBiggerThan50KBytes")) || "true".equals(session.getAttribute("ImageExtensionIsNotAccepted"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("ImageIsBiggerThan50KBytes"))) { out.print("Image can't be Bigger Than 50Kb!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("ImageExtensionIsNotAccepted"))) { out.print("Only .jpg File Extensions Are Accepted!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight">Image Description</td><td class="tdLeft"><input type="text" class="required" name="description" size="50" value="<% if(session.getAttribute("descriptionS") != null) { out.print(session.getAttribute("descriptionS")); } %>"></td><td></td></tr>
<% if("true".equals(session.getAttribute("DescriptionIsBiggerThan50Characters")) || "true".equals(session.getAttribute("DescriptionIsInvalid"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("DescriptionIsBiggerThan50Characters"))) { out.print("Description Field Can't Be Bigger Than 50 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("DescriptionIsInvalid"))) { out.print("<br />Choose a Valid Description with a-z A-Z 0-9 Characters!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight">Country</td><td class="tdLeft"><select class="required" name="country">
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

				<tr><td class="tdRight">About</td><td class="tdLeft"><textarea id="TAAbout" class="required" name="about" cols="80" style="height: 800px; max-height: 800px;"><% if(session.getAttribute("aboutS") != null) { out.print(session.getAttribute("aboutS")); } %></textarea></td>
				<td><jsp:include page="AboutInstructions.jsp" flush="true" /><br /><br /><div class="TextAreaCounter"></div></td></tr>
<% if("true".equals(session.getAttribute("AboutIsBiggerThanNCharacters")) || "true".equals(session.getAttribute("AboutHasMoreThanNLineBreaks"))
 || "true".equals(session.getAttribute("HasHTMLInjection"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("AboutIsBiggerThanNCharacters"))) { out.print("<br />About field can't be bigger than 20000 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("AboutHasMoreThanNLineBreaks"))) { out.print("<br />About field can't Have More than 100 Line Breaks!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("HasHTMLInjection"))) { out.print("<br />The Characters < and > Are Not Allowed In The About Field!"); } %></span>
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

