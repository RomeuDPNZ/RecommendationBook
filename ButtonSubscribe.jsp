
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Subscription" %>
<%@ page import="recBook.SubscriptionDAO" %>
<%@ page import="recBook.SubscriptionDAOOutro" %>

<%@ include file="Validation.jsp" %>

<%

	String id = request.getParameter("id");

%>

<% if(!new Validation().isIdValid(id)) { %>

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

	Subscription s = new Subscription();
	SubscriptionDAO sDAO = new SubscriptionDAO(db);
	SubscriptionDAOOutro sDAOOutro = new SubscriptionDAOOutro(db);

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

			s = sDAO.select(Long.valueOf(id));

			if(sDAOOutro.isSubscribed(s.getRecommender(), s.getSubscriber()) > 0l) {
				sDAO.delete(Long.valueOf(id));
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
	$("#Subscribe").click(function(){
		$("#ButtonSubscribe").load("ButtonSubscribed.jsp?recommender=<%= s.getRecommender() %>&subscriber=<%= s.getSubscriber() %>");
	});
});

//-->
</script>

</head>

<body>

<!-- <button id="Subscribe" class="ButtonSubscribe">Subscribe</button> -->

<div id="ButtonSubscribe">
	<button id="Subscribe" class="ButtonSubscribe">Subscribe</button>
</div>

</body>
 
</html>

<% } %>
