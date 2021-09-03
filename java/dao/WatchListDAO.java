
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class WatchListDAO {

	public DB db;

	public WatchListDAO(DB db) {
		this.db = db;
	}

	public Long insert(WatchList watchList) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("INSERT INTO WatchList (movie,recommender,stateWatch) VALUES(?,?,?)");
		ps.setLong(1, watchList.getMovie());
		ps.setLong(2, watchList.getRecommender());
		ps.setString(3, watchList.getStateWatchToMySQL());
		ps.executeUpdate();

		Long lastInsertId = 0l;

		ps = db.conexao.prepareStatement("SELECT LAST_INSERT_ID()");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			lastInsertId = result.getLong(1);
		}

		return lastInsertId;
	}

	public WatchList select(Long id) throws Exception {
		WatchList watchList = new WatchList();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM WatchList WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			watchList.setId(result.getLong("id"));
			watchList.setMovie(result.getLong("movie"));
			watchList.setRecommender(result.getLong("recommender"));
			watchList.setStateWatchFromMySQL(result.getString("stateWatch"));
			watchList.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			watchList.setCreatedOnFromMySQL(result.getString("createdOn"));
		}

		return watchList;
	}

	public void update(WatchList watchList) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("UPDATE WatchList SET movie = ?,recommender = ?,stateWatch = ? WHERE id = ?");
		ps.setLong(1, watchList.getMovie());
		ps.setLong(2, watchList.getRecommender());
		ps.setString(3, watchList.getStateWatchToMySQL());
		ps.setLong(4, watchList.getId());
		ps.executeUpdate();

	}

	public void updateOnlyChanged(WatchList watchList) throws Exception {
		PreparedStatement ps;
		WatchList watchListAtual = select(watchList.getId());

		if(watchListAtual.getId().equals(watchList.getId())) {

			if(!watchListAtual.getMovie().equals(watchList.getMovie())) {
				ps = db.conexao.prepareStatement("UPDATE WatchList SET movie = ? WHERE id = ?");
				ps.setLong(1, watchList.getMovie());
				ps.setLong(2, watchList.getId());
				ps.executeUpdate();
			}

			if(!watchListAtual.getRecommender().equals(watchList.getRecommender())) {
				ps = db.conexao.prepareStatement("UPDATE WatchList SET recommender = ? WHERE id = ?");
				ps.setLong(1, watchList.getRecommender());
				ps.setLong(2, watchList.getId());
				ps.executeUpdate();
			}

			if(!watchListAtual.getStateWatchToMySQL().equals(watchList.getStateWatchToMySQL())) {
				ps = db.conexao.prepareStatement("UPDATE WatchList SET stateWatch = ? WHERE id = ?");
				ps.setString(1, watchList.getStateWatchToMySQL());
				ps.setLong(2, watchList.getId());
				ps.executeUpdate();
			}

		}
	}

	public void delete(WatchList watchList) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM WatchList WHERE id = ?");
		ps.setLong(1, watchList.getId());
		ps.executeUpdate();
	}

	public void delete(Long id) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM WatchList WHERE id = ?");
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

		ResultSet result = db.Consulta("SELECT * FROM WatchList LIMIT "+from+","+to+"");

		while(result.next()) {
			WatchList watchList = new WatchList();
			watchList.setId(result.getLong("id"));
			watchList.setMovie(result.getLong("movie"));
			watchList.setRecommender(result.getLong("recommender"));
			watchList.setStateWatchFromMySQL(result.getString("stateWatch"));
			watchList.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			watchList.setCreatedOnFromMySQL(result.getString("createdOn"));

			list.add(watchList);

		}

		return list;
	}

	public Long getCount() throws Exception {
		Long count = 0l;

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM WatchList");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			count = result.getLong(1);
		}

		return count;
	}

}