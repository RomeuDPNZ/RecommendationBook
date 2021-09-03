
<%@ include file="TestLocales.jsp" %>

<%@ page import="java.util.Locale" %>

<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%@ page import="recBook.DB" %>

<%

		// out.print(new TestLocales().getCountry("pt_BR"));

		Locale locale = Locale.forLanguageTag("de_DE".replace("_","-"));

		String country = locale.getDisplayCountry(Locale.US);

		Long countryId = 0l;

		/*
		 * Conecta ao Banco de Dados
		 */

		DB db = new DB();
		db.ConectaDB();

		if(db.conexao == null) {
			System.err.println("DB Connection Error: "+db.conexao);
		}

		/*
		 * Select
		 */

		try {
			PreparedStatement ps = db.conexao.prepareStatement("SELECT id FROM Countries WHERE country = ? OR country SOUNDS LIKE ?");
			ps.setString(1, country);
			ps.setString(2, country);
			ResultSet result = ps.executeQuery();

			while(result.next()) {
				countryId = result.getLong("id");
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

		if(countryId.equals(0l)) {
			countryId = 1l;
		}

		out.print(countryId);

%>