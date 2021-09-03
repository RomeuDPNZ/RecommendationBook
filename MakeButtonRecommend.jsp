
<%
	String table = (String) request.getParameter("table");
	String width = (String) request.getParameter("width");
%>

<%@ include file="Validation.jsp" %>

<% if((request.getParameter("id") == null) || (request.getParameter("table") == null) || (request.getParameter("width") == null)) { %>

	<span class="red">Error: Parameters Id or Table == null</span>

<% } else if(!width.equals("100") && !width.equals("static")) { %>

	<span class="red">Error: width Can Only Be 100 or static</span>

<% } else if(!table.equals("Recommender") && !table.equals("Recommended")) { %>

	<span class="red">Error: Table Can Only Be Recommended or Recommender</span>

<% } else if(!new Validation().isIdValid(request.getParameter("id"))) { %>

	<span class="red">Error: Id Has To Be a Number</span>

<% } else { %>

<%
	Cookie[] cookies = request.getCookies();

	Boolean isRecommenderLogged = false;
	Long recommenderIdLogged = 0l;

	if(cookies != null) {

	for(Cookie cookie:cookies) {
 		if(cookie.getName().equals("IsRecommenderLogged")) {
			if(cookie.getValue().equals("Yes")) {
				isRecommenderLogged = true;
			}
		}
	}

	for(Cookie cookie:cookies) {
 		if(cookie.getName().equals("RecommenderId")) {
			if(isRecommenderLogged) {
				recommenderIdLogged = Long.valueOf((String) cookie.getValue());
			}
		}
	}

	}

%>

<%

	Long recommendedIdShowed = Long.valueOf((String) request.getParameter("id"));

	String ButtonRecommend = "Recommend"+recommendedIdShowed+"ForTable"+table+"";

%>

<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%@ page import="recBook.DB" %>

<%@ page import="recBook.Recommended" %>
<%@ page import="recBook.RecommendedDAO" %>
<%@ page import="recBook.RecommendedType" %>
<%@ page import="recBook.RecommendedTypeDAO" %>
<%@ page import="recBook.AddRecDAOOutro" %>
<%@ page import="recBook.ActionsDAOOutro" %>

<%@ page import="recBook.Recommender" %>
<%@ page import="recBook.RecommenderPageDAO" %>

<%

	RecommenderPageDAO rpDAO = null;
	Recommender recommender = new Recommender();
	Integer action = 0;
	Long recommendedId = 0l;

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	if(table.equals("Recommended")) {

	Recommended recommended = new Recommended();
	RecommendedDAO recommendedDAO = new RecommendedDAO(db);

	try {

		recommended = recommendedDAO.select(recommendedIdShowed);

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	RecommendedType recommendedType = new RecommendedType();
	RecommendedTypeDAO recommendedTypeDAO = new RecommendedTypeDAO(db);
	
	try {

		recommendedType = recommendedTypeDAO.select(Long.valueOf(recommended.getType()));

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	String type = recommendedType.getType();

	try {

		action = new ActionsDAOOutro(db).getActionId("Recommended the "+type+"");

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	AddRecDAOOutro addRecDAOOutro = new AddRecDAOOutro(db);

	try {

		recommendedId = new AddRecDAOOutro(db).isRecommender(recommenderIdLogged, recommendedIdShowed, action);

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	} else if(table.equals("Recommender")) {

	try {

		rpDAO = new RecommenderPageDAO(db, recommenderIdLogged, recommendedIdShowed);

		recommender = rpDAO.getRecommender();
		action = rpDAO.getAction();
		recommendedId = rpDAO.getRecommended();

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally {}

	}

	/*
	 * Desconecta do Banco de Dados
	 */

	if(db.conexao != null) {
		db.DesconectaDB();
	}

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

<% if(isRecommenderLogged) { %>
<script type="text/javascript"> 
<!--
	<% if(recommendedId > 0l) { %>
$(document).ready(function(){
$(".<%= ButtonRecommend %>").mouseover(function(){ $(".<%= ButtonRecommend %>").html("UnRecommend"); $(".<%= ButtonRecommend %>").addClass("<%= bu %>"); $(".<%= ButtonRecommend %>").removeClass("<%= br %>"); });
$(".<%= ButtonRecommend %>").mouseout(function(){ $(".<%= ButtonRecommend %>").html("Recommended"); $(".<%= ButtonRecommend %>").addClass("<%= br %>"); $(".<%= ButtonRecommend %>").removeClass("<%= bu %>"); });
});
$(document).ready(function(){ $(".<%= ButtonRecommend %>").one('click', function(event){
	event.stopImmediatePropagation();
	$(".<%= ButtonRecommend %>Div").load("ButtonRecommendOutro.jsp?recommender=<%= recommenderIdLogged %>&addRec=<%= recommendedIdShowed %>&action=<%= action %>&table=<%= table %>&buttonId=<%= recommendedIdShowed %>&UserAction=UnRecommend&width=<%= width %>", function (response) { $(".<%= ButtonRecommend %>Div").html(response); }); }); });
	<% } else { %>
$(document).ready(function(){ $(".<%= ButtonRecommend %>").one('click', function(event){
	event.stopImmediatePropagation();

	/* $(".<%= ButtonRecommend %>Div").html("<div id=\"Spinner\" class=\"Spinner\"><img width=\"100\" height=\"100\" src=\"./img/static/ajax-loader-GoldenRod.gif\" alt=\"\" /></div>"); */

	$(".<%= ButtonRecommend %>Div").load("ButtonRecommendOutro.jsp?recommender=<%= recommenderIdLogged %>&addRec=<%= recommendedIdShowed %>&action=<%= action %>&table=<%= table %>&buttonId=<%= recommendedIdShowed %>&UserAction=Recommend&width=<%= width %>&first=yes", function (response) { $(".<%= ButtonRecommend %>Div").html(response); }); }); });
	<% } %>

//-->
</script>
<% } else { %>
<script type="text/javascript"> 
<!--
$(document).ready(function(){ $(".<%= ButtonRecommend %>").one('click', function(event){
	event.stopImmediatePropagation();
	$(".<%= ButtonRecommend %>Div").load("AboutNotLoggedRecommend.jsp", function (response) { $(".<%= ButtonRecommend %>Div").html(response); }); }); });
//-->
</script>
<% } %>

<% if(recommendedId > 0l) { %>
<div class="<%= ButtonRecommend %>Div <%= bd %>"><button class="<%= ButtonRecommend %> <%= br %>">Recommended</button></div>
<% } else { %>
<div class="<%= ButtonRecommend %>Div <%= bd %>"><button class="<%= ButtonRecommend %> <%= bd %>">Recommend</button></div>
<% } %>

<% } %>
