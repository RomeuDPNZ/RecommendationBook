
<% if(!request.getParameterMap().containsKey("id")) { %>

	<jsp:forward page="/index.jsp" />

<% } else { %>

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
 
<meta name="keywords" content="Recommendations for the Entity <%= recommended.getName() %> by Sex, Age Range and Country on Recommendation Book by Country" />
<meta name="description" content="Recommendations for the Entity <%= recommended.getName() %> by Sex, Age Range and Country on Recommendation Book by Country" />

<link rel="icon" href="./img/static/RBIcon.ico" type="image/x-icon">

<link href='http://fonts.googleapis.com/css?family=Roboto:500' rel='stylesheet' type='text/css'>

<style type="text/css">
<!--
   @import url("RecommendationBookCSS.css");
-->
</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />

<script src="js/jquery-1.10.2.js"></script>
<script type="text/javascript"> 
<!--

$(document).ready(function(){
	$("#TableWithCriterias").change(function() {
		var sex = $("#sex").val();
		var country = $("#country").val();
		var from = $("#ageFrom").val();
		var to = $("#ageTo").val();

		if(sex != "" && country != "" && from != "" && to != "") {

			$("#spanRecommendations").empty().append("Computing...");

			var posting = $.post("RecommendationsBySexAgeAndCountryRecs.jsp", {id: <%= id %>, action: <%= action %>, sex: sex, country: country, from: from, to: to});

			posting.done(function(data) {
				$("#spanRecommendations").empty().append(data);
			});

		}
	});
});

//-->
</script>

</head>

<body>

<jsp:include page="MiniMenu.jsp" flush="true" />

<div class="Corpo">

	<fieldset>
	<legend>Recommendations for the Entity <a class="SeeAll" href="Recommended.jsp?id=<%= id %>"><%= recommended.getName() %></a> by Sex, Age Range and Country</legend>

			<table id="TableWithCriterias">

				<thead>
				<tr>
				<td colspan="2">
<h1 class="Action">Choose the Sex, Country and Age Range for the Entity...</h1>
				</td>
				</tr>
				</thead>

			<tbody>

				<tr><td class="tdRight">Sex</td><td class="tdLeft"><select id="sex" name="sex">
				<jsp:include page="Sex.jsp" flush="true" />
				</select></td>

				<tr><td class="tdRight">Country</td><td class="tdLeft"><select id="country" name="country">
				<jsp:include page="Countries.jsp?withWWE=Yes" flush="true" />
				</select></td>

				<tr><td class="tdRight">From Age</td><td class="tdLeft"><select id="ageFrom" name="ageFrom">
				<jsp:include page="AgeRange.jsp?from=0&to=120" flush="true" />
				</select></td>

				<tr><td class="tdRight">To Age</td><td class="tdLeft"><select id="ageTo" name="ageTo">
				<jsp:include page="AgeRange.jsp?from=0&to=120" flush="true" />
				</select></td>

			</tbody>
			</table>

	</fieldset>

	<fieldset>
	<legend>Result</legend>

			<table>
			<tbody>
				<tr>
				<td>
					<span class="green" style="font-size: 30px" id="spanRecommendations"></span>
				</td>
				</tr>
			</tbody>
			</table>

	</fieldset>

</div>

<jsp:include page="Rodape.jsp" flush="true" />

</body>
 
</html>

<% } %>
