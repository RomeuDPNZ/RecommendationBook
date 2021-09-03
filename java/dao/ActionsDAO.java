
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ActionsDAO {

	public DB db;

	public ActionsDAO(DB db) {
		this.db = db;
	}

	public Long insert(Actions actions) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("INSERT INTO Actions (action) VALUES(?)");
		ps.setString(1, actions.getAction());
		ps.executeUpdate();

		Long lastInsertId = 0l;

		ps = db.conexao.prepareStatement("SELECT LAST_INSERT_ID()");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			lastInsertId = result.getLong(1);
		}

		return lastInsertId;
	}

	public Actions select(Long id) throws Exception {
		Actions actions = new Actions();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM Actions WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			actions.setId(result.getLong("id"));
			actions.setAction(result.getString("action"));
		}

		return actions;
	}

	public void update(Actions actions) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("UPDATE Actions SET action = ? WHERE id = ?");
		ps.setString(1, actions.getAction());
		ps.setLong(2, actions.getId());
		ps.executeUpdate();

	}

	public void updateOnlyChanged(Actions actions) throws Exception {
		PreparedStatement ps;
		Actions actionsAtual = select(actions.getId());

		if(actionsAtual.getId().equals(actions.getId())) {

			if(!actionsAtual.getAction().equals(actions.getAction())) {
				ps = db.conexao.prepareStatement("UPDATE Actions SET action = ? WHERE id = ?");
				ps.setString(1, actions.getAction());
				ps.setLong(2, actions.getId());
				ps.executeUpdate();
			}

		}
	}

	public void delete(Actions actions) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM Actions WHERE id = ?");
		ps.setLong(1, actions.getId());
		ps.executeUpdate();
	}

	public void delete(Long id) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM Actions WHERE id = ?");
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

		ResultSet result = db.Consulta("SELECT * FROM Actions LIMIT "+from+","+to+"");

		while(result.next()) {
			Actions actions = new Actions();
			actions.setId(result.getLong("id"));
			actions.setAction(result.getString("action"));

			list.add(actions);

		}

		return list;
	}

	public Long getCount() throws Exception {
		Long count = 0l;

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM Actions");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			count = result.getLong(1);
		}

		return count;
	}

}