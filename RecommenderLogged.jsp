
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Recommender" %>
<%@ page import="recBook.RecommenderDAO" %>

<%

	Boolean isRecommenderLogged = false;
	Long recommenderIdLogged = 0l;

	if(request.getCookies() != null) {

	Cookie[] cookies = request.getCookies();

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

	if(isRecommenderLogged) {
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

			recommender = recommenderDAO.select(recommenderIdLogged);

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
				db.DesconectaDB();
			}
		}

		if((recommender.getId().equals(recommenderIdLogged)) && (recommender.getNickName() != null)) {
			out.print("<a href=\"Recommender.jsp?id="+recommender.getId()+"\">"+recommender.getNickName()+"</a>");
			session.setAttribute("RecommenderLoggedNickname", ""+recommender.getNickName()+"");
		}

	} else {
		out.print("<a href=\"AddRecommender.jsp\">Register</a> - <a href=\"Login.jsp\">Login</a>");
	}

%>