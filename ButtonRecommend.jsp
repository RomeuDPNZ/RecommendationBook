
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.AddRec" %>
<%@ page import="recBook.AddRecDAO" %>
<%@ page import="recBook.AddRecDAOOutro" %>
<%@ page import="recBook.DecrementRecommendations" %>

<%@ include file="Validation.jsp" %>

<%

	String id = request.getParameter("id");
	String table = request.getParameter("table");

%>

<% if(!new Validation().isIdValid(id)) { %>

	<jsp:forward page="/Error.jsp?id=6" />

<% } else if(!table.equals("Recommender") && !table.equals("Recommended")) { %>

	<jsp:forward page="/Error.jsp?id=6" />

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

	AddRec ar = new AddRec();
	AddRecDAO arDAO = new AddRecDAO(db);
	AddRecDAOOutro arDAOOutro = new AddRecDAOOutro(db);

	Cookie[] cookies = request.getCookies();

	Boolean isRecommenderLogged = false;

	for(Cookie cookie:cookies) {
 		if(cookie.getName().equals("IsRecommenderLogged")) {
			if(cookie.getValue().equals("Yes")) {
				isRecommenderLogged = true;
			}
		}
	}

	if(isRecommenderLogged) {

		/*
		 * SELECT - DELETE
		 */

		Long lastInsert = 0l;

		try {

			db.conexao.setAutoCommit(false);

			ar = arDAO.select(Long.valueOf(id));

			if(arDAOOutro.isRecommender(ar.getRecommender(), ar.getAddRec(), ar.getAction()) > 0l) {
				new DecrementRecommendations(db).decrementRecommendations(table, ar.getAddRec());
				arDAO.delete(Long.valueOf(id));
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
	$("#Recommend").click(function(){
	$("#ButtonRecommend").load("ButtonRecommended.jsp?recommender=<%= ar.getRecommender() %>&addRec=<%= ar.getAddRec() %>&action=<%= ar.getAction() %>&table=<%= table %>");
	});
});

//-->
</script>

</head>

<body>

<div id="ButtonRecommend">
	<button id="Recommend" class="ButtonRecommend">Recommend</button>
</div>

</body>
 
</html>

<% } %>
