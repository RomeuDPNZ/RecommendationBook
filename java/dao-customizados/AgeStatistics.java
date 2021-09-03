
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AgeStatistics {

	public DB db;

	public AgeStatistics(DB db) {
		this.db = db;
	}

	public Long getAgeStatisticsGeneral(Integer from, Integer to) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) AS numberOfRecommenders FROM Recommender WHERE birthDate BETWEEN CURDATE() - INTERVAL ? YEAR AND CURDATE() - INTERVAL ? YEAR");
		ps.setInt(1, to);
		ps.setInt(2, from);
		ResultSet result = ps.executeQuery();

		Long ageStats = 0l;

		while(result.next()) {
			ageStats = result.getLong("numberOfRecommenders");
		}

		return ageStats;
	}

	public Long getAgeStatistics(Long id, Integer from, Integer to, Integer action) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) AS recs FROM AddRec WHERE AddRec.addRec = ? AND recommender IN (SELECT id FROM Recommender WHERE birthDate BETWEEN CURDATE() - INTERVAL ? YEAR AND CURDATE() - INTERVAL ? YEAR) AND action = ?");
		ps.setLong(1, id);
		ps.setInt(2, to);
		ps.setInt(3, from);
		ps.setInt(4, action);
		ResultSet result = ps.executeQuery();

		Long ageStats = 0l;

		while(result.next()) {
			ageStats = result.getLong("recs");
		}

		return ageStats;
	}

}