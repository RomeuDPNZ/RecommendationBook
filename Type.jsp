<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%@ page import="recBook.DB" %>
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

	List list = new ArrayList();
	RecommendedTypeDAO recommendedTypeDAO = new RecommendedTypeDAO(db);	

	try {

		list = recommendedTypeDAO.getList(1, 250);

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());
	} finally {

		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}
	}

	Iterator itr = list.iterator();

	if("".equals(session.getAttribute("typeS"))) {
		out.print("<option value=\"\"></option>");
	} else {
		out.print("<option value=\"\" selected=\"selected\"></option>");
	}

	while(itr.hasNext()) {
		RecommendedType recommendedType = (RecommendedType) itr.next();
		if(recommendedType.getId().toString().equals(session.getAttribute("typeS"))) {
			out.print("<option value=\""+recommendedType.getId()+"\" selected=\"selected\">"+recommendedType.getType()+"</option>");
		} else {
			out.print("<option value=\""+recommendedType.getId()+"\">"+recommendedType.getType()+"</option>");
		}
	}
%>