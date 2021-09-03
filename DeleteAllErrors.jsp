
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

<% } else if(!recommenderIdLogged.equals(1l)) { %>

	<jsp:forward page="/Error.jsp?id=7" />

<% } else { %>

<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>

<%

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	try {

		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM ERRORS");
		ps.execute();

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());
	} finally { }

	/*
	 * Desconecta do Banco de Dados
	 */

	if(db.conexao != null) {
		db.DesconectaDB();
	}

%>

<% } %>
