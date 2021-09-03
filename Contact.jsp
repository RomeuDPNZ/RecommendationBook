
<%@ page errorPage="Error.jsp" %>

<jsp:include page="GetDevice.jsp" flush="true" />

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("Contact");

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

<!DOCTYPE htm>

<html lang="en-US">

<head>
 
<title>Contact</title>
 
<meta name="keywords" content="Contact Recommendation Book" />
<meta name="description" content="Contact Recommendation Book" />

<link rel="icon" href="./img/static/RBIcon.ico" type="image/x-icon">

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
<script type="text/javascript" src="js/TextAreaCounter.js"></script>

<script type="text/javascript" src="js/jquery.validate.js"></script>
<script type="text/javascript" src="js/jquery.validate.min.js"></script>
<script type="text/javascript" src="js/additional-methods.js"></script>
<script type="text/javascript" src="js/additional-methods.min.js"></script>

<script type="text/javascript" src="js/ValidateMethods.js"></script>

<script type="text/javascript"> 
<!--

$(document).ready(function(){

	TextAreaCounter("#TAMessage", "div.TextAreaCounter", 750);

var rules = {
	'email': { required: true, maxlength: '100', regex: "^([a-zA-Z0-9_.-]+)@([a-zA-Z0-9_.-]+)$" },
	'subject': { required: true, maxlength: '100', regex: "^([a-zA-Z0-9\\s]+)$" },
	'message': { required: true, maxlength: '750', hasMoreThanNLineBreaks: '15' },
};

var messages = {
	'message': { required: "Message Field Cannot Be Empty!", 
		maxlength: "Message Field Cannot Be Bigger Than 750 Characters!", 
		hasMoreThanNLineBreaks: "Message Field Cannot Have More Than 15 Line Breaks!" },
	'email': { required: "E-mail Field Cannot Be Empty!", 
		maxlength: "E-mail Field Cannot Be Bigger Than 100 Characters!", 
		regex: "Type a Valid E-mail!" },
	'subject': { required: "Subject Field Cannot Be Empty!", 
		maxlength: "Subject Field Cannot Be Bigger Than 100 Characters!", 
		regex: "Type a Valid Subject With a-z A-Z 0-9 Characters!" }
};

	$("#Contact").validate({rules:rules, messages:messages});

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

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
	<div class="Corpo">
		<form method="post" id="Contact" action="ContactValidation.jsp" enctype="multipart/form-data">
				<table style="border-spacing: 0px;">
				<thead>
				<tr>
				<td>
<h1 class="Action">You Are Now Contacting Recommendation Book...</h1><br />
<span class="Action Bold">All Fields Are Required</span>
				</td>
				</tr>
				</thead>
				<tbody>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">Your E-mail</span></td></tr>
				<tr><td class="tdLeft"><input type="email" class="required" name="email" value="<% if(session.getAttribute("emailS") != null) { out.print(session.getAttribute("emailS")); } %>"></td></tr>
<% if("true".equals(session.getAttribute("EmailCantBeEmpty")) || "true".equals(session.getAttribute("EmailIsBiggerThan100Characters")) || "true".equals(session.getAttribute("EmailIsInvalid"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("EmailCantBeEmpty"))) { out.print("Email field can't be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("EmailIsBiggerThan100Characters"))) { out.print("Email field can't be bigger than 100 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("EmailIsInvalid"))) { out.print("<br />Type a Valid Email!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">Subject</span></td></tr>
				<tr><td class="tdLeft"><input type="text" class="required" name="subject" value="<% if(session.getAttribute("subjectS") != null) { out.print(session.getAttribute("subjectS")); } %>"></td></tr>
<% if("true".equals(session.getAttribute("SubjectCantBeEmpty")) || "true".equals(session.getAttribute("SubjectIsBiggerThan100Characters")) || "true".equals(session.getAttribute("SubjectIsInvalid"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("SubjectCantBeEmpty"))) { out.print("Subject field can't be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("SubjectIsBiggerThan100Characters"))) { out.print("Subject field can't be bigger than 100 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("SubjectIsInvalid"))) { out.print("<br />Type a Valid Subject With a-z A-Z 0-9 Characters!"); } %></span>
					</td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields"><span class="Bold">Your Message</span> <div class="TextAreaCounter"></div></td></tr>
				<tr><td class="tdLeft"><textarea id="TAMessage" class="required" name="message" style="height: 250px; max-height: 250px;"><% if(session.getAttribute("messageS") != null) { out.print(session.getAttribute("messageS")); } %></textarea></td></tr>
<% if("true".equals(session.getAttribute("MessageCantBeEmpty")) || "true".equals(session.getAttribute("MessageIsBiggerThan750Characters")) || "true".equals(session.getAttribute("MessageHasMoreThan15LineBreaks")) || "true".equals(session.getAttribute("MessageHasHTMLInjection"))) { %>
				<tr>
					<td class="tdLeft">
<span class="error"><% if("true".equals(session.getAttribute("MessageCantBeEmpty"))) { out.print("Message field can't be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("MessageIsBiggerThan750Characters"))) { out.print("Message field can't be bigger than 750 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("MessageHasMoreThan15LineBreaks"))) { out.print("Message field can't Have More than 15 Line Breaks!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("MessageHasHTMLInjection"))) { out.print("<br />The Characters < and > Are Not Allowed In The Message Field!"); } %></span>
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
<% if("true".equals(session.getAttribute("CaptchaIsWrong")))  { %>
				<tr>
					<td class="tdLeft"><span class="error">Incorrect Captcha! Enter Captcha Again!</span></td>
				</tr>
<% } %>

				<tr><td class="tdLeft SpaceForFields"><input type="submit" value="Send Message" /></td></tr>

				</tbody>
				</table>
		</form>
	</div>
<% } else { %>
	<div class="Corpo">
		<form method="post" id="Contact" action="ContactValidation.jsp" enctype="multipart/form-data">
				<table class="listras" style="border-spacing: 0px;">
				<thead>
				<tr>
				<td colspan="3">
<h1 class="Action">You Are Now Contacting Recommendation Book...</h1><br />
<span class="Action Bold">All Fields Are Required</span>
				</td>
				</tr>
				</thead>
				<tbody>

				<tr><td class="tdRight" style="width: 40%"><span class="Bold">Your E-mail</span></td><td class="tdLeft"><input type="email" class="required" name="email" size="50" value="<% if(session.getAttribute("emailS") != null) { out.print(session.getAttribute("emailS")); } %>"></td><td></td></tr>
<% if("true".equals(session.getAttribute("EmailCantBeEmpty")) || "true".equals(session.getAttribute("EmailIsBiggerThan100Characters")) || "true".equals(session.getAttribute("EmailIsInvalid"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("EmailCantBeEmpty"))) { out.print("Email field can't be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("EmailIsBiggerThan100Characters"))) { out.print("Email field can't be bigger than 100 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("EmailIsInvalid"))) { out.print("<br />Type a Valid Email!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight"><span class="Bold">Subject</span></td><td class="tdLeft"><input type="text" class="required" name="subject" size="50" value="<% if(session.getAttribute("subjectS") != null) { out.print(session.getAttribute("subjectS")); } %>"></td><td></td></tr>
<% if("true".equals(session.getAttribute("SubjectCantBeEmpty")) || "true".equals(session.getAttribute("SubjectIsBiggerThan100Characters")) || "true".equals(session.getAttribute("SubjectIsInvalid"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("SubjectCantBeEmpty"))) { out.print("Subject field can't be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("SubjectIsBiggerThan100Characters"))) { out.print("Subject field can't be bigger than 100 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("SubjectIsInvalid"))) { out.print("<br />Type a Valid Subject With a-z A-Z 0-9 Characters!"); } %></span>
					</td>
					<td></td>
				</tr>
<% } %>

				<tr><td class="tdRight"><span class="Bold">Your Message</span></td>
				<td class="tdLeft"><textarea id="TAMessage" class="required" name="message" cols="50" style="height: 250px; max-height: 250px;"><% if(session.getAttribute("messageS") != null) { out.print(session.getAttribute("messageS")); } %></textarea></td><td><div class="TextAreaCounter"></div></td></tr>
<% if("true".equals(session.getAttribute("MessageCantBeEmpty")) || "true".equals(session.getAttribute("MessageIsBiggerThan750Characters")) || "true".equals(session.getAttribute("MessageHasMoreThan15LineBreaks")) || "true".equals(session.getAttribute("MessageHasHTMLInjection"))) { %>
				<tr>
					<td></td>
					<td>
<span class="error"><% if("true".equals(session.getAttribute("MessageCantBeEmpty"))) { out.print("Message field can't be Empty!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("MessageIsBiggerThan750Characters"))) { out.print("Message field can't be bigger than 750 Characters!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("MessageHasMoreThan15LineBreaks"))) { out.print("Message field can't Have More than 15 Line Breaks!"); } %></span>
<span class="error"><% if("true".equals(session.getAttribute("MessageHasHTMLInjection"))) { out.print("<br />The Characters < and > Are Not Allowed In The Message Field!"); } %></span>
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

				<tr><td class="tdRight"></td><td class="tdLeft"><input type="submit" value="Send Message" /></td><td></td></tr>

				</tbody>
				</table>
		</form>
	</div>
<% } %>

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
	<jsp:include page="RodapeMobile.jsp" flush="true" />
<% } else { %>
	<jsp:include page="Rodape.jsp" flush="true" />
<% } %>

</div>

</body>
 
</html>
