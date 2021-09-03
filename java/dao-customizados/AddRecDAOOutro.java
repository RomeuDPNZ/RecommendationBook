
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AddRecDAOOutro {

	public DB db;

	public AddRecDAOOutro(DB db) {
		this.db = db;
	}

	public Long recommended(Long id) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM AddRec WHERE recommender = ? AND action IN (SELECT id FROM Actions WHERE action LIKE '%Recommended the %')");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		Long timesRecommended = 0l;

		while(result.next()) {
			timesRecommended = result.getLong(1);
		}

		return timesRecommended;
	}

	public Long isRecommender(Long recommenderIdLogged, Long thing, Integer action) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT id FROM AddRec WHERE recommender = ? AND addRec = ? AND action = ?");
		ps.setLong(1, recommenderIdLogged);
		ps.setLong(2, thing);
		ps.setInt(3, action);
		ResultSet result = ps.executeQuery();

		Long addRecId = 0l;

		while(result.next()) {
			addRecId = result.getLong("id");
		}

		return addRecId;
	}

	public void delete(Long addRec, Integer action) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM AddRec WHERE addRec = ? AND action = ?");
		ps.setLong(1, addRec);
		ps.setInt(2, action);
		ps.executeUpdate();
	}

}