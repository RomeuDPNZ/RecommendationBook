
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.AddRec" %>
<%@ page import="recBook.AddRecDAO" %>
<%@ page import="recBook.AddRecDAOOutro" %>
<%@ page import="recBook.IncrementRecommendations" %>

<%@ include file="Validation.jsp" %>

<%

	String table = request.getParameter("table");
	String recommender = request.getParameter("recommender");
	String addRec = request.getParameter("addRec");
	String action = request.getParameter("action");

	Validation v = new Validation();

%>

<% if(!v.isIdValid(recommender) || !v.isIdValid(addRec) || !v.isIdValid(action)) { %>

	<jsp:forward page="/Error.jsp?id=6" />

<% } else if(!table.equals("Recommender") && !table.equals("Recommended")) { %>

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

		AddRec ar = new AddRec();

		ar.setRecommender(Long.valueOf(recommender));
		ar.setAddRec(Long.valueOf(addRec));
		ar.setAction(Integer.valueOf(action));

		AddRecDAO arDAO = new AddRecDAO(db);
		AddRecDAOOutro arDAOOutro = new AddRecDAOOutro(db);

		/*
		 * INSERT
		 */

		try {


			db.conexao.setAutoCommit(false);

			if(arDAOOutro.isRecommender(ar.getRecommender(), ar.getAddRec(), ar.getAction()).equals(0l)) {
				lastInsert = arDAO.insert(ar);
				new IncrementRecommendations(db).incrementRecommendations(table, ar.getAddRec());
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
	$("#Recommended").mouseover(function(){
		$("#Recommended").html("UnRecommend");
		$("#Recommended").addClass("ButtonUnRecommend");
		$("#Recommended").removeClass("ButtonRecommended");
	});
	$("#Recommended").mouseout(function(){
		$("#Recommended").html("Recommended");
		$("#Recommended").addClass("ButtonRecommended");
		$("#Recommended").removeClass("ButtonUnRecommend");
	});
});

$(document).ready(function(){
	$("#Recommended").click(function(){
		$("#ButtonRecommend").load("ButtonRecommend.jsp?id=<%= lastInsert %>&table=<%= table %>");
	});
});

//-->
</script>

</head>

<body>

<div id="ButtonRecommended">
	<button id="Recommended" class="ButtonRecommended">Recommended</button>
</div>

</body>
 
</html>

<% } %>

