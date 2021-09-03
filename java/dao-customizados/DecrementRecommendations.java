
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DecrementRecommendations {

	public DB db;

	public DecrementRecommendations(DB db) {
		this.db = db;
	}

	public Long decrementRecommendations(String table, Long id) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("UPDATE "+table+" SET recommendations=recommendations-1 WHERE id = ?");
		ps.setLong(1, id);
		ps.executeUpdate();

		Long recommendations = 0l;

		ps = db.conexao.prepareStatement("SELECT recommendations FROM "+table+" WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			recommendations = result.getLong(1);
		}

		return recommendations;

	}

}