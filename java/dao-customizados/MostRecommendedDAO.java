
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MostRecommendedDAO {

	public DB db;

	public MostRecommendedDAO(DB db) {
		this.db = db;
	}

	public List getMostRecommended(String type, Integer limit) throws Exception {
		List list = new ArrayList();

		if(type.equals("Recommender")) {

			PreparedStatement ps = db.conexao.prepareStatement("SELECT id, nickName as name, recommendations FROM Recommender ORDER BY recommendations DESC LIMIT ?");
			ps.setInt(1, limit);
			ResultSet result = ps.executeQuery();

			while(result.next()) {
				MostRecommended mostRecommended = new MostRecommended();

				mostRecommended.setId(result.getLong("id"));
				mostRecommended.setName(result.getString("name"));
				mostRecommended.setRecommendations(result.getLong("recommendations"));

				list.add(mostRecommended);
			}

		} else {

			PreparedStatement ps = db.conexao.prepareStatement("SELECT id, name, recommendations, recommender, (SELECT nickName from Recommender WHERE id=Recommended.recommender) as nickName FROM Recommended WHERE type=(SELECT id FROM RecommendedType WHERE type=?) ORDER BY recommendations DESC LIMIT ?");
			ps.setString(1, type);
			ps.setInt(2, limit);
			ResultSet result = ps.executeQuery();

			while(result.next()) {
				MostRecommended mostRecommended = new MostRecommended();

				mostRecommended.setId(result.getLong("id"));
				mostRecommended.setName(result.getString("name"));
				mostRecommended.setRecommendations(result.getLong("recommendations"));
				mostRecommended.setIdRecommender(result.getLong("recommender"));
				mostRecommended.setRecommender(result.getString("nickName"));

				list.add(mostRecommended);
			}

		}

		return list;
	}

}