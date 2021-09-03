
<%@ page errorPage="Error.jsp" %>

<%@ include file="Validation.jsp" %>

<%

	String recommender = (String) request.getParameter("recommender");
	String subscriber = (String) request.getParameter("subscriber");
	String userAction = (String) request.getParameter("UserAction");
	String width = (String) request.getParameter("width");

%>

<% if(((request.getParameter("recommender") == null) || (request.getParameter("subscriber") == null) || (request.getParameter("UserAction") == null) || (request.getParameter("width") == null))) { %>

	<span class="red">Error: Invalid Parameters</span>

<% } else { %>

<% if((request.getParameter("recommender") == null) || (request.getParameter("width") == null)) { %>

	<span class="red">Error: Parameters Id or Table == null</span>

<% } else if(!width.equals("100") && !width.equals("static") && !width.equals("small")) { %>

	<span class="red">Error: width Can Only Be 100 or static or small</span>

<% } else if(!new Validation().isIdValid(request.getParameter("recommender"))) { %>

	<span class="red">Error: recommender Has To Be a Number</span>

<% } else if(!new Validation().isIdValid(request.getParameter("subscriber"))) { %>

	<span class="red">Error: subscriber Has To Be a Number</span>

<% } else { %>

<%

	String ButtonRecommend = "SubscribeFor"+recommender+"";

%>

<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Subscription" %>
<%@ page import="recBook.SubscriptionDAO" %>
<%@ page import="recBook.SubscriptionDAOOutro" %>

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

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
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

			if(sDAOOutro.isSubscribed(s.getRecommender(), s.getSubscriber()).equals(0l) && userAction.equals("Subscribe")) {
				sDAO.insert(s);
			} else if((sDAOOutro.isSubscribed(s.getRecommender(), s.getSubscriber()) > 0l) && userAction.equals("UnSubscribe")) {
				PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM Subscription WHERE recommender = ? AND subscriber = ?");
				ps.setLong(1, s.getRecommender());
				ps.setLong(2, s.getSubscriber());
				ps.executeUpdate();
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

<script type="text/javascript"> 
<!--

<% if(userAction.equals("UnSubscribe")) { %>
$(document).ready(function(){ $(".<%= ButtonRecommend %>").one('click', function(event){ event.stopImmediatePropagation(); 
$(".<%= ButtonRecommend %>Div").load("ButtonSubscribeOutro.jsp?recommender=<%= recommender %>&subscriber=<%= recommenderIdLogged %>&UserAction=Subscribe&width=<%= width %>", function (response) { $(".<%= ButtonRecommend %>Div").html(response); }); }); });
<% } else if(userAction.equals("Subscribe")) { %>
$(document).ready(function(){
$(".<%= ButtonRecommend %>").mouseover(function(){ $(".<%= ButtonRecommend %>").html("UnSubscribe"); $(".<%= ButtonRecommend %>").addClass("<%= bu %>"); $(".<%= ButtonRecommend %>").removeClass("<%= br %>"); });
$(".<%= ButtonRecommend %>").mouseout(function(){ $(".<%= ButtonRecommend %>").html("Subscribed"); $(".<%= ButtonRecommend %>").addClass("<%= br %>"); $(".<%= ButtonRecommend %>").removeClass("<%= bu %>"); });
});
$(document).ready(function(){ $(".<%= ButtonRecommend %>").one('click', function(event){ event.stopImmediatePropagation(); 
$(".<%= ButtonRecommend %>Div").load("ButtonSubscribeOutro.jsp?recommender=<%= recommender %>&subscriber=<%= recommenderIdLogged %>&UserAction=UnSubscribe&width=<%= width %>", function (response) { $(".<%= ButtonRecommend %>Div").html(response); }); }); });
<% } %>

//-->
</script>

<% if(userAction.equals("UnSubscribe")) { %>
<button class="<%= ButtonRecommend %> <%= bd %>">Subscribe</button>
<% } else if(userAction.equals("Subscribe")) { %>
<button class="<%= ButtonRecommend %> <%= br %>">Subscribed</button>
<% } %>

<% } %>

<% } %>