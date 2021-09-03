
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RecommenderDAOOutro {

	public DB db;

	public RecommenderDAOOutro(DB db) {
		this.db = db;
	}

	public Recommender selectForSeeAll(Long id) throws Exception {
		Recommender recommender = new Recommender();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT id, nickName FROM Recommender WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			recommender.setId(result.getLong("id"));
			recommender.setNickName(result.getString("nickName"));
		}

		return recommender;
	}

}