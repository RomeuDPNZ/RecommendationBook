
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.DoesIdExists" %>
<%@ page import="recBook.RecordImage" %>
<%@ page import="recBook.IncrementPageViews" %>

<%@ page import="recBook.Recommended" %>
<%@ page import="recBook.RecommendedDAO" %>
<%@ page import="recBook.RecommendedType" %>
<%@ page import="recBook.RecommendedTypeDAO" %>
<%@ page import="recBook.ActionsDAOOutro" %>
<%@ page import="recBook.AddRecDAOOutro" %>
<%@ page import="recBook.Recommender" %>
<%@ page import="recBook.RecommenderDAO" %>
<%@ page import="recBook.RecommenderUtils" %>
<%@ page import="recBook.RecBookDateFormat" %>
<%@ page import="recBook.Countries" %>
<%@ page import="recBook.CountriesDAO" %>
<%@ page import="recBook.RankingDAO" %>
<%@ page import="recBook.ReadList" %>
<%@ page import="recBook.ReadListDAOOutro" %>
<%@ page import="recBook.WatchList" %>
<%@ page import="recBook.WatchListDAOOutro" %>
<%@ page import="recBook.ListenList" %>
<%@ page import="recBook.ListenListDAOOutro" %>
<%@ page import="recBook.AgeStatistics" %>

<%@ page import="recBook.IsImageRecorded" %>
<%@ page import="java.lang.NullPointerException" %>
<%@ page import="java.lang.SecurityException" %>

<%@ page import="java.util.regex.*" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.Vector" %>

<%@ include file="Validation.jsp" %>

