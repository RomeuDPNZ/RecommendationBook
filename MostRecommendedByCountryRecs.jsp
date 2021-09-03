
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Iterator" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.MostRecommended" %>

<%@ page import="recBook.Recommended" %>
<%@ page import="recBook.RecommendedDAO" %>
<%@ page import="recBook.RecommendedType" %>
<%@ page import="recBook.RecommendedTypeDAO" %>

<%

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	Long country = Long.valueOf((String) session.getAttribute("countryForMost"));
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
			PreparedStatement ps = db.conexao.prepareStatement("SELECT id, name, recommendations, recommender, (SELECT nickName from Recommender WHERE id=Recommended.recommender) as nickName FROM Recommended WHERE country = ? ORDER BY recommendations DESC LIMIT ?,?");
			ps.setLong(1, country);
			ps.setInt(2, limitFrom);
			ps.setInt(3, limitTo);
			ResultSet result = ps.executeQuery();

			while(result.next()) {
				MostRecommended mostRecommended = new MostRecommended();

				mostRecommended.setId(result.getLong("id"));
				mostRecommended.setName(result.getString("name"));
				mostRecommended.setRecommendations(result.getLong("recommendations"));
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

	}

	}

	Iterator itr = recommendations.iterator();

	if(recommendations.isEmpty()) {
		if(session.getAttribute("GetDevice").toString().contains("Mobi")) {

		if(pageS == 1) {
			out.println("<tr><td class=\"LightGrayBorder\">Nothing yet!</td></tr>");
		} else {
			out.println("<tr><td class=\"LightGrayBorder\"><span class=\"LoadMore\">That's Everything that this Country Has...</span></td></tr>");
		}

		} else {

		if(pageS == 1) {
			out.println("<tr><td class=\"LightGrayBorder\">Nothing yet!</td></tr>");
		} else {
			out.println("<tr><td colspan=\"4\" class=\"LightGrayBorder\"><span class=\"LoadMore\">That's Everything that this Country Has...</span></td></tr>");
		}

		}
	} else {

		Long ranking = 1l;
		Long pastRecommendations = 0l;

		if(session.getAttribute("ranking") != null) {
			ranking = Long.valueOf((String) session.getAttribute("ranking"));
		}

		if(session.getAttribute("pastRecommendations") != null) {
			pastRecommendations = Long.valueOf((String) session.getAttribute("pastRecommendations"));
		}

		Boolean afterFirst = false;

		while(itr.hasNext()) {
				MostRecommended r = (MostRecommended) itr.next();

				if(pastRecommendations > r.getRecommendations()) {
					++ranking;
				}

	Recommended recommended = new Recommended();
	RecommendedDAO recommendedDAO = new RecommendedDAO(db);

	try {

		recommended = recommendedDAO.select(Long.valueOf(r.getId()));

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		if(db.conexao != null) {
			db.DesconectaDB();
		}

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	RecommendedType recommendedType = new RecommendedType();
	RecommendedTypeDAO recommendedTypeDAO = new RecommendedTypeDAO(db);
	
	try {

		recommendedType = recommendedTypeDAO.select(Long.valueOf(recommended.getType()));

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		if(db.conexao != null) {
			db.DesconectaDB();
		}

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	String type = recommendedType.getType();

			if(session.getAttribute("GetDevice").toString().contains("Mobi")) {

			if(afterFirst.equals(true)) { out.println("<tr><td colspan=\"2\" class=\"SpaceForFields\"></td></tr>"); }

			afterFirst = true;

				out.println("<tr><td class=\"LightGrayBorder\"><span class=\"green\">Ranking: "+ranking+"</span></td></tr><tr><td class=\"LightGrayBorder\">"+type+": <a href=\"Recommended.jsp?id="+r.getId()+"\">"+r.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\">"); pageContext.include("MakeButtonRecommend.jsp?id="+r.getId()+"&table=Recommended&width=100"); out.println("</td></tr>"); if(type.contains("Book") || type.contains("Album") || type.contains("Movie")) { out.println("<tr><td class=\"LightGrayBorder\">"); pageContext.include("MakeButtonTODO.jsp?id="+r.getId()+"&width=100"); out.println("</td></tr>"); } out.println("<tr><td class=\"LightGrayBorder\"><span class=\"green\">Recommendations: "+r.getRecommendations()+"</span><span class=\"Nickname\"></td></tr><tr><td class=\"LightGrayBorder\">Recommender: <a  href=\"Recommender.jsp?id="+r.getIdRecommender()+"\">"+r.getRecommender()+"</a></span></td></tr>");

			} else {

			out.println("<tr><td class=\"LightGrayBorder\"><span class=\"green\">Ranking: "+ranking+"</span></td><td class=\"LightGrayBorder\">"+type+": <a href=\"Recommended.jsp?id="+r.getId()+"\">"+r.getName()+"</a></td>");
			out.println("<td class=\"LightGrayBorder\">"); pageContext.include("MakeButtonRecommend.jsp?id="+r.getId()+"&table=Recommended&width=static");
			if(type.contains("Book") || type.contains("Album") || type.contains("Movie")) {
				pageContext.include("MakeButtonTODO.jsp?id="+r.getId()+"&width=static");
			}
			out.println("</td>");
			out.println("<td class=\"LightGrayBorder\"><span class=\"green\">Recommendations: "+r.getRecommendations()+"</span></td></tr>");

			}

				pastRecommendations = r.getRecommendations();

		}

		if(session.getAttribute("GetDevice").toString().contains("Mobi")) {

		out.println("<tr class=\"LoadMore\" id=\""+(++pageS)+"\" onclick=\"\"><td class=\"LightGrayBorder\"><span class=\"LoadMore\">Click To Load More Recommendations</span></td></tr>");

		} else {

		out.println("<tr class=\"LoadMore\" id=\""+(++pageS)+"\" onclick=\"\"><td colspan=\"4\" class=\"LightGrayBorder\"><span class=\"LoadMore\">Click To Load More Recommendations</span></td></tr>");

		}

	/*
	 * Desconecta do Banco de Dados
	 */

	if(db.conexao != null) {
		db.DesconectaDB();
	}

	session.setAttribute("ranking", ""+String.valueOf(ranking)+"");
	session.setAttribute("pastRecommendations", ""+String.valueOf(pastRecommendations)+"");
	}

%>
