
<%@ page errorPage="Error.jsp" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("BeforeUpdateRecommender");

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

%>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.IsImageRecorded" %>
<%@ page import="java.lang.NullPointerException" %>
<%@ page import="java.lang.SecurityException" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Recommender" %>
<%@ page import="recBook.RecommenderDAO" %>
<%@ page import="recBook.DoesIdExists" %>

<%@ include file="Validation.jsp" %>

<% if(!new Validation().isIdValid(request.getParameter("id"))) { %>

	<jsp:forward page="/Error.jsp?id=4" />

<% } else if(!new DoesIdExists().check("Recommender", (Long.valueOf(request.getParameter("id"))))) { %>

	<jsp:forward page="/Error.jsp?id=2" />

<% } else { %>

<%
	Cookie[] cookies = request.getCookies();

	Long recommenderIdShowed = Long.valueOf((String) request.getParameter("id"));
	Boolean isRecommenderLogged = false;
	Long recommenderIdLogged = 0l;

	if(cookies != null) {

	for(Cookie cookie:cookies) {
 		if(cookie.getName().equals("IsRecommenderLogged")) {
			if(cookie.getValue().equals("Yes")) {
				isRecommenderLogged = true;
			}
		}
	}

	for(Cookie cookie:cookies) {
 		if(cookie.getName().equals("RecommenderId")) {
			if(isRecommenderLogged) {
				recommenderIdLogged = Long.valueOf((String) cookie.getValue());
			}
		}
	}

	}

%>

<% if(!isRecommenderLogged) { %>

	<jsp:forward page="/Login.jsp" />

<% } else { %>

<%

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	Recommender recommender = new Recommender();
	RecommenderDAO recommenderDAO = new RecommenderDAO(db);
	
	try {

		recommender = recommenderDAO.select(recommenderIdShowed);

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());
	} finally { }

	Boolean permissionDenied = false;

	if(recommenderIdLogged.equals(recommender.getId())) {

	session.setAttribute("IdS", recommender.getId());
	session.setAttribute("nickNameS", recommender.getNickName());
	session.setAttribute("countryS", recommender.getCountry().toString());
	session.setAttribute("officialWebsiteS", recommender.getOfficialWebsite());
	session.setAttribute("aboutS", recommender.getAbout());

	session.setAttribute("sexS", recommender.getSexToMySQL());
	String birthDate[] = recommender.getBirthDateToMySQL().split("-");
	session.setAttribute("yearS", birthDate[0]);
	session.setAttribute("monthS", birthDate[1]);
	session.setAttribute("dayS", birthDate[2]);

	/*
	 * Imagem
	 */

	String imagemOutro = "NoImageAvailable.png";
	String imagemNome = "Recommender"+recommender.getId()+".jpg";

	try {

		if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

			imagemOutro = imagemNome;

		}

	} catch(NullPointerException e) {
			System.err.println("NullPointerException: "+e.getMessage());

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
	} catch(SecurityException e) {
			System.err.println("SecurityException: "+e.getMessage());

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

	session.setAttribute("imageNome", imagemOutro);

	} else {
		permissionDenied = true;
	}

	/*
	 * Desconecta do Banco de Dados
	 */

	if(db.conexao != null) {
		db.DesconectaDB();
	}

	if(permissionDenied) {
		response.sendRedirect("Error.jsp?id=7");
	} else {
		response.sendRedirect("UpdateRecommender.jsp");
	}

%>

<% } %>

<% } %>

