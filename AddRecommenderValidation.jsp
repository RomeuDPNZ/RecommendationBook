<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %> 

<%@ include file="Validation.jsp" %>
<%@ page import="recBook.DoesRecommenderExists" %>
<%@ page import="recBook.EmailDAO" %>
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

	if(fv.isEmpty(ac.getField("nickName"), "NickNameCantBeEmpty")) { containError = true; }
	if(fv.isBiggerThanNCharacters(ac.getField("nickName"), 50, "NickNameIsBiggerThan50Characters")) { containError = true; }
	if(fv.isEmpty(ac.getField("sex"), "SexIsNotSelected")) { containError = true; }
	if(fv.isEmpty(ac.getField("country"), "CountryIsNotSelected")) { containError = true; }
	if(fv.isEmpty(ac.getField("year"), "YearIsNotSelected")) { containError = true; }
	if(fv.isEmpty(ac.getField("month"), "MonthIsNotSelected")) { containError = true; }
	if(fv.isEmpty(ac.getField("day"), "DayIsNotSelected")) { containError = true; }
	if(fv.isBiggerThanNCharacters(ac.getField("officialWebsite"), 100, "OfficialWebsiteIsBiggerThan100Characters")) { containError = true; }
	if(fv.isEmpty(ac.getField("email"), "EmailCantBeEmpty")) { containError = true; }
	if(fv.isEmpty(ac.getField("remail"), "REmailCantBeEmpty")) { containError = true; }
	if(fv.isBiggerThanNCharacters(ac.getField("email"), 100, "EmailIsBiggerThan100Characters")) { containError = true; }
	if(fv.isBiggerThanNCharacters(ac.getField("remail"), 100, "REmailIsBiggerThan100Characters")) { containError = true; }
	if(fv.isEmpty(ac.getField("password"), "PasswordCantBeEmpty")) { containError = true; }
	if(fv.isEmpty(ac.getField("rpassword"), "RPasswordCantBeEmpty")) { containError = true; }
	if(fv.isBiggerThanNCharacters(ac.getField("password"), 50, "PasswordIsBiggerThan50Characters")) { containError = true; }
	if(fv.isBiggerThanNCharacters(ac.getField("rpassword"), 50, "RPasswordIsBiggerThan50Characters")) { containError = true; }

	if(fv.isTextAreaBiggerThanNCharacters(ac.getField("about"), 750, "AboutIsBiggerThan750Characters")) { containError = true; }
	if(fv.hasTextAreaMoreThanNLineBreaks(ac.getField("about"), 15, "AboutHasMoreThan15LineBreaks")) { containError = true; }

	if(fv.isFileBiggerThanNBytes(ac.getFileSize("image"), 50000l, "ImageIsBiggerThan50KBytes")) { containError = true; }
	session.setAttribute("ImageExtensionIsNotAccepted", "");
	if(!(ac.getFileExtension("image").equals(""))) {
		if(fv.isFileExtensionNotAccepted(ac.getFileExtension("image"), "ImageExtensionIsNotAccepted")) { containError = true; }
	}

	if(fv.isCaptchaWrong(ac.getField("recaptcha_challenge_field"), ac.getField("recaptcha_response_field"), "CaptchaIsWrong")) { containError = true; }

	/* Cria variáveis de sessão que seráo utilizadas para exibir os erros pertinentes a cada preenchimento incorrento do usuário.
	 */
	session.setAttribute("NickNameIsInvalid", "");
	session.setAttribute("NickNameAlreadyTaken", "");
	session.setAttribute("DateIsInvalid", "");
	session.setAttribute("EmailIsInvalid", "");
	session.setAttribute("REmailIsInvalid", "");
	session.setAttribute("EmailsAreNotEqual", "");
	session.setAttribute("PasswordsAreNotEqual", "");
	session.setAttribute("EmailAlreadyRegistered", "");
	session.setAttribute("OfficialWebsiteIsInvalid", "");
	session.setAttribute("PasswordsAreInvalid", "");
	session.setAttribute("HasHTMLInjection", "");

	/* Cria variáveis de sessão que seráo utilizadas para salvar os campos que já foram anteriormente preenchidos pelo usuário.
	 */
	session.setAttribute("nickNameS", ac.getField("nickName"));
	session.setAttribute("sexS", ac.getField("sex"));
	session.setAttribute("countryS", ac.getField("country"));
	session.setAttribute("yearS", ac.getField("year"));
	session.setAttribute("monthS", ac.getField("month"));
	session.setAttribute("dayS", ac.getField("day"));
	session.setAttribute("officialWebsiteS", ac.getField("officialWebsite"));
	session.setAttribute("aboutS", ac.getField("about"));
	session.setAttribute("emailS", ac.getField("email"));
	session.setAttribute("remailS", ac.getField("remail"));
	session.setAttribute("passwordS", ac.getField("password"));
	session.setAttribute("image", ac.getFile("image"));
	session.setAttribute("imageExtension", ac.getFileExtension("image"));
	session.setAttribute("imageTamanho", ac.getFileSize("image"));

	Validation v = new Validation();

	if(v.isNicknameValid(ac.getField("nickName")) == false) {
		session.setAttribute("NickNameIsInvalid", "true");
		containError = true;
	}

	if(v.isDateValid(ac.getField("year"), ac.getField("month"), ac.getField("day")) == false) {
		session.setAttribute("DateIsInvalid", "true");
		containError = true;
	}

	if(v.isEmailValid(ac.getField("email")) == false) {
		session.setAttribute("EmailIsInvalid", "true");
		containError = true;
	}

	if(v.isEmailValid(ac.getField("remail")) == false) {
		session.setAttribute("REmailIsInvalid", "true");
		containError = true;
	}

	if(ac.getField("email").equals(ac.getField("remail")) == false) {
		session.setAttribute("EmailsAreNotEqual", "true");
		containError = true;
	}

	if(ac.getField("password").equals(ac.getField("rpassword")) == false) {
		session.setAttribute("PasswordsAreNotEqual", "true");
		containError = true;
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

	if(ac.getField("password").equals(ac.getField("rpassword")) == true) {
		if(v.isPasswordValid(ac.getField("password")) == false) {
			session.setAttribute("PasswordsAreInvalid", "true");
			containError = true;
		}
	}

	if(!("".equals(ac.getField("nickName")))) {

		Long wasFound = new DoesRecommenderExists().check(ac.getField("nickName"));

		if(wasFound >= 1) {
			session.setAttribute("NickNameAlreadyTaken", "true");
			containError = true;
		}

	}

	if(!("".equals(ac.getField("email")))) {

		Long emailFound = new EmailDAO().isEmailAlreadyRegistered(ac.getField("email"));

		if(emailFound >= 1) {
			session.setAttribute("EmailAlreadyRegistered", "true");
			containError = true;
		}

	}

	if(containError) {
		response.sendRedirect("AddRecommender.jsp");
	} else {
		response.sendRedirect("SaveRecommender.jsp");
	}

%>