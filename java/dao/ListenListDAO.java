
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ListenListDAO {

	public DB db;

	public ListenListDAO(DB db) {
		this.db = db;
	}

	public Long insert(ListenList listenList) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("INSERT INTO ListenList (album,recommender,stateListen) VALUES(?,?,?)");
		ps.setLong(1, listenList.getAlbum());
		ps.setLong(2, listenList.getRecommender());
		ps.setString(3, listenList.getStateListenToMySQL());
		ps.executeUpdate();

		Long lastInsertId = 0l;

		ps = db.conexao.prepareStatement("SELECT LAST_INSERT_ID()");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			lastInsertId = result.getLong(1);
		}

		return lastInsertId;
	}

	public ListenList select(Long id) throws Exception {
		ListenList listenList = new ListenList();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM ListenList WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			listenList.setId(result.getLong("id"));
			listenList.setAlbum(result.getLong("album"));
			listenList.setRecommender(result.getLong("recommender"));
			listenList.setStateListenFromMySQL(result.getString("stateListen"));
			listenList.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			listenList.setCreatedOnFromMySQL(result.getString("createdOn"));
		}

		return listenList;
	}

	public void update(ListenList listenList) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("UPDATE ListenList SET album = ?,recommender = ?,stateListen = ? WHERE id = ?");
		ps.setLong(1, listenList.getAlbum());
		ps.setLong(2, listenList.getRecommender());
		ps.setString(3, listenList.getStateListenToMySQL());
		ps.setLong(4, listenList.getId());
		ps.executeUpdate();

	}

	public void updateOnlyChanged(ListenList listenList) throws Exception {
		PreparedStatement ps;
		ListenList listenListAtual = select(listenList.getId());

		if(listenListAtual.getId().equals(listenList.getId())) {

			if(!listenListAtual.getAlbum().equals(listenList.getAlbum())) {
				ps = db.conexao.prepareStatement("UPDATE ListenList SET album = ? WHERE id = ?");
				ps.setLong(1, listenList.getAlbum());
				ps.setLong(2, listenList.getId());
				ps.executeUpdate();
			}

			if(!listenListAtual.getRecommender().equals(listenList.getRecommender())) {
				ps = db.conexao.prepareStatement("UPDATE ListenList SET recommender = ? WHERE id = ?");
				ps.setLong(1, listenList.getRecommender());
				ps.setLong(2, listenList.getId());
				ps.executeUpdate();
			}

			if(!listenListAtual.getStateListenToMySQL().equals(listenList.getStateListenToMySQL())) {
				ps = db.conexao.prepareStatement("UPDATE ListenList SET stateListen = ? WHERE id = ?");
				ps.setString(1, listenList.getStateListenToMySQL());
				ps.setLong(2, listenList.getId());
				ps.executeUpdate();
			}

		}
	}

	public void delete(ListenList listenList) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM ListenList WHERE id = ?");
		ps.setLong(1, listenList.getId());
		ps.executeUpdate();
	}

	public void delete(Long id) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM ListenList WHERE id = ?");
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

		ResultSet result = db.Consulta("SELECT * FROM ListenList LIMIT "+from+","+to+"");

		while(result.next()) {
			ListenList listenList = new ListenList();
			listenList.setId(result.getLong("id"));
			listenList.setAlbum(result.getLong("album"));
			listenList.setRecommender(result.getLong("recommender"));
			listenList.setStateListenFromMySQL(result.getString("stateListen"));
			listenList.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			listenList.setCreatedOnFromMySQL(result.getString("createdOn"));

			list.add(listenList);

		}

		return list;
	}

	public Long getCount() throws Exception {
		Long count = 0l;

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM ListenList");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			count = result.getLong(1);
		}

		return count;
	}

}