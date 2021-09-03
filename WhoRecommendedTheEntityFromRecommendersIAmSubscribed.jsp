
<% if(!request.getParameterMap().containsKey("id")) { %>

	<jsp:forward page="/index.jsp" />

<% } else { %>

<jsp:include page="GetDevice.jsp" flush="true" />

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Recommended" %>
<%@ page import="recBook.RecommendedDAO" %>
<%@ page import="recBook.Recommender" %>
<%@ page import="recBook.RecommenderDAO" %>
<%@ page import="recBook.RecommendedType" %>
<%@ page import="recBook.RecommendedTypeDAO" %>
<%@ page import="recBook.ActionsDAOOutro" %>

<%

	Long id = Long.valueOf((String) request.getParameter("id"));
	Long recommenderId = Long.valueOf((String) request.getParameter("recommender"));

	String forRecommended = "false";

	if(request.getParameter("forRecommended") != null) {
		forRecommended = (String) request.getParameter("forRecommended");
	}

	session.setAttribute("idWhoRecommendedTheEntityFromRecommendersIAmSubscribed", ""+id+"");

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

	Recommender recommender = new Recommender();
	RecommenderDAO recommenderDAO = new RecommenderDAO(db);

	try {

		recommender = recommenderDAO.select(recommenderId);

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

	session.setAttribute("recommenderWhoRecommendedTheEntityFromRecommendersIAmSubscribed", ""+recommender.getId()+"");

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

	session.setAttribute("idWhoRecommendedTheEntityFromRecommendersIAmSubscribedAction", ""+action+"");

	/*
	 * Desconecta do Banco de Dados
	 */

	if(db.conexao != null) {
		db.DesconectaDB();
	}

%>

<% if(forRecommended.equals("true")) { %>

	<jsp:include page="WhoRecommendedTheEntityFromRecommendersIAmSubscribedRecs.jsp?page=1&forRecommended=true" flush="true" />

<% } else { %>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="Who Recommended the Entity <%= recommended.getName() %> From Recommenders that <%= recommender.getNickName() %> is Subscribed on Recommendation Book" />
<meta name="description" content="Who Recommended the Entity <%= recommended.getName() %> From Recommenders that <%= recommender.getNickName() %> is Subscribed on Recommendation Book" />

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

$(document).ready(function(){
	$(document).on("click", "tr.LoadMore", function() {
		var id = $(this).attr("id");

		var posting = $.post("WhoRecommendedTheEntityFromRecommendersIAmSubscribedRecs.jsp", {page: id});

		posting.done(function(data) {
			$("tr.LoadMore").replaceWith(data);
		});

	});
});

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
<legend>Who Recommended the Entity <a class="SeeAll" href="Recommended.jsp?id=<%= id %>"><%= recommended.getName() %></a> From Recommenders that <a class="SeeAll" href="Recommender.jsp?id=<%= recommender.getId() %>"><%= recommender.getNickName() %></a> is Subscribed?</legend>

			<table>
			<tbody>

				<jsp:include page="WhoRecommendedTheEntityFromRecommendersIAmSubscribedRecs.jsp?page=1" flush="true" />

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

