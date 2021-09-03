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
				<legend>Persons</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderAdditions.jsp?table=Persons" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Groups</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderAdditions.jsp?table=Groups" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Books</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderAdditions.jsp?table=Books" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Movies</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderAdditions.jsp?table=Movies" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Bands</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderAdditions.jsp?table=Bands" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Albums</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderAdditions.jsp?table=Albums" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Songs</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderAdditions.jsp?table=Songs" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Projects</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderAdditions.jsp?table=Projects" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Websites</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderAdditions.jsp?table=Websites" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Companies</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderAdditions.jsp?table=Companies" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Products</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderAdditions.jsp?table=Products" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Places</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderAdditions.jsp?table=Places" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Foods</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderAdditions.jsp?table=Foods" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Games</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderAdditions.jsp?table=Games" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Guns</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderAdditions.jsp?table=Guns" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Knives</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderAdditions.jsp?table=Knives" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Cars</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderAdditions.jsp?table=Cars" flush="true" />
				</tbody>
				</table>
			</fieldset>

			<fieldset>
				<legend>Motorcycles</legend>
				<table>
				<tbody>
					<jsp:include page="RecommenderAdditions.jsp?table=Motorcycles" flush="true" />
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