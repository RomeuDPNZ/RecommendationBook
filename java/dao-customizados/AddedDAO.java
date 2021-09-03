
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AddedDAO {

	public DB db;

	public AddedDAO(DB db) {
		this.db = db;
	}

	public List getList(String table, String name, String action, Long recommenderId, Integer limitFrom, Integer limitTo) throws Exception {
		List list = new ArrayList();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT "+table+".id as id, "+name+" as Added, "+table+".recommendations as Recommendations, AddRec.createdOn as time FROM AddRec INNER JOIN "+table+" ON AddRec.addRec="+table+".id INNER JOIN Actions ON Actions.id=AddRec.action WHERE Actions.action=? AND AddRec.recommender=? ORDER BY time DESC LIMIT ?,?");
		ps.setString(1, action);
		ps.setLong(2, recommenderId);
		ps.setInt(3, limitFrom);
		ps.setInt(4, limitTo);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			Added added = new Added();

			added.setId(result.getLong("id"));
			added.setName(result.getString("Added"));
			added.setRecommendations(result.getLong("Recommendations"));
			added.setCreatedOnFromMySQL(result.getString("time"));

			list.add(added);
		}

		return list;
	}

	public Long getCount(Long recommenderId, String action) throws Exception {
		List list = new ArrayList();

		Long count = 0l;

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM AddRec WHERE recommender=? AND action=(SELECT id FROM Actions WHERE action=?) ORDER BY createdOn");
		ps.setLong(1, recommenderId);
		ps.setString(2, action);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			count = result.getLong(1);
		}

		return count;
	}

}