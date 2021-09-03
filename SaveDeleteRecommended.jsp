
<%@ page errorPage="Error.jsp" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("SaveDeleteRecommended");

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
<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Recommended" %>
<%@ page import="recBook.RecommendedDAO" %>
<%@ page import="recBook.RecommendedType" %>
<%@ page import="recBook.RecommendedTypeDAO" %>
<%@ page import="recBook.AddRecDAOOutro" %>
<%@ page import="recBook.ActionsDAOOutro" %>
<%@ page import="recBook.DeleteImage" %>
<%@ page import="recBook.WatchListDAOOutro" %>
<%@ page import="recBook.ReadListDAOOutro" %>
<%@ page import="recBook.ListenListDAOOutro" %>

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

<%
	Long id = (Long) session.getAttribute("IdS");
	String image = (String) session.getAttribute("imageNome");

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	Recommended recommendedAtual = new Recommended();
	RecommendedDAO recommendedDAO = new RecommendedDAO(db);

	try {

		recommendedAtual = recommendedDAO.select(Long.valueOf(id));

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}

		if(db.conexao != null) {
			db.DesconectaDB();
		}
	} finally {
	}

	RecommendedType recommendedType = new RecommendedType();
	RecommendedTypeDAO recommendedTypeDAO = new RecommendedTypeDAO(db);
	ActionsDAOOutro actionsDAOOutro = new ActionsDAOOutro(db);
	AddRecDAOOutro addRecDAOOutro = new AddRecDAOOutro(db);

	Boolean permissionDenied = false;

	if(recommenderIdLogged.equals(recommendedAtual.getRecommender())) {

	try {

		/*
		 * Deleta imagem antiga
		 */
		if(!image.equals("NoImageAvailable.png")) {
			new DeleteImage(request, "\\img\\user\\", "Recommended"+id+".jpg");
		}

		db.conexao.setAutoCommit(false);

		recommendedType = recommendedTypeDAO.select(Long.valueOf(recommendedAtual.getType()));

		Integer addedAction = actionsDAOOutro.getActionId("Added the "+recommendedType.getType()+"");
		Integer recommendedAction = actionsDAOOutro.getActionId("Recommended the "+recommendedType.getType()+"");

		addRecDAOOutro.delete(Long.valueOf(id), addedAction);
		addRecDAOOutro.delete(Long.valueOf(id), recommendedAction);

		recommendedDAO.delete(Long.valueOf(id));

		if(recommendedType.getType().equals("Movie")) {

			new WatchListDAOOutro(db).delete(recommendedAtual.getId());

		} else if(recommendedType.getType().equals("Book")) {

			new ReadListDAOOutro(db).delete(recommendedAtual.getId());

		} else if(recommendedType.getType().equals("Album")) {

			new ListenListDAOOutro(db).delete(recommendedAtual.getId());

		}

		db.conexao.commit();

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally {

		/*
		 * Desconecta do Banco de Dados
		 */
		if(db.conexao != null) {
			db.conexao.setAutoCommit(true);
			db.DesconectaDB();
		}
	}

	} else {
		permissionDenied = true;
	}

	session.setAttribute("IdS", "");
	session.setAttribute("nameS", "");
	session.setAttribute("imageNome", "");

	if(permissionDenied) {
		response.sendRedirect("Error.jsp?id=7");
	} else {
		response.sendRedirect("Recommender.jsp?id="+recommenderIdLogged.toString()+"");
	}

%>

<% } %>

