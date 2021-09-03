
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("ContactValidation");

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

%>

<%@ include file="Validation.jsp" %>
<%@ include file="SendMail.jsp" %>

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

	if(fv.isEmpty(ac.getField("email"), "EmailCantBeEmpty")) { containError = true; }
	if(fv.isBiggerThanNCharacters(ac.getField("email"), 100, "EmailIsBiggerThan100Characters")) { containError = true; }

	if(fv.isEmpty(ac.getField("subject"), "SubjectCantBeEmpty")) { containError = true; }
	if(fv.isBiggerThanNCharacters(ac.getField("subject"), 100, "SubjectIsBiggerThan100Characters")) { containError = true; }

	if(fv.isEmpty(ac.getField("message"), "MessageCantBeEmpty")) { containError = true; }
	if(fv.isTextAreaBiggerThanNCharacters(ac.getField("message"), 750, "MessageIsBiggerThan750Characters")) { containError = true; }
	if(fv.hasTextAreaMoreThanNLineBreaks(ac.getField("message"), 15, "MessageHasMoreThan15LineBreaks")) { containError = true; }

	if(fv.isCaptchaWrong(ac.getField("recaptcha_challenge_field"), ac.getField("recaptcha_response_field"), "CaptchaIsWrong")) { containError = true; }

	/* Cria variáveis de sessão que seráo utilizadas para exibir os erros pertinentes a cada preenchimento incorrento do usuário.
	 */
	session.setAttribute("EmailIsInvalid", "");
	session.setAttribute("SubjectIsInvalid", "");
	session.setAttribute("MessageHasHTMLInjection", "");

	session.setAttribute("emailS", ac.getField("email"));
	session.setAttribute("subjectS", ac.getField("subject"));
	session.setAttribute("messageS", ac.getField("message"));

	Validation v = new Validation();

	if(!ac.getField("email").equals("")) {
		if(v.isEmailValid(ac.getField("email")) == false) {
			session.setAttribute("EmailIsInvalid", "true");
			containError = true;
		}
	}

	if(!ac.getField("subject").equals("")) {
		if(v.isSubjectValid(ac.getField("subject")) == false) {
			session.setAttribute("SubjectIsInvalid", "true");
			containError = true;
		}
	}

	if(v.hasHTMLInjection(ac.getField("message")) == true) {
		session.setAttribute("MessageHasHTMLInjection", "true");
		containError = true;
	}

	if(containError) {
		response.sendRedirect("Contact.jsp");
	} else {

		/*
		 * Envia Email
		 */

		String from = ac.getField("email");
		String to = "recommendationbook@gmail.com";
		String subject = "From: "+from+" - "+ac.getField("subject");
		String message = ac.getField("message");

		SendMail sm = new SendMail(to, from, subject, message);

		try {
			sm.Send();
		} catch(Exception e) {
			System.err.println("EmailException: "+e.getMessage());
		}

		session.setAttribute("emailS", "");
		session.setAttribute("subjectS", "");
		session.setAttribute("messageS", "");

		response.sendRedirect("MessageToRecommender.jsp?id=5");
	}

%>