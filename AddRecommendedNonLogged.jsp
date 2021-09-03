
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("AddRecommendedNonLogged");

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
	Long recommenderIdLogged = 3l;

	if(cookies != null) {

	for(Cookie cookie:cookies) {
 		if(cookie.getName().equals("IsRecommenderLogged")) {
			if(cookie.getValue().equals("Yes")) {
				isRecommenderLogged = true;
			}
		}
	}

	}

%>

<% if(isRecommenderLogged) { %>

	<jsp:forward page="/AddRecommended.jsp" />

<% } else { %>

<jsp:include page="GetDevice.jsp" flush="false" />

<%@ page import="net.tanesha.recaptcha.ReCaptcha" %>
<%@ page import="net.tanesha.recaptcha.ReCaptchaFactory" %>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="Recommending on Recommendation Book" />
<meta name="description" content="Recommending on Recommendation Book" />

<link rel="icon" href="./img/static/RBIcon.ico" type="image/x-icon">

<link href='http://fonts.googleapis.com/css?family=Roboto:500' rel='stylesheet' type='text/css'>

<style type="text/css">
<!--
   @import url("RecommendationBookCSS.css");

.ui-effects-transfer { border: 2px dotted gray; }

-->
</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookMobileCSS.css" />

<% } %>

<script src="js/jquery-1.10.2.js"></script>
<script src="js/jquery-ui.js"></script>
<script src="js/RecommendationBookJS.js"></script>
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
	'name': { required: true, maxlength: '50', regex: "^[a-zA-Z0-9\\s]+$" },
	'type': { required: true },
	'officialWebsite': { required: false, maxlength: '100', regex: "^([a-zA-Z0-9_.-]{1,100})$" },
	'about': { required: true, maxlength: '20000', hasMoreThanNLineBreaks: '100', checkForInvalidCharacters: true },
	'image': { required: true, extension: "jpg", imageCantBeBiggerThanNBytes: '51200' },
	'description': { required: false, maxlength: '50', regex: "^[a-zA-Z0-9\\s]+$" }
};

var messages = {
	'name': { required: "Name Field Cannot Be Empty!", maxlength: "Name Field Cannot Be Bigger Than 50 Characters!",
		 regex: "Choose a Valid Nickname With a-z A-Z 0-9 Characters!" },
	'description': { required: "Description Field Cannot Be Empty!", maxlength: "Description Field Cannot Be Bigger Than 50 Characters!",
		 regex: "Choose a Valid Description With a-z A-Z 0-9 Characters!" },
	'type': { required: "Type Field Cannot be Empty!" },
	'country': { required: "Country Field Cannot Be Empty!" },
	'about': { required: "About Field Cannot Be Empty!", maxlength: "About Field Cannot Be Bigger Than 20000 Characters!", hasMoreThanNLineBreaks: "About Field Cannot Have More Than 100 Line Breaks!" },
	'officialWebsite': { maxlength: "Official Website Field Cannot Be Bigger Than 100 Characters!", regex: "Choose a valid Official Website With a-z A-Z 0-9 . _ -  Characters!" },
	'image': { required: "Choose an Image!", extension: "Only .jpg File Extensions Are Accepted" }
};

	$("#AddRecommended").validate({rules:rules, messages:messages});

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
		<form method="post" id="AddRecommended" action="AddRecommendedValidationNonLogged.jsp" enctype="multipart/form-data">
				<table style="border-spacing: 0px;">
				<thead>
				<tr>
				<td>
<h1 class="Action">You Are Now Recommending Something...</h1><br />
<span class="Action"><span class="Nickname">This is the Page for Recommending an Entity to Recommendation Book for Non Registered Recommenders. 
If you Want to Register Click on the Link Register on the Upper Right Corner. If you Don't Want to Register but Want to Recommend, Fill all the Fields Below and Click the Button "Add to Recommendation Book" to Make your Recommendation Which Will Appear <a target="_blank" href="Recommender.jsp?id=3">Here</a>.</span></span><br /><br />
<span class="Action Bold">Fields in Bold Are Required / All Fileds Cannot Be Changed Later</span><br /><br />
<jsp:include page="FacebookGoogleInstructions.jsp" flush="true" />

				</td>
				</tr>
				</thead>
				<tbody>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">Name</span></td></tr>
				<t><td class="tdLeft"><input type="text" class="required" name="name" size="50" value="<% if(session.getAttribute("nameS") != null) { out.print(session.getAttribute("nameS")); } %>" /></td></tr><tr><td class="tdLeft"><span class="Nickname">First Fill up the Name of the Entity you are Recommending. It can be a Book, a Movie or an Album, for example. You can see all the Entities you can Recommend on the Field Type Below.</span></td></tr>
