
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.AddRec" %>
<%@ page import="recBook.AddRecDAO" %>
<%@ page import="recBook.AddRecDAOOutro" %>
<%@ page import="recBook.DecrementRecommendations" %>
<%@ page import="recBook.IncrementRecommendations" %>

<%@ include file="SendNotification.jsp" %>

<%@ include file="Validation.jsp" %>

<%

	String table = (String) request.getParameter("table");
	String recommender = (String) request.getParameter("recommender");
	String addRec = (String) request.getParameter("addRec");
	String action = (String) request.getParameter("action");
	String buttonId = (String) request.getParameter("buttonId");
	String userAction = (String) request.getParameter("UserAction");
	String width = (String) request.getParameter("width");

%>

<% if((request.getParameter("table") == null) || (request.getParameter("recommender") == null) || (request.getParameter("addRec") == null) || (request.getParameter("action") == null) || (request.getParameter("buttonId") == null) || (request.getParameter("UserAction") == null) || (request.getParameter("width") == null)) { %>

	<span class="red">Error: Invalid Parameters</span>

<% } else { %>

<% if(!table.equals("Recommender") && !table.equals("Recommended")) { %>

	<span class="red">Error: Table Can Only Be Recommended or Recommender</span>

<% } else if(!userAction.equals("Recommend") && !userAction.equals("UnRecommend")) { %>

	<span class="red">Error: UserAction Can Only Be Recommend or UnRecommend</span>

<% } else if(!width.equals("100") && !width.equals("static")) { %>

	<span class="red">Error: width Can Only Be 100 or static</span>

<% } else if(!new Validation().isIdValid(request.getParameter("recommender"))) { %>

	<span class="red">Error: recommender Has To Be a Number</span>

<% } else if(!new Validation().isIdValid(request.getParameter("addRec"))) { %>

	<span class="red">Error: addRec Has To Be a Number</span>

<% } else if(!new Validation().isIdValid(request.getParameter("action"))) { %>

	<span class="red">Error: action Has To Be a Number</span>

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

	if(cookies != null) {

	for(Cookie cookie:cookies) {
 		if(cookie.getName().equals("IsRecommenderLogged")) {
			if(cookie.getValue().equals("Yes")) {
				isRecommenderLogged = true;
			}
		}
	}

	}

	if(isRecommenderLogged) {

		/*
		 * SELECT - DELETE
		 */

		try {

			db.conexao.setAutoCommit(false);

			if((arDAOOutro.isRecommender(Long.valueOf(recommender), Long.valueOf(addRec), Integer.valueOf(action)) > 0l) && userAction.equals("UnRecommend")) {
				new DecrementRecommendations(db).decrementRecommendations(table, Long.valueOf(addRec));
				PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM AddRec WHERE recommender = ? AND addRec = ? AND action = ?");
				ps.setLong(1, Long.valueOf(recommender));
				ps.setLong(2, Long.valueOf(addRec));
				ps.setInt(3, Integer.valueOf(action));
				ps.executeUpdate();
			} else if((arDAOOutro.isRecommender(Long.valueOf(recommender), Long.valueOf(addRec), Integer.valueOf(action)).equals(0l)) && userAction.equals("Recommend")) {
				ar.setRecommender(Long.valueOf(recommender));
				ar.setAddRec(Long.valueOf(addRec));
				ar.setAction(Integer.valueOf(action));
				arDAO.insert(ar);
				new IncrementRecommendations(db).incrementRecommendations(table, Long.valueOf(addRec));
			}

			db.conexao.commit();

			if(request.getParameter("first") != null) {

			if(userAction.equals("Recommend") && (request.getParameter("first").equals("yes"))) {

				SendNotification sn = new SendNotification(Long.valueOf(recommender), Long.valueOf(addRec), Integer.valueOf(action));

				try {
					sn.start();
				} catch(Exception e) {
					System.err.println("EmailException: "+e.getMessage());

					String uri = request.getRequestURI();
					String pageName = uri.substring(uri.lastIndexOf("/")+1);

					if(e.getMessage() != null) {
						throw new Exception(e.getMessage()+" Page: "+pageName);
					}
				}
			}

			}

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

	String button = "Recommend"+buttonId+"ForTable"+table+"";
	String buttonDiv = button+"Div";

	String bd = "ButtonRecommendOutro";
	String br = "ButtonRecommendedOutro";
	String bu = "ButtonUnRecommendOutro";

	if(width.equals("100")) {
		bd = "ButtonRecommend";
		br = "ButtonRecommended";
		bu = "ButtonUnRecommend";	
	} else if(width.equals("static")) {
		bd = "ButtonRecommendOutro";
		br = "ButtonRecommendedOutro";
		bu = "ButtonUnRecommendOutro";
	}

%>

<script type="text/javascript"> 
<!--

<% if(userAction.equals("UnRecommend")) { %>
$(document).ready(function(){
	$(".<%= button %>").one('click', function(event){
	event.stopImmediatePropagation();

	/* $(".<%= buttonDiv %>").html("<div id=\"Spinner\" class=\"Spinner\"><img width=\"100\" height=\"100\" src=\"./img/static/ajax-loader-GoldenRod.gif\" alt=\"\" /></div>"); */

	$(".<%= buttonDiv %>").load("ButtonRecommendOutro.jsp?recommender=<%= recommender %>&addRec=<%= addRec %>&action=<%= action %>&table=<%= table %>&buttonId=<%= addRec %>&UserAction=Recommend&width=<%= width %>&first=no", function (response) { $(".<%= buttonDiv %>").html(response); }); }); });
<% } else if(userAction.equals("Recommend")) { %>
$(document).ready(function(){
$(".<%= button %>").mouseover(function(){ $(".<%= button %>").html("UnRecommend"); $(".<%= button %>").addClass("<%= bu %>"); $(".<%= button %>").removeClass("<%= br %>"); });
$(".<%= button %>").mouseout(function(){ $(".<%= button %>").html("Recommended"); $(".<%= button %>").addClass("<%= br %>"); $(".<%= button %>").removeClass("<%= bu %>"); });
});
$(document).ready(function(){
	$(".<%= button %>").one('click', function(event){
	event.stopImmediatePropagation();
	$(".<%= buttonDiv %>").load("ButtonRecommendOutro.jsp?recommender=<%= recommender %>&addRec=<%= addRec %>&action=<%= action %>&table=<%= table %>&buttonId=<%= addRec %>&UserAction=UnRecommend&width=<%= width %>", function (response) { $(".<%= buttonDiv %>").html(response); }); }); });
<% } %>

//-->
</script>

<% if(userAction.equals("UnRecommend")) { %>
<button class="<%= button %> <%= bd %>">Recommend</button>
<% } else if(userAction.equals("Recommend")) { %>
<button class="<%= button %> <%= br %>">Recommended</button>
<% } %>

<% } %>

<% } %>