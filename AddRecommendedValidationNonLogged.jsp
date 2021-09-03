<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>

<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

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

	if(fv.isEmpty(ac.getField("name"), "NameCantBeEmpty")) { containError = true; }
	if(fv.isBiggerThanNCharacters(ac.getField("name"), 50, "NameIsBiggerThan50Characters")) { containError = true; }
	if(fv.isEmpty(ac.getField("type"), "TypeIsNotSelected")) { containError = true; }
	if(fv.isEmpty(ac.getField("country"), "CountryIsNotSelected")) { containError = true; }
	if(fv.isEmpty(ac.getField("about"), "AboutCantBeEmpty")) { containError = true; }
	if(fv.isFileEmpty(ac.getFileSize("image"), "ImageCantBeEmpty")) { containError = true; }

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

	/* Cria variáveis de sessão que seráo utilizadas para exibir os erros pertinentes a cada preenchimento incorrento do usuário.
	 */
	session.setAttribute("NameIsInvalid", "");
	session.setAttribute("DescriptionIsInvalid", "");
	session.setAttribute("OfficialWebsiteIsInvalid", "");
	session.setAttribute("PasswordsAreInvalid", "");
	session.setAttribute("HasHTMLInjection", "");

	/* Cria variáveis de sessão que seráo utilizadas para salvar os campos que já foram anteriormente preenchidos pelo usuário.
	 */
	session.setAttribute("nameS", ac.getField("name"));
	session.setAttribute("typeS", ac.getField("type"));
	session.setAttribute("countryS", ac.getField("country"));
	session.setAttribute("officialWebsiteS", ac.getField("officialWebsite"));
	session.setAttribute("aboutS", ac.getField("about"));
	session.setAttribute("image", ac.getFile("image"));
	session.setAttribute("imageExtension", ac.getFileExtension("image"));
	session.setAttribute("descriptionS", ac.getField("description"));
	session.setAttribute("imageTamanho", ac.getFileSize("image"));

	Validation v = new Validation();

	if(v.isNameValid(ac.getField("name")) == false) {
		session.setAttribute("NameIsInvalid", "true");
		containError = true;
	}

	if(!ac.getField("description").equals("")) {
		if(v.isDescriptionValid(ac.getField("description")) == false) {
			session.setAttribute("DescriptionIsInvalid", "true");
			containError = true;
		}
	}

	if(!ac.getField("officialWebsite").equals("")) {
		if(v.isWebsiteValid(ac.getField("officialWebsite")) == false) {
			session.setAttribute("OfficialWebsiteIsInvalid", "true");
			containError = true;
		}
	}

	if(v.hasHTMLInjection(ac.getField("about")) == true) {
		session.setAttribute("HasHTMLInjection", "true");
		containError = true;
	}

	if(containError) {
		response.sendRedirect("AddRecommendedNonLogged.jsp");
	} else {
		response.sendRedirect("SaveRecommendedNonLogged.jsp");
	}

%>