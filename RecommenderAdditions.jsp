
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Added" %>
<%@ page import="recBook.AddedDAO" %>
<%@ page import="recBook.IsImageRecorded" %>

<jsp:include page="GetDevice.jsp" flush="true" />

<%

	DB db = (DB) request.getSession().getAttribute("DB");

	Long recommenderIdShowed = Long.valueOf((String) session.getAttribute("RecommenderIdShowed"));
	String table = request.getParameter("table");
	String name = "Recommended.name";
	String action = "";
	String seeAll = "";
	Integer limitFrom = 0;
	Integer limitTo = 10;

	if(table.equals("Persons")) {
		action = "Added the Person";
		seeAll = "Persons";
	} else if(table.equals("Groups")) {
		action = "Added the Group";
		seeAll = "Groups";
	} else if(table.equals("Books")) {
		action = "Added the Book";
		seeAll = "Books";
	} else if(table.equals("Movies")) {
		action = "Added the Movie";
		seeAll = "Movies";
	} else if(table.equals("Bands")) {
		action = "Added the Band";
		seeAll = "Bands";
	} else if(table.equals("Albums")) {
		action = "Added the Album";
		seeAll = "Albums";
	} else if(table.equals("Songs")) {
		action = "Added the Song";
		seeAll = "Songs";
	} else if(table.equals("Projects")) {
		action = "Added the Project";
		seeAll = "Projects";
	} else if(table.equals("Websites")) {
		action = "Added the Website";
		seeAll = "Websites";
	} else if(table.equals("Companies")) {
		action = "Added the Company";
		seeAll = "Companies";
	} else if(table.equals("Products")) {
		action = "Added the Product";
		seeAll = "Products";
	} else if(table.equals("Places")) {
		action = "Added the Place";
		seeAll = "Places";
	} else if(table.equals("Foods")) {
		action = "Added the Food";
		seeAll = "Foods";
	} else if(table.equals("Games")) {
		action = "Added the Game";
		seeAll = "Games";
	} else if(table.equals("Guns")) {
		action = "Added the Gun";
		seeAll = "Guns";
	} else if(table.equals("Knives")) {
		action = "Added the Knife";
		seeAll = "Knives";
	} else if(table.equals("Cars")) {
		action = "Added the Car";
		seeAll = "Cars";
	} else if(table.equals("Motorcycles")) {
		action = "Added the Motorcycle";
		seeAll = "Motorcycles";
	} else {
		table = "";
		name = "";
		action = "";
	}

	table = "Recommended";

	/*
	 * Select
	 */

	List added = new ArrayList();
	AddedDAO addedDAO = new AddedDAO(db);

	try {
		added = addedDAO.getList(table, name, action, recommenderIdShowed, limitFrom, limitTo);

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	Iterator itr = added.iterator();

	String imagemNome = "";
	String imagemOutro = "";

	if(added.isEmpty()) {
		out.println("<tr><td class=\"LightGrayBorder\">Nothing yet!</td></tr>");
	} else {
		while(itr.hasNext()) {
			Added a = (Added) itr.next();

			imagemNome = table+""+a.getId()+".jpg";
			imagemOutro = "NoImageAvailable.png";

			if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

				imagemOutro = imagemNome;

			}

			String recs = "rec";
			if(a.getRecommendations() > 1l || a.getRecommendations() == 0l) { recs = "recs"; }

if(session.getAttribute("GetDevice").toString().contains("Mobi")) {

			out.println("<tr><th rowspan=\"3\"><a href=\""+table+".jsp?id="+a.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" width=\"300\" height=\"300\" alt=\""+a.getName()+"\" /></a></th><td style=\"width: 100%;\" class=\"LightGrayBorder\"><a href=\""+table+".jsp?id="+a.getId()+"\"><span class=\"Nickname\">"+a.getName()+"</span></a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+a.getRecommendations()+" "+recs+"</span></td></tr><tr><td class=\"LightGrayBorder\">");
 pageContext.include("MakeButtonRecommend.jsp?id="+a.getId()+"&table="+table+"&width=100"); 
if(action.contains("Book") || action.contains("Album") || action.contains("Movie")) {
 pageContext.include("MakeButtonTODO.jsp?id="+a.getId()+"&width=100");
}
out.println("</td></tr>");

} else {

			out.println("<tr><td><a href=\""+table+".jsp?id="+a.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" width=\"100\" height=\"100\" alt=\""+a.getName()+"\" /></a></td><td style=\"width: 100%;\" class=\"LightGrayBorder\"><a href=\""+table+".jsp?id="+a.getId()+"\"><span class=\"Nickname\">"+a.getName()+"</span></a></td><td class=\"LightGrayBorder\"><span class=\"green\">"+a.getRecommendations()+" "+recs+"</span></td><td class=\"LightGrayBorder\">");
 pageContext.include("MakeButtonRecommend.jsp?id="+a.getId()+"&table="+table+"&width=static"); 
if(action.contains("Book") || action.contains("Album") || action.contains("Movie")) {
 pageContext.include("MakeButtonTODO.jsp?id="+a.getId()+"&width=static");
}
out.println("</td></tr>");

}

		}

if(session.getAttribute("GetDevice").toString().contains("Mobi")) {

	out.println("<tr><td class=\"LightGrayBorder\" colspan=\"2\"><a href=\"AllAdditions.jsp?id="+recommenderIdShowed+"&type="+seeAll+"&page=1\">See All "+seeAll+"</a></td>");

} else {

	out.println("<tr><td class=\"LightGrayBorder\" colspan=\"4\"><a href=\"AllAdditions.jsp?id="+recommenderIdShowed+"&type="+seeAll+"&page=1\">See All "+seeAll+"</a></td>");

}

	}


%>