
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.MostRecommended" %>

<%

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	String forRecommended = "false";

	if(request.getParameter("forRecommended") != null) {
		forRecommended = (String) request.getParameter("forRecommended");
	}

	Long id = Long.valueOf((String) session.getAttribute("idWhoRecommendedTheEntityFromSubscribersOf"));
	Long recommender = Long.valueOf((String) session.getAttribute("recommenderWhoRecommendedTheEntityFromSubscribersOf"));
	Integer action = Integer.valueOf((String) session.getAttribute("idWhoRecommendedTheEntityFromSubscribersOfAction"));
	Boolean ok = true;
	Integer pageS = Integer.valueOf((String) request.getParameter("page"));
	Integer limitFrom = 0;
	Integer limitTo = 50;

	if(pageS > 1) {
		limitFrom = ((pageS*limitTo)-limitTo);
	}

	List recommendations = new ArrayList();

	if(ok) {

	/*
	 * Select
	 */

	try {
			PreparedStatement ps = db.conexao.prepareStatement("SELECT AddRec.recommender as recommender, (SELECT nickName from Recommender WHERE id=AddRec.recommender) as nickName FROM AddRec WHERE addRec = ? AND action = ? AND AddRec.recommender IN (SELECT subscriber FROM Subscription WHERE Subscription.recommender = ?) LIMIT ?,?");
			ps.setLong(1, id);
			ps.setInt(2, action);
			ps.setLong(3, recommender);
			ps.setInt(4, limitFrom);
			ps.setInt(5, limitTo);
			ResultSet result = ps.executeQuery();

			while(result.next()) {
				MostRecommended mostRecommended = new MostRecommended();

				mostRecommended.setIdRecommender(result.getLong("recommender"));
				mostRecommended.setRecommender(result.getString("nickName"));

				recommendations.add(mostRecommended);
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

	Iterator itr = recommendations.iterator();

	if(forRecommended.equals("true")) {

	Integer numeroDeRecomendadoresASeremExibidos = 10;
	Integer i = 0;

	if(recommendations.isEmpty()) {
		out.println("<dd class=\"user\"><span class=\"green\">Nothing yet!</span></dd>");
	} else {

		while(i<numeroDeRecomendadoresASeremExibidos && itr.hasNext()) {
				MostRecommended r = (MostRecommended) itr.next();

				out.println("<dd class=\"InLine user\"><span class=\"Nickname\"><a href=\"Recommender.jsp?id="+r.getIdRecommender()+"\">"+r.getRecommender()+"</a></span>");
				pageContext.include("MakeButtonSubscribe.jsp?recommender="+r.getIdRecommender()+"&width=static");
				out.println("</dd>");

				++i;
		}

		if(recommendations.size() > numeroDeRecomendadoresASeremExibidos) { out.println("<dd class=\"user\"><a href=\"WhoRecommendedTheEntityFromSubscribersOf.jsp?id="+id+"&recommender="+recommender+"\">More Recommenders...</a></dd>"); }

	}

	} else {

	if(recommendations.isEmpty()) {
		if(pageS == 1) {
			out.println("<tr><td class=\"LightGrayBorder\">Nothing yet!</td></tr>");
		} else {
			out.println("<tr><td class=\"LightGrayBorder\"><span class=\"LoadMore\">That's All...</span></td></tr>");
		}
	} else {

		while(itr.hasNext()) {
				MostRecommended r = (MostRecommended) itr.next();

				out.println("<tr><td class=\"InLine LightGrayBorder\"><span class=\"Nickname\"><a href=\"Recommender.jsp?id="+r.getIdRecommender()+"\">"+r.getRecommender()+"</a></span>");
				pageContext.include("MakeButtonSubscribe.jsp?recommender="+r.getIdRecommender()+"&width=static");
				out.println("</td></tr>");

		}

		out.println("<tr class=\"LoadMore\" id=\""+(++pageS)+"\" onclick=\"\"><td class=\"LightGrayBorder\"><span class=\"LoadMore\">Click To Load More Recommenders</span></td></tr>");

	}

	}

%>
