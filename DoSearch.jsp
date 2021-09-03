
<%@ page errorPage="Error.jsp" %>

<jsp:include page="GetDevice.jsp" flush="true" />

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("DoSearch");

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

%>

<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%@ page import="recBook.DB" %>

<%!

public class Search {

	private Long ordem;
	private String type;
	private Long recommendedId;
	private String recommendedName;
	private Long recommendations;
	private Long recommenderId;
	private String recommender;

	public Search() {

	}

	public Long getOrdem() {
		return this.ordem;
	}

	public void setOrdem(Long ordem) {
		this.ordem = ordem;
	}

	public String getType() {
		return this.type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Long getRecommendedId() {
		return this.recommendedId;
	}

	public void setRecommendedId(Long recommendedId) {
		this.recommendedId = recommendedId;
	}

	public String getRecommendedName() {
		return this.recommendedName;
	}

	public void setRecommendedName(String recommendedName) {
		this.recommendedName = recommendedName;
	}

	public Long getRecommendations() {
		return this.recommendations;
	}

	public void setRecommendations(Long recommendations) {
		this.recommendations = recommendations;
	}

	public Long getRecommenderId() {
		return this.recommenderId;
	}

	public void setRecommenderId(Long recommenderId) {
		this.recommenderId = recommenderId;
	}

	public String getRecommender() {
		return this.recommender;
	}

	public void setRecommender(String recommender) {
		this.recommender = recommender;
	}

}

%>

<%
	String search = "";

	if(request.getParameter("search") != null) {
		search = request.getParameter("search");
	}

	session.setAttribute("SearchString", search);

	List listSearch = new ArrayList();

	Integer limit = 1000;

	if((!search.equals("")) && (search != null)) {

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	/*
	 * Executa Busca Exatas e Parecidas
	 */

	try {
		PreparedStatement ps = db.conexao.prepareStatement("CALL getSearchAdult(?,?)");
		ps.setString(1, search);
		ps.setInt(2, limit);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			Search s = new Search();

			s.setOrdem(result.getLong("ordem"));
			s.setType(result.getString("type"));
			s.setRecommendedId(result.getLong("id"));
			s.setRecommendedName(result.getString("name"));
			s.setRecommendations(result.getLong("recommendations"));
			s.setRecommenderId(result.getLong("recommenderId"));
			s.setRecommender(result.getString("recommender"));

			listSearch.add(s);
		}
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
	 * Executa Busca Por Palavras
	 */

	String searchRegex = search.replace(" ", "|");

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT 3 as ordem, (Select type FROM RecommendedType WHERE id=Recommended.type) as type, id, name, recommendations, (Select id FROM Recommender WHERE id=Recommended.recommender) as recommenderId, (Select nickName FROM Recommender WHERE id=Recommended.recommender) as recommender FROM Recommended WHERE name REGEXP ? ORDER BY recommendations DESC LIMIT ?");
		ps.setString(1, searchRegex);
		ps.setInt(2, limit);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			Search s = new Search();

			s.setOrdem(result.getLong("ordem"));
			s.setType(result.getString("type"));
			s.setRecommendedId(result.getLong("id"));
			s.setRecommendedName(result.getString("name"));
			s.setRecommendations(result.getLong("recommendations"));
			s.setRecommenderId(result.getLong("recommenderId"));
			s.setRecommender(result.getString("recommender"));

			listSearch.add(s);
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

	}

%>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Search</title>
 
<meta name="keywords" content="Search Recommendation Book" />
<meta name="description" content="Search on Recommendation Book" />

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

<script type="text/javascript"> 
<!--

//-->
</script>

</head>

<body>

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
	<jsp:include page="MiniMenuMobile.jsp" flush="true" />
<% } else { %>
	<jsp:include page="CabecalhoMenu.jsp" flush="true" />
<% } %>

<jsp:include page="Search.jsp" flush="true" />

<div class="Corpo">

	<fieldset>
		<legend>Search Results</legend>

<%

	if((!search.equals("")) && (search != null)) {

	List alreadyPlaced = new ArrayList();

	Iterator itr = listSearch.iterator();

	if(search.equals("")) {

		out.println("<span>Enter a Term to Make a Search!</span>");

	} else {

	if(listSearch.isEmpty()) {
		out.println("<span>Nothing Found With Term: "+search+"!</span>");
	} else {

	while(itr.hasNext()) {
		Search s = (Search) itr.next();

		if(!alreadyPlaced.contains(s.getType()+"-"+s.getRecommendedId())) {

		if(s.getType().equals("Recommender")) {
		out.print("<div class=\"DivSearchResult\">Recommender: <a href=\"Recommender.jsp?id="+s.getRecommenderId()+"\">"+s.getRecommender()+"</a><span class=\"green\"> - Recommendations: "+s.getRecommendations()+"</span></div>");
		} else {
		out.print("<div class=\"DivSearchResult\">"+s.getType()+": <a href=\"Recommended.jsp?id="+s.getRecommendedId()+"\">"+s.getRecommendedName()+"</a><span class=\"green\"> - Recommendations: "+s.getRecommendations()+"</span><span class=\"Nickname\"> - Recommender: <a href=\"Recommender.jsp?id="+s.getRecommenderId()+"\">"+s.getRecommender()+"</a></span></div>");
		}

		}

		alreadyPlaced.add(s.getType()+"-"+s.getRecommendedId());

	}

	}

	}

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
