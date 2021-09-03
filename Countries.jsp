
<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Countries" %>
<%@ page import="recBook.CountriesDAO" %>

<%

	String withWWE = request.getParameter("withWWE");

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	List list = new ArrayList();
	CountriesDAO countriesDAO = new CountriesDAO(db);	

	try {

		list = countriesDAO.getList(1, 250);

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

	Iterator itr = list.iterator();

	if("".equals(session.getAttribute("countryS"))) {
		out.print("<option value=\"\"></option>");
	} else {
		out.print("<option value=\"\" selected=\"selected\"></option>");
	}

	while(itr.hasNext()) {
		Countries countries = (Countries) itr.next();
		if(countries.getCountry().equals("World Wide Entity") && withWWE.equals("Yes")) {
			if(countries.getId().toString().equals(session.getAttribute("countryS"))) {
				out.print("<option value=\""+countries.getId()+"\" selected=\"selected\">"+countries.getCountry()+"</option>");
			} else {
				out.print("<option value=\""+countries.getId()+"\">"+countries.getCountry()+"</option>");
			}
		}
	}

	itr = list.iterator();

	while(itr.hasNext()) {
		Countries countries = (Countries) itr.next();
		if(!countries.getCountry().equals("World Wide Entity")) {
			if(countries.getId().toString().equals(session.getAttribute("countryS"))) {
				out.print("<option value=\""+countries.getId()+"\" selected=\"selected\">"+countries.getCountry()+"</option>");
			} else {
				out.print("<option value=\""+countries.getId()+"\">"+countries.getCountry()+"</option>");
			}
		}
	}

%>