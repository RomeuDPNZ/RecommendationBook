
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class WatchListDAOOutro {

	public DB db;

	public WatchListDAOOutro(DB db) {
		this.db = db;
	}

	public WatchList select(Long idMovie, Long idRecommender) throws Exception {
		WatchList watchList = new WatchList();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM WatchList WHERE movie = ? AND recommender = ?");
		ps.setLong(1, idMovie);
		ps.setLong(2, idRecommender);
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

	public void delete(Long idMovie) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM WatchList WHERE movie = ?");
		ps.setLong(1, idMovie);
		ps.executeUpdate();
	}

}