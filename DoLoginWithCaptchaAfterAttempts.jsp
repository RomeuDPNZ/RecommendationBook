
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("DoLogin");

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

%>

<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Login" %>
<%@ page import="recBook.LoginDAO" %>
<%@ page import="recBook.EmailDAO" %>

<%@ page import="recBook.Cryptography" %>

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
	if(fv.isEmpty(ac.getField("password"), "PasswordCantBeEmpty")) { containError = true; }
	if(fv.isBiggerThanNCharacters(ac.getField("password"), 50, "PasswordIsBiggerThan50Characters")) { containError = true; }

	if(ac.getField("AttemptsMade").equals("true")) {

		if(fv.isCaptchaWrong(ac.getField("recaptcha_challenge_field"), ac.getField("recaptcha_response_field"), "CaptchaIsWrong")) { containError = true; }

	}

	String email = ac.getField("email");
	String password = ac.getField("password");

	Long recommenderId = 0l;

	if(containError) {


	} else {

		/*
		 * Conecta ao Banco de Dados
		 */

		DB db = new DB();
		db.ConectaDB();

		if(db.conexao == null) {
			System.err.println("DB Connection Error: "+db.conexao);
		}

		Login login = new Login();
		LoginDAO loginDAO = new LoginDAO(db);
		EmailDAO emailDAO = new EmailDAO();

		byte[] passwordDBBytes = {};

		/*
		* Select
		*/

		try {

			login = emailDAO.select(email);

		} catch(SQLException e) {
			System.err.println("SQLException: "+e.getMessage());

			String uri = request.getRequestURI();
			String pageName = uri.substring(uri.lastIndexOf("/")+1);

			if(e.getMessage() != null) {
				throw new SQLException(e.getMessage()+" Page: "+pageName);
			}
		} finally {}

		if(login.getId() != null) {

			/*
			 * Descriptografa Password para verificação
			 */

			try {

				Cryptography c = new Cryptography(password);

				passwordDBBytes = c.Decrypt(login.getPassword());

			} catch(Exception e) {
				System.err.println("CryptographyException: "+e.getMessage());

				String uri = request.getRequestURI();
				String pageName = uri.substring(uri.lastIndexOf("/")+1);

				if(!e.getMessage().contains("Given final block not properly padded")) {
					throw new Exception(e.getMessage()+" Page: "+pageName);
				} else {
					containError = true;
					session.setAttribute("WrongEmailOrPassword", "true");
				}
			}

			/*
			 * Verifica Password descriptografado do Banco de Dados com Password do formulário
			 */

			String passwordDBString = new String(passwordDBBytes);

			if(!(password.equals(passwordDBString)) || !(email.equals(login.getEmail()))) {
				containError = true;
				session.setAttribute("WrongEmailOrPassword", "true");

				/*
				 * Attempts Made
				 */

				Integer attemptsMade = 0;

				try {

					PreparedStatement ps = db.conexao.prepareStatement("SELECT attemptsMade FROM Login WHERE email = ?");
					ps.setString(1, email);
					ResultSet result = ps.executeQuery();

					while(result.next()) {
						attemptsMade = result.getInt("attemptsMade");
					}

					if(attemptsMade < 3) {

						++attemptsMade;

						ps = db.conexao.prepareStatement("UPDATE Login SET attemptsMade = ? WHERE email = ?");
						ps.setInt(1, attemptsMade);
						ps.setString(2, email);
						ps.executeUpdate();

					} else {

						session.setAttribute("TooManyWrongAttemptsMade", "true");

					}

				} catch(SQLException e) {
					System.err.println("SQLException: "+e.getMessage());

					String uri = request.getRequestURI();
					String pageName = uri.substring(uri.lastIndexOf("/")+1);

					if(e.getMessage() != null) {
						throw new SQLException(e.getMessage()+" Page: "+pageName);
					}
				} finally { }
				
			} else {

				/*
				 * Select
				 */

				try {
					PreparedStatement ps = db.conexao.prepareStatement("SELECT id FROM Recommender WHERE login = ?");
					ps.setLong(1, login.getId());
					ResultSet result = ps.executeQuery();

					while(result.next()) {
						recommenderId = result.getLong("id");
					}

					ps = db.conexao.prepareStatement("UPDATE Login SET attemptsMade = 0 WHERE email = ?");
					ps.setString(1, email);
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
				 * Desconecta do Banco de Dados
				 */

				if(db.conexao != null) {
					db.DesconectaDB();
				}

			}

		} else {
			containError = true;
			session.setAttribute("WrongEmailOrPassword", "true");
		}

	}

	if(containError) {
		response.sendRedirect("Login.jsp");
	} else {
		session.setAttribute("TooManyWrongAttemptsMade", "false");

		session.setAttribute("isRecommenderLogged", "Yes");
		session.setAttribute("RecommenderId", ""+recommenderId.toString()+"");

		Cookie isRecommenderLogged = new Cookie("IsRecommenderLogged", "Yes");
		isRecommenderLogged.setMaxAge(365*24*60*60);
		response.addCookie(isRecommenderLogged);

		Cookie recommenderIdCookie = new Cookie("RecommenderId", ""+recommenderId.toString()+"");
		recommenderIdCookie.setMaxAge(365*24*60*60);
		response.addCookie(recommenderIdCookie);

		response.sendRedirect("Recommender.jsp?id="+recommenderId.toString()+"");
	}

%>