
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DoesRecommenderExists {

	public DoesRecommenderExists() {

	}

	public Long check(String search) throws Exception {
		DB db = new DB();
		db.ConectaDB();

		Long wasFound = 0l;

		try {
			PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) AS wasFound FROM Recommender WHERE LOWER(nickname) = LOWER(?)");
			ps.setString(1, search);
			ResultSet result = ps.executeQuery();

			while(result.next()) {

				wasFound = result.getLong("wasFound");

			}

		} catch(SQLException e) {
			System.err.println("SQLException: "+e.getMessage());
		} finally {
			db.DesconectaDB();
		}

		return wasFound;
	}

}