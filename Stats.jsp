
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

	Long recommendations = 0l;
	Long recommenders = 0l;

	try {

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM Recommended");
		ResultSet result = ps.executeQuery();
		while(result.next()) { recommendations = result.getLong(1); }

		ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM Recommender");
		result = ps.executeQuery();
		while(result.next()) { recommenders = result.getLong(1); }

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}
	} finally {
		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}
	}

	out.print("<div class=\"Stats\"><fieldset>The <span class=\"RecommendationBook\">Recommendation Book</span> has <span class=\"green\">"+recommendations.toString()+"</span> Entities <a href=\"AddRecommended.jsp\">Recommended</a> and <span class=\"green\">"+recommenders.toString()+"</span> Registered <a href=\"AddRecommender.jsp\">Recommenders</a>. <a href=\"MoreStats.jsp\">More Stats</a>.</fieldset></div>");

%>
