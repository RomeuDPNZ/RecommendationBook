
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>

<%

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	Long id = Long.valueOf((String) request.getParameter("id"));
	Integer action = Integer.valueOf((String) request.getParameter("action"));
	String sex = ((String) request.getParameter("sex"));
	Integer country = Integer.valueOf((String) request.getParameter("country"));
	Integer from = Integer.valueOf((String) request.getParameter("from"));
	Integer to = Integer.valueOf((String) request.getParameter("to"));

	/*
	 * Select
	 */

	String recs = "";

	try {
			PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) AS recs FROM AddRec WHERE AddRec.addRec = ? AND action = ? AND AddRec.recommender IN (SELECT id FROM Recommender WHERE country=?) AND AddRec.recommender IN (SELECT id FROM Recommender WHERE birthDate BETWEEN CURDATE() - INTERVAL ? YEAR AND CURDATE() - INTERVAL ? YEAR) AND AddRec.recommender IN (SELECT id FROM Recommender WHERE sex = ?)");
			ps.setLong(1, id);
			ps.setInt(2, action);
			ps.setInt(3, country);
			ps.setInt(4, to);
			ps.setInt(5, from);
			ps.setString(6, sex);
			ResultSet result = ps.executeQuery();

			while(result.next()) {

				recs = result.getString("recs");

			}

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
	} finally {

		if(db.conexao != null) {
			db.DesconectaDB();
		}

	}

	String output = "";

	if(recs.equals("1")) { output = recs+" Recommendation With This Criteria"; } else { output = recs+" Recommendations With This Criteria"; }

	out.println(output);

%>
