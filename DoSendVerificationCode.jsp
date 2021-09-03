
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<% if(request == null) { %>

	<jsp:forward page="/ResetPassword.jsp" />

<% } else { %>

<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.io.IOException" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.RandomGenerator" %>

<%@ include file="SendMail.jsp" %>

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

	if(fv.isEmpty(ac.getField("email"), "EmailCantBeEmpty")) { containError = true; }
	if(fv.isBiggerThanNCharacters(ac.getField("email"), 100, "EmailIsBiggerThan100Characters")) { containError = true; }

	if(fv.isCaptchaWrong(ac.getField("recaptcha_challenge_field"), ac.getField("recaptcha_response_field"), "CaptchaIsWrong")) { containError = true; }

	String email = ac.getField("email");

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	if(containError) {

	} else {

		/*
		 * SELECT
		 */

		Long emails = 0l;

		try {
			PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) as numberFound FROM Login WHERE email = ?");
			ps.setString(1, email);
			ResultSet result = ps.executeQuery();

			while(result.next()) {
				emails = result.getLong("numberFound");
			}

		} catch(SQLException e) {
			System.err.println("SQLException: "+e.getMessage());

			String uri = request.getRequestURI();
			String pageName = uri.substring(uri.lastIndexOf("/")+1);

			if(e.getMessage() != null) {
				throw new SQLException(e.getMessage()+" Page: "+pageName);
			}
		} finally { }

		if(emails < 1l) {
			session.setAttribute("EmailNotFound", "true");
			containError = true;

			/*
			 * Desconecta do Banco de Dados
			 */

			if(db.conexao != null) {
				db.DesconectaDB();
			}
		} else {

			/*
			 * SELECT
			 */

			long loginId = 0l;

			try {
				PreparedStatement ps = db.conexao.prepareStatement("SELECT id FROM Login WHERE email = ?");
				ps.setString(1, email);
				ResultSet result = ps.executeQuery();

				while(result.next()) {
					loginId = result.getLong("id");
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
			 * Gera Codigo de Confirmacao
			 */

			RandomGenerator rlg = new RandomGenerator();
			String codigoDeConfirmacao = rlg.getLettersAndNumbers();

			/*
			 * INSERT
			 */

			try {
				PreparedStatement ps = db.conexao.prepareStatement("INSERT INTO ResetPassword (login,email,code) VALUES (?,?,?)");
				ps.setLong(1, loginId);
				ps.setString(2, email);
				ps.setString(3, codigoDeConfirmacao);
				ps.executeUpdate();
			} catch(SQLException e) {
				System.err.println("SQLException: "+e.getMessage());

				String uri = request.getRequestURI();
				String pageName = uri.substring(uri.lastIndexOf("/")+1);

				if(e.getMessage() != null) {
					throw new SQLException(e.getMessage()+" Page: "+pageName);
				}
			} finally { }

			/*
			 * Envia Email com Código de Verificação
			 */


			String url = request.getRequestURL().toString();

			if(url.contains("localhost:8080")) {
				url = "http://localhost:8080/";
			} else if(url.contains("localhost:8989")) {
				url = "http://localhost:8989/";
			} else {
				url = "http://recommendationbook.com";
			}

			String from = "recommendationbook@gmail.com";
			String subject = "Recommendation Book Password Reset Verification Code";
			String c = codigoDeConfirmacao;
			String id = String.valueOf(loginId);
			String em = email;
String text = "<a href=\""+url+"/DoCheckVerificationCode.jsp?code="+c+"&id="+id+"&email="+em+"\">"+url+"/DoCheckVerificationCode.jsp?code="+c+"&id="+id+"&email="+em+"</a>";

			SendMail sm = new SendMail(email, from, subject, text);

			try {
				sm.Send();
			} catch(Exception e) {
				System.err.println("EmailException: "+e.getMessage());

				String uri = request.getRequestURI();
				String pageName = uri.substring(uri.lastIndexOf("/")+1);

				if(e.getMessage() != null) {
					throw new Exception(e.getMessage()+" Page: "+pageName);
				}
			}

		}

	}

	/*
	 * Desconecta do Banco de Dados
	 */

	if(db.conexao != null) {
		db.DesconectaDB();
	}

	if(containError == false) {
		response.sendRedirect("MessageToRecommender.jsp?id=6");
	} else {
		response.sendRedirect("ResetPassword.jsp");
	}

%>

<% } %>
