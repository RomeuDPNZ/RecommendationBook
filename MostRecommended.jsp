
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.MostRecommended" %>
<%@ page import="recBook.MostRecommendedDAO" %>

<% if(!request.getParameterMap().containsKey("type")) { %>

	<jsp:forward page="/index.jsp" />

<% } else { %>

<jsp:include page="GetDevice.jsp" flush="true" />

<%

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	String type = (String) request.getParameter("type");
	Boolean ok = true;
	Integer limit = 1000;
	String thing = "";

	if(type.equals("Recommender")) {
		thing = "Recommenders";
	} else if(type.equals("Person")) {
		thing = "Persons";
	} else if(type.equals("Group")) {
		thing = "Groups";
	} else if(type.equals("Book")) {
		thing = "Books";
	} else if(type.equals("Movie")) {
		thing = "Movies";
	} else if(type.equals("Band")) {
		thing = "Bands";
	} else if(type.equals("Album")) {
		thing = "Albums";
	} else if(type.equals("Song")) {
		thing = "Songs";
	} else if(type.equals("Project")) {
		thing = "Projects";
	} else if(type.equals("Website")) {
		thing = "Websites";
	} else if(type.equals("Company")) {
		thing = "Companies";
	} else if(type.equals("Product")) {
		thing = "Products";
	} else if(type.equals("Place")) {
		thing = "Places";
	} else if(type.equals("Food")) {
		thing = "Foods";
	} else if(type.equals("Game")) {
		thing = "Games";
	} else if(type.equals("Gun")) {
		thing = "Guns";
	} else if(type.equals("Knife")) {
		thing = "Knives";
	} else if(type.equals("Car")) {
		thing = "Cars";
	} else if(type.equals("Motorcycle")) {
		thing = "Motorcycles";
	} else {
		ok = false;
	}

	List recommendations = new ArrayList();

	if(ok) {

	/*
	 * Select
	 */

	MostRecommendedDAO mostRecommendedDAO = new MostRecommendedDAO(db);

	try {
		recommendations = mostRecommendedDAO.getMostRecommended(type, limit);

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

	}

%>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="The <%= limit %> Most Recommended <%= thing %> on Recommendation Book" />
<meta name="description" content="The <%= limit %> Most Recommended <%= thing %> on Recommendation Book" />

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

<script src="js/jquery-1.10.2.js"></script>
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
	<legend>The <%= limit %> Most Recommended <%= thing %></legend>

			<table>
			<tbody>

<%

	Iterator itr = recommendations.iterator();

	if(recommendations.isEmpty()) {
		out.println("<tr><td class=\"LightGrayBorder\">Nothing yet!</td></tr>");
	} else {

		Long ranking = 1l;
		Long pastRecommendations = 0l;
		Boolean afterFirst = false;

		if(type.equals("Recommender")) {

			while(itr.hasNext()) {
				MostRecommended r = (MostRecommended) itr.next();

				if(pastRecommendations > r.getRecommendations()) {
					++ranking;
				}

			if(session.getAttribute("GetDevice").toString().contains("Mobi")) {

			if(afterFirst.equals(true)) { out.println("<tr><td colspan=\"2\" class=\"SpaceForFields\"></td></tr>"); }

			afterFirst = true;

				out.println("<tr><td class=\"LightGrayBorder\"><span class=\"green\">Ranking: "+ranking+"</span></td></tr><tr><td class=\"LightGrayBorder\">Recommender: <span class=\"Nickname\"><a href=\"Recommender.jsp?id="+r.getId()+"\">"+r.getName()+"</a></span></td></tr><tr><td class=\"LightGrayBorder\">"); pageContext.include("MakeButtonRecommend.jsp?id="+r.getId()+"&table=Recommender&width=100"); out.println("</tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">Recommendations: "+r.getRecommendations()+"</span></td></tr>");

			} else {

				out.println("<tr><td class=\"LightGrayBorder\"><span class=\"green\">Ranking: "+ranking+"</span></td><td class=\"LightGrayBorder\">Recommender: <span class=\"Nickname\"><a href=\"Recommender.jsp?id="+r.getId()+"\">"+r.getName()+"</a></span></td><td class=\"LightGrayBorder\">"); pageContext.include("MakeButtonRecommend.jsp?id="+r.getId()+"&table=Recommender&width=static"); out.println("<td class=\"LightGrayBorder\"><span class=\"green\">Recommendations: "+r.getRecommendations()+"</span></td></tr>");

			}

				pastRecommendations = r.getRecommendations();

			}

		} else {

			while(itr.hasNext()) {
				MostRecommended r = (MostRecommended) itr.next();

				if(pastRecommendations > r.getRecommendations()) {
					++ranking;
				}

			if(session.getAttribute("GetDevice").toString().contains("Mobi")) {

			if(afterFirst.equals(true)) { out.println("<tr><td colspan=\"2\" class=\"SpaceForFields\"></td></tr>"); }

			afterFirst = true;

				out.println("<tr><td class=\"LightGrayBorder\"><span class=\"green\">Ranking: "+ranking+"</span></td></tr><tr><td class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+r.getId()+"\">"+r.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\">");  pageContext.include("MakeButtonRecommend.jsp?id="+r.getId()+"&table=Recommended&width=100"); if(type.contains("Book") || type.contains("Album") || type.contains("Movie")) { pageContext.include("MakeButtonTODO.jsp?id="+r.getId()+"&width=100"); } out.println("</td></tr><tr>"); out.println("<td class=\"LightGrayBorder\"><span class=\"green\">Recommendations: "+r.getRecommendations()+"</span></td></tr><tr><td class=\"LightGrayBorder\">Recommender: <span class=\"Nickname\"><a  href=\"Recommender.jsp?id="+r.getIdRecommender()+"\">"+r.getRecommender()+"</a></span></td></tr>");

			} else {

				out.println("<tr><td class=\"LightGrayBorder\"><span class=\"green\">Ranking: "+ranking+"</span></td><td class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+r.getId()+"\">"+r.getName()+"</a></td><td class=\"LightGrayBorder\">");  pageContext.include("MakeButtonRecommend.jsp?id="+r.getId()+"&table=Recommended&width=static"); if(type.contains("Book") || type.contains("Album") || type.contains("Movie")) { pageContext.include("MakeButtonTODO.jsp?id="+r.getId()+"&width=static"); } out.println("</td>"); out.println("<td class=\"LightGrayBorder\"><span class=\"green\">Recommendations: "+r.getRecommendations()+"</span></td><td class=\"LightGrayBorder\">Recommender: <span class=\"Nickname\"><a  href=\"Recommender.jsp?id="+r.getIdRecommender()+"\">"+r.getRecommender()+"</a></span></td></tr>");

			}

				pastRecommendations = r.getRecommendations();

			}

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
