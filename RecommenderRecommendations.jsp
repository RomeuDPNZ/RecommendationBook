
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Recommendations" %>
<%@ page import="recBook.RecommendationsDAO" %>
<%@ page import="recBook.IsImageRecorded" %>

<jsp:include page="GetDevice.jsp" flush="true" />

<%

	DB db = (DB) request.getSession().getAttribute("DB");

	Long recommenderIdShowed = Long.valueOf((String) session.getAttribute("RecommenderIdShowed"));
	String table = request.getParameter("table");
	String seeAll = "";
	String name = "";
	String action = "";
	Integer limitFrom = 0;
	Integer limitTo = 10;

	if(table.equals("Recommender")) {
		name = "Recommender.nickName";
		action = "Recommended the Recommender";
		seeAll = "Recommender";
	} else if(table.equals("Persons")) {
		name = "Recommended.name";
		action = "Recommended the Person";
		seeAll = "Persons";
	} else if(table.equals("Groups")) {
		name = "Recommended.name";
		action = "Recommended the Group";
		seeAll = "Groups";
	} else if(table.equals("Books")) {
		name = "Recommended.name";
		action = "Recommended the Book";
		seeAll = "Books";
	} else if(table.equals("Movies")) {
		name = "Recommended.name";
		action = "Recommended the Movie";
		seeAll = "Movies";
	} else if(table.equals("Bands")) {
		name = "Recommended.name";
		action = "Recommended the Band";
		seeAll = "Bands";
	} else if(table.equals("Albums")) {
		name = "Recommended.name";
		action = "Recommended the Album";
		seeAll = "Albums";
	} else if(table.equals("Songs")) {
		name = "Recommended.name";
		action = "Recommended the Song";
		seeAll = "Songs";
	} else if(table.equals("Projects")) {
		name = "Recommended.name";
		action = "Recommended the Project";
		seeAll = "Projects";
	} else if(table.equals("Websites")) {
		name = "Recommended.name";
		action = "Recommended the Website";
		seeAll = "Websites";
	} else if(table.equals("Companies")) {
		name = "Recommended.name";
		action = "Recommended the Company";
		seeAll = "Companies";
	} else if(table.equals("Products")) {
		name = "Recommended.name";
		action = "Recommended the Product";
		seeAll = "Products";
	} else if(table.equals("Places")) {
		name = "Recommended.name";
		action = "Recommended the Place";
		seeAll = "Places";
	} else if(table.equals("Foods")) {
		name = "Recommended.name";
		action = "Recommended the Food";
		seeAll = "Foods";
	} else if(table.equals("Games")) {
		name = "Recommended.name";
		action = "Recommended the Game";
		seeAll = "Games";
	} else if(table.equals("Guns")) {
		name = "Recommended.name";
		action = "Recommended the Gun";
		seeAll = "Guns";
	} else if(table.equals("Knives")) {
		name = "Recommended.name";
		action = "Recommended the Knife";
		seeAll = "Knives";
	} else if(table.equals("Cars")) {
		name = "Recommended.name";
		action = "Recommended the Car";
		seeAll = "Cars";
	} else if(table.equals("Motorcycles")) {
		name = "Recommended.name";
		action = "Recommended the Motorcycle";
		seeAll = "Motorcycles";
	} else {
		table = "";
		name = "";
		action = "";
		seeAll = "";
	}

	if(!table.equals("Recommender")) {
		table = "Recommended";
	}

	/*
	 * Select
	 */

	List recommendations = new ArrayList();
	RecommendationsDAO recommendationsDAO = new RecommendationsDAO(db);

	try {
		recommendations = recommendationsDAO.getList(table, name, action, recommenderIdShowed, limitFrom, limitTo);

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	Iterator itr = recommendations.iterator();

	String imagemNome = "";
	String imagemOutro = "";

	if(recommendations.isEmpty()) {
		out.println("<tr><td class=\"LightGrayBorder\">Nothing yet!</td></tr>");
	} else {

		while(itr.hasNext()) {
			Recommendations r = (Recommendations) itr.next();

			imagemNome = table+""+r.getId()+".jpg";
			imagemOutro = "NoImageAvailable.png";

			if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

				imagemOutro = imagemNome;

			}

			String recs = "rec";
			if(r.getRecommendations() > 1l || r.getRecommendations() == 0l) { recs = "recs"; }

if(session.getAttribute("GetDevice").toString().contains("Mobi")) {

			out.println("<tr><th rowspan=\"3\"><a href=\""+table+".jsp?id="+r.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" width=\"300\" height=\"300\" alt=\""+r.getRecommended()+"\"  /></a></th><td style=\"width: 100%;\" class=\"LightGrayBorder\"><a href=\""+table+".jsp?id="+r.getId()+"\"><span class=\"Nickname\">"+r.getRecommended()+"</span></a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+r.getRecommendations()+" "+recs+"</span></td></tr><tr><td class=\"LightGrayBorder\">");
 pageContext.include("MakeButtonRecommend.jsp?id="+r.getId()+"&table="+table+"&width=100"); 
if(action.contains("Book") || action.contains("Album") || action.contains("Movie")) {
 pageContext.include("MakeButtonTODO.jsp?id="+r.getId()+"&width=100");
}
out.println("</td></tr>");

} else {

if(recommenderIdShowed.equals(r.getId()) && table.equals("Recommender")) {

			out.println("<tr><td><a href=\""+table+".jsp?id="+r.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" width=\"100\" height=\"100\" alt=\""+r.getRecommended()+"\"  /></a></td><td style=\"width: 100%;\" class=\"LightGrayBorder\"><a href=\""+table+".jsp?id="+r.getId()+"\"><span class=\"Nickname\">"+r.getRecommended()+"</span></a></td><td class=\"LightGrayBorder\"><span class=\"green\">"+r.getRecommendations()+" "+recs+"</span></td><td class=\"LightGrayBorder\">");
 pageContext.include("MakeButtonRecommend.jsp?id="+r.getId()+"&table="+table+"&width=100"); 
out.println("</td></tr>");

} else {

			out.println("<tr><td><a href=\""+table+".jsp?id="+r.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" width=\"100\" height=\"100\" alt=\""+r.getRecommended()+"\"  /></a></td><td style=\"width: 100%;\" class=\"LightGrayBorder\"><a href=\""+table+".jsp?id="+r.getId()+"\"><span class=\"Nickname\">"+r.getRecommended()+"</span></a></td><td class=\"LightGrayBorder\"><span class=\"green\">"+r.getRecommendations()+" "+recs+"</span></td><td class=\"LightGrayBorder\">");
 pageContext.include("MakeButtonRecommend.jsp?id="+r.getId()+"&table="+table+"&width=static"); 
if(action.contains("Book") || action.contains("Album") || action.contains("Movie")) {
 pageContext.include("MakeButtonTODO.jsp?id="+r.getId()+"&width=static");
}
out.println("</td></tr>");

}

}

		}

if(session.getAttribute("GetDevice").toString().contains("Mobi")) {

	out.println("<tr><td class=\"LightGrayBorder\" colspan=\"2\"><a href=\"AllRecommendations.jsp?id="+recommenderIdShowed+"&type="+seeAll+"&page=1\">See All "+(seeAll.equals("Recommender") ? "Recommenders" : seeAll)+"</a></td>");

} else {

	out.println("<tr><td class=\"LightGrayBorder\" colspan=\"4\"><a href=\"AllRecommendations.jsp?id="+recommenderIdShowed+"&type="+seeAll+"&page=1\">See All "+(seeAll.equals("Recommender") ? "Recommenders" : seeAll)+"</a></td>");

}

	}

%>