<% if(!request.getParameterMap().containsKey("id")) { %>

	<jsp:forward page="/Error.jsp?id=6" />

<% } else if(!new Validation().isIdValid(request.getParameter("id"))) { %>

	<jsp:forward page="/Error.jsp?id=4" />

<% } else if(!new DoesIdExists().check("Recommended", (Long.valueOf(request.getParameter("id"))))) { %>

	<jsp:forward page="/Error.jsp?id=2" />

<% } else { %>

<jsp:include page="GetDevice.jsp" flush="true" />

<%
	Cookie[] cookies = request.getCookies();

	Long recommendedIdShowed = Long.valueOf((String) request.getParameter("id"));
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

	IncrementPageViews ipv = new IncrementPageViews(db);
	ipv.incrementPageViews("Recommended", recommendedIdShowed);

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

	Integer action = 0;

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

	Long recommendedId = 0l;

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

	Recommender recommender = new Recommender();
	RecommenderDAO recommenderDAO = new RecommenderDAO(db);

	try {

		recommender = recommenderDAO.select(recommended.getRecommender());

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

	Countries countries = new Countries();
	CountriesDAO countriesDAO = new CountriesDAO(db);
	String country = "";

	try {

		countries = countriesDAO.select(Long.valueOf(recommended.getCountry()));
		country = countries.getCountry();

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

	String generalRanking = "";
	String rankingByType = "";

	RankingDAO rankingDAO = new RankingDAO(db);

	try {

		generalRanking = rankingDAO.getRecommendedGeneralRanking(recommendedIdShowed).toString();

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

	try {

		rankingByType = rankingDAO.getRecommendedRankingByType(recommendedIdShowed, recommended.getType()).toString();

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

	String createdOn = new RecBookDateFormat().getDate(recommended.getCreatedOn());

	String officialWebsite = "";

	if(recommended.getOfficialWebsite() == null || recommended.getOfficialWebsite().equals("")) {
		officialWebsite = "Website Pending";
	} else {
		officialWebsite = recommended.getOfficialWebsite();
	}

	String about = "";

	if(recommended.getAbout() == null || recommended.getAbout().equals("")) {
		about = "About Pending";
	} else {
		about = recommended.getAbout();
	}

	/*
	 * Insert Links In About
	 */

	about = about.trim();

	char[] aboutArray = about.toCharArray();

	Integer beginIndex = 0;
	Integer endIndex = 0;

	Vector<String> vector = new Vector<String>();

	for(char s : aboutArray) {

		++endIndex;
		
		String letter = String.valueOf(s);

		if(Pattern.matches("^([\\t\\s\\f\\r])$", letter)) {
			String word = about.substring(beginIndex, endIndex-1);
			vector.add(word);
			vector.add(letter);
			beginIndex = endIndex;
		}

	}

	vector.add(about.substring(beginIndex, endIndex));

	Iterator i = vector.iterator();

	String aboutOutro = "";

	String regexURL = "^(((((http|https|ftp)(://))?)+)((www.)?)((?<!mailto:)(?<!@)[a-zA-Z0-9\\-]+[.][a-z]+[a-zA-Z0-9\\-+&@#/%?=~_|!:,.;()]+))$";
	String regexEmail = "^(((mailto:)?)([a-zA-Z0-9._%\\-+]+[@][a-zA-Z0-9\\-.]+))$";
	String regexSearch = "^((#){1}([a-zA-Z0-9+]+))$";

	while(i.hasNext()) {
		String word = (String) i.next();

		if(Pattern.matches(regexURL, word)) {
			word = word.replaceAll(regexURL, "<a href=\"//$9\" target=\"_blank\">$1</a>");	
		} else if(Pattern.matches(regexEmail, word)) {
			word = word.replaceAll(regexEmail, "<a href=\"mailto:$4\" target=\"_blank\">$1</a>");	
		} else if(Pattern.matches(regexSearch, word)) {
			word = word.replaceAll(regexSearch, "<a href=\"http://recommendationbook.com/DoSearch.jsp?search=$3\" target=\"_blank\">$1</a>");	
		} 

		aboutOutro = aboutOutro + word;
	}

	about = aboutOutro;
	aboutArray = about.toCharArray();

	Boolean tralha = false;
	String id = "";

	String output = "";
	Recommended recommendedOutro = new Recommended();
	RecommendedDAO recommendedDAOOutro = new RecommendedDAO(db);
	DoesIdExists doesIdExists = new DoesIdExists();

	for(char s : aboutArray) {
		
		String letter = String.valueOf(s);

		if(tralha) {
			if(Pattern.matches("^([0-9]+)$", letter)) {
				id += letter;
			} else if(letter.equals("#") && !id.equals("")) {

				try {

					if(doesIdExists.check("Recommended", (Long.valueOf(id)))) {

						try {

							recommendedOutro = recommendedDAOOutro.select(Long.valueOf(id));

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

						output = "<a href=\"Recommended.jsp?id="+id+"\">"+recommendedOutro.getName()+"</a>";
					} else {
						output = "<span class=\"error\">Id "+id+" Not Found</span>";
					}

				} catch(SQLException e) {
					System.err.println("SQLException: "+e.getMessage());
				} finally { }

				about = about.replace("#"+id+"#", output);
				id = "";
			} else {
				tralha = false;
				id="";
			}
		}

		if(letter.equals("#")) {
			tralha = true;
		}

	}

	about = about.replaceAll("\n", "<br />");

	/*
	 * Imagem
	 */

	String imagemNome = "Recommended"+recommendedIdShowed+".jpg";
	String imagemOutro = "NoImageAvailable.png";

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

	String descricaoDaImagem = "";

	if(recommended.getDescriptionImage() == null || recommended.getDescriptionImage().equals("")) {

	} else {
		descricaoDaImagem = recommended.getDescriptionImage();
	}

	String getURL = request.getRequestURL().toString()+"?"+request.getQueryString().toString();

	/*
	 * Select recNonLogged
	 */

	Long recNonLogged = 0l;

/*

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT recNonLogged FROM Recommended WHERE id = ?");
		ps.setLong(1, recommendedIdShowed);
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

*/

	/*
	 * Select Rec from Males and Females
	 */

	Long recFromMales = 0l;
	Long recFromFemales = 0l;

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) AS recFromMales FROM AddRec WHERE AddRec.addRec = ? AND recommender IN (SELECT id FROM Recommender WHERE sex = 1) AND action = ?");
		ps.setLong(1, recommendedIdShowed);
		ps.setInt(2, action);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			recFromMales = result.getLong("recFromMales");
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) AS recFromFemales FROM AddRec WHERE AddRec.addRec = ? AND recommender IN (SELECT id FROM Recommender WHERE sex = 2) AND action = ?");
		ps.setLong(1, recommendedIdShowed);
		ps.setInt(2, action);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			recFromFemales = result.getLong("recFromFemales");
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	/*
	 * Age Statistics
	 */

	Long recs010 = 0l;
	Long recs1020 = 0l;
	Long recs2030 = 0l;
	Long recs3040 = 0l;
	Long recs4050 = 0l;
	Long recs5060 = 0l;
	Long recs60120 = 0l;

	try {
		AgeStatistics ageStats = new AgeStatistics(db);

		recs010 = ageStats.getAgeStatistics(recommendedIdShowed, 0, 10, action);
		recs1020 = ageStats.getAgeStatistics(recommendedIdShowed, 10, 20, action);
		recs2030 = ageStats.getAgeStatistics(recommendedIdShowed, 20, 30, action);
		recs3040 = ageStats.getAgeStatistics(recommendedIdShowed, 30, 40, action);
		recs4050 = ageStats.getAgeStatistics(recommendedIdShowed, 40, 50, action);
		recs5060 = ageStats.getAgeStatistics(recommendedIdShowed, 50, 60, action);
		recs60120 = ageStats.getAgeStatistics(recommendedIdShowed, 60, 120, action);

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
 
<title><%= recommended.getName() %> on Recommendation Book</title>
 
<meta name="keywords" content="<%= recommended.getName() %>" />
<meta name="description" content="The Recommendation Book for the <%= type %> <%= recommended.getName() %>" />

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

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

DLWidthMobile();

AboutWidthMobile();

<% } else { %>

DLWidth();

AboutWidth();

<% } %>

$(document).ready(function(){

	$(".Things").hide();

	$("h3").click(function(){
		$(this).toggleClass("HToggleUp HToggleDown").next().slideToggle();
	});

});

function setDivStatisticsInformationHeight() {
	$("fieldset.RecommendedLeftRightColumnFieldset").css("min-height", "50px");
	$("fieldset.RecommendedRightRightColumnFieldset").css("min-height", "50px");

	var left = $("fieldset.RecommendedLeftRightColumnFieldset").height();
	var right = $("fieldset.RecommendedRightRightColumnFieldset").height();

	if(left != right) {
		if(left < right) {
			$("fieldset.RecommendedLeftRightColumnFieldset").css("min-height", ""+right+"px");
		} else {
			$("fieldset.RecommendedRightRightColumnFieldset").css("min-height", ""+left+"px");
		}
	}

	setTimeout(setDivStatisticsInformationHeight, 500);
}

$(document).ready(function() {
	setDivStatisticsInformationHeight();
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

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

<div class="Geral">
	<jsp:include page="MiniMenuMobile.jsp" flush="true" />
	<jsp:include page="Search.jsp" flush="true" />
	<div class="Corpo">
		<div class="CenterColumn">
		<div class="CenterColumn">
			<fieldset class="CenterColumn">
				<legend><%= type %></legend>
				<div class="PersonGroupImage">
					<figure>
						<img class="PersonGroupImage" src="./img/user/<%= imagemOutro %>" alt="<%= recommended.getName() %>" />
						<figcaption><%= descricaoDaImagem %></figcaption>
					</figure>
				</div>

<% pageContext.include("MakeButtonRecommend.jsp?id="+recommended.getId()+"&table=Recommended&width=100"); %>

<% if(type.equals("Movie") || type.equals("Album") || type.equals("Book")) { %>

<% pageContext.include("MakeButtonTODO.jsp?id="+recommended.getId()+"&width=100"); %>

<% } %>

			</fieldset>
			<fieldset class="CenterColumn">
				<legend>Affiliate</legend>
<script charset="utf-8" type="text/javascript">
amzn_assoc_ad_type = "responsive_search_widget";
amzn_assoc_tracking_id = "recommbook-20";
amzn_assoc_link_id = "K6SAAUSSGRZUZK33";
amzn_assoc_marketplace = "amazon";
amzn_assoc_region = "US";
amzn_assoc_placement = "";
amzn_assoc_search_type = "search_widget";
amzn_assoc_width = "auto";
amzn_assoc_height = "auto";
amzn_assoc_default_search_category = "";
amzn_assoc_default_search_key = "<%= recommended.getName() %>";
amzn_assoc_theme = "light";
amzn_assoc_bg_color = "FFFFFF";
</script>
<script src="//z-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&Operation=GetScript&ID=OneJS&WS=1&MarketPlace=US"></script>
			</fieldset>
			<fieldset class="CenterColumn">
				<legend>Information</legend>
				<dl class="user">
					<dt class="user">Name</dt>
						<dd class="user"><span class="Nickname"><%= recommended.getName() %></span></dd>
					<dt class="user">Type</dt>
						<dd class="user"><a href="MostRecommended.jsp?type=<%= type %>"><%= type %></a></dd>
					<dt class="user">Added By</dt>
		<dd class="InLine user"><span class="Nickname"><a href="Recommender.jsp?id=<%= recommender.getId() %>"><%= recommender.getNickName() %></a></span><% pageContext.include("MakeButtonSubscribe.jsp?recommender="+recommender.getId()+"&width=static"); %></dd>
						<dd class="user"><%= createdOn %></dd>

<% if(recommended.getRecommender().equals(recommenderIdLogged)) { %>

					<dt class="user"><a href="BeforeUpdateRecommended.jsp?id=<%= recommendedIdShowed %>">Update</a></dt>

					<dt class="user"><a class="delete" href="BeforeDeleteRecommended.jsp?id=<%= recommendedIdShowed %>">Delete</a></dt>

<% } %>


					<dt class="user">Country</dt>
<%

	country = "<a href=\"MostRecommendedByCountry.jsp?country="+recommended.getCountry()+"\">"+country+"</a>";

%>
						<dd class="user"><%= country %></dd>
					<dt class="user">Official Website</dt>
<%

	if(!officialWebsite.equals("Website Pending")) { officialWebsite = "<a href=\"http://"+officialWebsite+"/\" target=\"_blank\">"+officialWebsite+"</a>"; }

%>
						<dd class="user"><%= officialWebsite %></dd>
<!--
					<dt class="user">Created On</dt>
						<dd class="user"><%= recommended.getCreatedOnToMySQL() %></dd>
					<dt class="user">Last Updated</dt>
						<dd class="user"><%= recommended.getLastUpdatedOnToMySQL() %></dd>
-->
					<dt class="user">Who Recommended?</dt>
					<% pageContext.include("WhoRecommendedTheEntity.jsp?id="+recommendedIdShowed+"&forRecommended=true"); %>
					<dt class="user">Who Recommended this Entity From <span class="Nickname"><a href="Recommender.jsp?id=<%= recommender.getId() %>"><%= recommender.getNickName() %></a></span>'s Subscribers?</dt>
					<% pageContext.include("WhoRecommendedTheEntityFromSubscribersOf.jsp?id="+recommendedIdShowed+"&recommender="+recommender.getId()+"&forRecommended=true"); %>
<% if(isRecommenderLogged && (recommenderIdLogged != recommender.getId())) { %>
					<dt class="user">Who Recommended this Entity From My Subscribers?</dt>
					<% pageContext.include("WhoRecommendedTheEntityFromSubscribersOf.jsp?id="+recommendedIdShowed+"&recommender="+recommenderIdLogged+"&forRecommended=true"); %>
<% } %>
					<dt class="user">Who Recommended this Entity From Recommenders that <span class="Nickname"><a href="Recommender.jsp?id=<%= recommender.getId() %>"><%= recommender.getNickName() %></a></span> is Subscribed?</dt>
					<% pageContext.include("WhoRecommendedTheEntityFromRecommendersIAmSubscribed.jsp?id="+recommendedIdShowed+"&recommender="+recommender.getId()+"&forRecommended=true"); %>
<% if(isRecommenderLogged && (recommenderIdLogged != recommender.getId())) { %>
					<dt class="user">Who Recommended this Entity From Recommenders that I am Subscribed?</dt>
					<% pageContext.include("WhoRecommendedTheEntityFromRecommendersIAmSubscribed.jsp?id="+recommendedIdShowed+"&recommender="+recommenderIdLogged+"&forRecommended=true"); %>
<% } %>
				</dl>
			</fieldset>
		</div>
		<div class="CenterColumn">
			<fieldset class="CenterColumn">
				<legend>Statistics</legend>
				<dl class="user">
					<dt class="user">Recommendations</dt>
				<dd class="user"><span class="green"><%= recommended.getRecommendations() %> Recommendation<% if(recommended.getRecommendations() > 1l || recommended.getRecommendations() == 0l) { out.println("s"); } %></span></dd>
<!--
					<dt class="user">Anonymous Recommendations</dt>
						<dd class="user"><span class="green"><%= recNonLogged %> Recommendations</span></dd>
					<dt class="user">Total Recommendations</dt>
<%
	Long total = recommended.getRecommendations() + recNonLogged;
%>
						<dd class="user"><span class="green"><%= total %> Recommendations</span></dd>
-->
					<dt class="user">Page Views</dt>
						<dd class="user"><span class="green"><%= recommended.getPageViews() %> Page Views</span></dd>
					<dt class="user">General Ranking</dt>
						<dd class="user"><span class="green"><%= generalRanking %> Most Recommended</span></dd>
					<dt class="user">Ranking By Type</dt>
						<dd class="user"><span class="green"><%= rankingByType %> Most Recommended</span></dd>
					<dt class="user">Recommendations by Sex</dt>
						<dd class="user"><span class="green"><%= recFromMales %> Recommendation<% if(recFromMales > 1l || recFromMales == 0l) { out.println("s"); } %> from Males</span></dd>
						<dd class="user"><span class="green"><%= recFromFemales %> Recommendation<% if(recFromFemales > 1l || recFromFemales == 0l) { out.println("s"); } %> from Females</span></dd>
					<dt class="user">Recommendations by Age Range</dt>
			<% if((recs010 == 0l) && (recs1020 == 0l) && (recs2030 == 0l) && (recs3040 == 0l) && (recs4050 == 0l) && (recs5060 == 0l) && (recs60120 == 0l)) { %><dd class="user"><span class="green">Nothing Yet!</span></dd><% } %>
						<% if(recs010 > 0l) { %><dd class="user"><span class="green"><%= recs010 %> Recommendation<% if(recs010 > 1l) { out.println("s"); } %> from Age Between 0 - 10</span></dd><% } %>
						<% if(recs1020 > 0l) { %><dd class="user"><span class="green"><%= recs1020 %> Recommendation<% if(recs1020 > 1l) { out.println("s"); } %> from Age Between 10 - 20</span></dd><% } %>
						<% if(recs2030 > 0l) { %><dd class="user"><span class="green"><%= recs2030 %> Recommendation<% if(recs2030 > 1l) { out.println("s"); } %> from Age Between 20 - 30</span></dd><% } %>
						<% if(recs3040 > 0l) { %><dd class="user"><span class="green"><%= recs3040 %> Recommendation<% if(recs3040 > 1l) { out.println("s"); } %> from Age Between 30 - 40</span></dd><% } %>
						<% if(recs4050 > 0l) { %><dd class="user"><span class="green"><%= recs4050 %> Recommendation<% if(recs4050 > 1l) { out.println("s"); } %> from Age Between 40 - 50</span></dd><% } %>
						<% if(recs5060 > 0l) { %><dd class="user"><span class="green"><%= recs5060 %> Recommendation<% if(recs5060 > 1l) { out.println("s"); } %> from Age Between 50 - 60</span></dd><% } %>
						<% if(recs60120 > 0l) { %><dd class="user"><span class="green"><%= recs60120 %> Recommendation<% if(recs60120 > 1l) { out.println("s"); } %> from Age Between 60 - 120</span></dd><% } %>
					<dt class="user">Recommendations by Country</dt>
						<% pageContext.include("RecommendationsByCountry.jsp?id="+recommendedIdShowed+"&forRecommended=true"); %>
					<dt class="user">Recommendations by Sex, Age Range and Country</dt>
						<dd class="user"><a href="RecommendationsBySexAgeAndCountry.jsp?id=<%= recommendedIdShowed %>">Click for Recommendations by Sex, Age Range and Country</a></dd>
					<dt class="user">Facebook Recommendations</dt>
<dd class="user"><div class="fb-like" data-href="<%= getURL %>" data-layout="button_count" data-action="recommend" data-show-faces="false" data-share="true"></div></dd>
				</dl>
			</fieldset>
		</div>
		<div class="CenterColumn">
			<fieldset class="CenterColumn">
				<legend>About <%= recommended.getName() %></legend>
					<div class="AboutPerson">
						<%= about %>
					</div>
			</fieldset>
		</div>
		<div class="CenterColumn">
			<fieldset class="CenterColumn">
				<legend>Facebook Comments</legend>
					<div class="fb-comments" data-href="<%= getURL %>" data-numposts="5" data-version="v2.3"></div>
			</fieldset>
		</div>
	</div>
	</div>
	<jsp:include page="RodapeMobile.jsp" flush="true" />
</div>

<% } else { %>

<div class="Geral">
	<jsp:include page="MiniMenu.jsp" flush="true" />
	<div class="Corpo">
		<div class="RecommendedLeftColumn">
			<fieldset class="RecommendedLeftColumnFieldset">
				<legend><%= type %></legend>
				<div class="PersonGroupImage">
					<figure>
						<img class="PersonGroupImage" src="./img/user/<%= imagemOutro %>" alt="<%= recommended.getName() %>" />
						<figcaption><%= descricaoDaImagem %></figcaption>
					</figure>
				</div>

<% pageContext.include("MakeButtonRecommend.jsp?id="+recommended.getId()+"&table=Recommended&width=100"); %>

<% if(type.equals("Movie") || type.equals("Album") || type.equals("Book")) { %>

<% pageContext.include("MakeButtonTODO.jsp?id="+recommended.getId()+"&width=100"); %>

<% } %>

			</fieldset>
			<fieldset class="RecommendedLeftColumnFieldset">
				<legend>Affiliate</legend>
<script charset="utf-8" type="text/javascript">
amzn_assoc_ad_type = "responsive_search_widget";
amzn_assoc_tracking_id = "recommbook-20";
amzn_assoc_link_id = "K6SAAUSSGRZUZK33";
amzn_assoc_marketplace = "amazon";
amzn_assoc_region = "US";
amzn_assoc_placement = "";
amzn_assoc_search_type = "search_widget";
amzn_assoc_width = "auto";
amzn_assoc_height = "auto";
amzn_assoc_default_search_category = "";
amzn_assoc_default_search_key = "<%= recommended.getName() %>";
amzn_assoc_theme = "light";
amzn_assoc_bg_color = "FFFFFF";
</script>
<script src="//z-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&Operation=GetScript&ID=OneJS&WS=1&MarketPlace=US"></script>
			</fieldset>
		</div>
		<div class="RecommendedRightColumn">
		<div class="RecommendedLeftRightColumn">
			<fieldset class="RecommendedLeftRightColumnFieldset">
				<legend>Statistics</legend>
				<dl class="user">
					<dt class="user">Recommendations</dt>
				<dd class="user"><span class="green"><%= recommended.getRecommendations() %> Recommendation<% if(recommended.getRecommendations() > 1l || recommended.getRecommendations() == 0l) { out.println("s"); } %></span></dd>
<!--
					<dt class="user">Anonymous Recommendations</dt>
						<dd class="user"><span class="green"><%= recNonLogged %> Recommendations</span></dd>
					<dt class="user">Total Recommendations</dt>
<%
	Long total = recommended.getRecommendations() + recNonLogged;
%>
						<dd class="user"><span class="green"><%= total %> Recommendations</span></dd>
-->
					<dt class="user">Page Views</dt>
						<dd class="user"><span class="green"><%= recommended.getPageViews() %> Page Views</span></dd>
					<dt class="user">General Ranking</dt>
						<dd class="user"><span class="green"><%= generalRanking %> Most Recommended</span></dd>
					<dt class="user">Ranking By Type</dt>
						<dd class="user"><span class="green"><%= rankingByType %> Most Recommended</span></dd>
					<dt class="user">Recommendations by Sex</dt>
						<dd class="user"><span class="green"><%= recFromMales %> Recommendation<% if(recFromMales > 1l || recFromMales == 0l) { out.println("s"); } %> from Males</span></dd>
						<dd class="user"><span class="green"><%= recFromFemales %> Recommendation<% if(recFromFemales > 1l || recFromFemales == 0l) { out.println("s"); } %> from Females</span></dd>
					<dt class="user">Recommendations by Age Range</dt>
			<% if((recs010 == 0l) && (recs1020 == 0l) && (recs2030 == 0l) && (recs3040 == 0l) && (recs4050 == 0l) && (recs5060 == 0l) && (recs60120 == 0l)) { %><dd class="user"><span class="green">Nothing Yet!</span></dd><% } %>
						<% if(recs010 > 0l) { %><dd class="user"><span class="green"><%= recs010 %> Recommendation<% if(recs010 > 1l) { out.println("s"); } %> from Age Between 0 - 10</span></dd><% } %>
						<% if(recs1020 > 0l) { %><dd class="user"><span class="green"><%= recs1020 %> Recommendation<% if(recs1020 > 1l) { out.println("s"); } %> from Age Between 10 - 20</span></dd><% } %>
						<% if(recs2030 > 0l) { %><dd class="user"><span class="green"><%= recs2030 %> Recommendation<% if(recs2030 > 1l) { out.println("s"); } %> from Age Between 20 - 30</span></dd><% } %>
						<% if(recs3040 > 0l) { %><dd class="user"><span class="green"><%= recs3040 %> Recommendation<% if(recs3040 > 1l) { out.println("s"); } %> from Age Between 30 - 40</span></dd><% } %>
						<% if(recs4050 > 0l) { %><dd class="user"><span class="green"><%= recs4050 %> Recommendation<% if(recs4050 > 1l) { out.println("s"); } %> from Age Between 40 - 50</span></dd><% } %>
						<% if(recs5060 > 0l) { %><dd class="user"><span class="green"><%= recs5060 %> Recommendation<% if(recs5060 > 1l) { out.println("s"); } %> from Age Between 50 - 60</span></dd><% } %>
						<% if(recs60120 > 0l) { %><dd class="user"><span class="green"><%= recs60120 %> Recommendation<% if(recs60120 > 1l) { out.println("s"); } %> from Age Between 60 - 120</span></dd><% } %>
					<dt class="user">Recommendations by Country</dt>
						<% pageContext.include("RecommendationsByCountry.jsp?id="+recommendedIdShowed+"&forRecommended=true"); %>
					<dt class="user">Recommendations by Sex, Age Range and Country</dt>
						<dd class="user"><a href="RecommendationsBySexAgeAndCountry.jsp?id=<%= recommendedIdShowed %>">Click for Recommendations by Sex, Age Range and Country</a></dd>
					<dt class="user">Facebook Recommendations</dt>
<dd class="user"><div class="fb-like" data-href="<%= getURL %>" data-layout="button_count" data-action="recommend" data-show-faces="false" data-share="true"></div></dd>
				</dl>
			</fieldset>
		</div>
		<div class="RecommendedRightRightColumn">
			<fieldset class="RecommendedRightRightColumnFieldset">
				<legend>Information</legend>
				<dl class="user">
					<dt class="user">Name</dt>
						<dd class="user"><span class="Nickname"><%= recommended.getName() %></span></dd>
					<dt class="user">Type</dt>
						<dd class="user"><a href="MostRecommended.jsp?type=<%= type %>"><%= type %></a></dd>
					<dt class="user">Added By</dt>
		<dd class="InLine user"><span class="Nickname"><a href="Recommender.jsp?id=<%= recommender.getId() %>"><%= recommender.getNickName() %></a></span><% pageContext.include("MakeButtonSubscribe.jsp?recommender="+recommender.getId()+"&width=static"); %></dd>
						<dd class="user"><%= createdOn %></dd>

<% if(recommended.getRecommender().equals(recommenderIdLogged)) { %>

					<dt class="user"><a href="BeforeUpdateRecommended.jsp?id=<%= recommendedIdShowed %>">Update</a></dt>

					<dt class="user"><a class="delete" href="BeforeDeleteRecommended.jsp?id=<%= recommendedIdShowed %>">Delete</a></dt>

<% } %>


					<dt class="user">Country</dt>
<%

	country = "<a href=\"MostRecommendedByCountry.jsp?country="+recommended.getCountry()+"\">"+country+"</a>";

%>
						<dd class="user"><%= country %></dd>
					<dt class="user">Official Website</dt>
<%

	if(!officialWebsite.equals("Website Pending")) { officialWebsite = "<a href=\"http://"+officialWebsite+"/\" target=\"_blank\">"+officialWebsite+"</a>"; }

%>
						<dd class="user"><%= officialWebsite %></dd>
<!--
					<dt class="user">Created On</dt>
						<dd class="user"><%= recommended.getCreatedOnToMySQL() %></dd>
					<dt class="user">Last Updated</dt>
						<dd class="user"><%= recommended.getLastUpdatedOnToMySQL() %></dd>
-->
					<dt class="user">Who Recommended?</dt>
					<% pageContext.include("WhoRecommendedTheEntity.jsp?id="+recommendedIdShowed+"&forRecommended=true"); %>
					<dt class="user">Who Recommended this Entity From <span class="Nickname"><a href="Recommender.jsp?id=<%= recommender.getId() %>"><%= recommender.getNickName() %></a></span>'s Subscribers?</dt>
					<% pageContext.include("WhoRecommendedTheEntityFromSubscribersOf.jsp?id="+recommendedIdShowed+"&recommender="+recommender.getId()+"&forRecommended=true"); %>
<% if(isRecommenderLogged && (recommenderIdLogged != recommender.getId())) { %>
					<dt class="user">Who Recommended this Entity From My Subscribers?</dt>
					<% pageContext.include("WhoRecommendedTheEntityFromSubscribersOf.jsp?id="+recommendedIdShowed+"&recommender="+recommenderIdLogged+"&forRecommended=true"); %>
<% } %>
					<dt class="user">Who Recommended this Entity From Recommenders that <span class="Nickname"><a href="Recommender.jsp?id=<%= recommender.getId() %>"><%= recommender.getNickName() %></a></span> is Subscribed?</dt>
					<% pageContext.include("WhoRecommendedTheEntityFromRecommendersIAmSubscribed.jsp?id="+recommendedIdShowed+"&recommender="+recommender.getId()+"&forRecommended=true"); %>
<% if(isRecommenderLogged && (recommenderIdLogged != recommender.getId())) { %>
					<dt class="user">Who Recommended this Entity From Recommenders that I am Subscribed?</dt>
					<% pageContext.include("WhoRecommendedTheEntityFromRecommendersIAmSubscribed.jsp?id="+recommendedIdShowed+"&recommender="+recommenderIdLogged+"&forRecommended=true"); %>
<% } %>
				</dl>
			</fieldset>
		</div>
		<div class="CenterColumn">
			<fieldset class="RecommendedCenterColumnFieldset">
				<legend>About <%= recommended.getName() %></legend>
					<div class="AboutPerson">
						<%= about %>
					</div>
			</fieldset>
		</div>
		<div class="CenterColumn">
			<fieldset class="RecommendedCenterColumnFieldset">
				<legend>Facebook Comments</legend>
					<div class="fb-comments" data-href="<%= getURL %>" data-numposts="5" data-version="v2.3"></div>
			</fieldset>
		</div>
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