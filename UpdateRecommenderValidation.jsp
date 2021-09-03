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

	if(fv.isBiggerThanNCharacters(ac.getField("password"), 50, "PasswordIsBiggerThan50Characters")) { containError = true; }
	if(fv.isBiggerThanNCharacters(ac.getField("rpassword"), 50, "RPasswordIsBiggerThan50Characters")) { containError = true; }

	if(fv.isEmpty(ac.getField("sex"), "SexIsNotSelected")) { containError = true; }
	if(fv.isEmpty(ac.getField("country"), "CountryIsNotSelected")) { containError = true; }
	if(fv.isEmpty(ac.getField("year"), "YearIsNotSelected")) { containError = true; }
	if(fv.isEmpty(ac.getField("month"), "MonthIsNotSelected")) { containError = true; }
	if(fv.isEmpty(ac.getField("day"), "DayIsNotSelected")) { containError = true; }

	if(fv.isBiggerThanNCharacters(ac.getField("officialWebsite"), 100, "OfficialWebsiteIsBiggerThan100Characters")) { containError = true; }

	if(fv.isTextAreaBiggerThanNCharacters(ac.getField("about"), 750, "AboutIsBiggerThan750Characters")) { containError = true; }
	if(fv.hasTextAreaMoreThanNLineBreaks(ac.getField("about"), 15, "AboutHasMoreThan15LineBreaks")) { containError = true; }

	if(fv.isFileBiggerThanNBytes(ac.getFileSize("image"), 51200l, "ImageIsBiggerThan50KBytes")) { containError = true; }
	session.setAttribute("ImageExtensionIsNotAccepted", "");
	if(!(ac.getFileExtension("image").equals(""))) {
		if(fv.isFileExtensionNotAccepted(ac.getFileExtension("image"), "ImageExtensionIsNotAccepted")) { containError = true; }
	}

	if(fv.isCaptchaWrong(ac.getField("recaptcha_challenge_field"), ac.getField("recaptcha_response_field"), "CaptchaIsWrong")) { containError = true; }

	session.setAttribute("DateIsInvalid", "");
	session.setAttribute("PasswordsAreNotEqual", "");
	session.setAttribute("PasswordsAreInvalid", "");
	session.setAttribute("OfficialWebsiteIsInvalid", "");
	session.setAttribute("HasHTMLInjection", "");

	/* Cria variáveis de sessão que seráo utilizadas para salvar os campos que já foram anteriormente preenchidos pelo usuário.
	 */
	session.setAttribute("passwordS", ac.getField("password"));
	session.setAttribute("officialWebsiteS", ac.getField("officialWebsite"));
	session.setAttribute("sexS", ac.getField("sex"));
	session.setAttribute("countryS", ac.getField("country"));
	session.setAttribute("yearS", ac.getField("year"));
	session.setAttribute("monthS", ac.getField("month"));
	session.setAttribute("dayS", ac.getField("day"));
	session.setAttribute("aboutS", ac.getField("about"));
	session.setAttribute("image", ac.getFile("image"));
	session.setAttribute("imageTamanho", ac.getFileSize("image"));

	Validation v = new Validation();

	if(v.isDateValid(ac.getField("year"), ac.getField("month"), ac.getField("day")) == false) {
		session.setAttribute("DateIsInvalid", "true");
		containError = true;
	}

	if(ac.getField("password").equals(ac.getField("rpassword")) == false) {
		session.setAttribute("PasswordsAreNotEqual", "true");
		containError = true;
	}

	if(!ac.getField("password").equals("") && !ac.getField("rpassword").equals("")) {
		if(ac.getField("password").equals(ac.getField("rpassword")) == true) {
			if(v.isPasswordValid(ac.getField("password")) == false) {
				session.setAttribute("PasswordsAreInvalid", "true");
				containError = true;
			}
		}
	}

	if(v.hasHTMLInjection(ac.getField("about")) == true) {
		session.setAttribute("HasHTMLInjection", "true");
		containError = true;
	}

	if(!ac.getField("officialWebsite").equals("")) {
		if(v.isWebsiteValid(ac.getField("officialWebsite")) == false) {
			session.setAttribute("OfficialWebsiteIsInvalid", "true");
			containError = true;
		}
	}

	if(containError) {
		response.sendRedirect("UpdateRecommender.jsp");
	} else {
		response.sendRedirect("SaveUpdateRecommender.jsp");
	}

%>