
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

	Long recommenderIdShowed = Long.valueOf((String) session.getAttribute("RecommenderIdShowed"));
	String recommenderAge = (String) session.getAttribute("RecommenderAge");
	Integer pageS = Integer.valueOf((String) request.getParameter("page"));
	Boolean afterFirst = Boolean.valueOf((String) request.getParameter("afterFirst"));
	Integer limitFrom = 0;
	Integer limitTo = 25;

	if(pageS > 1) {
		limitFrom = ((pageS*limitTo)-limitTo);
	}

	/*
	 * Select
	 */

	List subscription = new ArrayList();

	GetSubscriptionInformationDAO getSIDAO = new GetSubscriptionInformationDAO(db);

	try {

		subscription = getSIDAO.getList(recommenderIdShowed, limitFrom, limitTo, recommenderAge);

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

	Iterator itr = subscription.iterator();

	if(subscription.isEmpty()) {
		if(pageS == 1) {
			out.println("<tr><td class=\"LightGrayBorder\"><span class=\"Nickname\">Welcome to <img src=\"./img/static/LogoTransparencia.png\" width=\"300\" height=\"140\" /><br /><br />You are Officially a Recommender Now!<br /><br />You Can Recommend the Stuff you Love and your Nickname Will Appear in All of Your Recommendations with a link to this Page so your Friends Can Keep Track of All the Recommendations You Make.<br /><br />Check if your Nickname is Being Displayed on the Right Upper Corner of this Page. If it is, you are Logged. If it's not, click on the Login Link to Make your Authentication. You can Add Entities to Recommendation Book but your Nickname Won't be Displayed on that Page if you are not Logged. If you are Logged you receive full credit.<br /><br />If you Wanna See the Recommendations from Your Friends go to Their Recommendation Book Profile and Click the Subscribe Button at the Right Corner. If you Wanna See Your Own Recommendations Click the Subscribe Button on Your Own Recommendation Book.<br /><br />If you Wanna Recommend the Recommendation Book Profile from Your Friends go to Their Recommendation Book and Click the Recommend Button at the Right Corner. If you Wanna Recommend Your Own Recommendation Book Click the Recommend Button From Your Own Recommendation Book.<br /><br />If you Wanna Recommend the Stuff you Love Click the Recommend Stuff Button on the Recommender Container.<br /><br />This Welcome Message Will Appear to You as Long as you Dont Have a Recommended Entity on Your Subscription List.<br /><br />We Hope you Enjoy Recommendation Book!</span></td></tr>");
		} else {
			out.println("<tr><td colspan=\"4\" class=\"LightGrayBorder\"><span class=\"LoadMore\">That's Everything that this Recommender Recommended...</span></td></tr>");
		}
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

		if((s.getAction().contains("Recommended the Recommender")) || (s.getAction().contains("Subscribed to the Recommender"))) {
			table = "Recommender";
		} else {
			table = "Recommended";
		}

		imagemNomeRecommended = table+""+s.getThingId()+".jpg";
		imagemOutroRecommended = "NoImageAvailable.png";

		if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNomeRecommended)) {

			imagemOutroRecommended = imagemNomeRecommended;

		}
/*
		out.println("<tr><td><a href=\"Recommender.jsp?id="+s.getNickNameId()+"\"><img src=\"./img/user/"+imagemOutroRecommender+"\" width=\"100\" height=\"100\" alt=\""+s.getNickName()+"\" /></a></td><td class=\"LightGrayBorder\"><a href=\"Recommender.jsp?id="+s.getNickNameId()+"\"><span class=\"Nickname\">"+s.getNickName()+"</span></a> "+s.getAction()+" <a href=\""+table+".jsp?id="+s.getThingId()+"\">"+s.getThing()+"</a></td><td><a href=\""+table+".jsp?id="+s.getThingId()+"\"><img src=\"./img/user/"+imagemOutroRecommended+"\" width=\"100\" height=\"100\" alt=\""+s.getThing()+"\"/></a></td><td class=\"LightGrayBorder\">"+s.getCreatedOnToMySQL()+"</td></tr>");
*/

