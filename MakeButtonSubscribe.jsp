
<%
	String width = (String) request.getParameter("width");
	String recommender = (String) request.getParameter("recommender");
%>

<%@ include file="Validation.jsp" %>

<% if((request.getParameter("recommender") == null) || (request.getParameter("width") == null)) { %>

	<span class="red">Error: Parameters recommender or width == null</span>

<% } else if(!width.equals("100") && !width.equals("static") && !width.equals("small")) { %>

	<span class="red">Error: width Can Only Be 100 or static or small</span>

<% } else if(!new Validation().isIdValid(request.getParameter("recommender"))) { %>

	<span class="red">Error: recommender Has To Be a Number</span>

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

<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%@ page import="recBook.DB" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Subscription" %>
<%@ page import="recBook.SubscriptionDAO" %>
<%@ page import="recBook.SubscriptionDAOOutro" %>

<%

	String ButtonRecommend = "SubscribeFor"+recommender+"";

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	SubscriptionDAOOutro sDAOOutro = new SubscriptionDAOOutro(db);

	Boolean isSubscribed = false;

		try {

			if(sDAOOutro.isSubscribed(Long.valueOf(recommender), Long.valueOf(recommenderIdLogged)) > 0l) {
				isSubscribed = true;
			}

		} catch(SQLException e) {
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
	} else if(width.equals("small")) {
		bd = "ButtonRecommendSmall";
		br = "ButtonRecommendedSmall";
		bu = "ButtonUnRecommendSmall";
	}

%>

<% if(isRecommenderLogged) { %>
<script type="text/javascript"> 
<!--
	<% if(isSubscribed.equals(true)) { %>
$(document).ready(function(){
$(".<%= ButtonRecommend %>").mouseover(function(){ $(".<%= ButtonRecommend %>").html("UnSubscribe"); $(".<%= ButtonRecommend %>").addClass("<%= bu %>"); $(".<%= ButtonRecommend %>").removeClass("<%= br %>"); });
$(".<%= ButtonRecommend %>").mouseout(function(){ $(".<%= ButtonRecommend %>").html("Subscribed"); $(".<%= ButtonRecommend %>").addClass("<%= br %>"); $(".<%= ButtonRecommend %>").removeClass("<%= bu %>"); });
});
$(document).ready(function(){ $(".<%= ButtonRecommend %>").one('click', function(event){ event.stopImmediatePropagation(); 
$(".<%= ButtonRecommend %>Div").load("ButtonSubscribeOutro.jsp?recommender=<%= recommender %>&subscriber=<%= recommenderIdLogged %>&UserAction=UnSubscribe&width=<%= width %>", function (response) { $(".<%= ButtonRecommend %>Div").html(response); }); }); });
	<% } else { %>
$(document).ready(function(){ $(".<%= ButtonRecommend %>").one('click', function(event){ event.stopImmediatePropagation(); 
$(".<%= ButtonRecommend %>Div").load("ButtonSubscribeOutro.jsp?recommender=<%= recommender %>&subscriber=<%= recommenderIdLogged %>&UserAction=Subscribe&width=<%= width %>", function (response) { $(".<%= ButtonRecommend %>Div").html(response); }); }); });
	<% } %>

//-->
</script>
<% } else { %>
<script type="text/javascript"> 
<!--
$(document).ready(function(){ $(".<%= ButtonRecommend %>").one('click', function(event){ event.stopImmediatePropagation(); $(".<%= ButtonRecommend %>Div").load("AboutNotLoggedSubscribe.jsp", function (response) { $(".<%= ButtonRecommend %>Div").html(response); }); }); });
//-->
</script>
<% } %>

<% if(isSubscribed.equals(true)) { %>
<div class="<%= ButtonRecommend %>Div <%= bd %>"><button class="<%= ButtonRecommend %> <%= br %>">Subscribed</button></div>
<% } else { %>
<div class="<%= ButtonRecommend %>Div <%= bd %>"><button class="<%= ButtonRecommend %> <%= bd %>">Subscribe</button></div>
<% } %>

<% } %>
