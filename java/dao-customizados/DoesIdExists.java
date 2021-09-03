
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DoesIdExists {

	public DoesIdExists() {

	}

	public Boolean check(String table, Long id) {
		DB db = new DB();
		db.ConectaDB();

		Long wasFoundLong = 0l;

		try {
			PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) AS wasFound FROM "+table+" WHERE id = ?");
			ps.setLong(1, id);
			ResultSet result = ps.executeQuery();

			while(result.next()) {

				wasFoundLong = result.getLong("wasFound");

			}

		} catch(SQLException e) {
			System.err.println("SQLException: "+e.getMessage());
		} finally {
			db.DesconectaDB();
		}

		Boolean wasFound = false;

		if(wasFoundLong > 0l) {
			wasFound = true;
		}

		return wasFound;
	}

}