
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%@ page import="recBook.DB" %>

<%@ include file="Validation.jsp" %>

<%

	String table = request.getParameter("table");
	String rec = request.getParameter("rec");

	Validation v = new Validation();

%>

<% if(!v.isIdValid(rec)) { %>

	<jsp:forward page="/Error.jsp?id=6" />

<% } else if(!table.equals("Recommender") && !table.equals("Recommended")) { %>

	<jsp:forward page="/Error.jsp?id=6" />

<% } else { %>

<%

	Long lastInsert = 0l;

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	Long max = Long.MAX_VALUE;
	Long actual = 0l;

	/*
	 * INSERT
	 */

	try {

		/*
		PreparedStatement ps = db.conexao.prepareStatement("SELECT ~0 as max_bigint_unsigned");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			max = result.getLong("max_bigint_unsigned");
		}
		*/

		PreparedStatement ps = db.conexao.prepareStatement("SELECT recNonLogged FROM "+table+" WHERE id = ?");
		ps.setLong(1, Long.valueOf(rec));
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			actual = result.getLong("recNonLogged");
		}

		if(actual < max) {
			ps = db.conexao.prepareStatement("UPDATE "+table+" SET recNonLogged = recNonLogged + 1 WHERE id = ?");
			ps.setLong(1, Long.valueOf(rec));
			ps.executeUpdate();
		}

	} catch(SQLException e) {
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

%>

<!DOCTYPE html>

<html lang="en-US">

<head>
 
<title>Recommendation Book</title>
 
<meta name="keywords" content="" />
<meta name="description" content="" />

</head>

<body>

<div id="ButtonRecommended">
	<button id="Recommended" class="ButtonRecommended">Recommended</button>
</div>

</body>
 
</html>

<% } %>

