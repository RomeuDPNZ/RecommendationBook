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

	request.getSession().setAttribute("DB", db);

%>


			<fieldset>
				<legend>Books To Read</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderTODO.jsp?table=Read&state=ToRead" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Books Already Read</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderTODO.jsp?table=Read&state=Read" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Movies To Watch</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderTODO.jsp?table=Watch&state=ToWatch" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Movies Already Watched</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderTODO.jsp?table=Watch&state=Watched" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Albums To Listen</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderTODO.jsp?table=Listen&state=ToListen" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Albums Already Listened</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderTODO.jsp?table=Listen&state=Listened" flush="true" />
				</tbody>
				</table>
			</fieldset>


<%

	/*
	 * Desconecta do Banco de Dados
	 */

	if(db.conexao != null) {
		db.DesconectaDB();
	}

%>
