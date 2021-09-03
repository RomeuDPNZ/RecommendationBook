
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.WatchList" %>
<%@ page import="recBook.WatchListDAO" %>
<%@ page import="recBook.WatchListDAOOutro" %>
<%@ page import="recBook.DoesIdExists" %>

<%@ include file="Validation.jsp" %>

<%

	String recommender = request.getParameter("recommender");
	String movie = request.getParameter("movie");

%>

<% if((!new Validation().isIdValid(recommender)) || (!new Validation().isIdValid(movie))) { %>

	<jsp:forward page="/Error.jsp?id=4" />

<% } else if((!new DoesIdExists().check("Recommender", (Long.valueOf(recommender)))) || (!new DoesIdExists().check("Recommended", (Long.valueOf(movie))))) { %>

	<jsp:forward page="/Error.jsp?id=2" />

<% } else { %>

<%

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	Cookie[] cookies = request.getCookies();

	Boolean isRecommenderLogged = false;

	for(Cookie cookie:cookies) {
 		if(cookie.getName().equals("IsRecommenderLogged")) {
			if(cookie.getValue().equals("Yes")) {
				isRecommenderLogged = true;
			}
		}
	}

	Long lastInsert = 0l;

	if(isRecommenderLogged) {

		/*
		 * SELECT - DELETE
		 */

		WatchList watchList = new WatchList();

		try {

			watchList = new WatchListDAOOutro(db).select(Long.valueOf(movie), Long.valueOf(recommender));

			if(watchList.getId() == null) {
				WatchList watchListInsert = new WatchList();
				watchListInsert.setMovie(Long.valueOf(movie));
				watchListInsert.setRecommender(Long.valueOf(recommender));
				watchListInsert.setStateWatchFromMySQL("ToWatch");
				lastInsert = new WatchListDAO(db).insert(watchListInsert);
			}


		} catch(SQLException e) {
			System.err.println("SQLException: "+e.getMessage());

			String uri = request.getRequestURI();
			String pageName = uri.substring(uri.lastIndexOf("/")+1);

			if(e.getMessage() != null) {
				throw new SQLException(e.getMessage()+" Page: "+pageName);
			}
		} finally {
			if(db.conexao != null) {
				db.conexao.setAutoCommit(true);
				db.DesconectaDB();
			}
		}

	} else {
		if(db.conexao != null) {
			db.DesconectaDB();
		}

		response.sendRedirect("Login.jsp");
	}

%>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="" />
<meta name="description" content="" />

<script src="js/jquery-1.10.2.js"></script>
<script type="text/javascript"> 
<!--

$(document).ready(function(){
	$("#ToWatchActivated").click(function(){
		$("#ButtonToWatchActivated").load("ButtonWatched.jsp?id=<%= lastInsert %>");
	});
});

//-->
</script>

</head>

<body>

<div id="ButtonToWatchActivated">
	<button id="ToWatchActivated" class="ButtonRecommended">Added To To-Watch</button>
</div>

</body>
 
</html>

<% } %>
