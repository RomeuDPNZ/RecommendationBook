
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>

<%@ page import="java.text.SimpleDateFormat" %>

<%@ page import="java.io.File"%>
<%@ page import="java.io.RandomAccessFile"%>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.FileNotFoundException" %>

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

<%@ include file="Validation.jsp" %>

<% if(!new Validation().isIdValid(request.getParameter("id"))) { %>

	<jsp:forward page="/Error.jsp?id=4" />

<% } else if(!new DoesIdExists().check("Recommended", (Long.valueOf(request.getParameter("id"))))) { %>

	<jsp:forward page="/Error.jsp?id=2" />

<% } else { %>

<%
	Cookie[] cookies = request.getCookies();

	Long recommendedIdShowed = Long.valueOf((String) request.getParameter("id"));
	Boolean isRecommenderLogged = false;
	Long recommenderIdLogged = 0l;

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

	String todo = "";

	ReadList readList = new ReadList();
	WatchList watchList = new WatchList();
	ListenList listenList = new ListenList();

	if(isRecommenderLogged) {

	if(type.equals("Movie")) {

		try {

			watchList = new WatchListDAOOutro(db).select(recommendedIdShowed, recommenderIdLogged);

			if(watchList.getId() != null) {
				todo = watchList.getStateWatchToMySQL();
			}

		} catch(SQLException e) {
			System.err.println("SQLException: "+e.getMessage());

			if(db.conexao != null) {
				db.DesconectaDB();
			}

			String uri = request.getRequestURI();
			String pageName = uri.substring(uri.lastIndexOf("/")+1);

			if(e.getMessage() != null) {
				throw new SQLException(e.getMessage()+" Page: "+pageName);
			}
		} finally { }

	} else if(type.equals("Book")) {

		try {

			readList = new ReadListDAOOutro(db).select(recommendedIdShowed, recommenderIdLogged);

			if(readList.getId() != null) {
				todo = readList.getStateReadToMySQL();
			}

		} catch(SQLException e) {
			System.err.println("SQLException: "+e.getMessage());

			if(db.conexao != null) {
				db.DesconectaDB();
			}

			String uri = request.getRequestURI();
			String pageName = uri.substring(uri.lastIndexOf("/")+1);

			if(e.getMessage() != null) {
				throw new SQLException(e.getMessage()+" Page: "+pageName);
			}
		} finally { }

	} else if(type.equals("Album")) {

		try {

			listenList = new ListenListDAOOutro(db).select(recommendedIdShowed, recommenderIdLogged);

			if(listenList.getId() != null) {
				todo = listenList.getStateListenToMySQL();
			}

		} catch(SQLException e) {
			System.err.println("SQLException: "+e.getMessage());

			if(db.conexao != null) {
				db.DesconectaDB();
			}

			String uri = request.getRequestURI();
			String pageName = uri.substring(uri.lastIndexOf("/")+1);

			if(e.getMessage() != null) {
				throw new SQLException(e.getMessage()+" Page: "+pageName);
			}
		} finally { }

	}

	}

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
		about = recommended.getAbout().replace("\n", "<br />");
	}

	/*
	 * Insert Links In About
	 */

	char[] aboutArray = about.toCharArray();

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

	/*
	 * Imagem
	 */

	String imagemOutro = "NoImageAvailable.png";
	String imagemNome = "Recommended"+recommended.getId()+"."+recommended.getExtensionImage()+"";

	if(recommended.getExtensionImage() != null && !(recommended.getExtensionImage().equals(""))) {

		imagemOutro = imagemNome;

		try {

			new RecordImage(request, recommended.getImage(), "\\img\\user\\", imagemNome);

		} catch(FileNotFoundException e) {
			System.err.println("FileNotFoundException: "+e.getMessage());

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
		} catch(IOException e) {
			System.err.println("IOException: "+e.getMessage());

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

	String descricaoDaImagem = "";

	if(recommended.getDescriptionImage() == null || recommended.getDescriptionImage().equals("")) {

	} else {
		descricaoDaImagem = recommended.getDescriptionImage();
	}

%>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="" />
<meta name="description" content="" />
 
<style type="text/css">
<!--
   @import url("RecommendationBookCSS.css");
-->
</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />

<script src="js/jquery-1.10.2.js"></script>
<script src="js/jquery-ui.js"></script>
<script src="js/RecommendationBookJS.js"></script>
<script type="text/javascript"> 
<!--

WidthStaticAt(900);

DLWidth();

AboutWidth();

$(document).ready(function(){

	$(".Things").hide();

	$("h3").click(function(){
		$(this).toggleClass("HToggleUp HToggleDown").next().slideToggle();
	});

});

<% if(isRecommenderLogged) { %>

	<% if(recommendedId > 0l) { %>

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
		$("#ButtonRecommended").load("ButtonRecommend.jsp?id=<%= recommendedId %>&table=Recommended");
	});
});

	<% } else { %>

$(document).ready(function(){
	$("#Recommend").click(function(){
$("#ButtonRecommend").load("ButtonRecommended.jsp?recommender=<%= recommenderIdLogged %>&addRec=<%= recommendedIdShowed %>&action=<%= action %>&table=Recommended");
	});
});

	<% } %>

