
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Recommender" %>
<%@ page import="recBook.DoesIdExists" %>
<%@ page import="recBook.IncrementPageViews" %>
<%@ page import="recBook.RecordImage" %>
<%@ page import="recBook.RecommenderPageDAO" %>
<%@ page import="recBook.RankingDAO" %>

<%@ page import="recBook.IsImageRecorded" %>
<%@ page import="java.lang.NullPointerException" %>
<%@ page import="java.lang.SecurityException" %>

<%@ include file="Validation.jsp" %>

<% if(!request.getParameterMap().containsKey("id")) { %>

	<jsp:forward page="/Error.jsp?id=6" />

<% } else if(!new Validation().isIdValid(request.getParameter("id"))) { %>

	<jsp:forward page="/Error.jsp?id=4" />

<% } else if(!new DoesIdExists().check("Recommender", (Long.valueOf(request.getParameter("id"))))) { %>

	<jsp:forward page="/Error.jsp?id=2" />

<% } else { %>

<jsp:include page="GetDevice.jsp" flush="true" />

<%
	Cookie[] cookies = request.getCookies();

	Long recommenderIdShowed = Long.valueOf((String) request.getParameter("id"));
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

	RecommenderPageDAO rpDAO = null;
	Recommender recommender = new Recommender();
	Integer action = 0;
	Long recommended = 0l;
	Long subscribed = 0l;

	try {

		rpDAO = new RecommenderPageDAO(db, recommenderIdLogged, recommenderIdShowed);

		recommender = rpDAO.getRecommender();
		action = rpDAO.getAction();
		recommended = rpDAO.getRecommended();
		subscribed = rpDAO.getSubscribed();

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

	session.setAttribute("RecommenderIdShowed", ""+recommenderIdShowed+"");
	session.setAttribute("RecommenderAge", ""+rpDAO.getAge()+"");
	request.getSession().setAttribute("DB", db);

	String recommenderRanking = "";
	RankingDAO rankingDAO = new RankingDAO(db);

	try {

		recommenderRanking = rankingDAO.getRecommenderGeneralRanking(recommenderIdShowed).toString();

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

	/*
	 * Imagem
	 */

	String imagemOutro = "NoImageAvailable.png";
	String imagemNome = "Recommender"+recommender.getId()+".jpg";

	try {

		if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

			imagemOutro = imagemNome;

		}

	} catch(NullPointerException e) {
			System.err.println("NullPointerException: "+e.getMessage());

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
	} catch(SecurityException e) {
			System.err.println("SecurityException: "+e.getMessage());

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

	IncrementPageViews ipv = new IncrementPageViews(db);
	ipv.incrementPageViews("Recommender", recommenderIdShowed);

/*
	if(!session.getAttribute("PageViewAlreadyIncremented").equals("Yes")) {
		ipv.incrementPageViews("Recommender", recommenderIdShowed);
		session.setAttribute("PageViewAlreadyIncremented", "Yes");
	}
*/

	String getURL = request.getRequestURL().toString()+"?"+request.getQueryString().toString();

	/*
	 * Select recNonLogged
	 */

	Long recNonLogged = 0l;

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT recNonLogged FROM Recommender WHERE id = ?");
		ps.setLong(1, recommenderIdShowed);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			recNonLogged = result.getLong("recNonLogged");
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

%>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title><%= recommender.getNickName() %> on Recommendation Book</title>
 
<meta name="keywords" content="<%= recommender.getNickName() %>" />
<meta name="description" content="Subscribe to <%= recommender.getNickName() %> to See all <%= recommender.getNickName() %> Recommendations." />

<meta property="og:image" content="http://recommendationbook.com/img/user/<%= imagemOutro %>" />

<link rel="icon" href="./img/static/RBIcon.ico" type="image/x-icon">

<style type="text/css">
<!--
   @import url("RecommendationBookCSS.css");
-->
</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookMobileCSS.css" />

<% } %>

<%
if(request.getHeader("User-Agent") != null) {
if(request.getHeader("User-Agent").contains("iPhone")) {
out.print("<link rel=\"stylesheet\" type=\"text/css\" media=\"screen\" href=\"RecommendationBookMobileiPhoneCSS.css\" />");
}
}
%>

<link href='http://fonts.googleapis.com/css?family=Roboto:500' rel='stylesheet' type='text/css'>

<script src="js/jquery-1.10.2.js"></script>
<script src="js/jquery-ui.js"></script>
<script src="js/RecommendationBookJS.js"></script>
<script type="text/javascript" src="js/jquery.validate.js"></script>
<script type="text/javascript" src="js/jquery.validate.min.js"></script>
<script type="text/javascript" src="js/additional-methods.js"></script>
<script type="text/javascript" src="js/additional-methods.min.js"></script>

<script type="text/javascript" src="js/ValidateMethods.js"></script>
<script type="text/javascript"> 
<!--

WidthStaticAt(900);

/*

$(document).ready(function(){
		if($(window).width() < 1100) {
			$("#ScrollbarUl").addClass("TabMenuWidth");
			$("#ScrollbarDiv").addClass("Scrollbar");
		} else {
			$("#ScrollbarUl").removeClass("TabMenuWidth");
			$("#ScrollbarDiv").removeClass("Scrollbar");
		}
	$(window).resize(function() {
		if($(window).width() < 1100) {
			$("#ScrollbarUl").addClass("TabMenuWidth");
			$("#ScrollbarDiv").addClass("Scrollbar");
		} else {
			$("#ScrollbarUl").removeClass("TabMenuWidth");
			$("#ScrollbarDiv").removeClass("Scrollbar");
		}
	});
});

*/


<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

DLWidthMobile();

<% } else { %>

DLWidth();

<% } %>

$(document).ready(function(){
	$("#tabs").tabs({collapsible: true});
});


$(document).ready(function(){

$("#searchId").submit(function(event) {

	event.preventDefault();

	var term = $("input[name='searchRecommendersRB']").val();
	var id = $("input[name='RecommenderIdShowed']").val();
	var url = "DoRecommendersRBSearch.jsp";

	if(term == "") {

		alert("Type Something on the Search Field.");

	} else {

		var posting = $.post(url, {search: term, RecommenderIdShowed: id});

		posting.done(function(data) {
			$("#ShowSearch").empty().append(data);
		});

	}

});


});

$(document).ready(function(){
	$(document).on("click", "tr.LoadMore", function() {
		var id = $(this).attr("id");

		var posting = $.post("RecommenderSubscription.jsp", {page: id, afterFirst: "true"});

		posting.done(function(data) {
			$("tr.LoadMore").replaceWith(data);
		});

	});
});

$(document).ready(function(){
	$("#AllRecommendations").one("click", function() {
		$("div#tabs-2").load("RecommenderAllRecommendations.jsp");
	});
});

$(document).ready(function(){
	$("#AllAdditions").one("click", function() {
		$("#tabs-3").load("RecommenderAllAdditions.jsp");
	});
});

$(document).ready(function(){
	$("#AllTODO").one("click", function() {
		$("#tabs-4").load("RecommenderAllTODO.jsp");
	});
});

//-->
</script>

</head>

<body>

<div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.4&appId=1054429214574465";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>

<div class="Geral">

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

	<jsp:include page="MiniMenuMobile.jsp" flush="true" />
	<jsp:include page="Search.jsp" flush="true" />
	<div class="Corpo">
		<div class="CenterColumn">
			<fieldset class="CenterColumn">
				<legend><%= recommender.getNickName() %>'s Recommendation Book</legend>
			<div id="tabs">

				<div id="ScrollbarDiv">
					<ul id="ScrollbarUl" class="TabMenu">
						<li class="TabMenu"><a href="#tabs-1">Subscription</a></li>
						<li class="TabMenu"><a href="#tabs-2" id="AllRecommendations">Recommendations</a></li>
						<li class="TabMenu"><a href="#tabs-3" id="AllAdditions">Additions</a></li>
						<li class="TabMenu"><a href="#tabs-4" id="AllTODO">To-Do</a></li>
						<li class="TabMenu"><a href="#tabs-5">Search</a></li>
					</ul>
				</div>

				<div id="tabs-1" class="Things">

				<table>
				<tbody>
					<jsp:include page="RecommenderSubscription.jsp?page=1&afterFirst=false" flush="true" />
				</tbody>
				</table>

				</div>

				<div id="tabs-2" class="Things">
					Wait... <div id="Spinner" class="Spinner" style="display: inline;"><img width="200" height="200" src="./img/static/ajax-loader-GoldenRod.gif" alt="" /></div>
				</div>

				<div id="tabs-3" class="Things">
					Wait... <div id="Spinner" class="Spinner" style="display: inline;"><img width="200" height="200" src="./img/static/ajax-loader-GoldenRod.gif" alt="" /></div>
				</div>

				<div id="tabs-4" class="Things">
					Wait... <div id="Spinner" class="Spinner" style="display: inline;"><img width="200" height="200" src="./img/static/ajax-loader-GoldenRod.gif" alt="" /></div>
				</div>

				<div id="tabs-5" class="Things">

				<div class="Search">
					<form method="post" action="DoRecommendersRBSearch.jsp" id="searchId">
						<fieldset>
							<legend>Search on this Recommendation Book</legend>
							<input class="Search" type="text" name="searchRecommendersRB" style="width: 45%;" value="" />
							<input type="hidden" name="RecommenderIdShowed" value="<%= recommenderIdShowed %>" />
							<input class="SearchButton" type="submit" value="Search" style="width: 20%;" />
						</fieldset>
					</form>
				</div>
				<fieldset><legend>Search Results for this Recommendation Book</legend><div id="ShowSearch" class="ShowSearch"></div></fieldset>

				</div>

			</div>

			</fieldset>
		</div>
		<div class="CenterColumn">
			<fieldset class="CenterColumn">
				<legend>Recommender</legend>
				<img class="RecommenderImage" width="500" height="500" src="./img/user/<%= imagemOutro %>" alt="<%= recommender.getNickName() %>" />

<% pageContext.include("MakeButtonRecommend.jsp?id="+recommender.getId()+"&table=Recommender&width=100"); %>

<div class="fb-like" data-href="<%= getURL %>" data-layout="button_count" data-action="recommend" data-show-faces="false" data-share="true"></div><br /><br />

<% pageContext.include("MakeButtonSubscribe.jsp?recommender="+recommender.getId()+"&width=100"); %>

				<div class="ButtonAddStuff">
					<form action="AddRecommended.jsp" method="post">
						<input class="AddStuff" type="submit" value="Recommend Stuff" />
					</form>
				</div>

				<dl class="user">
					<dt class="user">Recommender</dt>
						<dd class="user"><span class="Nickname"><%= recommender.getNickName() %></span></dd>
					<dt class="user">Was Recommended</dt>
						<dd class="user"><span class="green"><%= recommender.getRecommendations() %> Time<% if(recommender.getRecommendations() > 1l || recommender.getRecommendations() == 0l) { out.println("s"); } %></span></dd>
						<dd class="user"><a href="WhoRecommendedTheRecommender.jsp?id=<%= recommenderIdShowed %>">Who Recommended?</a></dd>
<!--
					<dt class="user">Anonymous Recommendations</dt>
						<dd class="user"><span class="green"><%= recNonLogged %> Recommendations</span></dd>
					<dt class="user">Total Recommendations</dt>
<%
	Long total = recommender.getRecommendations() + recNonLogged;
%>
						<dd class="user"><span class="green"><%= total %> Recommendations</span></dd>
-->
					<dt class="user">Recommended</dt>
						<dd class="user"><span class="green"><%= rpDAO.getTimesRecommended() %> Time<% if(rpDAO.getTimesRecommended() > 1l || rpDAO.getTimesRecommended() == 0l) { out.println("s"); } %></span></dd>
					<dt class="user">Recommender Ranking</dt>
						<dd class="user"><span class="green"><%= recommenderRanking %> Most Recommended</span></dd>
					<dt class="user">Subscribers</dt>
						<dd class="user"><span class="green"><%= rpDAO.getSubscribers() %> Recommender<% if(rpDAO.getSubscribers() > 1l || rpDAO.getSubscribers() == 0l) { out.println("s"); } %></span></dd>
						<dd class="user"><a href="WhoSubscribedTo.jsp?id=<%= recommenderIdShowed %>">Who Subscribed?</a></dd>
					<dt class="user">Has Subscribed To</dt>
						<dd class="user"><span class="green"><%= rpDAO.getHasSubscribedTo() %> Recommender<% if(rpDAO.getHasSubscribedTo() > 1l || rpDAO.getHasSubscribedTo() == 0l) { out.println("s"); } %></span></dd>
						<dd class="user"><a href="SubscribedToWho.jsp?id=<%= recommenderIdShowed %>">Subscribed To Who?</a></dd>
					<dt class="user">Page Views</dt>
						<dd class="user"><span class="green"><%= recommender.getPageViews() %> Page Views</span></dd>

<% if(recommenderIdShowed.equals(recommenderIdLogged)) { %>

					<dt class="user"><a href="BeforeUpdateRecommender.jsp?id=<%= recommenderIdLogged %>">Update</a></dt>

<% } %>

<% if(recommenderIdShowed.equals(recommenderIdLogged) && recommenderIdShowed.equals(1l)) { %>

					<dt class="user"><a href="ShowErrors.jsp">Show Errors</a></dt>

<% } %>

<% if(recommenderIdShowed.equals(recommenderIdLogged) && recommenderIdShowed.equals(1l)) { %>

					<dt class="user"><a href="Pageviews.jsp">Show PageViews</a></dt>

<% } %>

					<dt class="user">Sex</dt>
						<dd class="user"><%= recommender.getSexToMySQL() %></dd>
					<dt class="user">Age</dt>
						<dd class="user"><%= rpDAO.getAge() %></dd>
					<dt class="user">Country</dt>
						<dd class="user"><%= rpDAO.getCountry() %></dd>
					<dt class="user">Official Website</dt>
						<dd class="user"><%= rpDAO.getOfficialWebsite() %></dd>
					<dt class="user">About</dt>
						<dd class="user"><%= rpDAO.getAbout() %></dd>
					<dt class="user">Recommender Since</dt>
						<dd class="user"><%= recommender.getCreatedOnToMySQL() %></dd>

<% if(recommenderIdShowed.equals(recommenderIdLogged)) { %>
					<dt class="user"><a href="LogOut.jsp">Log out</a></dt>
<% } %>

<!--
					<dt class="user">Last Updated</dt>
						<dd class="user"><%= recommender.getLastUpdatedOnToMySQL() %></dd>
-->
				</dl>
			</fieldset>
		</div>
	</div>
	<jsp:include page="RodapeMobile.jsp" flush="true" />
</div>

<% } else { %>

	<jsp:include page="MiniMenu.jsp" flush="true" />
	<div class="Corpo">
		<div class="RecommenderLeftColumnOutro">
			<fieldset class="RightColumn">
				<legend><%= recommender.getNickName() %>'s Recommendation Book</legend>
			<div id="tabs">

				<div id="ScrollbarDiv">
					<ul id="ScrollbarUl" class="TabMenu">
						<li class="TabMenu"><a href="#tabs-1">Subscription</a></li>
						<li class="TabMenu"><a href="#tabs-2" id="AllRecommendations">Recommendations</a></li>
						<li class="TabMenu"><a href="#tabs-3" id="AllAdditions">Additions</a></li>
						<li class="TabMenu"><a href="#tabs-4" id="AllTODO">To-Do</a></li>
						<li class="TabMenu"><a href="#tabs-5">Search</a></li>
					</ul>
				</div>

				<div id="tabs-1" class="Things">

				<table>
				<tbody>
					<jsp:include page="RecommenderSubscription.jsp?page=1&afterFirst=false" flush="true" />
				</tbody>
				</table>

				</div>

				<div id="tabs-2" class="Things">
					<td>Wait... <div id="Spinner" class="Spinner" style="display: inline;"><img width="200" height="200" src="./img/static/ajax-loader-GoldenRod.gif" alt="" /></div>
				</div>

				<div id="tabs-3" class="Things">
					<td>Wait... <div id="Spinner" class="Spinner" style="display: inline;"><img width="200" height="200" src="./img/static/ajax-loader-GoldenRod.gif" alt="" /></div>
				</div>

				<div id="tabs-4" class="Things">
					<td>Wait... <div id="Spinner" class="Spinner" style="display: inline;"><img width="200" height="200" src="./img/static/ajax-loader-GoldenRod.gif" alt="" /></div>
				</div>

				<div id="tabs-5" class="Things">

				<div class="Search">
					<form method="post" action="DoRecommendersRBSearch.jsp" id="searchId">
						<fieldset>
							<legend>Search on this Recommendation Book</legend>
							<input class="Search" type="text" name="searchRecommendersRB" value="" />
							<input type="hidden" name="RecommenderIdShowed" value="<%= recommenderIdShowed %>" />
							<input class="SearchButton" type="submit" value="Search" />
						</fieldset>
					</form>
				</div>
				<fieldset><legend>Search Results for this Recommendation Book</legend><div id="ShowSearch" class="ShowSearch"></div></fieldset>

				</div>

			</div>

			</fieldset>
		</div>
		<div class="RecommenderRightColumn">
			<fieldset class="RecommenderRightColumnInformation">
				<legend>Recommender</legend>
				<img class="RecommenderImage" width="200" height="200" src="./img/user/<%= imagemOutro %>" alt="<%= recommender.getNickName() %>" />

<% pageContext.include("MakeButtonRecommend.jsp?id="+recommender.getId()+"&table=Recommender&width=100"); %>

<div class="fb-like" data-href="<%= getURL %>" data-layout="button_count" data-action="recommend" data-show-faces="false" data-share="true"></div><br /><br />

<% pageContext.include("MakeButtonSubscribe.jsp?recommender="+recommender.getId()+"&width=100"); %>

				<div class="ButtonAddStuff">
					<form action="AddRecommended.jsp" method="post">
						<input class="AddStuff" type="submit" value="Recommend Stuff" />
					</form>
				</div>

				<dl class="user">
					<dt class="user">Recommender</dt>
						<dd class="user"><span class="Nickname"><%= recommender.getNickName() %></span></dd>
					<dt class="user">Was Recommended</dt>
						<dd class="user"><span class="green"><%= recommender.getRecommendations() %> Time<% if(recommender.getRecommendations() > 1l || recommender.getRecommendations() == 0l) { out.println("s"); } %></span></dd>
						<dd class="user"><a href="WhoRecommendedTheRecommender.jsp?id=<%= recommenderIdShowed %>">Who Recommended?</a></dd>
<!--
					<dt class="user">Anonymous Recommendations</dt>
						<dd class="user"><span class="green"><%= recNonLogged %> Recommendations</span></dd>
					<dt class="user">Total Recommendations</dt>
<%
	Long total = recommender.getRecommendations() + recNonLogged;
%>
						<dd class="user"><span class="green"><%= total %> Recommendations</span></dd>
-->
					<dt class="user">Recommended</dt>
						<dd class="user"><span class="green"><%= rpDAO.getTimesRecommended() %> Time<% if(rpDAO.getTimesRecommended() > 1l || rpDAO.getTimesRecommended() == 0l) { out.println("s"); } %></span></dd>
					<dt class="user">Recommender Ranking</dt>
						<dd class="user"><span class="green"><%= recommenderRanking %> Most Recommended</span></dd>
					<dt class="user">Subscribers</dt>
						<dd class="user"><span class="green"><%= rpDAO.getSubscribers() %> Recommender<% if(rpDAO.getSubscribers() > 1l || rpDAO.getSubscribers() == 0l) { out.println("s"); } %></span></dd>
						<dd class="user"><a href="WhoSubscribedTo.jsp?id=<%= recommenderIdShowed %>">Who Subscribed?</a></dd>
					<dt class="user">Has Subscribed To</dt>
						<dd class="user"><span class="green"><%= rpDAO.getHasSubscribedTo() %> Recommender<% if(rpDAO.getHasSubscribedTo() > 1l || rpDAO.getHasSubscribedTo() == 0l) { out.println("s"); } %></span></dd>
						<dd class="user"><a href="SubscribedToWho.jsp?id=<%= recommenderIdShowed %>">Subscribed To Who?</a></dd>
					<dt class="user">Page Views</dt>
						<dd class="user"><span class="green"><%= recommender.getPageViews() %> Page Views</span></dd>

<% if(recommenderIdShowed.equals(recommenderIdLogged)) { %>

					<dt class="user"><a href="BeforeUpdateRecommender.jsp?id=<%= recommenderIdLogged %>">Update</a></dt>

<% } %>

<% if(recommenderIdShowed.equals(recommenderIdLogged) && recommenderIdShowed.equals(1l)) { %>

					<dt class="user"><a href="ShowErrors.jsp">Show Errors</a></dt>

<% } %>

<% if(recommenderIdShowed.equals(recommenderIdLogged) && recommenderIdShowed.equals(1l)) { %>

					<dt class="user"><a href="Pageviews.jsp">Show PageViews</a></dt>

<% } %>

					<dt class="user">Sex</dt>
						<dd class="user"><%= recommender.getSexToMySQL() %></dd>
					<dt class="user">Age</dt>
						<dd class="user"><%= rpDAO.getAge() %></dd>
					<dt class="user">Country</dt>
						<dd class="user"><%= rpDAO.getCountry() %></dd>
					<dt class="user">Official Website</dt>
						<dd class="user"><%= rpDAO.getOfficialWebsite() %></dd>
					<dt class="user">About</dt>
						<dd class="user"><%= rpDAO.getAbout() %></dd>
					<dt class="user">Recommender Since</dt>
						<dd class="user"><%= recommender.getCreatedOnToMySQL() %></dd>

<% if(recommenderIdShowed.equals(recommenderIdLogged)) { %>
					<dt class="user"><a href="LogOut.jsp">Log out</a></dt>
<% } %>

<!--
					<dt class="user">Last Updated</dt>
						<dd class="user"><%= recommender.getLastUpdatedOnToMySQL() %></dd>
-->
				</dl>
			</fieldset>
		</div>
	</div>
	<jsp:include page="Rodape.jsp" flush="true" />
</div>

<% } %>

</body>
 
</html>

<%

	/*
	 * Desconecta do Banco de Dados
	 */

	if(db.conexao != null) {
		db.DesconectaDB();
	}

%>

<% } %>
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       