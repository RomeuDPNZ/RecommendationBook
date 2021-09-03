
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RecommendedDAOOutro {

	public DB db;

	public RecommendedDAOOutro(DB db) {
		this.db = db;
	}

	public Recommended selectWithoutImage(Long id) throws Exception {
		Recommended recommended = new Recommended();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT id,recommender,recommendations,pageViews,name,type,country,officialWebsite,about,lastUpdatedOn,createdOn FROM Recommended WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			recommended.setId(result.getLong("id"));
			recommended.setRecommender(result.getLong("recommender"));
			recommended.setRecommendations(result.getLong("recommendations"));
			recommended.setPageViews(result.getLong("pageViews"));
			recommended.setName(result.getString("name"));
			recommended.setType(result.getInt("type"));
			recommended.setCountry(result.getInt("country"));
			recommended.setOfficialWebsite(result.getString("officialWebsite"));
			recommended.setAbout(result.getString("about"));
			recommended.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			recommended.setCreatedOnFromMySQL(result.getString("createdOn"));
		}

		return recommended;
	}

	public String selectImageExtension(Long id) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("SELECT extensionImage FROM Recommended WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		String extension = "";

		while(result.next()) {
			extension = result.getString("extensionImage");
		}

		return extension;
	}

}