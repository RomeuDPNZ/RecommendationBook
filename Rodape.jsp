
<%@ page errorPage="Error.jsp" %>

<%
	Cookie[] cookies = request.getCookies();

	Boolean isRecommenderLogged = false;

	if(cookies != null) {

	for(Cookie cookie:cookies) {
 		if(cookie.getName().equals("IsRecommenderLogged")) {
			if(cookie.getValue().equals("Yes")) {
				isRecommenderLogged = true;
			}
		}
	}

	}

%>

<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
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

	Long indexPageViews = 0l;

	try {

		PreparedStatement ps = db.conexao.prepareStatement("SELECT pageviews FROM PageViews WHERE page='index'");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			indexPageViews = result.getLong(1);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

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
	} finally { }
%>
	<div class="Rodape"><% if(isRecommenderLogged.equals(false)) { %><a href="Login.jsp">Login</a> - <a href="AddRecommender.jsp">Register Totally Free</a> - <a href="Login.jsp">Register with Facebook\Google Account</a> - <% } %><a href="index.jsp">10 Most Recommended</a><br /><br /><a href="AddRecommended.jsp">Recommend Something</a> - <a href="About.jsp">What's the Recommendation Book?</a> - <a href="Contact.jsp">Contact</a> - <a href="DoSearch.jsp">Search</a> - <a href="SiteMap.jsp">Site Map</a><br /><br />Recommendation Book - 2014-<jsp:include page="GetYear.jsp" flush="true" /> - Recommend your World <%= indexPageViews %> PageViews</div>