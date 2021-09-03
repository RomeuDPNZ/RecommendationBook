
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.TODO" %>
<%@ page import="recBook.TODODAO" %>
<%@ page import="recBook.IsImageRecorded" %>

<jsp:include page="GetDevice.jsp" flush="true" />

<%

	DB db = (DB) request.getSession().getAttribute("DB");

	Long recommenderIdShowed = Long.valueOf((String) session.getAttribute("RecommenderIdShowed"));
	String table = request.getParameter("table");
	String state = request.getParameter("state");
	Integer limitFrom = 0;
	Integer limitTo = 50;

	if(table.equals("Watch")) {

	} else if(table.equals("Listen")) {

	} else if(table.equals("Read")) {

	} else {
		table = "";
		state = "";
	}

	/*
	 * Select
	 */

	List todo = new ArrayList();
	TODODAO todoDAO = new TODODAO(db);

	try {

		if(table.equals("Watch")) {

			todo =todoDAO.getWatch(recommenderIdShowed, state, limitFrom, limitTo);

		} else if(table.equals("Read")) {

			todo = todoDAO.getRead(recommenderIdShowed, state, limitFrom, limitTo);

		} else if(table.equals("Listen")) {

			todo = todoDAO.getListen(recommenderIdShowed, state, limitFrom, limitTo);

		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	Iterator itr = todo.iterator();

	String imagemNome = "";
	String imagemOutro = "";

	if(todo.isEmpty()) {
		out.println("<tr><td class=\"LightGrayBorder\">Nothing yet!</td></tr>");
	} else {
		while(itr.hasNext()) {

			TODO t = (TODO) itr.next();

			imagemNome = "Recommended"+t.getId()+".jpg";
			imagemOutro = "NoImageAvailable.png";

			if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

				imagemOutro = imagemNome;

			}

			String recs = "rec";
			if(t.getRecommendations() > 1l || t.getRecommendations() == 0l) { recs = "recs"; }

if(session.getAttribute("GetDevice").toString().contains("Mobi")) {

			out.println("<tr><th rowspan=\"3\"><a href=\"Recommended.jsp?id="+t.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" width=\"300\" height=\"300\" alt=\""+t.getRecommended()+"\"/></a></th><td style=\"width: 100%;\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+t.getId()+"\"><span class=\"Nickname\">"+t.getRecommended()+"</span></a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+t.getRecommendations()+" "+recs+"</span></td></tr><tr><td class=\"LightGrayBorder\">");
 pageContext.include("MakeButtonRecommend.jsp?id="+t.getId()+"&table=Recommended&width=100"); 
 pageContext.include("MakeButtonTODO.jsp?id="+t.getId()+"&width=100");
out.println("</td></tr>");

} else {

			out.println("<tr><td><a href=\"Recommended.jsp?id="+t.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" width=\"100\" height=\"100\" alt=\""+t.getRecommended()+"\"/></a></td><td style=\"width: 100%;\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+t.getId()+"\"><span class=\"Nickname\">"+t.getRecommended()+"</span></a></td><td class=\"LightGrayBorder\"><span class=\"green\">"+t.getRecommendations()+" "+recs+"</span></td><td class=\"LightGrayBorder\">");
 pageContext.include("MakeButtonRecommend.jsp?id="+t.getId()+"&table=Recommended&width=static"); 
 pageContext.include("MakeButtonTODO.jsp?id="+t.getId()+"&width=static");
out.println("</td></tr>");

}

		}

if(session.getAttribute("GetDevice").toString().contains("Mobi")) {

	out.println("<tr><td class=\"LightGrayBorder\" colspan=\"2\"><a href=\"AllTODO.jsp?id="+recommenderIdShowed+"&state="+state+"&page=1\">See All</a></td>");

} else {

	out.println("<tr><td class=\"LightGrayBorder\" colspan=\"4\"><a href=\"AllTODO.jsp?id="+recommenderIdShowed+"&state="+state+"&page=1\">See All</a></td>");

}

	}

%>