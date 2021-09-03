
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ListenListDAOOutro {

	public DB db;

	public ListenListDAOOutro(DB db) {
		this.db = db;
	}

	public ListenList select(Long idAlbum, Long idRecommender) throws Exception {
		ListenList listenList = new ListenList();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM ListenList WHERE album = ? AND recommender = ?");
		ps.setLong(1, idAlbum);
		ps.setLong(2, idRecommender);
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

	public void delete(Long idAlbum) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM ListenList WHERE album = ?");
		ps.setLong(1, idAlbum);
		ps.executeUpdate();
	}

}