
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TODODAO {

	public DB db;

	public TODODAO(DB db) {
		this.db = db;
	}

	public List getWatch(Long idRecommender, String state, Integer limitFrom, Integer limitTo) throws Exception {
		List list = new ArrayList();

	PreparedStatement ps = db.conexao.prepareStatement("SELECT movie as id, (SELECT name FROM Recommended WHERE id=WatchList.movie) as recommended, (SELECT recommendations FROM Recommended WHERE id=WatchList.movie) as recommendations, WatchList.createdOn as time FROM WatchList WHERE recommender = ? AND stateWatch = ? ORDER BY time DESC LIMIT ?,?");
		ps.setLong(1, idRecommender);
		ps.setString(2, state);
		ps.setInt(3, limitFrom);
		ps.setInt(4, limitTo);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			TODO t = new TODO();

			t.setId(result.getLong("id"));
			t.setRecommended(result.getString("Recommended"));
			t.setRecommendations(result.getLong("Recommendations"));
			t.setCreatedOnFromMySQL(result.getString("time"));

			list.add(t);
		}

		return list;

	}

	public Long getCountWatch(Long recommenderId, String state) throws Exception {
		Long count = 0l;

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM WatchList WHERE recommender = ? AND stateWatch = ?");
		ps.setLong(1, recommenderId);
		ps.setString(2, state);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			count = result.getLong(1);
		}

		return count;
	}

	public List getListen(Long idRecommender, String state, Integer limitFrom, Integer limitTo) throws Exception {
		List list = new ArrayList();

	PreparedStatement ps = db.conexao.prepareStatement("SELECT album as id, (SELECT name FROM Recommended WHERE id=ListenList.album) as recommended, (SELECT recommendations FROM Recommended WHERE id=ListenList.album) as recommendations, ListenList.createdOn as time FROM ListenList WHERE recommender = ? AND stateListen = ? ORDER BY time DESC LIMIT ?,?");
		ps.setLong(1, idRecommender);
		ps.setString(2, state);
		ps.setInt(3, limitFrom);
		ps.setInt(4, limitTo);;
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			TODO t = new TODO();

			t.setId(result.getLong("id"));
			t.setRecommended(result.getString("Recommended"));
			t.setRecommendations(result.getLong("Recommendations"));
			t.setCreatedOnFromMySQL(result.getString("time"));

			list.add(t);
		}

		return list;

	}

	public Long getCountListen(Long recommenderId, String state) throws Exception {
		Long count = 0l;

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM ListenList WHERE recommender = ? AND stateListen = ?");
		ps.setLong(1, recommenderId);
		ps.setString(2, state);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			count = result.getLong(1);
		}

		return count;
	}

	public List getRead(Long idRecommender, String state, Integer limitFrom, Integer limitTo) throws Exception {
		List list = new ArrayList();

	PreparedStatement ps = db.conexao.prepareStatement("SELECT book as id, (SELECT name FROM Recommended WHERE id=ReadList.book) as recommended, (SELECT recommendations FROM Recommended WHERE id=ReadList.book) as recommendations, ReadList.createdOn as time FROM ReadList WHERE recommender = ? AND stateRead = ? ORDER BY createdOn DESC LIMIT ?,?");
		ps.setLong(1, idRecommender);
		ps.setString(2, state);
		ps.setInt(3, limitFrom);
		ps.setInt(4, limitTo);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			TODO t = new TODO();

			t.setId(result.getLong("id"));
			t.setRecommended(result.getString("Recommended"));
			t.setRecommendations(result.getLong("Recommendations"));
			t.setCreatedOnFromMySQL(result.getString("time"));

			list.add(t);
		}

		return list;

	}

	public Long getCountRead(Long recommenderId, String state) throws Exception {
		Long count = 0l;

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM ReadList WHERE recommender = ? AND stateRead = ?");
		ps.setLong(1, recommenderId);
		ps.setString(2, state);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			count = result.getLong(1);
		}

		return count;
	}

}
