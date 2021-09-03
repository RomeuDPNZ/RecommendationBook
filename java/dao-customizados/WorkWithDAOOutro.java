
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class WorkWithDAOOutro {

	public WorkWithDAOOutro() {

	}

	public Boolean alreadyExists(Long id, Long thing, String type) throws Exception {
		DB db = new DB();
		db.ConectaDB();
		db.Atualiza("USE RecommendationBook");

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM WorkWith WHERE recommender = ? AND thing = ? AND type = ?");
		ps.setLong(1, id);
		ps.setLong(2, thing);
		ps.setString(3, type);
		ResultSet result = ps.executeQuery();

		Long found = 0l;

		while(result.next()) {
			found = result.getLong(1);
		}

		Boolean alreadyExists = false;

		if(found > 0l) {
			alreadyExists = true;
		}

		db.DesconectaDB();

		return alreadyExists;
	}


	public void deleteAll(Long recommender) throws Exception {
		DB db = new DB();
		db.ConectaDB();
		db.Atualiza("USE RecommendationBook");

		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM WorkWith WHERE recommender = ?");
		ps.setLong(1, recommender);
		ps.executeUpdate();

		db.DesconectaDB();
	}


	public Boolean hasAtLeastTwoPersons(Long id) throws Exception {
		DB db = new DB();
		db.ConectaDB();
		db.Atualiza("USE RecommendationBook");

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM WorkWith WHERE recommender = ? AND type = 'Person'");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		Long found = 0l;

		while(result.next()) {
			found = result.getLong(1);
		}

		Boolean has = false;

		if(found >= 2l) {
			has = true;
		}

		db.DesconectaDB();

		return has;
	}

}