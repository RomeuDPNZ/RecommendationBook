
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Errors" %>
<%@ page import="recBook.ErrorsDAO" %>

<%!

public class SaveError {

	Long id;

	public SaveError(String message, String stackTrace) {

		Errors errors = new Errors();

		errors.setMessage(message);
		errors.setStacktrace(stackTrace);

		/*
		 * Conecta ao Banco de Dados
		 */

		DB db = new DB();
		db.ConectaDB();

		if(db.conexao == null) {
			System.err.println("DB Connection Error: "+db.conexao);
		}

		ErrorsDAO errorsDAO = new ErrorsDAO(db);

		/*
		* INSERT
		*/

		try {

			this.setId(errorsDAO.insert(errors));

		} catch(SQLException e) {
			System.err.println("SQLException: "+e.getMessage());
		} catch(Exception e) {
			System.err.println("Exception: "+e.getMessage());
		} finally {
			db.DesconectaDB();
		}

	}

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

}

%>