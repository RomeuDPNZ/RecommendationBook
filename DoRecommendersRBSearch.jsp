
<%@ page errorPage="Error.jsp" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("DoRecommendersRBSearch");

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

}

%>

<%

	/* DoRecommendersRBSearch.jsp?search=Romeu&RecommenderIdShowed=1 */

	String search = request.getParameter("search");
	Long recommenderIdShowed = Long.valueOf((String) request.getParameter("RecommenderIdShowed"));

	List listSearch = new ArrayList();

	Integer limit = 1000;

	if(!search.equals("")) {

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

	String searchRegex = search.replace(" ", "|");

	try {
		PreparedStatement ps = db.conexao.prepareStatement("CALL getSearchRecommendersRecommendationBook(?,?,?,?)");
		ps.setString(1, search);
		ps.setString(2, searchRegex);
		ps.setInt(3, limit);
		ps.setLong(4, recommenderIdShowed);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			Search s = new Search();

			s.setOrdem(result.getLong("ordem"));
			s.setType(result.getString("RAction"));
			s.setRecommendedId(result.getLong("id"));
			s.setRecommendedName(result.getString("name"));
			s.setRecommendations(result.getLong("recommendations"));

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
	} finally {

		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}
	}

	}

	List alreadyPlaced = new ArrayList();

	Iterator itr = listSearch.iterator();

	if(search.equals("")) {

		out.println("<span>Enter a Term to Make a Search!</span>");

	} else {

	if(listSearch.isEmpty()) {
		out.println("<span>Nothing Found on this Recommendation Book With Term: "+search+"!</span>");
	} else {

	while(itr.hasNext()) {
		Search s = (Search) itr.next();

		if(!alreadyPlaced.contains(s.getType()+"-"+s.getRecommendedId())) {

		if(s.getType().equals("Recommended the Recommender")) {
		out.print("<div class=\"DivSearchResult\">"+s.getType()+": <a href=\"Recommender.jsp?id="+s.getRecommendedId()+"\">"+s.getRecommendedName()+"</a><span class=\"green\"> - Recommendations: "+s.getRecommendations()+"</span></div>");
		} else {
		out.print("<div class=\"DivSearchResult\">"+s.getType()+": <a href=\"Recommended.jsp?id="+s.getRecommendedId()+"\">"+s.getRecommendedName()+"</a><span class=\"green\"> - Recommendations: "+s.getRecommendations()+"</span></div>");
		}

		}

		alreadyPlaced.add(s.getType()+"-"+s.getRecommendedId());

	}

	}

	}

%>

