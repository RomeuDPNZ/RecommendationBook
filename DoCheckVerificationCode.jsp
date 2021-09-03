
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("DoResetPassword");

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
<%@ page import="java.io.IOException" %>

<%@ page import="recBook.DB" %>

<%@ include file="SendMail.jsp" %>
<%@ page import="recBook.ErrorServlet" %>
<%@ page import="recBook.Cryptography" %>
<%@ page import="recBook.PasswordGenerator" %>

<%@ include file="Validation.jsp" %>

<%
	Boolean errorCodeNotFound = false;
	Boolean errorInvalidEmail = false;
	Boolean errorInvalidId = false;
	Boolean errorInvalidCode = false;

	Validation v = new Validation();

	String id = request.getParameter("id");
	String code = request.getParameter("code");
	String email = request.getParameter("email");

	if(!v.isIdValid(id)) { errorInvalidId = true; }
	if(!v.isCodeValid(code)) { errorInvalidCode = true; }
	if(!v.isEmailValid(email)) { errorInvalidEmail = true; }

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	if(errorInvalidId || errorInvalidCode || errorInvalidEmail) {

	} else {

	/*
	 * SELECT
	 */

	Long verification = 0l;

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) as numberFound FROM ResetPassword WHERE email = ? AND Code = ? AND Login = ?");
		ps.setString(1, email);
		ps.setString(2, code);
		ps.setLong(3, Long.valueOf(id));
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			verification = result.getLong("numberFound");
		}

		} catch(SQLException e) {
			System.err.println("SQLException: "+e.getMessage());

			String uri = request.getRequestURI();
			String pageName = uri.substring(uri.lastIndexOf("/")+1);

			if(e.getMessage() != null) {
				throw new SQLException(e.getMessage()+" Page: "+pageName);
			}
		} finally { }

	if(verification < 1l) {
			errorCodeNotFound = true;

			/*
			 * Desconecta do Banco de Dados
			 */

			if(db.conexao != null) {
				db.DesconectaDB();
			}
	} else {

			/*
			 * Gera Novo Password
			 */

			PasswordGenerator pg = new PasswordGenerator();

			String newPassword = pg.getPassword();

			/*
			 * Criptografa Password
			 */

			byte[] pcBytes = {};

			try {

				Cryptography c = new Cryptography(newPassword);

				pcBytes = c.Encrypt(newPassword);

			} catch(Exception e) {
				System.err.println("CryptographyException: "+e.getMessage());

				String uri = request.getRequestURI();
				String pageName = uri.substring(uri.lastIndexOf("/")+1);

				if(e.getMessage() != null) {
					throw new Exception(e.getMessage()+" Page: "+pageName);
				}
			}

			/*
			 * UPDATE
			 */

			try {
				PreparedStatement ps = db.conexao.prepareStatement("UPDATE Login SET password = ? WHERE email = ?");
				ps.setBytes(1, pcBytes);
				ps.setString(2, email);
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
			 * Envia Email com Novo Password
			 */

			String from = "recommendationbook@gmail.com";
			String subject = "Recommendation Book Password Reset";
			String text = "Here is Your Password Reset: "+newPassword+"<br /><br />Annotate this Password and Delete This e-mail";

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

			/*
			 * DELETE
			 */

			try {
				PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM ResetPassword WHERE email = ? AND Code = ? AND Login = ?");
				ps.setString(1, email);
				ps.setString(2, code);
				ps.setLong(3, Long.valueOf(id));
				ps.executeUpdate();
			} catch(SQLException e) {
				System.err.println("SQLException: "+e.getMessage());

				String uri = request.getRequestURI();
				String pageName = uri.substring(uri.lastIndexOf("/")+1);

				if(e.getMessage() != null) {
					throw new SQLException(e.getMessage()+" Page: "+pageName);
				}
			} finally { }

		}

	}

	/*
	 * Desconecta do Banco de Dados
	 */

	if(db.conexao != null) {
		db.DesconectaDB();
	}

	if(errorInvalidEmail || errorCodeNotFound || errorInvalidId || errorInvalidCode) {

		String idError = "";

		if(errorInvalidEmail) {
			idError = "8";
		} else if(errorCodeNotFound) {
			idError = "3";
		} else if(errorInvalidId) {
			idError = "4";
		} else if(errorInvalidCode) {
			idError = "5";
		}

		response.sendRedirect("Error.jsp?id="+idError);
	} else {
		response.sendRedirect("MessageToRecommender.jsp?id=2");
	}

%>