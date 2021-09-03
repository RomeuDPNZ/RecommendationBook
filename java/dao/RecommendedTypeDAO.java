
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class RecommendedTypeDAO {

	public DB db;

	public RecommendedTypeDAO(DB db) {
		this.db = db;
	}

	public Long insert(RecommendedType recommendedType) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("INSERT INTO RecommendedType (type) VALUES(?)");
		ps.setString(1, recommendedType.getType());
		ps.executeUpdate();

		Long lastInsertId = 0l;

		ps = db.conexao.prepareStatement("SELECT LAST_INSERT_ID()");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			lastInsertId = result.getLong(1);
		}

		return lastInsertId;
	}

	public RecommendedType select(Long id) throws Exception {
		RecommendedType recommendedType = new RecommendedType();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM RecommendedType WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			recommendedType.setId(result.getLong("id"));
			recommendedType.setType(result.getString("type"));
		}

		return recommendedType;
	}

	public void update(RecommendedType recommendedType) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("UPDATE RecommendedType SET type = ? WHERE id = ?");
		ps.setString(1, recommendedType.getType());
		ps.setLong(2, recommendedType.getId());
		ps.executeUpdate();

	}

	public void updateOnlyChanged(RecommendedType recommendedType) throws Exception {
		PreparedStatement ps;
		RecommendedType recommendedTypeAtual = select(recommendedType.getId());

		if(recommendedTypeAtual.getId().equals(recommendedType.getId())) {

			if(!recommendedTypeAtual.getType().equals(recommendedType.getType())) {
				ps = db.conexao.prepareStatement("UPDATE RecommendedType SET type = ? WHERE id = ?");
				ps.setString(1, recommendedType.getType());
				ps.setLong(2, recommendedType.getId());
				ps.executeUpdate();
			}

		}
	}

	public void delete(RecommendedType recommendedType) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM RecommendedType WHERE id = ?");
		ps.setLong(1, recommendedType.getId());
		ps.executeUpdate();
	}

	public void delete(Long id) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM RecommendedType WHERE id = ?");
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

		ResultSet result = db.Consulta("SELECT * FROM RecommendedType LIMIT "+from+","+to+"");

		while(result.next()) {
			RecommendedType recommendedType = new RecommendedType();
			recommendedType.setId(result.getLong("id"));
			recommendedType.setType(result.getString("type"));

			list.add(recommendedType);

		}

		return list;
	}

	public Long getCount() throws Exception {
		Long count = 0l;

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM RecommendedType");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			count = result.getLong(1);
		}

		return count;
	}

}