<% if("true".equals(session.getAttribute("NameCantBeEmpty")) || "true".equals(session.getAttribute("NameIsBiggerThan50Characters")) || "true".equals(session.getAttribute("NameIsInvalid"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("NameCantBeEmpty"))) { out.print("Name Field Can't Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("NameIsBiggerThan50Characters"))) { out.print("Name Field Can't Be Bigger Than 50 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("NameIsInvalid"))) { out.print("<br />Choose a Valid Name with a-z A-Z 0-9 Characters!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">Image</span></td></tr>
				<tr><td class="tdLeft"><input type="file" class="required" name="image" accept="image/*" id="PreviewImage" /></td></tr>
				<tr><td><div id="DivImagePreview"></div></td></tr>
				<tr><td class="tdLeft"><span class="Nickname">Choose an Image for the Entity that you are Recommending. The Image Cannot be Bigger Than 50Kb and Only .jpg File Extensions Are Accepted.</span></td></tr>
<% if("true".equals(session.getAttribute("ImageIsBiggerThan50KBytes")) || "true".equals(session.getAttribute("ImageExtensionIsNotAccepted")) || "true".equals(session.getAttribute("ImageCantBeEmpty"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("ImageCantBeEmpty"))) { out.print("Image Field Can't Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("ImageIsBiggerThan50KBytes"))) { out.print("Image Cannot be Bigger Than 50Kb!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("ImageExtensionIsNotAccepted"))) { out.print("Only .jpg File Extensions Are Accepted!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields">Image Description</td></tr>
				<tr><td class="tdLeft"><input type="text" class="required" name="description" size="50" value="<% if(session.getAttribute("descriptionS") != null) { out.print(session.getAttribute("descriptionS")); } %>" /></td></tr><tr><td class="tdLeft"><span class="Nickname">Type a Description for the Image you Chose Above. This Field is Optional.</span></td></tr>
<% if("true".equals(session.getAttribute("DescriptionIsBiggerThan50Characters")) || "true".equals(session.getAttribute("DescriptionIsInvalid"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("DescriptionIsBiggerThan50Characters"))) { out.print("Description Field Can't Be Bigger Than 50 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("DescriptionIsInvalid"))) { out.print("<br />Choose a Valid Description with a-z A-Z 0-9 Characters!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">Type</span></td></tr>
				<tr><td class="tdLeft"><select class="required" name="type"><jsp:include page="Type.jsp" flush="true" /></select></td></tr>
				<tr><td class="tdLeft"><span class="Nickname">Choose the Type of the Entity that you are Recommending.</span></td></tr>
<% if("true".equals(session.getAttribute("TypeIsNotSelected"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("TypeIsNotSelected"))) { out.print("Type field can't be Empty!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">Country</span></td></tr>
				<tr><td class="tdLeft"><select class="required" name="country"><jsp:include page="Countries.jsp?withWWE=Yes" flush="true" /></select></td></tr>
				<tr><td class="tdLeft"><span class="Nickname">Choose the Country of the Entity that you are Recommending. If it's an International Entity, Choose the First Option: "World Wide Entity".</span></td></tr>
<% if("true".equals(session.getAttribute("CountryIsNotSelected"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("CountryIsNotSelected"))) { out.print("Country field can't be Empty!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields">Official Website</td></tr>
				<tr><td class="tdLeft"><input type="text" class="required" name="officialWebsite" size="50" value="<% if(session.getAttribute("officialWebsiteS") != null) { out.print(session.getAttribute("officialWebsiteS")); } %>"></td></tr>
				<tr><td class="tdLeft"><span class="Nickname">Choose the Official Website of the Entity that you are Recommending. This Field is Optional.</span></td></tr>
<% if("true".equals(session.getAttribute("OfficialWebsiteIsBiggerThan100Characters")) || "true".equals(session.getAttribute("OfficialWebsiteIsInvalid"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("OfficialWebsiteIsBiggerThan100Characters"))) { out.print("<br />Official Website field can't be bigger than 100 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("OfficialWebsiteIsInvalid"))) { out.print("<br />Choose a valid Official Website with a-z A-Z 0-9 . _ -  characters!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">About</span> <div class="TextAreaCounter"></div></td></tr>
				<tr><td class="tdLeft"><textarea id="TAAbout" class="required" name="about" cols="55" style="height: 800px; max-height: 800px;"><% if(session.getAttribute("aboutS") != null) { out.print(session.getAttribute("aboutS")); } %></textarea></td></tr>
				<tr><td class="tdLeft"><jsp:include page="AboutInstructions.jsp" flush="true" /></td></tr>
<% if("true".equals(session.getAttribute("AboutIsBiggerThanNCharacters")) || "true".equals(session.getAttribute("AboutHasMoreThanNLineBreaks"))
 || "true".equals(session.getAttribute("HasHTMLInjection")) || "true".equals(session.getAttribute("AboutCantBeEmpty"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("AboutCantBeEmpty"))) { out.print("<br />About Field Can't Be Empty!"); } %></span>
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
				<tr><td class="tdLeft"><span class="Nickname">Enter the Captcha to Prove you are not a Machine.</span></td></tr>
<% if("true".equals(session.getAttribute("CaptchaIsWrong")))  { %>
				<tr>
					<td class="tdLeft"><span class="error">Incorrect Captcha! Enter Captcha Again!</span></td>
				</tr>
<% } %>

				<tr><td class="SpaceForFields"><input type="submit" value="Add To Recommendation Book" /></td></tr><tr><td class="tdLeft"><span class="Nickname">After Filling all the Fields Above. Take a Breath. Read Everything Again to Make Sure you Haven't Mistyped Anything and Click this Button to Make your Recommendation. Don't Worry We Won't Ask for your Credit Card in a Next Page. The Recommendation Book is Totally Free. Thanks for Using Recommendation Book!</span></td></tr>
				</tbody>
				</table>
		</form>
<% } else { %>
		<form method="post" id="AddRecommended" action="AddRecommendedValidationNonLogged.jsp" enctype="multipart/form-data">
				<div id="InputHiddens"></div>
				<table class="listras" style="border-spacing: 0px;">
				<thead>
				<tr>
				<td colspan="3">
<h1 class="Action">You Are Now Recommending Something...</h1><br />
<span class="Action"><span class="Nickname">This is the Page for Recommending an Entity to Recommendation Book for Non Registered Recommenders. 
If you Want to Register Click on the Link Register on the Upper Right Corner. If you Don't Want to Register but Want to Recommend, Fill all the Fields Below and Click the Button "Add to Recommendation Book" to Make your Recommendation Which Will Appear <a target="_blank" href="Recommender.jsp?id=3">Here</a>.</span></span><br /><br />
<span class="Action Bold">Fields in Bold Are Required / All Fileds Cannot Be Changed Later</span><br />
<jsp:include page="FacebookGoogleInstructions.jsp" flush="true" />

				</td>
				</tr>
				</thead>
				<tbody>

				<tr><td class="tdRight" style="width: 10%"><span class="Bold">Name</span></td><td class="tdLeft"><input type="text" class="required" name="name" size="50" value="<% if(session.getAttribute("nameS") != null) { out.print(session.getAttribute("nameS")); } %>" /></td><td><span class="Nickname">First Fill up the Name of the Entity you are Recommending. It can be a Book, a Movie or an Album, for example. You can see all the Entities you can Recommend on the Field Type Below.</span></td></tr>
<% if("true".equals(session.getAttribute("NameCantBeEmpty")) || "true".equals(session.getAttribute("NameIsBiggerThan50Characters")) || "true".equals(session.getAttribute("NameIsInvalid"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("NameCantBeEmpty"))) { out.print("Name Field Can't Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("NameIsBiggerThan50Characters"))) { out.print("Name Field Can't Be Bigger Than 50 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("NameIsInvalid"))) { out.print("<br />Choose a Valid Name with a-z A-Z 0-9 Characters!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr>
					<td class="tdRight"><span class="Bold">Image</span></td>
					<td class="tdLeft"><input type="file" class="required" name="image" accept="image/*" id="PreviewImage" /><div id="DivImagePreview"></div></td>
					<td><span class="Nickname">Choose an Image for the Entity that you are Recommending. The Image Cannot be Bigger Than 50Kb and Only .jpg File Extensions Are Accepted.</span></td>
				</tr>
<% if("true".equals(session.getAttribute("ImageIsBiggerThan50KBytes")) || "true".equals(session.getAttribute("ImageExtensionIsNotAccepted")) || "true".equals(session.getAttribute("ImageCantBeEmpty"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("ImageCantBeEmpty"))) { out.print("Image Field Can't Be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("ImageIsBiggerThan50KBytes"))) { out.print("Image Cannot be Bigger Than 50Kb!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("ImageExtensionIsNotAccepted"))) { out.print("Only .jpg File Extensions Are Accepted!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight">Image Description</td><td class="tdLeft"><input type="text" class="required" name="description" size="50" value="<% if(session.getAttribute("descriptionS") != null) { out.print(session.getAttribute("descriptionS")); } %>" /></td><td><span class="Nickname">Type a Description for the Image you Chose Above. This Field is Optional.</span></td></tr>
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

				<tr><td class="tdRight"><span class="Bold">Type</span></td><td class="tdLeft">
				<select class="required" name="type">
				<jsp:include page="Type.jsp" flush="true" />
				</select></td><td><span class="Nickname">Choose the Type of the Entity that you are Recommending.</span></td></tr>
<% if("true".equals(session.getAttribute("TypeIsNotSelected"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("TypeIsNotSelected"))) { out.print("Type field can't be Empty!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight"><span class="Bold">Country</span></td><td class="tdLeft"><select class="required" name="country">
				<jsp:include page="Countries.jsp?withWWE=Yes" flush="true" />
				</select></td><td><span class="Nickname">Choose the Country of the Entity that you are Recommending. If it's an International Entity, Choose the First Option: "World Wide Entity".</span></td></tr>
<% if("true".equals(session.getAttribute("CountryIsNotSelected"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("CountryIsNotSelected"))) { out.print("Country field can't be Empty!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight">Official Website</td><td class="tdLeft"><input type="text" class="required" name="officialWebsite" size="50" value="<% if(session.getAttribute("officialWebsiteS") != null) { out.print(session.getAttribute("officialWebsiteS")); } %>"></td><td><span class="Nickname">Choose the Official Website of the Entity that you are Recommending. This Field is Optional.</span></td></tr>
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

				<tr><td class="tdRight"><span class="Bold">About</span></td><td class="tdLeft"><textarea id="TAAbout" class="required" name="about" cols="55" style="height: 800px; max-height: 800px;"><% if(session.getAttribute("aboutS") != null) { out.print(session.getAttribute("aboutS")); } %></textarea></td>
				<td><jsp:include page="AboutInstructions.jsp" flush="true" /><br /><br /><div class="TextAreaCounter"></div></td></tr>
<% if("true".equals(session.getAttribute("AboutIsBiggerThanNCharacters")) || "true".equals(session.getAttribute("AboutHasMoreThanNLineBreaks"))
 || "true".equals(session.getAttribute("HasHTMLInjection")) || "true".equals(session.getAttribute("AboutCantBeEmpty"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("AboutCantBeEmpty"))) { out.print("<br />About Field Can't Be Empty!"); } %></span>
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
				<td><span class="Nickname">Enter the Captcha to Prove you are not a Machine.</span></td>
				</tr>
<% if("true".equals(session.getAttribute("CaptchaIsWrong")))  { %>
				<tr>
					<td></td><td><span class="error">Incorrect Captcha! Enter Captcha Again!</span></td><td></td>
				</tr>
<% } %>

				<tr><td class="tdRight"></td><td class="tdLeft"><input type="submit" value="Add To Recommendation Book" /></td><td><span class="Nickname">After Filling all the Fields Above. Take a Breath. Read Everything Again to Make Sure you Haven't Mistyped Anything and Click this Button to Make your Recommendation. Don't Worry We Won't Ask for your Credit Card in a Next Page. This is not a Dating Website. The Recommendation Book is Totally Free. Thanks for Using Recommendation Book!</span></td></tr>
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
