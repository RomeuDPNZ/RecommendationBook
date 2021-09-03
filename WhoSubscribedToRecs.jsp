
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

	Long id = Long.valueOf((String) session.getAttribute("idWhoSubscribedTo"));
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
			PreparedStatement ps = db.conexao.prepareStatement("SELECT subscriber as recommender, (SELECT nickName from Recommender WHERE id=subscriber) as nickName FROM Subscription WHERE recommender = ? LIMIT ?,?");
			ps.setLong(1, id);
			ps.setInt(2, limitFrom);
			ps.setInt(3, limitTo);
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

%>
