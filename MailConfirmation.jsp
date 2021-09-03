 
<%@ page import="java.sql.PreparedStatement" %> 
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Login" %>
<%@ page import="recBook.LoginDAO" %>
<%@ page import="recBook.Recommender" %>
<%@ page import="recBook.RecommenderDAO" %>
<%@ page import="recBook.AwaitingConfirmation" %>
<%@ page import="recBook.AwaitingConfirmationDAO" %>

<%@ page import="java.io.IOException" %>
<%@ page import="java.io.FileNotFoundException" %>

<%@ page import="recBook.RecordImage" %>

<%@ include file="Validation.jsp" %>

<%
	Long recommenderId = 0l;

	Boolean errorIdNotFound = false;
	Boolean errorCodeNotFound = false;
	Boolean errorInvalidId = false;
	Boolean errorInvalidCode = false;

	Validation v = new Validation();

	String id = request.getParameter("id");
	String code = request.getParameter("code");

	if(!v.isIdValid(id)) { errorInvalidId = true; }
	if(!v.isCodeValid(code)) { errorInvalidCode = true; }

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	if(!errorInvalidId && !errorInvalidCode) {

	AwaitingConfirmation ac = new AwaitingConfirmation();

	AwaitingConfirmationDAO acDAO = new AwaitingConfirmationDAO(db);

	/*
	* SELECT
	*/

	try {

		ac = acDAO.select(Long.valueOf(id));

	} catch(SQLException e) {
		if(db.conexao != null) {
			db.DesconectaDB();
		}

		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	/*
	 * Verifica se o id existe no Banco de Dados
	 */

	if(ac.getId() == null) {
		errorIdNotFound = true;
	}

	/*
	 * Verifica se codigo do Banco de Dados é igual ao codigo do Usuário
	 */

	if(code.equals(ac.getCode())) {

		Login login = new Login();

		login.setEmail(ac.getEmail());
		login.setPassword(ac.getPassword());
		login.setRole(ac.getRole());

		LoginDAO loginDAO = new LoginDAO(db);

		/*
		* INSERT - DELETE
		*/

		Long loginLong = 0l;

		try {

			db.conexao.setAutoCommit(false);

			loginLong = loginDAO.insert(login);

			Recommender recommender = new Recommender();

			recommender.setLogin(loginLong);
			recommender.setRecommendations(0l);
			recommender.setPageViews(0l);
			recommender.setNickName(ac.getNickName());
			recommender.setSex(ac.getSex());
			recommender.setCountry(Integer.valueOf(ac.getCountry()));
			recommender.setBirthDate(ac.getBirthDate());
			recommender.setShowSex(true);
			recommender.setShowCountry(true);
			recommender.setShowBirth(true);
			recommender.setOfficialWebsite(ac.getOfficialWebsite());
			recommender.setAbout(ac.getAbout());

			RecommenderDAO recommenderDAO = new RecommenderDAO(db);

			recommenderId = recommenderDAO.insert(recommender);
			acDAO.delete(Long.valueOf(id));

			db.conexao.commit();

		} catch(SQLException e) {
			db.conexao.rollback();
			System.err.println("Transaction Is Being Rolled Back: "+e.getMessage());

			String uri = request.getRequestURI();
			String pageName = uri.substring(uri.lastIndexOf("/")+1);

			if(e.getMessage() != null) {
				throw new SQLException(e.getMessage()+" Page: "+pageName);
			}
		} finally {
			if(db.conexao != null) {
				db.conexao.setAutoCommit(true);
				db.DesconectaDB();
			}
		}

		if(ac.getImage().length > 0) {

		try {

			new RecordImage(request, ac.getImage(), "\\img\\user\\", "Recommender"+recommenderId+".jpg");

		} catch(FileNotFoundException e) {
			System.err.println("FileNotFoundException: "+e.getMessage());

			/*
			 * Desconecta do Banco de Dados
			 */

			if(db.conexao != null) {
				db.DesconectaDB();
			}

			String uri = request.getRequestURI();
			String pageName = uri.substring(uri.lastIndexOf("/")+1);

			if(e.getMessage() != null) {
				throw new SQLException(e.getMessage()+" Page: "+pageName);
			}
		} catch(IOException e) {
			System.err.println("IOException: "+e.getMessage());

			/*
			 * Desconecta do Banco de Dados
			 */

			if(db.conexao != null) {
				db.DesconectaDB();
			}

			String uri = request.getRequestURI();
			String pageName = uri.substring(uri.lastIndexOf("/")+1);

			if(e.getMessage() != null) {
				throw new SQLException(e.getMessage()+" Page: "+pageName);
			}
		} finally {}

		}

	} else {
		errorCodeNotFound = true;
	}

	}

	if(errorIdNotFound || errorCodeNotFound || errorInvalidId || errorInvalidCode) {

		String idError = "";

		if(errorIdNotFound) {
			idError = "2";
		} else if(errorCodeNotFound) {
			idError = "3";
		} else if(errorInvalidId) {
			idError = "4";
		} else if(errorInvalidCode) {
			idError = "5";
		}

		response.sendRedirect("Error.jsp?id="+idError);
	} else {

		session.setAttribute("isRecommenderLogged", "Yes");
		session.setAttribute("RecommenderId", ""+recommenderId.toString()+"");

		Cookie isRecommenderLogged = new Cookie("IsRecommenderLogged", "Yes");
		isRecommenderLogged.setMaxAge(365*24*60*60);
		response.addCookie(isRecommenderLogged);

		Cookie recommenderIdCookie = new Cookie("RecommenderId", ""+recommenderId.toString()+"");
		recommenderIdCookie.setMaxAge(365*24*60*60);
		response.addCookie(recommenderIdCookie);

		response.sendRedirect("Recommender.jsp?id="+recommenderId.toString());
	}

%>