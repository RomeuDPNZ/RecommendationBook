
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.DoesIdExists" %>

<%@ page import="recBook.Recommended" %>
<%@ page import="recBook.RecommendedDAO" %>
<%@ page import="recBook.RecommendedType" %>
<%@ page import="recBook.RecommendedTypeDAO" %>

<%@ page import="recBook.ReadList" %>
<%@ page import="recBook.ReadListDAO" %>
<%@ page import="recBook.ReadListDAOOutro" %>

<%@ page import="recBook.WatchList" %>
<%@ page import="recBook.WatchListDAO" %>
<%@ page import="recBook.WatchListDAOOutro" %>

<%@ page import="recBook.ListenList" %>
<%@ page import="recBook.ListenListDAO" %>
<%@ page import="recBook.ListenListDAOOutro" %>

<%@ include file="Validation.jsp" %>

<%

	String width = (String) request.getParameter("width");

%>

<% if((request.getParameter("id") == null) || (request.getParameter("width") == null)) { %>

	<span class="red">Error: Parameters Id or width == null</span>

<% } else if(!width.equals("100") && !width.equals("static")) { %>

	<span class="red">Error: width Can Only Be 100 or static</span>

<% } else if(!new Validation().isIdValid(request.getParameter("id"))) { %>

	<span class="red">Error: Id Has To Be a Number</span>

<% } else if((!new DoesIdExists().check("Recommended", (Long.valueOf(request.getParameter("id")))))) { %>

	<span class="red">Recommended Entity Doesnt Exists</span>

<% } else { %>

<%

	Long recommendedIdShowed = Long.valueOf((String) request.getParameter("id"));

	String ButtonRecommend = "TODO"+recommendedIdShowed+"";

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

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

%>

<% if(!type.equals("Movie") && !type.equals("Album") && !type.equals("Book")) { %>

	<span class="red">Error: The Entity Type has to Be a Book, a Movie or an Album</span>

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

	String printAction = "";
	Boolean activated = false;
	String action = "";

	if(type.equals("Book")) {

		ReadList readList = new ReadList();

		readList = new ReadListDAOOutro(db).select(recommendedIdShowed, recommenderIdLogged);

		if(readList.getId() == null) {
			printAction = "To Read";
			activated = false;
			action = "ToRead";
		} else if((readList.getId() != null) && (readList.getStateReadToMySQL().equals("ToRead"))) {
			printAction = "To Read";
			activated = true;
			action = "Read";
		} else if((readList.getId() != null) && (readList.getStateReadToMySQL().equals("Read"))) {
			printAction = "Read";
			activated = true;
			action = "Reset";
		}

	} else if(type.equals("Movie")) {

		WatchList watchList = new WatchList();

		watchList = new WatchListDAOOutro(db).select(recommendedIdShowed, recommenderIdLogged);

		if(watchList.getId() == null) {
			printAction = "To Watch";
			activated = false;
			action = "ToWatch";
		} else if((watchList.getId() != null) && (watchList.getStateWatchToMySQL().equals("ToWatch"))) {
			printAction = "To Watch";
			activated = true;
			action = "Watched";
		} else if((watchList.getId() != null) && (watchList.getStateWatchToMySQL().equals("Watched"))) {
			printAction = "Watched";
			activated = true;
			action = "Reset";
		}

	} else if(type.equals("Album")) {

		ListenList listenList = new ListenList();

		listenList = new ListenListDAOOutro(db).select(recommendedIdShowed, recommenderIdLogged);

		if(listenList.getId() == null) {
			printAction = "To Listen";
			activated = false;
			action = "ToListen";
		} else if((listenList.getId() != null) && (listenList.getStateListenToMySQL().equals("ToListen"))) {
			printAction = "To Listen";
			activated = true;
			action = "Listened";
		} else if((listenList.getId() != null) && (listenList.getStateListenToMySQL().equals("Listened"))) {
			printAction = "Listened";
			activated = true;
			action = "Reset";
		}

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
$(document).ready(function(){ $(".<%= ButtonRecommend %>").one('click', function(event){ event.stopImmediatePropagation(); $(".<%= ButtonRecommend %>Div").load("ButtonTODO.jsp?id=<%= recommendedIdShowed %>&width=<%= width %>&action=<%= action %>", function (response) { $(".<%= ButtonRecommend %>Div").html(response); }); }); });
//-->
</script>
<% } else { %>
<script type="text/javascript"> 
<!--
$(document).ready(function(){ $(".<%= ButtonRecommend %>").one('click', function(event){ event.stopImmediatePropagation(); $(".<%= ButtonRecommend %>Div").load("AboutNotLoggedSubscribe.jsp", function (response) { $(".<%= ButtonRecommend %>Div").html(response); }); }); });
//-->
</script>
<% } %>

<% if(isRecommenderLogged) { %>
<% if(activated.equals(true)) { %>
<div class="<%= ButtonRecommend %>Div <%= bd %>"><button class="<%= ButtonRecommend %> <%= br %>"><%= printAction %></button></div>
<% } else { %>
<div class="<%= ButtonRecommend %>Div <%= bd %>"><button class="<%= ButtonRecommend %> <%= bd %>"><%= printAction %></button></div>
<% } %>
<% } else { %>
<div class="<%= ButtonRecommend %>Div <%= bd %>"><button class="<%= ButtonRecommend %> <%= bd %>"><%= printAction %></button></div>
<% } %>

<% } %>

<% } %>
