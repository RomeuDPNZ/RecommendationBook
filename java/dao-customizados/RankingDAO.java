
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RankingDAO {

	public DB db;

	public RankingDAO(DB db) {
		this.db = db;
	}

	public Long getRecommendedGeneralRanking(Long id) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT (SELECT COUNT(1) FROM Recommended b WHERE b.recommendations > a. recommendations) + 1 as rank FROM Recommended AS a WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		Long ranking = 0l;

		while(result.next()) {
			ranking = result.getLong("rank");
		}

		return ranking;
	}

	public Long getRecommendedRankingByType(Long id, Integer type) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT (SELECT COUNT(1) FROM Recommended b WHERE b.recommendations > a. recommendations AND b.type = ?) + 1 as rank FROM Recommended AS a WHERE type = ? AND id = ?");
		ps.setInt(1, type);
		ps.setInt(2, type);
		ps.setLong(3, id);
		ResultSet result = ps.executeQuery();

		Long ranking = 0l;

		while(result.next()) {
			ranking = result.getLong("rank");
		}

		return ranking;
	}

	public Long getRecommenderGeneralRanking(Long id) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT (SELECT COUNT(1) FROM Recommender b WHERE b.recommendations > a. recommendations) + 1 as rank FROM Recommender AS a WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		Long ranking = 0l;

		while(result.next()) {
			ranking = result.getLong("rank");
		}

		return ranking;
	}

}
