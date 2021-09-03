
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<%@ include file="Validation.jsp" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.DoesRecommenderExists" %>

<%

		/*
		 * Conecta ao Banco de Dados
		 */

		DB db = new DB();
		db.ConectaDB();

		if(db.conexao == null) {
			System.err.println("DB Connection Error: "+db.conexao);
		}

		/*
		 * Construct Nickname From Name
		 */

		String nickname = "Cod_junior";

		String standardNickname = "Recommender";

		nickname = nickname.replaceAll("[^\\w_]", "");

		if(nickname.length() > 50) {
			nickname = nickname.substring(0, 50);
		}

		Long wasFound = 0l;

		Long lastId = 0l;
		Long lastIdOutro = 0l;

		/*
		 * Select
		 */

		try {
			PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) as lastId FROM Recommender");
			ResultSet result = ps.executeQuery();

			while(result.next()) {
				lastId = result.getLong("lastId");
				lastIdOutro = lastId;
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

		if(!nickname.equals("")) {
			wasFound = new DoesRecommenderExists().check(nickname);
		} else {
			nickname = standardNickname;

			++lastId;

			do {
				nickname = nickname+""+lastId;
				wasFound = new DoesRecommenderExists().check(nickname);
				++lastId;
			} while(wasFound >= 1);
		}

		String nicknameOutro = nickname;
		//String nicknameOutro = nickname+"ttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttoooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo";

		if(wasFound >= 1) {

			++lastId;

			while(wasFound >= 1) {
				nickname = nicknameOutro+""+lastId;
				if(nickname.length() > 50) {
					Integer len = (""+lastId+"").length();
					nickname = nicknameOutro.substring(0, 50-len)+""+lastId;
				}
				wasFound = new DoesRecommenderExists().check(nickname);
				++lastId;
			}

		}

		Validation v = new Validation();

		//nickname = nickname+"#@#$%";

		if(v.isNicknameValid(nickname) == false) {

			nickname = standardNickname;

			lastId = lastIdOutro;

			++lastId;

			do {
				nickname = nickname+""+lastId;
				wasFound = new DoesRecommenderExists().check(nickname);
				++lastId;
			} while(wasFound >= 1);
		}

		out.print("Nickname = "+nickname);

%>