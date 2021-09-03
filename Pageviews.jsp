
<%
	Cookie[] cookies = request.getCookies();

	Boolean isRecommenderLogged = false;
	Long recommenderIdLogged = 0l;

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

	session.setAttribute("RecommenderIdLogged", ""+recommenderIdLogged+"");
%>

<% if(!recommenderIdLogged.equals(1l)) { %>

	<jsp:forward page="/Error.jsp?id=7" />

<% } else { %>

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

	Long about = 0l;
	Long addRecommended = 0l;
	Long addRecommender = 0l;
	Long addRecommendedNonLogged = 0l;
	Long saveRecommended = 0l;
	Long saveRecommender = 0l;
	Long beforeUpdateRecommended = 0l;
	Long beforeUpdateRecommender = 0l;
	Long beforeDeleteRecommended = 0l;
	Long saveUpdateRecommended = 0l;
	Long saveUpdateRecommender = 0l;
	Long saveDeleteRecommended = 0l;
	Long doLogin = 0l;
	Long login = 0l;
	Long doResetPassword = 0l;
	Long resetPassword = 0l;
	Long doSearch = 0l;
	Long doRecommendersRBSearch = 0l;
	Long search = 0l;
	Long error = 0l;
	Long index = 0l;
	Long logOut = 0l;
	Long contact = 0l;
	Long contactValidation = 0l;
	Long messageToRecommender = 0l;

	try {

		PreparedStatement ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='index'");
		ResultSet result = ps.executeQuery();
		while(result.next()) { index = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='About'");
		result = ps.executeQuery();
		while(result.next()) { about = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='AddRecommended'");
		result = ps.executeQuery();
		while(result.next()) { addRecommended = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='AddRecommender'");
		result = ps.executeQuery();
		while(result.next()) { addRecommender = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='SaveRecommended'");
		result = ps.executeQuery();
		while(result.next()) { saveRecommended = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='SaveRecommender'");
		result = ps.executeQuery();
		while(result.next()) { saveRecommender = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='BeforeUpdateRecommended'");
		result = ps.executeQuery();
		while(result.next()) { beforeUpdateRecommended = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='BeforeUpdateRecommender'");
		result = ps.executeQuery();
		while(result.next()) { beforeUpdateRecommender = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='BeforeDeleteRecommended'");
		result = ps.executeQuery();
		while(result.next()) { beforeDeleteRecommended = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='SaveUpdateRecommended'");
		result = ps.executeQuery();
		while(result.next()) { saveUpdateRecommended = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='SaveUpdateRecommender'");
		result = ps.executeQuery();
		while(result.next()) { saveUpdateRecommender = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='SaveDeleteRecommended'");
		result = ps.executeQuery();
		while(result.next()) { saveDeleteRecommended = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='DoLogin'");
		result = ps.executeQuery();
		while(result.next()) { doLogin = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='Login'");
		result = ps.executeQuery();
		while(result.next()) { login = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='DoResetPassword'");
		result = ps.executeQuery();
		while(result.next()) { doResetPassword = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='ResetPassword'");
		result = ps.executeQuery();
		while(result.next()) { resetPassword = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='DoSearch'");
		result = ps.executeQuery();
		while(result.next()) { doSearch = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='DoRecommendersRBSearch'");
		result = ps.executeQuery();
		while(result.next()) { doRecommendersRBSearch = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='Search'");
		result = ps.executeQuery();
		while(result.next()) { search = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='Error'");
		result = ps.executeQuery();
		while(result.next()) { error = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='LogOut'");
		result = ps.executeQuery();
		while(result.next()) { logOut = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='Contact'");
		result = ps.executeQuery();
		while(result.next()) { contact = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='ContactValidation'");
		result = ps.executeQuery();
		while(result.next()) { contactValidation = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='MessageToRecommender'");
		result = ps.executeQuery();
		while(result.next()) { messageToRecommender = result.getLong("pageViews"); }

		ps = db.conexao.prepareStatement("SELECT pageViews FROM PageViews WHERE page='AddRecommendedNonLogged'");
		result = ps.executeQuery();
		while(result.next()) { addRecommendedNonLogged = result.getLong("pageViews"); }

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

%>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="" />
<meta name="description" content="" />
 
<style type="text/css">

div.PageViews {
	padding: 1em;
	border: 1px solid green;
	margin-bottom: 1em;
}

</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />

<script type="text/javascript"> 
<!--

//-->
</script>

</head>

<body>

<div class="Geral">
	<jsp:include page="CabecalhoMenu.jsp" flush="true" />
	<jsp:include page="Search.jsp" flush="true" />
	<div class="Corpo">

<%

	out.print("<div class=\"PageViews\">Index = "+index.toString()+"</div>");
	out.print("<div class=\"PageViews\">about = "+about.toString()+"</div>");
	out.print("<div class=\"PageViews\">addRecommended = "+addRecommended.toString()+"</div>");
	out.print("<div class=\"PageViews\">addRecommender = "+addRecommender.toString()+"</div>");
	out.print("<div class=\"PageViews\">addRecommendedNonLogged = "+addRecommendedNonLogged.toString()+"</div>");
	out.print("<div class=\"PageViews\">saveRecommended = "+saveRecommended.toString()+"</div>");
	out.print("<div class=\"PageViews\">saveRecommender = "+saveRecommender.toString()+"</div>");
	out.print("<div class=\"PageViews\">beforeUpdateRecommended = "+beforeUpdateRecommended.toString()+"</div>");
	out.print("<div class=\"PageViews\">beforeUpdateRecommender = "+beforeUpdateRecommender.toString()+"</div>");
	out.print("<div class=\"PageViews\">beforeDeleteRecommended = "+beforeDeleteRecommended.toString()+"</div>");
	out.print("<div class=\"PageViews\">saveUpdateRecommended = "+saveUpdateRecommended.toString()+"</div>");
	out.print("<div class=\"PageViews\">saveUpdateRecommender = "+saveUpdateRecommender.toString()+"</div>");
	out.print("<div class=\"PageViews\">saveDeleteRecommended = "+saveDeleteRecommended.toString()+"</div>");
	out.print("<div class=\"PageViews\">doLogin = "+doLogin.toString()+"</div>");
	out.print("<div class=\"PageViews\">login = "+login.toString()+"</div>");
	out.print("<div class=\"PageViews\">doResetPassword = "+doResetPassword.toString()+"</div>");
	out.print("<div class=\"PageViews\">resetPassword = "+resetPassword.toString()+"</div>");
	out.print("<div class=\"PageViews\">doSearch = "+doSearch.toString()+"</div>");
	out.print("<div class=\"PageViews\">doRecommendersRBSearch = "+doRecommendersRBSearch.toString()+"</div>");
	out.print("<div class=\"PageViews\">search = "+search.toString()+"</div>");
	out.print("<div class=\"PageViews\">error = "+error.toString()+"</div>");
	out.print("<div class=\"PageViews\">logOut = "+logOut.toString()+"</div>");
	out.print("<div class=\"PageViews\">contact = "+contact.toString()+"</div>");
	out.print("<div class=\"PageViews\">contactValidation = "+contactValidation.toString()+"</div>");
	out.print("<div class=\"PageViews\">messageToRecommender = "+messageToRecommender.toString()+"</div>");
%>

	</div>
	<jsp:include page="Rodape.jsp" flush="true" />
</div>

</body>
 
</html>

<% } %>
