
<%@ page errorPage="Error.jsp" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("SaveRecommended");

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

%>

<%
	Cookie[] cookies = request.getCookies();

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

<%@ page import="java.sql.SQLException" %>

<%@ page import="java.text.SimpleDateFormat" %>

<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Recommended" %>
<%@ page import="recBook.RecommendedDAO" %>
<%@ page import="recBook.RecommendedType" %>
<%@ page import="recBook.RecommendedTypeDAO" %>
<%@ page import="recBook.AddRec" %>
<%@ page import="recBook.AddRecDAO" %>
<%@ page import="recBook.ActionsDAOOutro" %>

<%@ page import="java.io.IOException" %>
<%@ page import="java.io.FileNotFoundException" %>

<%@ page import="recBook.RecordImage" %>

<%@ include file="SendNotification.jsp" %>

<%
	String name = (String) session.getAttribute("nameS");
	String type = (String) session.getAttribute("typeS");
	String country = (String) session.getAttribute("countryS");
	String officialWebsite = (String) session.getAttribute("officialWebsiteS");
	String about = (String) session.getAttribute("aboutS");
	String extensao = (String) session.getAttribute("imageExtension");
	String descricao = (String) session.getAttribute("descriptionS");
	byte[] imagem = (byte[]) session.getAttribute("image");
	Long imagemTamanho = (Long) session.getAttribute("imageTamanho");

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	Recommended recommended = new Recommended();
	RecommendedDAO recommendedDAO = new RecommendedDAO(db);
	RecommendedTypeDAO recommendedTypeDAO = new RecommendedTypeDAO(db);

	AddRec addRec = new AddRec();
	AddRecDAO addRecDAO = new AddRecDAO(db);
	ActionsDAOOutro actionsDAOOutro = new ActionsDAOOutro(db);

	recommended.setRecommender(recommenderIdLogged);
	recommended.setRecommendations(0l);
	recommended.setPageViews(0l);
	recommended.setName(name);
	recommended.setType(Integer.valueOf(type));
	recommended.setCountry(Integer.valueOf(country));
	recommended.setOfficialWebsite(officialWebsite);
	recommended.setAbout(about);
	recommended.setDescriptionImage(descricao);

	Long recommendedId = 0l;

	try {

		db.conexao.setAutoCommit(false);

		recommendedId = recommendedDAO.insert(recommended);

		RecommendedType recommendedType = recommendedTypeDAO.select(Long.valueOf(type));
		String typeForAction = recommendedType.getType();

		Integer action = actionsDAOOutro.getActionId("Added the "+typeForAction+"");

		addRec.setRecommender(recommenderIdLogged);
		addRec.setAddRec(recommendedId);
		addRec.setAction(action);

		addRecDAO.insert(addRec);

		db.conexao.commit();

		SendNotification sn = new SendNotification(recommenderIdLogged, recommendedId, action);

		try {
			sn.start();
		} catch(Exception e) {
			System.err.println("EmailException: "+e.getMessage());

			String uri = request.getRequestURI();
			String pageName = uri.substring(uri.lastIndexOf("/")+1);

			if(e.getMessage() != null) {
				throw new Exception(e.getMessage()+" Page: "+pageName);
			}
		}

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

	if(imagem.length > 0 && imagemTamanho > 0l) {

	try {

		new RecordImage(request, imagem, "\\img\\user\\", "Recommended"+recommendedId+".jpg");

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

	session.setAttribute("nameS", "");
	session.setAttribute("typeS", "");
	session.setAttribute("countryS", "");
	session.setAttribute("officialWebsiteS", "");
	session.setAttribute("aboutS", "");
	session.setAttribute("image", "");
	session.setAttribute("imageTamanho", "");
	session.setAttribute("descriptionS", "");

	response.sendRedirect("Recommended.jsp?id="+recommendedId+"");

%>

<% } %>
