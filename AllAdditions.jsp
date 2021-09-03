
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Added" %>
<%@ page import="recBook.AddedDAO" %>
<%@ page import="recBook.Recommender" %>
<%@ page import="recBook.RecommenderDAOOutro" %>
<%@ page import="recBook.DoesIdExists" %>

<%@ include file="Validation.jsp" %>

<% if((!request.getParameterMap().containsKey("id")) || (!request.getParameterMap().containsKey("page")) || (!request.getParameterMap().containsKey("type"))) { %>

	<jsp:forward page="/Error.jsp?id=6" />

<% } else if(!new Validation().isIdValid(request.getParameter("id"))) { %>

	<jsp:forward page="/Error.jsp?id=4" />

<% } else if(!new Validation().isIdValid(request.getParameter("page"))) { %>

	<jsp:forward page="/Error.jsp?id=4" />

<% } else if(!new DoesIdExists().check("Recommender", (Long.valueOf(request.getParameter("id"))))) { %>

	<jsp:forward page="/Error.jsp?id=2" />

<% } else { %>

<jsp:include page="GetDevice.jsp" flush="true" />

<%

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	Long recommenderIdShowed = Long.valueOf((String) request.getParameter("id"));
	String type = (String) request.getParameter("type");
	String typeOutro = type;
	Integer pageS = Integer.valueOf((String) request.getParameter("page"));
	String name = "Recommended.name";
	String action = "";
	String seeAll = "";

	Integer limitFrom = 0;
	Integer limitTo = 100;

	if(pageS > 1) {
		limitFrom = ((pageS*limitTo)-limitTo);
	}

	if(type.equals("Persons")) {
		action = "Added the Person";
		seeAll = "Persons";
	} else if(type.equals("Groups")) {
		action = "Added the Group";
		seeAll = "Groups";
	} else if(type.equals("Books")) {
		action = "Added the Book";
		seeAll = "Books";
	} else if(type.equals("Movies")) {
		action = "Added the Movie";
		seeAll = "Movies";
	} else if(type.equals("Bands")) {
		action = "Added the Band";
		seeAll = "Bands";
	} else if(type.equals("Albums")) {
		action = "Added the Album";
		seeAll = "Albums";
	} else if(type.equals("Songs")) {
		action = "Added the Song";
		seeAll = "Songs";
	} else if(type.equals("Projects")) {
		action = "Added the Project";
		seeAll = "Projects";
	} else if(type.equals("Websites")) {
		action = "Added the Website";
		seeAll = "Websites";
	} else if(type.equals("Companies")) {
		action = "Added the Company";
		seeAll = "Companies";
	} else if(type.equals("Products")) {
		action = "Added the Product";
		seeAll = "Products";
	} else if(type.equals("Places")) {
		action = "Added the Place";
		seeAll = "Places";
	} else if(type.equals("Foods")) {
		action = "Added the Food";
		seeAll = "Foods";
	} else if(type.equals("Games")) {
		action = "Added the Game";
		seeAll = "Games";
	} else if(type.equals("Guns")) {
		action = "Added the Gun";
		seeAll = "Guns";
	} else if(type.equals("Knives")) {
		action = "Added the Knife";
		seeAll = "Knives";
	} else if(type.equals("Cars")) {
		action = "Added the Car";
		seeAll = "Cars";
	} else if(type.equals("Motorcycles")) {
		action = "Added the Motorcycle";
		seeAll = "Motorcycles";
	} else {
		type = "";
		name = "";
		action = "";
	}

	type = "Recommended";

	/*
	 * Select
	 */

	List added = new ArrayList();
	AddedDAO addedDAO = new AddedDAO(db);

	try {
		added = addedDAO.getList(type, name, action, recommenderIdShowed, limitFrom, limitTo);

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	Recommender recommender = new Recommender();
	RecommenderDAOOutro recommenderDAOOutro = new RecommenderDAOOutro(db);

	try {
		recommender = recommenderDAOOutro.selectForSeeAll(recommenderIdShowed);

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally {}

%>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="All <%= seeAll  %> Added by <%= recommender.getNickName() %> on Recommendation Book" />
<meta name="description" content="All <%= seeAll  %> Added by <%= recommender.getNickName() %> on Recommendation Book" />

<link rel="icon" href="./img/static/RBIcon.ico" type="image/x-icon">

<link href='http://fonts.googleapis.com/css?family=Roboto:500' rel='stylesheet' type='text/css'>

<style type="text/css">
<!--
   @import url("RecommendationBookCSS.css");
-->
</style>
<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookCSS.css" />

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>

<link rel="stylesheet" type="text/css" media="screen" href="RecommendationBookMobileCSS.css" />

<% } %>

<script src="js/jquery-1.10.2.js"></script>
<script type="text/javascript"> 
<!--

//-->
</script>

</head>

<body>

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
	<jsp:include page="MiniMenuMobile.jsp" flush="true" />
<% } else { %>
	<jsp:include page="MiniMenu.jsp" flush="true" />
<% } %>

<div class="Corpo">

	<fieldset>
	<legend>All <%= seeAll  %> Added by <a class="SeeAll" href="Recommender.jsp?id=<%= recommender.getId() %>"><%= recommender.getNickName() %></a></legend>

			<table>
			<tbody>

<%

	Iterator itr = added.iterator();

	if(added.isEmpty()) {
		out.println("<tr><td class=\"LightGrayBorder\">Nothing yet!</td></tr>");
	} else {
		Boolean afterFirst = false;

		while(itr.hasNext()) {
			Added a = (Added) itr.next();

			if(session.getAttribute("GetDevice").toString().contains("Mobi")) {

			if(afterFirst.equals(true)) { out.println("<tr><td colspan=\"2\" class=\"SpaceForFields\"></td></tr>"); }

			afterFirst = true;

			out.println("<tr><td class=\"LightGrayBorder\"><a href=\""+type+".jsp?id="+a.getId()+"\"><span class=\"Nickname\">"+a.getName()+"</span></a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">Recommendations: "+a.getRecommendations()+"</span></td></tr><tr><td class=\"LightGrayBorder\">"); pageContext.include("MakeButtonRecommend.jsp?id="+a.getId()+"&table=Recommended&width=100"); out.println("</td></tr>"); if(typeOutro.contains("Books") || typeOutro.contains("Albums") || typeOutro.contains("Movies")) { out.println("<tr><td class=\"LightGrayBorder\">"); pageContext.include("MakeButtonTODO.jsp?id="+a.getId()+"&width=100"); out.println("</td></tr>"); }

			} else {

			out.println("<tr><td class=\"LightGrayBorder\"><a href=\""+type+".jsp?id="+a.getId()+"\"><span class=\"Nickname\">"+a.getName()+"</span></a></td>");
			out.println("<td class=\"LightGrayBorder\">"); pageContext.include("MakeButtonRecommend.jsp?id="+a.getId()+"&table=Recommended&width=static"); out.println("</td>");
			if(typeOutro.contains("Books") || typeOutro.contains("Albums") || typeOutro.contains("Movies")) {
				out.println("<td class=\"LightGrayBorder\">"); pageContext.include("MakeButtonTODO.jsp?id="+a.getId()+"&width=static"); out.println("</td>");
			}
			out.println("<td class=\"LightGrayBorder\"><span class=\"green\">Recommendations: "+a.getRecommendations()+"</span></td></tr>");

			}

		}
	}

%>

			</tbody>
			</table>

<%


	/*
	 * Count
	 */

	Integer numeroPaginas = 0;
	Long count = 0l;

	try {

		count = addedDAO.getCount(recommenderIdShowed, action);

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally {
		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}
	}

	Double doubleCount = count.doubleValue();

	numeroPaginas = ((doubleCount.intValue())/limitTo);

	if((doubleCount % limitTo) != 0) {
		numeroPaginas++; 
	}

	if(numeroPaginas > 1) {

		out.println("<div class=\"pages\">");

		for(int i=1;i<=numeroPaginas;i++) {
			if(pageS.equals(i)) {
out.println("<a class=\"pages\" href=\"AllAdditions.jsp?id="+recommenderIdShowed+"&type="+seeAll+"&page="+i+"\"><span class=\"green\">"+i+"</span></a>");
			} else {
out.println("<a class=\"pages\" href=\"AllAdditions.jsp?id="+recommenderIdShowed+"&type="+seeAll+"&page="+i+"\">"+i+"</a>");
			}
		}

		out.println("</div>");

	}

%>


	</fieldset>

</div>

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
	<jsp:include page="RodapeMobile.jsp" flush="true" />
<% } else { %>
	<jsp:include page="Rodape.jsp" flush="true" />
<% } %>

</body>
 
</html>

<% } %>