<% } else { %>

$(document).ready(function(){
	$("#Recommend").click(function(){
		alert("Log in to Recommend!");
	});
});

<% } %>

<% if(isRecommenderLogged) { %>

	<% if(type.equals("Movie")) { %>

		<% if(todo.equals("ToWatch")) { %>

$(document).ready(function(){
	$("#ToWatchActivated").click(function(){
		$("#ButtonToWatchActivated").load("ButtonWatched.jsp?id=<%= watchList.getId() %>");
	});
});

		<% } else if(todo.equals("Watched")) { %>

$(document).ready(function(){
	$("#Watched").click(function(){
		$("#ButtonWatched").load("ButtonToWatch.jsp?id=<%= watchList.getId() %>");
	});
});

		<% } else { %>

$(document).ready(function(){
	$("#ToWatch").click(function(){
		$("#ButtonToWatch").load("ButtonToWatchActivated.jsp?recommender=<%= recommenderIdLogged %>&movie=<%= recommendedIdShowed %>");
	});
});

		<% } %>

	<% } else if(type.equals("Album")) { %>

		<% if(todo.equals("ToListen")) { %>

$(document).ready(function(){
	$("#ToListenActivated").click(function(){
		$("#ButtonToListenActivated").load("ButtonListened.jsp?id=<%= listenList.getId() %>");
	});
});

		<% } else if(todo.equals("Listened")) { %>

$(document).ready(function(){
	$("#Listened").click(function(){
		$("#ButtonListened").load("ButtonToListen.jsp?id=<%= listenList.getId() %>");
	});
});

		<% } else { %>

$(document).ready(function(){
	$("#ToListen").click(function(){
		$("#ButtonToListen").load("ButtonToListenActivated.jsp?recommender=<%= recommenderIdLogged %>&album=<%= recommendedIdShowed %>");
	});
});

		<% } %>

	<% } else if(type.equals("Book")) { %>

		<% if(todo.equals("ToRead")) { %>

$(document).ready(function(){
	$("#ToReadActivated").click(function(){
		$("#ButtonToReadActivated").load("ButtonRead.jsp?id=<%= readList.getId() %>");
	});
});

		<% } else if(todo.equals("Read")) { %>

$(document).ready(function(){
	$("#Read").click(function(){
		$("#ButtonRead").load("ButtonToRead.jsp?id=<%= readList.getId() %>");
	});
});

		<% } else { %>

$(document).ready(function(){
	$("#ToRead").click(function(){
		$("#ButtonToRead").load("ButtonToReadActivated.jsp?recommender=<%= recommenderIdLogged %>&book=<%= recommendedIdShowed %>");
	});
});

		<% } %>

	<% } %>

<% } else { %>

	<% if(type.equals("Movie")) { %>

$(document).ready(function(){
	$("#ToWatch").click(function(){
		alert("Log in To Add Movies To Your To-Watch List!");
	});
});

	<% } else if(type.equals("Album")) { %>

$(document).ready(function(){
	$("#ToListen").click(function(){
		alert("Log in To Add Albums To Your To-Listen List!");
	});
});

	<% } else if(type.equals("Book")) { %>

$(document).ready(function(){
	$("#ToRead").click(function(){
		alert("Log in To Add Books To Your To-Read List!");
	});
});

	<% } %>

<% } %>

//-->
</script>

</head>

<body>

<div class="Geral">
	<jsp:include page="MiniMenu.jsp" flush="true" />
	<div class="Corpo">
		<div class="CenterColumn">
			<fieldset class="RightColumn ">
				<legend>About <%= recommended.getName() %></legend>
					<div class="AboutPerson">
						<%= about %>
					</div>
			</fieldset>
<!--
			<fieldset class="CenterColumn">
				<legend>Publicidade</legend>
					<figure>
						<img class="AdHorizontalSmall" src="./img/static/adsense468.jpg" />
						<br />
						<figcaption></figcaption>
					</figure>
			</fieldset>
-->
		</div>
		<div class="RightColumn">
			<fieldset class="RightColumn PersonGroupInformation">
				<legend><%= type %></legend>
				<div class="PersonGroupImage">
					<figure>
						<img class="PersonGroupImage" src="./img/user/<%= imagemOutro %>" alt="<%= recommended.getName() %>" />
						<figcaption><%= descricaoDaImagem %></figcaption>
					</figure>
				</div>

