<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>

<%@ include file="Validation.jsp" %>
<%@ page import="recBook.ApacheCommons" %>
<%@ page import="org.apache.commons.fileupload.FileUploadException" %>
<%@ page import="recBook.FormValidation" %>

<%

	ApacheCommons ac = null;

	try {

		ac = new ApacheCommons(request);

	} catch(FileUploadException e) {
		System.err.println("FileUploadException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new FileUploadException(e.getMessage()+" Page: "+pageName);
		}
	} finally {}

	FormValidation fv = new FormValidation(request);
	Boolean containError = false;

	if(fv.isEmpty(ac.getField("country"), "CountryIsNotSelected")) { containError = true; }

	if(fv.isBiggerThanNCharacters(ac.getField("officialWebsite"), 100, "OfficialWebsiteIsBiggerThan100Characters")) { containError = true; }

	if(fv.isTextAreaBiggerThanNCharacters(ac.getField("about"), 20000, "AboutIsBiggerThanNCharacters")) { containError = true; }
	if(fv.hasTextAreaMoreThanNLineBreaks(ac.getField("about"), 100, "AboutHasMoreThanNLineBreaks")) { containError = true; }

	if(fv.isFileBiggerThanNBytes(ac.getFileSize("image"), 51200l, "ImageIsBiggerThan50KBytes")) { containError = true; }
	session.setAttribute("ImageExtensionIsNotAccepted", "");
	if(!(ac.getFileExtension("image").equals(""))) {
		if(fv.isFileExtensionNotAccepted(ac.getFileExtension("image"), "ImageExtensionIsNotAccepted")) { containError = true; }
	}
	if(fv.isBiggerThanNCharacters(ac.getField("description"), 50, "DescriptionIsBiggerThan50Characters")) { containError = true; }

	if(fv.isCaptchaWrong(ac.getField("recaptcha_challenge_field"), ac.getField("recaptcha_response_field"), "CaptchaIsWrong")) { containError = true; }

	session.setAttribute("DescriptionIsInvalid", "");
	session.setAttribute("OfficialWebsiteIsInvalid", "");
	session.setAttribute("HasHTMLInjection", "");

	/* Cria variáveis de sessão que seráo utilizadas para salvar os campos que já foram anteriormente preenchidos pelo usuário.
	 */
	session.setAttribute("countryS", ac.getField("country"));
	session.setAttribute("officialWebsiteS", ac.getField("officialWebsite"));
	session.setAttribute("aboutS", ac.getField("about"));
	session.setAttribute("image", ac.getFile("image"));
	session.setAttribute("imageTamanho", ac.getFileSize("image"));
	session.setAttribute("descriptionS", ac.getField("description"));

	Validation v = new Validation();

	if(!ac.getField("officialWebsite").equals("")) {
		if(v.isWebsiteValid(ac.getField("officialWebsite")) == false) {
			session.setAttribute("OfficialWebsiteIsInvalid", "true");
			containError = true;
		}
	}

	if(!ac.getField("about").equals("")) {
		if(v.hasHTMLInjection(ac.getField("about")) == true) {
			session.setAttribute("HasHTMLInjection", "true");
			containError = true;
		}
	}

	if(!ac.getField("description").equals("")) {
		if(v.isDescriptionValid(ac.getField("description")) == false) {
			session.setAttribute("DescriptionIsInvalid", "true");
			containError = true;
		}
	}

	if(containError) {
		response.sendRedirect("UpdateRecommended.jsp");
	} else {
		response.sendRedirect("SaveUpdateRecommended.jsp");
	}

%>