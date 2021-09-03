
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.TODO" %>
<%@ page import="recBook.TODODAO" %>
<%@ page import="recBook.Recommender" %>
<%@ page import="recBook.RecommenderDAOOutro" %>
<%@ page import="recBook.DoesIdExists" %>

<%@ include file="Validation.jsp" %>

<% if((!request.getParameterMap().containsKey("id")) || (!request.getParameterMap().containsKey("page")) || (!request.getParameterMap().containsKey("state"))) { %>

	<jsp:forward page="/Error.jsp?id=6" />

<% } else if(!new Validation().isIdValid(request.getParameter("id"))) { %>

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
	String state = (String) request.getParameter("state");
	Integer pageS = Integer.valueOf((String) request.getParameter("page"));

	Integer limitFrom = 0;
	Integer limitTo = 100;

	if(pageS > 1) {
		limitFrom = ((pageS*limitTo)-limitTo);
	}

	String description = "";

	if(state.equals("ToWatch")) {

		description = "All Movies on the To-Watch List of";

	} else if(state.equals("Watched")) {

		description = "All Movies Already Watched by";

	} else if(state.equals("ToRead")) {

		description = "All Books on the To-Read List of";

	} else if(state.equals("Read")) {

		description = "All Books Already Read by";

	} else if(state.equals("ToListen")) {

		description = "All Albums on the To-Listen List of";

	} else if(state.equals("Listened")) {

		description = "All Albums Already Listened by";

	}

	/*
	 * Select
	 */

	List todo = new ArrayList();
	TODODAO todoDAO = new TODODAO(db);

	try {

		if(state.equals("ToWatch") || state.equals("Watched")) {

			todo = todoDAO.getWatch(recommenderIdShowed, state, limitFrom, limitTo);

		} else if(state.equals("ToRead") || state.equals("Read")) {

			todo = todoDAO.getRead(recommenderIdShowed, state, limitFrom, limitTo);

		} else if(state.equals("ToListen") || state.equals("Listened")) {

			todo = todoDAO.getListen(recommenderIdShowed, state, limitFrom, limitTo);

		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally {}

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
 
<meta name="keywords" content="<%= description %> <%= recommender.getNickName() %> on Recommendation Book" />
<meta name="description" content="<%= description %> <%= recommender.getNickName() %> on Recommendation Book" />

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
	<legend><%= description %> <a class="SeeAll" href="Recommender.jsp?id=<%= recommender.getId() %>"><%= recommender.getNickName() %></a></legend>

			<table>
			<tbody>

<%

	Iterator itr = todo.iterator();

	if(todo.isEmpty()) {
		out.println("<tr><td class=\"LightGrayBorder\">Nothing yet!</td></tr>");
	} else {
		Boolean afterFirst = false;

		while(itr.hasNext()) {

			TODO t = (TODO) itr.next();

			if(session.getAttribute("GetDevice").toString().contains("Mobi")) {

			if(afterFirst.equals(true)) { out.println("<tr><td colspan=\"2\" class=\"SpaceForFields\"></td></tr>"); }

			afterFirst = true;

			out.println("<tr><td class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+t.getId()+"\"><span class=\"Nickname\">"+t.getRecommended()+"</span></a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">Recommendations: "+t.getRecommendations()+"</span></td></tr><tr><td class=\"LightGrayBorder\">"); pageContext.include("MakeButtonRecommend.jsp?id="+t.getId()+"&table=Recommended&width=100"); pageContext.include("MakeButtonTODO.jsp?id="+t.getId()+"&width=100"); out.println("</td></tr>");

			} else {

			out.println("<tr><td class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+t.getId()+"\"><span class=\"Nickname\">"+t.getRecommended()+"</span></a></td>");
			out.println("<td class=\"LightGrayBorder\">"); pageContext.include("MakeButtonRecommend.jsp?id="+t.getId()+"&table=Recommended&width=static"); out.println("</td>");
			out.println("<td class=\"LightGrayBorder\">"); pageContext.include("MakeButtonTODO.jsp?id="+t.getId()+"&width=static"); out.println("</td>");
			out.println("<td class=\"LightGrayBorder\"><span class=\"green\">Recommendations: "+t.getRecommendations()+"</span></td></tr>");

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

		if(state.equals("ToWatch") || state.equals("Watched")) {

			count = todoDAO.getCountWatch(recommenderIdShowed, state);

		} else if(state.equals("ToRead") || state.equals("Read")) {

			count = todoDAO.getCountRead(recommenderIdShowed, state);

		} else if(state.equals("ToListen") || state.equals("Listened")) {

			count = todoDAO.getCountListen(recommenderIdShowed, state);

		}

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
out.println("<a class=\"pages\" href=\"AllTODO.jsp?id="+recommenderIdShowed+"&state="+state+"&page="+i+"\"><span class=\"green\">"+i+"</span></a>");
			} else {
out.println("<a class=\"pages\" href=\"AllTODO.jsp?id="+recommenderIdShowed+"&state="+state+"&page="+i+"\">"+i+"</a>");
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
