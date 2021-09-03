
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.GetSubscriptionInformation" %>
<%@ page import="recBook.GetSubscriptionInformationDAO" %>
<%@ page import="recBook.IsImageRecorded" %>

<%

	DB db = (DB) request.getSession().getAttribute("DB");

	Long recommenderIdShowed = Long.valueOf((String) session.getAttribute("RecommenderIdShowed"));
	String recommenderAge = (String) session.getAttribute("RecommenderAge");
	Integer limit = 150;

	/*
	 * Select
	 */

	List subscription = new ArrayList();

	GetSubscriptionInformationDAO getSIDAO = new GetSubscriptionInformationDAO(db);

	try {

		subscription = getSIDAO.getList(recommenderIdShowed, limit, recommenderAge);

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	Iterator itr = subscription.iterator();

	if(subscription.isEmpty()) {
		out.println("<tr><td class=\"LightGrayBorder\">Nothing yet!</td></tr>");
	} else {


	String imagemNomeRecommender = "";
	String imagemOutroRecommender = "";
	String imagemNomeRecommended = "";
	String imagemOutroRecommended = "";
	String table = "";

	while(itr.hasNext()) {
		GetSubscriptionInformation s = (GetSubscriptionInformation) itr.next();

		imagemNomeRecommender = "Recommender"+s.getNickNameId()+".jpg";
		imagemOutroRecommender = "NoImageAvailable.png";

		if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNomeRecommender)) {

			imagemOutroRecommender = imagemNomeRecommender;

		}

		if(s.getAction().contains("Recommended the Recommender")) {
			table = "Recommender";
		} else {
			table = "Recommended";
		}

		imagemNomeRecommended = table+""+s.getThingId()+".jpg";
		imagemOutroRecommended = "NoImageAvailable.png";

		if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNomeRecommended)) {

			imagemOutroRecommended = imagemNomeRecommended;

		}

		out.println("<tr><td><img src=\"./img/user/"+imagemOutroRecommender+"\" width=\"100px\" height=\"100px\" /></td><td class=\"LightGrayBorder\"><a href=\"Recommender.jsp?id="+s.getNickNameId()+"\"><span class=\"Nickname\">"+s.getNickName()+"</span></a> "+s.getAction()+" <a href=\""+table+".jsp?id="+s.getThingId()+"\">"+s.getThing()+"</a></td><td><img src=\"./img/user/"+imagemOutroRecommended+"\" width=\"100px\" height=\"100px\" /></td><td class=\"LightGrayBorder\">"+s.getCreatedOnToMySQL()+"</td></tr>");

	}

	}

%>