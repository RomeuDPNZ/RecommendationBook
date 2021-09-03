
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Subscription" %>
<%@ page import="recBook.SubscriptionDAO" %>
<%@ page import="recBook.SubscriptionDAOOutro" %>

<%@ include file="Validation.jsp" %>

<%

	String recommender = request.getParameter("recommender");
	String subscriber = request.getParameter("subscriber");

	Validation v = new Validation();

%>

<% if(!v.isIdValid(recommender) && !v.isIdValid(subscriber)) { %>

	<jsp:forward page="/Error.jsp?id=6" />

<% } else { %>

<%

	Long lastInsert = 0l;

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

	if(isRecommenderLogged) {

		Subscription s = new Subscription();

		s.setRecommender(Long.valueOf(recommender));
		s.setSubscriber(Long.valueOf(subscriber));

		SubscriptionDAO sDAO = new SubscriptionDAO(db);
		SubscriptionDAOOutro sDAOOutro = new SubscriptionDAOOutro(db);

		/*
		 * INSERT
		 */

		try {

			if(sDAOOutro.isSubscribed(s.getRecommender(), s.getSubscriber()).equals(0l)) {
				lastInsert = sDAO.insert(s);
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
	$("#Subscribed").mouseover(function(){
		$("#Subscribed").html("UnSubscribe");
		$("#Subscribed").addClass("ButtonUnSubscribe");
		$("#Subscribed").removeClass("ButtonSubscribed");
	});
	$("#Subscribed").mouseout(function(){
		$("#Subscribed").html("Subscribed");
		$("#Subscribed").addClass("ButtonSubscribed");
		$("#Subscribed").removeClass("ButtonUnSubscribe");
	});
});

$(document).ready(function(){
	$("#Subscribed").click(function(){
		$("#ButtonSubscribed").load("ButtonSubscribe.jsp?id=<%= lastInsert %>");
	});
});

//-->
</script>

</head>

<body>

<!-- <button id="Subscribeded" class="ButtonSubscribed">Subscribed</button> -->

<div id="ButtonSubscribed">
	<button id="Subscribed" class="ButtonSubscribed">Subscribed</button>
</div>

</body>
 
</html>

<% } %>

