
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.ListenList" %>
<%@ page import="recBook.ListenListDAO" %>
<%@ page import="recBook.ListenListDAOOutro" %>
<%@ page import="recBook.DoesIdExists" %>

<%@ include file="Validation.jsp" %>

<%

	String recommender = request.getParameter("recommender");
	String album = request.getParameter("album");

%>

<% if((!new Validation().isIdValid(recommender)) || (!new Validation().isIdValid(album))) { %>

	<jsp:forward page="/Error.jsp?id=4" />

<% } else if((!new DoesIdExists().check("Recommender", (Long.valueOf(recommender)))) || (!new DoesIdExists().check("Recommended", (Long.valueOf(album))))) { %>

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

		ListenList listenList = new ListenList();

		try {

			listenList = new ListenListDAOOutro(db).select(Long.valueOf(album), Long.valueOf(recommender));

			if(listenList.getId() == null) {
				ListenList listenListInsert = new ListenList();
				listenListInsert.setAlbum(Long.valueOf(album));
				listenListInsert.setRecommender(Long.valueOf(recommender));
				listenListInsert.setStateListenFromMySQL("ToListen");
				lastInsert = new ListenListDAO(db).insert(listenListInsert);
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
	$("#ToListenActivated").click(function(){
		$("#ButtonToListenActivated").load("ButtonListened.jsp?id=<%= lastInsert %>");
	});
});

//-->
</script>

</head>

<body>

<div id="ButtonToListenActivated">
	<button id="ToListenActivated" class="ButtonRecommended">Added To To-Listen</button>
</div>

</body>
 
</html>

<% } %>
