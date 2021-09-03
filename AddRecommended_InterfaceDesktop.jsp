
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("AddRecommended");

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

<% if(!isRecommenderLogged) { %>

	<jsp:forward page="/AddRecommendedNonLogged.jsp" />

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
	'about': { required: false, maxlength: '20000', hasMoreThanNLineBreaks: '100', checkForInvalidCharacters: true },
	'image': { required: false, extension: "jpg", imageCantBeBiggerThanNBytes: '51200' },
	'description': { required: false, maxlength: '50', regex: "^[a-zA-Z0-9\\s]+$" }
};

var messages = {
	'name': { required: "Name Field Cannot Be Empty!", maxlength: "Name Field Cannot Be Bigger Than 50 Characters!",
		 regex: "Choose a Valid Nickname With a-z A-Z 0-9 Characters!" },
	'description': { required: "Description Field Cannot Be Empty!", maxlength: "Description Field Cannot Be Bigger Than 50 Characters!",
		 regex: "Choose a Valid Description With a-z A-Z 0-9 Characters!" },
	'type': { required: "Type Field Cannot be Empty!" },
	'country': { required: "Country Field Cannot Be Empty!" },
	'about': { maxlength: "About Field Cannot Be Bigger Than 20000 Characters!", hasMoreThanNLineBreaks: "About Field Cannot Have More Than 100 Line Breaks!" },
	'officialWebsite': { maxlength: "Official Website Field Cannot Be Bigger Than 100 Characters!", regex: "Choose a valid Official Website With a-z A-Z 0-9 . _ -  Characters!" },
	'image': { extension: "Only .jpg File Extensions Are Accepted" }
};

	$("#AddRecommended").validate({rules:rules, messages:messages});

});

//-->
</script>

</head>

<body>

<div class="Geral">
	<jsp:include page="MiniMenu.jsp" flush="true" />
	<div class="Corpo">
		<form method="post" id="AddRecommended" action="AddRecommendedValidation.jsp" enctype="multipart/form-data">
				<div id="InputHiddens"></div>
				<table class="listras" style="border-spacing: 0px;">
				<thead>
				<tr>
				<td colspan="3">
<h1 class="Action">You Are Now Recommending Something...</h1><br />
<span class="Action Bold">Fields in Bold Are Required</span>
				</td>
				</tr>
				</thead>
				<tbody>

				<tr><td class="tdRight" style="width: 10%"><span class="Bold">Name</span></td><td class="tdLeft"><input type="text" class="required" name="name" size="50" value="<% if(session.getAttribute("nameS") != null) { out.print(session.getAttribute("nameS")); } %>" /></td><td><span class="CantBeChanged">Attention. You Cannot Change the Name Later. Type Carefully.</span></td></tr>
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
					<td class="tdRight">Image</td>
					<td class="tdLeft"><input type="file" class="required" name="image" accept="image/*" id="PreviewImage" /><div id="DivImagePreview"></div></td>
					<td><span class="Nickname">Image Cannot Be Bigger Than 50Kb and Only .jpg File Extensions Are Accepted</span></td>
				</tr>
<% if("true".equals(session.getAttribute("ImageIsBiggerThan50KBytes")) || "true".equals(session.getAttribute("ImageExtensionIsNotAccepted"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("ImageIsBiggerThan50KBytes"))) { out.print("Image Cannot be Bigger Than 50Kb!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("ImageExtensionIsNotAccepted"))) { out.print("Only .jpg File Extensions Are Accepted!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight">Image Description</td><td class="tdLeft"><input type="text" class="required" name="description" size="50" value="<% if(session.getAttribute("descriptionS") != null) { out.print(session.getAttribute("descriptionS")); } %>" /></td><td></td></tr>
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
				</select></td><td><span class="CantBeChanged">Attention. You Cannot Change the Type Later. Choose Carefully.</span></td></tr>
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
				<td><span class="Nickname"><jsp:include page="AboutInstructions.jsp" flush="true" /></span><br /><br /><div class="TextAreaCounter"></div></td></tr>
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

<%

	
	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	/*
	 * Conta Todas as Adições do Últimos Dias/Semanas/Meses
	 */

	Long recs = 0l;
	Long maxRecs = 300l;

	try {

PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM Recommended WHERE Recommender = ? AND CreatedOn >= NOW() - INTERVAL 1 MONTH");
		ps.setLong(1, recommenderIdLogged);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			recs = result.getLong(1);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	/*
	 * Desconecta do Banco de Dados
	 */

	if(db.conexao != null) {
		db.DesconectaDB();
	}

%>

<% if(recs >= maxRecs) { %>

				<tr><td class="tdRight"><span class="Bold">Enter Captcha</span></td>
				<td class="tdLeft"><input type="hidden" name="WithCaptcha" value="true" />
<%

	ReCaptcha c = ReCaptchaFactory.newReCaptcha("6LdQqvwSAAAAAMNiEciF2_Sp1xndgsleTvtiz7jV", "6LdQqvwSAAAAABKN8ktbyXwzsOsXzFHHCucctMcY", false);
	out.print(c.createRecaptchaHtml(null, null));

%>
				</td>
				<td><span class="Nickname">You Are Being Asked To Insert Captcha Because You Added More Than <%= maxRecs.toString() %> Entities In The Last Month.</span></td>
				</tr>
<% if("true".equals(session.getAttribute("CaptchaIsWrong")))  { %>
				<tr>
					<td></td><td><span class="error">Incorrect Captcha! Enter Captcha Again!</span></td><td></td>
				</tr>
<% } %>

<% } else { %>

<input type="hidden" name="WithCaptcha" value="false" />

<% } %>

				<tr><td class="tdRight"></td><td class="tdLeft"><input type="submit" value="Add To Recommendation Book" /></td><td></td></tr>
				</tbody>
				</table>
		</form>
	</div>
	<jsp:include page="Rodape.jsp" flush="true" />
</div>

</body>
 
</html>

<% } %>
