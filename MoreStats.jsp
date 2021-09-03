
<jsp:include page="GetDevice.jsp" flush="true" />

<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.RecommendedType" %>
<%@ page import="recBook.RecommendedTypeDAO" %>
<%@ page import="recBook.AgeStatistics" %>

<%!

public class RecBookStats {

	private String type;
	private String recommendations;

	public RecBookStats() {
	}

	public String getType() {
		return this.type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getRecommendations() {
		return this.recommendations;
	}

	public void setRecommendations(String recommendations) {
		this.recommendations = recommendations;
	}

}

%>

<%!

public class RecBookStatsGeneral {

	private Long entityId;
	private String entity;
	private String stats;

	public RecBookStatsGeneral() {
	}

	public Long getEntityId() {
		return this.entityId;
	}

	public void setEntityId(Long entityId) {
		this.entityId = entityId;
	}

	public String getEntity() {
		return this.entity;
	}

	public void setEntity(String entity) {
		this.entity = entity;
	}

	public String getStats() {
		return this.stats;
	}

	public void setStats(String stats) {
		this.stats = stats;
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

	List list = new ArrayList();
	RecommendedTypeDAO recommendedTypeDAO = new RecommendedTypeDAO(db);	

	try {

		list = recommendedTypeDAO.getList(1, 250);

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());
	} finally {}

	List stats = new ArrayList();

	try {

		PreparedStatement ps;
		ResultSet result;

		Iterator itr = list.iterator();

		while(itr.hasNext()) {
			RecommendedType recommendedType = (RecommendedType) itr.next();

			ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type=?)");
			ps.setString(1, recommendedType.getType());
			result = ps.executeQuery();

			while(result.next()) {

				RecBookStats recBookStats = new RecBookStats();
				recBookStats.setType(recommendedType.getType());
				recBookStats.setRecommendations(Long.toString(result.getLong(1)));
				stats.add(recBookStats);

			}
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}
	} finally {

	}

	String countOfMales = "";
	String countOfFemales = "";

	try {

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) as countOfMales FROM Recommender WHERE sex=1");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			countOfMales = result.getString("countOfMales");
		}

		ps = db.conexao.prepareStatement("SELECT COUNT(*) as countOfFemales FROM Recommender WHERE sex=2");
		result = ps.executeQuery();

		while(result.next()) {
			countOfFemales = result.getString("countOfFemales");
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}
	} finally {

	}

	/*
	 * Age Statistics
	 */

	Long recs010 = 0l;
	Long recs1020 = 0l;
	Long recs2030 = 0l;
	Long recs3040 = 0l;
	Long recs4050 = 0l;
	Long recs5060 = 0l;
	Long recs6070 = 0l;
	Long recs7080 = 0l;
	Long recs8090 = 0l;
	Long recs90100 = 0l;
	Long recs100120 = 0l;

	try {
		AgeStatistics ageStats = new AgeStatistics(db);

		recs010 = ageStats.getAgeStatisticsGeneral(0, 10);
		recs1020 = ageStats.getAgeStatisticsGeneral(10, 20);
		recs2030 = ageStats.getAgeStatisticsGeneral(20, 30);
		recs3040 = ageStats.getAgeStatisticsGeneral(30, 40);
		recs4050 = ageStats.getAgeStatisticsGeneral(40, 50);
		recs5060 = ageStats.getAgeStatisticsGeneral(50, 60);
		recs6070 = ageStats.getAgeStatisticsGeneral(60, 70);
		recs7080 = ageStats.getAgeStatisticsGeneral(70, 80);
		recs8090 = ageStats.getAgeStatisticsGeneral(80, 90);
		recs90100 = ageStats.getAgeStatisticsGeneral(90, 100);
		recs100120 = ageStats.getAgeStatisticsGeneral(100, 120);

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	List numberOfRecommendersByCountry = new ArrayList();

	try {

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) as stats, (SELECT id FROM Countries WHERE id=Recommender.country) as countryId, (SELECT country FROM Countries WHERE id=Recommender.country) as country FROM Recommender GROUP BY country ORDER BY stats DESC");
		ResultSet result = ps.executeQuery();

		while(result.next()) {

			RecBookStatsGeneral recBookStatsGeneral = new RecBookStatsGeneral();
			recBookStatsGeneral.setEntityId(result.getLong("countryId"));
			recBookStatsGeneral.setEntity(result.getString("country"));
			recBookStatsGeneral.setStats(result.getString("stats"));
			numberOfRecommendersByCountry.add(recBookStatsGeneral);

		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}
	} finally { }

	List numberOfEntitiesByCountry = new ArrayList();

	try {

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) as stats, (SELECT id FROM Countries WHERE id=Recommended.country) as countryId, (SELECT country FROM Countries WHERE id=Recommended.country) as country FROM Recommended GROUP BY country ORDER BY stats DESC;");
		ResultSet result = ps.executeQuery();

		while(result.next()) {

			RecBookStatsGeneral recBookStatsGeneral = new RecBookStatsGeneral();
			recBookStatsGeneral.setEntityId(result.getLong("countryId"));
			recBookStatsGeneral.setEntity(result.getString("country"));
			recBookStatsGeneral.setStats(result.getString("stats"));
			numberOfEntitiesByCountry.add(recBookStatsGeneral);

		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}
	} finally { }

	/*
	 * Desconecta do Banco de Dados
	 */

	if(db.conexao != null) {
		db.DesconectaDB();
	}

