
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AddRecDAO {

	public DB db;

	public AddRecDAO(DB db) {
		this.db = db;
	}

	public Long insert(AddRec addRec) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("INSERT INTO AddRec (recommender,addRec,action) VALUES(?,?,?)");
		ps.setLong(1, addRec.getRecommender());
		ps.setLong(2, addRec.getAddRec());
		ps.setInt(3, addRec.getAction());
		ps.executeUpdate();

		Long lastInsertId = 0l;

		ps = db.conexao.prepareStatement("SELECT LAST_INSERT_ID()");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			lastInsertId = result.getLong(1);
		}

		return lastInsertId;
	}

	public AddRec select(Long id) throws Exception {
		AddRec addRec = new AddRec();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM AddRec WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			addRec.setId(result.getLong("id"));
			addRec.setRecommender(result.getLong("recommender"));
			addRec.setAddRec(result.getLong("addRec"));
			addRec.setAction(result.getInt("action"));
			addRec.setCreatedOnFromMySQL(result.getString("createdOn"));
		}

		return addRec;
	}

	public void update(AddRec addRec) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("UPDATE AddRec SET recommender = ?,addRec = ?,action = ? WHERE id = ?");
		ps.setLong(1, addRec.getRecommender());
		ps.setLong(2, addRec.getAddRec());
		ps.setInt(3, addRec.getAction());
		ps.setLong(4, addRec.getId());
		ps.executeUpdate();

	}

	public void updateOnlyChanged(AddRec addRec) throws Exception {
		PreparedStatement ps;
		AddRec addRecAtual = select(addRec.getId());

		if(addRecAtual.getId().equals(addRec.getId())) {

			if(!addRecAtual.getRecommender().equals(addRec.getRecommender())) {
				ps = db.conexao.prepareStatement("UPDATE AddRec SET recommender = ? WHERE id = ?");
				ps.setLong(1, addRec.getRecommender());
				ps.setLong(2, addRec.getId());
				ps.executeUpdate();
			}

			if(!addRecAtual.getAddRec().equals(addRec.getAddRec())) {
				ps = db.conexao.prepareStatement("UPDATE AddRec SET addRec = ? WHERE id = ?");
				ps.setLong(1, addRec.getAddRec());
				ps.setLong(2, addRec.getId());
				ps.executeUpdate();
			}

			if(!addRecAtual.getAction().equals(addRec.getAction())) {
				ps = db.conexao.prepareStatement("UPDATE AddRec SET action = ? WHERE id = ?");
				ps.setInt(1, addRec.getAction());
				ps.setLong(2, addRec.getId());
				ps.executeUpdate();
			}

		}
	}

	public void delete(AddRec addRec) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM AddRec WHERE id = ?");
		ps.setLong(1, addRec.getId());
		ps.executeUpdate();
	}

	public void delete(Long id) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM AddRec WHERE id = ?");
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

		ResultSet result = db.Consulta("SELECT * FROM AddRec LIMIT "+from+","+to+"");

		while(result.next()) {
			AddRec addRec = new AddRec();
			addRec.setId(result.getLong("id"));
			addRec.setRecommender(result.getLong("recommender"));
			addRec.setAddRec(result.getLong("addRec"));
			addRec.setAction(result.getInt("action"));
			addRec.setCreatedOnFromMySQL(result.getString("createdOn"));

			list.add(addRec);

		}

		return list;
	}

	public Long getCount() throws Exception {
		Long count = 0l;

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM AddRec");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			count = result.getLong(1);
		}

		return count;
	}

}