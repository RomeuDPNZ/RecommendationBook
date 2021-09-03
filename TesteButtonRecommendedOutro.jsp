
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.AddRec" %>
<%@ page import="recBook.AddRecDAO" %>
<%@ page import="recBook.AddRecDAOOutro" %>
<%@ page import="recBook.IncrementRecommendations" %>

<%@ include file="Validation.jsp" %>

<%

	String table = (String) request.getParameter("table");
	String recommender = (String) request.getParameter("recommender");
	String addRec = (String) request.getParameter("addRec");
	String action = (String) request.getParameter("action");
	String buttonId = (String) request.getParameter("buttonId");

	Validation v = new Validation();

%>

<% if(!v.isIdValid(recommender) || !v.isIdValid(addRec) || !v.isIdValid(action)) { %>

	<span class="red">Error: Parameters recommender or addRec or action == null</span>

<% } else if(!table.equals("Recommender") && !table.equals("Recommended")) { %>

	<span class="red">Error: Table Can Only Be Recommended or Recommender</span>

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

	String button = "Recommended"+buttonId+"ForTable"+table+"";
	String buttonDiv = button+"Div";

%>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="" />
<meta name="description" content="" />

<script src="//code.jquery.com/jquery-1.12.0.min.js"></script>
<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
<script type="text/javascript"> 
<!--

$(document).ready(function(){
	$(".<%= button %>").mouseover(function(){
		$(".<%= button %>").html("UnRecommend");
		$(".<%= button %>").addClass("ButtonUnRecommend");
		$(".<%= button %>").removeClass("ButtonRecommended");
	});
	$(".<%= button %>").mouseout(function(){
		$(".<%= button %>").html("Recommended");
		$(".<%= button %>").addClass("ButtonRecommended");
		$(".<%= button %>").removeClass("ButtonUnRecommend");
	});
});

$(document).ready(function(){
	$(".<%= button %>").click(function(){
		$(".<%= buttonDiv %>").load("ButtonRecommendOutro.jsp?id=<%= lastInsert %>&table=<%= table %>&buttonId=<%= buttonId %>");
		console.log("ButtonRecommendOutro.jsp?id=<%= lastInsert %>&table=<%= table %>&buttonId=<%= buttonId %>");
	});
});

//-->
</script>

</head>

<body>

<div class="<%= buttonDiv %>">
	<button class="<%= button %> ButtonRecommended">Recommended</button>
</div>

</body>
 
</html>

<% } %>