<% if(recommendedId > 0l) { %>
				<div id="ButtonRecommended" class="ButtonRecommend">
					<button id="Recommended" class="ButtonRecommended">Recommended</button>
				</div>


	<% if(type.equals("Movie")) { %>

		<% if(todo.equals("ToWatch")) { %>

				<div id="ButtonToWatchActivated" class="ButtonRecommended">
					<button id="ToWatchActivated" class="ButtonRecommended">Added To To-Watch</button>
				</div>

		<% } else if(todo.equals("Watched")) { %>

				<div id="ButtonWatched" class="ButtonRecommended">
					<button id="Watched" class="ButtonRecommended">Watched</button>
				</div>

		<% } else { %>

				<div id="ButtonToWatch" class="ButtonRecommend">
					<button id="ToWatch" class="ButtonRecommend">To-Watch</button>
				</div>

		<% } %>

	<% } else if(type.equals("Album")) { %>

		<% if(todo.equals("ToListen")) { %>

				<div id="ButtonToListenActivated" class="ButtonRecommended">
					<button id="ToListenActivated" class="ButtonRecommended">Added To To-Listen</button>
				</div>

		<% } else if(todo.equals("Listened")) { %>

				<div id="ButtonListened" class="ButtonRecommended">
					<button id="Listened" class="ButtonRecommended">Listened</button>
				</div>

		<% } else { %>

				<div id="ButtonToListen" class="ButtonRecommend">
					<button id="ToListen" class="ButtonRecommend">To-Listen</button>
				</div>

		<% } %>

	<% } else if(type.equals("Book")) { %>

		<% if(todo.equals("ToRead")) { %>

				<div id="ButtonToReadActivated" class="ButtonRecommended">
					<button id="ToReadActivated" class="ButtonRecommended">Added To To-Read</button>
				</div>

		<% } else if(todo.equals("Read")) { %>

				<div id="ButtonRead" class="ButtonRecommended">
					<button id="Read" class="ButtonRecommended">Read</button>
				</div>

		<% } else { %>

				<div id="ButtonToRead" class="ButtonRecommend">
					<button id="ToRead" class="ButtonRecommend">To-Read</button>
				</div>

		<% } %>

	<% } %>

<% } else { %>
				<div id="ButtonRecommend" class="ButtonRecommend">
					<button id="Recommend" class="ButtonRecommend">Recommend</button>
				</div>

	<% if(type.equals("Movie")) { %>

				<div id="ToWatch" class="ButtonRecommend">
					<button id=ToWatch" class="ButtonRecommend">To-Watch</button>
				</div>

	<% } else if(type.equals("Album")) { %>

				<div id="ToListen" class="ButtonRecommend">
					<button id=ToListen" class="ButtonRecommend">To-Listen</button>
				</div>

	<% } else if(type.equals("Book")) { %>

				<div id="ToRead" class="ButtonRecommend">
					<button id=ToRead" class="ButtonRecommend">To-Read</button>
				</div>

	<% } %>

<% } %>

				<dl class="user">
					<dt class="user">Name</dt>
						<dd class="user"><%= recommended.getName() %></dd>
					<dt class="user">Type</dt>
						<dd class="user"><%= type %></dd>
					<dt class="user">Recommendations</dt>
						<dd class="user"><span class="green"><%= recommended.getRecommendations() %> Times</span></dd>
					<dt class="user">Page Views</dt>
						<dd class="user"><span class="green"><%= recommended.getPageViews() %> Page Views</span></dd>
					<dt class="user">General Ranking</dt>
						<dd class="user"><span class="green"><%= generalRanking %> Most Recommended</span></dd>
					<dt class="user">Ranking By Type</dt>
						<dd class="user"><span class="green"><%= rankingByType %> Most Recommended</span></dd>
					<dt class="user">Added By</dt>
		<dd class="user"><span class="Nickname"><a href="Recommender.jsp?id=<%= recommender.getId() %>"><%= recommender.getNickName() %></a></span></dd>
						<dd class="user"><%= createdOn %></dd>

<% if(recommended.getRecommender().equals(recommenderIdLogged)) { %>

					<dt class="user"><a href="BeforeUpdateRecommended.jsp?id=<%= recommendedIdShowed %>">Update</a></dt>

					<dt class="user"><a class="delete" href="BeforeDeleteRecommended.jsp?id=<%= recommendedIdShowed %>">Delete</a></dt>

<% } %>

					<dt class="user">Country</dt>
						<dd class="user"><%= country %></dd>
					<dt class="user">Official Website</dt>
						<dd class="user"><%= officialWebsite %></dd>
					<dt class="user">Created On</dt>
						<dd class="user"><%= recommended.getCreatedOnToMySQL() %></dd>
					<dt class="user">Last Updated</dt>
						<dd class="user"><%= recommended.getLastUpdatedOnToMySQL() %></dd>
				</dl>
			</fieldset>
		</div>
	</div>
	<jsp:include page="Rodape.jsp" flush="true" />
</div>

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

