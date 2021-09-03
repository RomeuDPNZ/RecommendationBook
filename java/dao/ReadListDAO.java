
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReadListDAO {

	public DB db;

	public ReadListDAO(DB db) {
		this.db = db;
	}

	public Long insert(ReadList readList) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("INSERT INTO ReadList (book,recommender,stateRead) VALUES(?,?,?)");
		ps.setLong(1, readList.getBook());
		ps.setLong(2, readList.getRecommender());
		ps.setString(3, readList.getStateReadToMySQL());
		ps.executeUpdate();

		Long lastInsertId = 0l;

		ps = db.conexao.prepareStatement("SELECT LAST_INSERT_ID()");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			lastInsertId = result.getLong(1);
		}

		return lastInsertId;
	}

	public ReadList select(Long id) throws Exception {
		ReadList readList = new ReadList();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM ReadList WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			readList.setId(result.getLong("id"));
			readList.setBook(result.getLong("book"));
			readList.setRecommender(result.getLong("recommender"));
			readList.setStateReadFromMySQL(result.getString("stateRead"));
			readList.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			readList.setCreatedOnFromMySQL(result.getString("createdOn"));
		}

		return readList;
	}

	public void update(ReadList readList) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("UPDATE ReadList SET book = ?,recommender = ?,stateRead = ? WHERE id = ?");
		ps.setLong(1, readList.getBook());
		ps.setLong(2, readList.getRecommender());
		ps.setString(3, readList.getStateReadToMySQL());
		ps.setLong(4, readList.getId());
		ps.executeUpdate();

	}

	public void updateOnlyChanged(ReadList readList) throws Exception {
		PreparedStatement ps;
		ReadList readListAtual = select(readList.getId());

		if(readListAtual.getId().equals(readList.getId())) {

			if(!readListAtual.getBook().equals(readList.getBook())) {
				ps = db.conexao.prepareStatement("UPDATE ReadList SET book = ? WHERE id = ?");
				ps.setLong(1, readList.getBook());
				ps.setLong(2, readList.getId());
				ps.executeUpdate();
			}

			if(!readListAtual.getRecommender().equals(readList.getRecommender())) {
				ps = db.conexao.prepareStatement("UPDATE ReadList SET recommender = ? WHERE id = ?");
				ps.setLong(1, readList.getRecommender());
				ps.setLong(2, readList.getId());
				ps.executeUpdate();
			}

			if(!readListAtual.getStateReadToMySQL().equals(readList.getStateReadToMySQL())) {
				ps = db.conexao.prepareStatement("UPDATE ReadList SET stateRead = ? WHERE id = ?");
				ps.setString(1, readList.getStateReadToMySQL());
				ps.setLong(2, readList.getId());
				ps.executeUpdate();
			}

		}
	}

	public void delete(ReadList readList) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM ReadList WHERE id = ?");
		ps.setLong(1, readList.getId());
		ps.executeUpdate();
	}

	public void delete(Long id) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM ReadList WHERE id = ?");
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

		ResultSet result = db.Consulta("SELECT * FROM ReadList LIMIT "+from+","+to+"");

		while(result.next()) {
			ReadList readList = new ReadList();
			readList.setId(result.getLong("id"));
			readList.setBook(result.getLong("book"));
			readList.setRecommender(result.getLong("recommender"));
			readList.setStateReadFromMySQL(result.getString("stateRead"));
			readList.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			readList.setCreatedOnFromMySQL(result.getString("createdOn"));

			list.add(readList);

		}

		return list;
	}

	public Long getCount() throws Exception {
		Long count = 0l;

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM ReadList");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			count = result.getLong(1);
		}

		return count;
	}

}