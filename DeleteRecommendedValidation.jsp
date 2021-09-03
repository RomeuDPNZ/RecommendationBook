
<%@ page import="recBook.ApacheCommons" %>
<%@ page import="org.apache.commons.fileupload.FileUploadException" %>

<%@ page import="recBook.FormValidation" %>

<%

	ApacheCommons ac = null;

	try {

		ac = new ApacheCommons(request);

	} catch(FileUploadException e) {
	} finally {}

	FormValidation fv = new FormValidation(request);
	Boolean containError = false;

	if(fv.isCaptchaWrong(ac.getField("recaptcha_challenge_field"), ac.getField("recaptcha_response_field"), "CaptchaIsWrong")) { containError = true; }

	if(containError) {
		response.sendRedirect("DeleteRecommended.jsp");
	} else {
		response.sendRedirect("SaveDeleteRecommended.jsp");
	}

%>