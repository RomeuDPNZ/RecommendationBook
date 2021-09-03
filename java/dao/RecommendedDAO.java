
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RecommendedDAO {

	public DB db;

	public RecommendedDAO(DB db) {
		this.db = db;
	}

	public Long insert(Recommended recommended) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("INSERT INTO Recommended (recommender,recommendations,pageViews,name,type,country,officialWebsite,about,descriptionImage) VALUES(?,?,?,?,?,?,?,?,?)");
		ps.setLong(1, recommended.getRecommender());
		ps.setLong(2, recommended.getRecommendations());
		ps.setLong(3, recommended.getPageViews());
		ps.setString(4, recommended.getName());
		ps.setInt(5, recommended.getType());
		ps.setInt(6, recommended.getCountry());
		ps.setString(7, recommended.getOfficialWebsite());
		ps.setString(8, recommended.getAbout());
		ps.setString(9, recommended.getDescriptionImage());
		ps.executeUpdate();

		Long lastInsertId = 0l;

		ps = db.conexao.prepareStatement("SELECT LAST_INSERT_ID()");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			lastInsertId = result.getLong(1);
		}

		return lastInsertId;
	}

	public Recommended select(Long id) throws Exception {
		Recommended recommended = new Recommended();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM Recommended WHERE id = ?");
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
			recommended.setDescriptionImage(result.getString("descriptionImage"));
			recommended.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			recommended.setCreatedOnFromMySQL(result.getString("createdOn"));
		}

		return recommended;
	}

	public void update(Recommended recommended) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("UPDATE Recommended SET recommender = ?,recommendations = ?,pageViews = ?,name = ?,type = ?,country = ?,officialWebsite = ?,about = ?,descriptionImage = ? WHERE id = ?");
		ps.setLong(1, recommended.getRecommender());
		ps.setLong(2, recommended.getRecommendations());
		ps.setLong(3, recommended.getPageViews());
		ps.setString(4, recommended.getName());
		ps.setInt(5, recommended.getType());
		ps.setInt(6, recommended.getCountry());
		ps.setString(7, recommended.getOfficialWebsite());
		ps.setString(8, recommended.getAbout());
		ps.setString(9, recommended.getDescriptionImage());
		ps.setLong(10, recommended.getId());
		ps.executeUpdate();

	}

	public void updateOnlyChanged(Recommended recommended) throws Exception {
		PreparedStatement ps;
		Recommended recommendedAtual = select(recommended.getId());

		if(recommendedAtual.getId().equals(recommended.getId())) {

			if(!recommendedAtual.getRecommender().equals(recommended.getRecommender())) {
				ps = db.conexao.prepareStatement("UPDATE Recommended SET recommender = ? WHERE id = ?");
				ps.setLong(1, recommended.getRecommender());
				ps.setLong(2, recommended.getId());
				ps.executeUpdate();
			}

			if(!recommendedAtual.getRecommendations().equals(recommended.getRecommendations())) {
				ps = db.conexao.prepareStatement("UPDATE Recommended SET recommendations = ? WHERE id = ?");
				ps.setLong(1, recommended.getRecommendations());
				ps.setLong(2, recommended.getId());
				ps.executeUpdate();
			}

			if(!recommendedAtual.getPageViews().equals(recommended.getPageViews())) {
				ps = db.conexao.prepareStatement("UPDATE Recommended SET pageViews = ? WHERE id = ?");
				ps.setLong(1, recommended.getPageViews());
				ps.setLong(2, recommended.getId());
				ps.executeUpdate();
			}

			if(!recommendedAtual.getName().equals(recommended.getName())) {
				ps = db.conexao.prepareStatement("UPDATE Recommended SET name = ? WHERE id = ?");
				ps.setString(1, recommended.getName());
				ps.setLong(2, recommended.getId());
				ps.executeUpdate();
			}

			if(!recommendedAtual.getType().equals(recommended.getType())) {
				ps = db.conexao.prepareStatement("UPDATE Recommended SET type = ? WHERE id = ?");
				ps.setInt(1, recommended.getType());
				ps.setLong(2, recommended.getId());
				ps.executeUpdate();
			}

			if(!recommendedAtual.getCountry().equals(recommended.getCountry())) {
				ps = db.conexao.prepareStatement("UPDATE Recommended SET country = ? WHERE id = ?");
				ps.setInt(1, recommended.getCountry());
				ps.setLong(2, recommended.getId());
				ps.executeUpdate();
			}

			if(!recommendedAtual.getOfficialWebsite().equals(recommended.getOfficialWebsite())) {
				ps = db.conexao.prepareStatement("UPDATE Recommended SET officialWebsite = ? WHERE id = ?");
				ps.setString(1, recommended.getOfficialWebsite());
				ps.setLong(2, recommended.getId());
				ps.executeUpdate();
			}

			if(!recommendedAtual.getAbout().equals(recommended.getAbout())) {
				ps = db.conexao.prepareStatement("UPDATE Recommended SET about = ? WHERE id = ?");
				ps.setString(1, recommended.getAbout());
				ps.setLong(2, recommended.getId());
				ps.executeUpdate();
			}

			if(!recommendedAtual.getDescriptionImage().equals(recommended.getDescriptionImage())) {
				ps = db.conexao.prepareStatement("UPDATE Recommended SET descriptionImage = ? WHERE id = ?");
				ps.setString(1, recommended.getDescriptionImage());
				ps.setLong(2, recommended.getId());
				ps.executeUpdate();
			}

		}
	}

	public void delete(Recommended recommended) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM Recommended WHERE id = ?");
		ps.setLong(1, recommended.getId());
		ps.executeUpdate();
	}

	public void delete(Long id) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM Recommended WHERE id = ?");
		ps.setLong(1, id);
		ps.executeUpdate();
	}

	public List getList(Integer page, Integer interval) throws Exception {
		List list = new ArrayList();

		Integer from = 0;
		Integer to = interval;

		if(page > 1) {
			from = ((page*to)-to);
		}

		ResultSet result = db.Consulta("SELECT * FROM Recommended LIMIT "+from+","+to+"");

		while(result.next()) {
			Recommended recommended = new Recommended();
			recommended.setId(result.getLong("id"));
			recommended.setRecommender(result.getLong("recommender"));
			recommended.setRecommendations(result.getLong("recommendations"));
			recommended.setPageViews(result.getLong("pageViews"));
			recommended.setName(result.getString("name"));
			recommended.setType(result.getInt("type"));
			recommended.setCountry(result.getInt("country"));
			recommended.setOfficialWebsite(result.getString("officialWebsite"));
			recommended.setAbout(result.getString("about"));
			recommended.setDescriptionImage(result.getString("descriptionImage"));
			recommended.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			recommended.setCreatedOnFromMySQL(result.getString("createdOn"));

			list.add(recommended);

		}

		return list;
	}

	public Long getCount() throws Exception {
		Long count = 0l;

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM Recommended");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			count = result.getLong(1);
		}

		return count;
	}

}