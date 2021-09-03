
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PersonsDAOOutro {

	public DB db;

	public PersonsDAOOutro(DB db) {
		this.db = db;
	}

	public String getOccupation(Long personId) throws Exception {
		String occupation = "";

		PreparedStatement ps = db.conexao.prepareStatement("SELECT (SELECT occupation FROM Occupations WHERE id=Persons.primaryOccupation) as occupation FROM Persons WHERE id = ?");
		ps.setLong(1, personId);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			occupation = result.getString("occupation");
		}

		return occupation;
	}

}