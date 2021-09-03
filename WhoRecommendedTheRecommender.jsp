
<% if(!request.getParameterMap().containsKey("id")) { %>

	<jsp:forward page="/index.jsp" />

<% } else { %>

<jsp:include page="GetDevice.jsp" flush="true" />

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Recommender" %>
<%@ page import="recBook.RecommenderDAOOutro" %>

<%

	Long id = Long.valueOf((String) request.getParameter("id"));

	session.setAttribute("idWhoRecommendedTheRecommender", ""+id+"");

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	Recommender recommender = new Recommender();
	RecommenderDAOOutro recommenderDAOOutro = new RecommenderDAOOutro(db);

	try {
		recommender = recommenderDAOOutro.selectForSeeAll(id);

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
	} finally {}

	/*
	 * Desconecta do Banco de Dados
	 */

	if(db.conexao != null) {
		db.DesconectaDB();
	}

%>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="Who Recommended the Recommender <%= recommender.getNickName() %> on Recommendation Book" />
<meta name="description" content="Who Recommended the Recommender <%= recommender.getNickName() %> on Recommendation Book" />

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

		var posting = $.post("WhoRecommendedTheRecommenderRecs.jsp", {page: id});

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
	<legend>Who Recommended the Recommender <a class="SeeAll" href="Recommender.jsp?id=<%= id %>"><%= recommender.getNickName() %></a></legend>

			<table>
			<tbody>

				<jsp:include page="WhoRecommendedTheRecommenderRecs.jsp?page=1" flush="true" />

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
