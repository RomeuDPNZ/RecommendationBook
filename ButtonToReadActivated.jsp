
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.ReadList" %>
<%@ page import="recBook.ReadListDAO" %>
<%@ page import="recBook.ReadListDAOOutro" %>
<%@ page import="recBook.DoesIdExists" %>

<%@ include file="Validation.jsp" %>

<%

	String recommender = request.getParameter("recommender");
	String book = request.getParameter("book");

%>

<% if((!new Validation().isIdValid(recommender)) || (!new Validation().isIdValid(book))) { %>

	<jsp:forward page="/Error.jsp?id=4" />

<% } else if((!new DoesIdExists().check("Recommender", (Long.valueOf(recommender)))) || (!new DoesIdExists().check("Recommended", (Long.valueOf(book))))) { %>

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

		ReadList readList = new ReadList();

		try {

			readList = new ReadListDAOOutro(db).select(Long.valueOf(book), Long.valueOf(recommender));

			if(readList.getId() == null) {
				ReadList readListInsert = new ReadList();
				readListInsert.setBook(Long.valueOf(book));
				readListInsert.setRecommender(Long.valueOf(recommender));
				readListInsert.setStateReadFromMySQL("ToRead");
				lastInsert = new ReadListDAO(db).insert(readListInsert);
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
	$("#ToReadActivated").click(function(){
		$("#ButtonToReadActivated").load("ButtonRead.jsp?id=<%= lastInsert %>");
	});
});

//-->
</script>

</head>

<body>

<div id="ButtonToReadActivated">
	<button id="ToReadActivated" class="ButtonRecommended">Added To To-Read</button>
</div>

</body>
 
</html>

<% } %>
