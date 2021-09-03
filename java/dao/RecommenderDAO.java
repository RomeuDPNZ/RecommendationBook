
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RecommenderDAO {

	public DB db;

	public RecommenderDAO(DB db) {
		this.db = db;
	}

	public Long insert(Recommender recommender) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("INSERT INTO Recommender (login,recommendations,pageViews,nickName,sex,country,birthDate,showSex,showCountry,showBirth,officialWebsite,about) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)");
		ps.setLong(1, recommender.getLogin());
		ps.setLong(2, recommender.getRecommendations());
		ps.setLong(3, recommender.getPageViews());
		ps.setString(4, recommender.getNickName());
		ps.setString(5, recommender.getSexToMySQL());
		ps.setInt(6, recommender.getCountry());
		ps.setString(7, recommender.getBirthDateToMySQL());
		ps.setBoolean(8, recommender.getShowSex());
		ps.setBoolean(9, recommender.getShowCountry());
		ps.setBoolean(10, recommender.getShowBirth());
		ps.setString(11, recommender.getOfficialWebsite());
		ps.setString(12, recommender.getAbout());
		ps.executeUpdate();

		Long lastInsertId = 0l;

		ps = db.conexao.prepareStatement("SELECT LAST_INSERT_ID()");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			lastInsertId = result.getLong(1);
		}

		return lastInsertId;
	}

	public Recommender select(Long id) throws Exception {
		Recommender recommender = new Recommender();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM Recommender WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			recommender.setId(result.getLong("id"));
			recommender.setLogin(result.getLong("login"));
			recommender.setRecommendations(result.getLong("recommendations"));
			recommender.setPageViews(result.getLong("pageViews"));
			recommender.setNickName(result.getString("nickName"));
			recommender.setSexFromMySQL(result.getString("sex"));
			recommender.setCountry(result.getInt("country"));
			recommender.setBirthDateFromMySQL(result.getString("birthDate"));
			recommender.setShowSex(result.getBoolean("showSex"));
			recommender.setShowCountry(result.getBoolean("showCountry"));
			recommender.setShowBirth(result.getBoolean("showBirth"));
			recommender.setOfficialWebsite(result.getString("officialWebsite"));
			recommender.setAbout(result.getString("about"));
			recommender.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			recommender.setCreatedOnFromMySQL(result.getString("createdOn"));
		}

		return recommender;
	}

	public void update(Recommender recommender) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("UPDATE Recommender SET login = ?,recommendations = ?,pageViews = ?,nickName = ?,sex = ?,country = ?,birthDate = ?,showSex = ?,showCountry = ?,showBirth = ?,officialWebsite = ?,about = ? WHERE id = ?");
		ps.setLong(1, recommender.getLogin());
		ps.setLong(2, recommender.getRecommendations());
		ps.setLong(3, recommender.getPageViews());
		ps.setString(4, recommender.getNickName());
		ps.setString(5, recommender.getSexToMySQL());
		ps.setInt(6, recommender.getCountry());
		ps.setString(7, recommender.getBirthDateToMySQL());
		ps.setBoolean(8, recommender.getShowSex());
		ps.setBoolean(9, recommender.getShowCountry());
		ps.setBoolean(10, recommender.getShowBirth());
		ps.setString(11, recommender.getOfficialWebsite());
		ps.setString(12, recommender.getAbout());
		ps.setLong(13, recommender.getId());
		ps.executeUpdate();

	}

	public void updateOnlyChanged(Recommender recommender) throws Exception {
		PreparedStatement ps;
		Recommender recommenderAtual = select(recommender.getId());

		if(recommenderAtual.getId().equals(recommender.getId())) {

			if(!recommenderAtual.getLogin().equals(recommender.getLogin())) {
				ps = db.conexao.prepareStatement("UPDATE Recommender SET login = ? WHERE id = ?");
				ps.setLong(1, recommender.getLogin());
				ps.setLong(2, recommender.getId());
				ps.executeUpdate();
			}

			if(!recommenderAtual.getRecommendations().equals(recommender.getRecommendations())) {
				ps = db.conexao.prepareStatement("UPDATE Recommender SET recommendations = ? WHERE id = ?");
				ps.setLong(1, recommender.getRecommendations());
				ps.setLong(2, recommender.getId());
				ps.executeUpdate();
			}

			if(!recommenderAtual.getPageViews().equals(recommender.getPageViews())) {
				ps = db.conexao.prepareStatement("UPDATE Recommender SET pageViews = ? WHERE id = ?");
				ps.setLong(1, recommender.getPageViews());
				ps.setLong(2, recommender.getId());
				ps.executeUpdate();
			}

			if(!recommenderAtual.getNickName().equals(recommender.getNickName())) {
				ps = db.conexao.prepareStatement("UPDATE Recommender SET nickName = ? WHERE id = ?");
				ps.setString(1, recommender.getNickName());
				ps.setLong(2, recommender.getId());
				ps.executeUpdate();
			}

			if(!recommenderAtual.getSexToMySQL().equals(recommender.getSexToMySQL())) {
				ps = db.conexao.prepareStatement("UPDATE Recommender SET sex = ? WHERE id = ?");
				ps.setString(1, recommender.getSexToMySQL());
				ps.setLong(2, recommender.getId());
				ps.executeUpdate();
			}

			if(!recommenderAtual.getCountry().equals(recommender.getCountry())) {
				ps = db.conexao.prepareStatement("UPDATE Recommender SET country = ? WHERE id = ?");
				ps.setInt(1, recommender.getCountry());
				ps.setLong(2, recommender.getId());
				ps.executeUpdate();
			}

			if(!recommenderAtual.getBirthDateToMySQL().equals(recommender.getBirthDateToMySQL())) {
				ps = db.conexao.prepareStatement("UPDATE Recommender SET birthDate = ? WHERE id = ?");
				ps.setString(1, recommender.getBirthDateToMySQL());
				ps.setLong(2, recommender.getId());
				ps.executeUpdate();
			}

			if(!recommenderAtual.getShowSex().equals(recommender.getShowSex())) {
				ps = db.conexao.prepareStatement("UPDATE Recommender SET showSex = ? WHERE id = ?");
				ps.setBoolean(1, recommender.getShowSex());
				ps.setLong(2, recommender.getId());
				ps.executeUpdate();
			}

			if(!recommenderAtual.getShowCountry().equals(recommender.getShowCountry())) {
				ps = db.conexao.prepareStatement("UPDATE Recommender SET showCountry = ? WHERE id = ?");
				ps.setBoolean(1, recommender.getShowCountry());
				ps.setLong(2, recommender.getId());
				ps.executeUpdate();
			}

			if(!recommenderAtual.getShowBirth().equals(recommender.getShowBirth())) {
				ps = db.conexao.prepareStatement("UPDATE Recommender SET showBirth = ? WHERE id = ?");
				ps.setBoolean(1, recommender.getShowBirth());
				ps.setLong(2, recommender.getId());
				ps.executeUpdate();
			}

			if(!recommenderAtual.getOfficialWebsite().equals(recommender.getOfficialWebsite())) {
				ps = db.conexao.prepareStatement("UPDATE Recommender SET officialWebsite = ? WHERE id = ?");
				ps.setString(1, recommender.getOfficialWebsite());
				ps.setLong(2, recommender.getId());
				ps.executeUpdate();
			}

			if(!recommenderAtual.getAbout().equals(recommender.getAbout())) {
				ps = db.conexao.prepareStatement("UPDATE Recommender SET about = ? WHERE id = ?");
				ps.setString(1, recommender.getAbout());
				ps.setLong(2, recommender.getId());
				ps.executeUpdate();
			}

		}
	}

	public void delete(Recommender recommender) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM Recommender WHERE id = ?");
		ps.setLong(1, recommender.getId());
		ps.executeUpdate();
	}

	public void delete(Long id) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM Recommender WHERE id = ?");
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

		ResultSet result = db.Consulta("SELECT * FROM Recommender LIMIT "+from+","+to+"");

		while(result.next()) {
			Recommender recommender = new Recommender();
			recommender.setId(result.getLong("id"));
			recommender.setLogin(result.getLong("login"));
			recommender.setRecommendations(result.getLong("recommendations"));
			recommender.setPageViews(result.getLong("pageViews"));
			recommender.setNickName(result.getString("nickName"));
			recommender.setSexFromMySQL(result.getString("sex"));
			recommender.setCountry(result.getInt("country"));
			recommender.setBirthDateFromMySQL(result.getString("birthDate"));
			recommender.setShowSex(result.getBoolean("showSex"));
			recommender.setShowCountry(result.getBoolean("showCountry"));
			recommender.setShowBirth(result.getBoolean("showBirth"));
			recommender.setOfficialWebsite(result.getString("officialWebsite"));
			recommender.setAbout(result.getString("about"));
			recommender.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			recommender.setCreatedOnFromMySQL(result.getString("createdOn"));

			list.add(recommender);

		}

		return list;
	}

	public Long getCount() throws Exception {
		Long count = 0l;

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM Recommender");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			count = result.getLong(1);
		}

		return count;
	}

}