%>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="Stats for Recommendation Book" />
<meta name="description" content="Stats for Recommendation Book" />
 
<style type="text/css">

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

<div class="Geral">

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
	<jsp:include page="MiniMenuMobile.jsp" flush="true" />
<% } else { %>
	<jsp:include page="MiniMenu.jsp" flush="true" />
<% } %>

	<div class="Corpo">

	<div class="Stats">

	<fieldset><legend>Stats for Recommendation Book</legend>

	<fieldset><legend>Number of Recommenders by Sex on Recommendation Book</legend>
		<span class="green">There are <%= countOfMales %> Male Recommenders</span><br /><br />
		<span class="green">There are <%= countOfFemales %> Female Recommenders</span><br /><br />
	</fieldset>

	<fieldset><legend>Number of Recommenders by Age Range on Recommendation Book</legend>
		<% if(recs010 > 0l) { %><span class="green"><%= recs010 %> Recommender<% if(recs010 > 1l) { out.println("s"); } %> from Age Between 0 - 10</span><br /><br /><% } %>
		<% if(recs1020 > 0l) { %><span class="green"><%= recs1020 %> Recommender<% if(recs1020 > 1l) { out.println("s"); } %> from Age Between 10 - 20</span><br /><br /><% } %>
		<% if(recs2030 > 0l) { %><span class="green"><%= recs2030 %> Recommender<% if(recs2030 > 1l) { out.println("s"); } %> from Age Between 20 - 30</span><br /><br /><% } %>
		<% if(recs3040 > 0l) { %><span class="green"><%= recs3040 %> Recommender<% if(recs3040 > 1l) { out.println("s"); } %> from Age Between 30 - 40</span><br /><br /><% } %>
		<% if(recs4050 > 0l) { %><span class="green"><%= recs4050 %> Recommender<% if(recs4050 > 1l) { out.println("s"); } %> from Age Between 40 - 50</span><br /><br /><% } %>
		<% if(recs5060 > 0l) { %><span class="green"><%= recs5060 %> Recommender<% if(recs5060 > 1l) { out.println("s"); } %> from Age Between 50 - 60</span><br /><br /><% } %>
		<% if(recs6070 > 0l) { %><span class="green"><%= recs6070 %> Recommender<% if(recs6070 > 1l) { out.println("s"); } %> from Age Between 60 - 70</span><br /><br /><% } %>
		<% if(recs7080 > 0l) { %><span class="green"><%= recs7080 %> Recommender<% if(recs7080 > 1l) { out.println("s"); } %> from Age Between 70 - 80</span><br /><br /><% } %>
		<% if(recs8090 > 0l) { %><span class="green"><%= recs8090 %> Recommender<% if(recs8090 > 1l) { out.println("s"); } %> from Age Between 80 - 90</span><br /><br /><% } %>
		<% if(recs90100 > 0l) { %><span class="green"><%= recs90100 %> Recommender<% if(recs90100 > 1l) { out.println("s"); } %> from Age Between 90 - 100</span><br /><br /><% } %>
		<% if(recs100120 > 0l) { %><span class="green"><%= recs100120 %> Recommender<% if(recs100120 > 1l) { out.println("s"); } %> from Age Between 100 - 120</span><% } %>
	</fieldset>

	<fieldset><legend>Number of Recommenders By Country on Recommendation Book</legend>

<%

		Iterator itr2 = numberOfRecommendersByCountry.iterator();

		while(itr2.hasNext()) {
			RecBookStatsGeneral rbsg = (RecBookStatsGeneral) itr2.next();

			String recommender = "Recommenders";
			if(rbsg.getStats().equals("1")) { recommender = "Recommender"; } else { recommender = "Recommenders"; }

			out.print("<span class=\"green\">"+rbsg.getStats()+" "+recommender+" from <a href=\"MostRecommendedByCountry.jsp?country="+rbsg.getEntityId()+"\">"+rbsg.getEntity()+"</a></span><br /><br />");
		}

%>


	</fieldset>

	<fieldset><legend>Number of Recommended Entities By Country on Recommendation Book</legend>

<%

		Iterator itr4 = numberOfEntitiesByCountry.iterator();

		while(itr4.hasNext()) {
			RecBookStatsGeneral rbsg = (RecBookStatsGeneral) itr4.next();

			out.print("<span class=\"green\">"+rbsg.getStats()+" Recommended Entities from <a href=\"MostRecommendedByCountry.jsp?country="+rbsg.getEntityId()+"\">"+rbsg.getEntity()+"</a></span><br /><br />");
		}

%>


	</fieldset>

	<fieldset><legend>Number of Entities by Type on Recommendation Book</legend>

<%

		Iterator itr3 = stats.iterator();

		while(itr3.hasNext()) {
			RecBookStats recBookStats = (RecBookStats) itr3.next();

			out.print("<span class=\"green\">"+recBookStats.getRecommendations()+" Recommended Entities From the Type <a href=\"MostRecommended.jsp?type="+recBookStats.getType()+"\">"+recBookStats.getType()+"</a></span><br /><br />");
		}

%>


	</fieldset>

	</fieldset>

	</div>

	</div>

<% if(session.getAttribute("GetDevice").toString().contains("Mobi")) { %>
	<jsp:include page="RodapeMobile.jsp" flush="true" />
<% } else { %>
	<jsp:include page="Rodape.jsp" flush="true" />
<% } %>

</div>

</body>
 
</html>
