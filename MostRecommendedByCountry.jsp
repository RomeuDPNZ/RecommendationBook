
<% if(!request.getParameterMap().containsKey("country")) { %>

	<jsp:forward page="/index.jsp" />

<% } else { %>

<jsp:include page="GetDevice.jsp" flush="true" />

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>

<%@ page import="recBook.Countries" %>
<%@ page import="recBook.CountriesDAO" %>

<%

	String country = (String) request.getParameter("country");

	session.setAttribute("countryForMost", ""+country+"");
	session.setAttribute("ranking", "1");
	session.setAttribute("pastRecommendations", "0");

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	Countries countries = new Countries();
	CountriesDAO countriesDAO = new CountriesDAO(db);

	try {

		countries = countriesDAO.select(Long.valueOf(country));
		country = countries.getCountry();

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
	} finally {
		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}
	}

%>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="The Most Recommended From <%= country %>" />
<meta name="description" content="The Most Recommended From <%= country %>" />

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

		var posting = $.post("MostRecommendedByCountryRecs.jsp", {page: id});

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
	<legend>The Most Recommended From <%= country %></legend>

			<table>
			<tbody>

				<jsp:include page="MostRecommendedByCountryRecs.jsp?page=1" flush="true" />

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
