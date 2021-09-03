
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ReadListDAOOutro {

	public DB db;

	public ReadListDAOOutro(DB db) {
		this.db = db;
	}

	public ReadList select(Long idBook, Long idRecommender) throws Exception {
		ReadList readList = new ReadList();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM ReadList WHERE book = ? AND recommender = ?");
		ps.setLong(1, idBook);
		ps.setLong(2, idRecommender);
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

	public void delete(Long idBook) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM ReadList WHERE book = ?");
		ps.setLong(1, idBook);
		ps.executeUpdate();
	}

}