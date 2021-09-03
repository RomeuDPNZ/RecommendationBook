
package recBook;

import java.sql.Connection;
import java.sql.Statement;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.ResultSet;

public class DB {

	public Connection conexao;
	public ResultSet resultado;

	public DB() {
		this.conexao = null;
		this.resultado = null;
	}

	public void ConectaDB() {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conexao = DriverManager.getConnection("jdbc:mysql://localhost/", "root", "*********");
		} catch(ClassNotFoundException e) {
			System.err.println("ClassNotFoundException: "+e.getMessage());
		} catch(SQLException e) {
			System.err.println("SQLException: "+e.getMessage());
			System.err.println("SQLState: "+e.getSQLState());
			System.err.println("VendorError: "+e.getErrorCode());
		} finally {}

		Atualiza("USE recommendationbook");
	}

	public void DesconectaDB() {
		try {
			if(conexao != null) { conexao.close(); }
		} catch(SQLException e) {} finally {}
	}

	public ResultSet Consulta(String consulta) {
		try {
			resultado = conexao.createStatement().executeQuery(consulta);
		} catch(SQLException e) {
			System.err.println("SQLException: "+e.getMessage());
			System.err.println("SQLState: "+e.getSQLState());
			System.err.println("VendorError: "+e.getErrorCode());
		} catch(Exception e) {
			DesconectaDB();
			System.gc();
			System.err.println("Exception: "+e.getMessage());
		} finally {}
		return resultado;
	}

	public void Atualiza(String atualiza) {
		try {
			Statement stmt = conexao.createStatement();
			stmt.executeUpdate(atualiza);	
		} catch(SQLException e) {
			System.err.println("SQLException: "+e.getMessage());
			System.err.println("SQLState: "+e.getSQLState());
			System.err.println("VendorError: "+e.getErrorCode());
		} catch(Exception e) {
			DesconectaDB();
			System.gc();
			System.err.println("Exception: "+e.getMessage());
		} finally {}
	}

}
