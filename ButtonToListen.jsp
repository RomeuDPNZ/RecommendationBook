
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.ListenList" %>
<%@ page import="recBook.ListenListDAO" %>
<%@ page import="recBook.ListenListDAOOutro" %>
<%@ page import="recBook.DoesIdExists" %>

<%@ include file="Validation.jsp" %>

<%

	String id = request.getParameter("id");

%>

<% if((!new Validation().isIdValid(id))) { %>

	<jsp:forward page="/Error.jsp?id=4" />

<% } else if((!new DoesIdExists().check("ListenList", (Long.valueOf(id))))) { %>

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
	ListenList listenList = new ListenList();

	if(isRecommenderLogged) {

		/*
		 * SELECT - DELETE
		 */

		try {
			db.conexao.setAutoCommit(false);

			listenList = new ListenListDAO(db).select(Long.valueOf(id));

			if(listenList.getId() != null) {
				new ListenListDAO(db).delete(listenList.getId());
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
	$("#ToListen").click(function(){
		$("#ButtonToListen").load("ButtonToListenActivated.jsp?recommender=<%= listenList.getRecommender() %>&album=<%= listenList.getAlbum() %>");
	});
});

//-->
</script>

</head>

<body>

<div id="ButtonToListen">
	<button id="ToListen" class="ButtonRecommend">To-Listen</button>
</div>

</body>
 
</html>

<% } %>
