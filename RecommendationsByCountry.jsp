
<% if(!request.getParameterMap().containsKey("id")) { %>

	<jsp:forward page="/index.jsp" />

<% } else { %>

<jsp:include page="GetDevice.jsp" flush="true" />

<%@ page import="java.sql.SQLException" %>

<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Recommended" %>
<%@ page import="recBook.RecommendedDAO" %>
<%@ page import="recBook.RecommendedType" %>
<%@ page import="recBook.RecommendedTypeDAO" %>
<%@ page import="recBook.ActionsDAOOutro" %>

<%!

public class RecByCountries {

	private String country;
	private String recommendations;

	public RecByCountries () {
	}

	public String getCountry() {
		return this.country;
	}

	public void setCountry(String country) {
		this.country = country;
	}

	public String getRecommendations() {
		return this.recommendations;
	}

	public void setRecommendations(String recommendations) {
		this.recommendations = recommendations;
	}

}

%>

<%

	Long id = Long.valueOf((String) request.getParameter("id"));

	String forRecommended = "false";

	if(request.getParameter("forRecommended") != null) {
		forRecommended = (String) request.getParameter("forRecommended");
	}

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

	try {

		recommended = recommendedDAO.select(id);

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

	RecommendedType recommendedType = new RecommendedType();
	RecommendedTypeDAO recommendedTypeDAO = new RecommendedTypeDAO(db);
	
	try {

		recommendedType = recommendedTypeDAO.select(Long.valueOf(recommended.getType()));

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

	String type = recommendedType.getType();

	Integer action = 0;

	try {

		action = new ActionsDAOOutro(db).getActionId("Recommended the "+type+"");

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

	List recommendations = new ArrayList();

	/*
	 * Select
	 */

	try {
			PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) as recs, Countries.country FROM AddRec INNER JOIN Countries INNER JOIN Recommender WHERE AddRec.addRec = ? AND action = ? AND AddRec.recommender=Recommender.id AND Recommender.country=Countries.id GROUP BY Countries.country ORDER BY recs DESC;");
			ps.setLong(1, id);
			ps.setInt(2, action);
			ResultSet result = ps.executeQuery();

			while(result.next()) {
				RecByCountries recByCountries = new RecByCountries();

				recByCountries.setCountry(result.getString("country"));
				recByCountries.setRecommendations(result.getString("recs"));

				recommendations.add(recByCountries);
			}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally {}

	/*
	 * Desconecta do Banco de Dados
	 */

	if(db.conexao != null) {
		db.DesconectaDB();
	}

%>

<% if(forRecommended.equals("true")) { %>

<%

	Integer numeroDePaisesASeremExibidos = 10;
	Integer i = 0;

	Iterator itr = recommendations.iterator();

	if(recommendations.isEmpty()) {
		out.println("<dd class=\"user\"><span class=\"green\">Nothing yet!</span></dd>");
	} else {

		while(i<numeroDePaisesASeremExibidos && itr.hasNext()) {
				RecByCountries r = (RecByCountries) itr.next();

				String output = "";

				if(r.getRecommendations().equals("1")) { output = ""+r.getRecommendations()+" Recommendation"; } else { output = ""+r.getRecommendations()+" Recommendations"; }

				out.println("<dd class=\"user\"><span class=\"green\">"+output+" from "+r.getCountry()+"</span></dd>");

				++i;

		}

		if(recommendations.size() > numeroDePaisesASeremExibidos) { out.println("<dd class=\"user\"><a href=\"RecommendationsByCountry.jsp?id="+id+"\">Click To See All Recommendations By Country</a></dd>"); }

	}

%>

<% } else { %>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="Recommendations for the Entity <%= recommended.getName() %> on Recommendation Book by Country" />
<meta name="description" content="Recommendations for the Entity <%= recommended.getName() %> on Recommendation Book by Country" />

<link rel="icon" href="./img/static/RBIcon.ico" type="image/x-icon">

<link href='http://fonts.googleapis.com/css?family=Roboto:500' rel='stylesheet' type='text/css'>

<style type="text/css">
<!--
   @import url("RecommendationBookCSS.css");
-->
</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookMobileCSS.css" />

<% } %>

<script type="text/javascript"> 
<!--

//-->
</script>

</head>

<body>

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
	<jsp:include page="MiniMenuMobile.jsp" flush="true" />
<% } else { %>
	<jsp:include page="MiniMenu.jsp" flush="true" />
<% } %>

<div class="Corpo">

	<fieldset>
	<legend>Recommendations for the Entity <a class="SeeAll" href="Recommended.jsp?id=<%= id %>"><%= recommended.getName() %></a> by Country</legend>

			<table>
			<tbody>

<%

	Iterator itr = recommendations.iterator();

	if(recommendations.isEmpty()) {
		out.println("<tr><td class=\"LightGrayBorder\">Nothing yet!</td></tr>");
	} else {

		while(itr.hasNext()) {
				RecByCountries r = (RecByCountries) itr.next();

				out.println("<tr><td class=\"LightGrayBorder\"><span class=\"green\">"+r.getRecommendations()+" Recommendations</span> from "+r.getCountry()+"</span></td></tr>");

		}

	}

%>

			</tbody>
			</table>

	</fieldset>

</div>

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
	<jsp:include page="RodapeMobile.jsp" flush="true" />
<% } else { %>
	<jsp:include page="Rodape.jsp" flush="true" />
<% } %>

</body>
 
</html>

<% } %>

<% } %>
