
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.ReadList" %>
<%@ page import="recBook.ReadListDAO" %>
<%@ page import="recBook.ReadListDAOOutro" %>
<%@ page import="recBook.DoesIdExists" %>

<%@ include file="Validation.jsp" %>

<%

	String id = request.getParameter("id");

%>

<% if((!new Validation().isIdValid(id))) { %>

	<jsp:forward page="/Error.jsp?id=4" />

<% } else if((!new DoesIdExists().check("ReadList", (Long.valueOf(id))))) { %>

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
	ReadList readList = new ReadList();

	if(isRecommenderLogged) {

		/*
		 * SELECT - DELETE
		 */

		try {
			db.conexao.setAutoCommit(false);

			readList = new ReadListDAO(db).select(Long.valueOf(id));

			if(readList.getId() != null) {
				new ReadListDAO(db).delete(readList.getId());
			}

			db.conexao.commit();

		} catch(SQLException e) {
			db.conexao.rollback();
			System.err.println("Transaction Is Being Rolled Back: "+e.getMessage());

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
	$("#ToRead").click(function(){
		$("#ButtonToRead").load("ButtonToReadActivated.jsp?recommender=<%= readList.getRecommender() %>&book=<%= readList.getBook() %>");
	});
});

//-->
</script>

</head>

<body>

<div id="ButtonToRead">
	<button id="ToRead" class="ButtonRecommend">To-Read</button>
</div>

</body>
 
</html>

<% } %>
