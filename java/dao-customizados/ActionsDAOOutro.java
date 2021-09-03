
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ActionsDAOOutro {

	public DB db;

	public ActionsDAOOutro(DB db) {
		this.db = db;
	}

	public Integer getActionId(String action) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT id FROM Actions WHERE action = ?");
		ps.setString(1, action);
		ResultSet result = ps.executeQuery();

		Integer actionId = 0;

		while(result.next()) {
			actionId = result.getInt("id");
		}

		return actionId;
	}

}