if(session.getAttribute("GetDevice").toString().contains("Mobi")) {

if(afterFirst.equals(true)) { out.println("<tr><td colspan=\"2\" class=\"SpaceForFields\"></td></tr>"); }

afterFirst = true;

out.println("<tr><td class=\"LightGrayBorder\"><a href=\"Recommender.jsp?id="+s.getNickNameId()+"\"><img src=\"./img/user/"+imagemOutroRecommender+"\" width=\"300\" height=\"300\" alt=\""+s.getNickName()+"\" /></a></td><td class=\"LightGrayBorder\" style=\"width: 100%;\" clas=\"LightGrayBorder\"><a href=\"Recommender.jsp?id="+s.getNickNameId()+"\"><span class=\"Nickname\">"+s.getNickName()+"</span></a> "+s.getAction()+" <a href=\""+table+".jsp?id="+s.getThingId()+"\">"+s.getThing()+"</a> on "+s.getCreatedOnToMySQL()+"</td></tr><tr><td class=\"LightGrayBorder\"><a href=\""+table+".jsp?id="+s.getThingId()+"\"><img src=\"./img/user/"+imagemOutroRecommended+"\" width=\"300\" height=\"300\" alt=\""+s.getThing()+"\"/></a></td><td class=\"LightGrayBorder\">");
 pageContext.include("MakeButtonRecommend.jsp?id="+s.getThingId()+"&table="+table+"&width=100"); 
if(s.getAction().contains("Book") || s.getAction().contains("Album") || s.getAction().contains("Movie")) {
 pageContext.include("MakeButtonTODO.jsp?id="+s.getThingId()+"&width=100");
}
if(table.equals("Recommender")) {
 pageContext.include("MakeButtonSubscribe.jsp?recommender="+s.getThingId()+"&width=100");
}
out.println("</td></tr>");

} else {

if(recommenderIdShowed.equals(s.getThingId()) && table.equals("Recommender")) {

out.println("<tr><td><a href=\"Recommender.jsp?id="+s.getNickNameId()+"\"><img src=\"./img/user/"+imagemOutroRecommender+"\" width=\"100\" height=\"100\" alt=\""+s.getNickName()+"\" /></a></td><td class=\"LightGrayBorder\"><a href=\"Recommender.jsp?id="+s.getNickNameId()+"\"><span class=\"Nickname\">"+s.getNickName()+"</span></a> "+s.getAction()+" <a href=\""+table+".jsp?id="+s.getThingId()+"\">"+s.getThing()+"</a> on "+s.getCreatedOnToMySQL()+"</td><td><a href=\""+table+".jsp?id="+s.getThingId()+"\"><img src=\"./img/user/"+imagemOutroRecommended+"\" width=\"100\" height=\"100\" alt=\""+s.getThing()+"\"/></a></td><td class=\"LightGrayBorder\">");
 pageContext.include("MakeButtonRecommend.jsp?id="+s.getThingId()+"&table="+table+"&width=100"); 
if(table.equals("Recommender")) {
 pageContext.include("MakeButtonSubscribe.jsp?recommender="+s.getThingId()+"&width=100");
}
out.println("</td></tr>");

} else {

out.println("<tr><td><a href=\"Recommender.jsp?id="+s.getNickNameId()+"\"><img src=\"./img/user/"+imagemOutroRecommender+"\" width=\"100\" height=\"100\" alt=\""+s.getNickName()+"\" /></a></td><td class=\"LightGrayBorder\"><a href=\"Recommender.jsp?id="+s.getNickNameId()+"\"><span class=\"Nickname\">"+s.getNickName()+"</span></a> "+s.getAction()+" <a href=\""+table+".jsp?id="+s.getThingId()+"\">"+s.getThing()+"</a> on "+s.getCreatedOnToMySQL()+"</td><td><a href=\""+table+".jsp?id="+s.getThingId()+"\"><img src=\"./img/user/"+imagemOutroRecommended+"\" width=\"100\" height=\"100\" alt=\""+s.getThing()+"\"/></a></td><td class=\"LightGrayBorder\">");
 pageContext.include("MakeButtonRecommend.jsp?id="+s.getThingId()+"&table="+table+"&width=static"); 
if(s.getAction().contains("Book") || s.getAction().contains("Album") || s.getAction().contains("Movie")) {
 pageContext.include("MakeButtonTODO.jsp?id="+s.getThingId()+"&width=static");
}
if(table.equals("Recommender")) {
 pageContext.include("MakeButtonSubscribe.jsp?recommender="+s.getThingId()+"&width=static");
}
out.println("</td></tr>");

}

}

	}

if(session.getAttribute("GetDevice").toString().contains("Mobi")) {

		out.println("<tr class=\"LoadMore\" id=\""+(++pageS)+"\" onclick=\"\"><td colspan=\"2\" class=\"LightGrayBorder\"><span class=\"LoadMore\">Click To Load More Recommendations</span></td></tr>");

} else {
		out.println("<tr class=\"LoadMore\" id=\""+(++pageS)+"\" onclick=\"\"><td colspan=\"4\" class=\"LightGrayBorder\"><span class=\"LoadMore\">Click To Load More Recommendations</span></td></tr>");

}

	}

%>