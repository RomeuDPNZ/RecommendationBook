
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DecrementPageViews {

	public DB db;

	public DecrementPageViews(DB db) {
		this.db = db;
	}

	public Long decrementPageViews(String thing, Long id) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("UPDATE "+thing+" SET pageViews=pageViews-1 WHERE id = ?");
		ps.setLong(1, id);
		ps.executeUpdate();

		Long pageViews = 0l;

		ps = db.conexao.prepareStatement("SELECT pageViews FROM "+thing+" WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			pageViews = result.getLong(1);
		}

		return pageViews;
	}

}