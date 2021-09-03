
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class PersonsOtherOccupationsDAOOutro {

	public DB db;

	public PersonsOtherOccupationsDAOOutro(DB db) {
		this.db = db;
	}

	public String getOtherOccupations(Long personId) throws Exception {
		List list = new ArrayList();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT (SELECT occupation FROM Occupations WHERE id=PersonsOtherOccupations.otherOccupation) as occupation FROM PersonsOtherOccupations WHERE person = ?");
		ps.setLong(1, personId);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			OtherOccupationsOutro otherOccupationsOutro = new OtherOccupationsOutro();

			otherOccupationsOutro.setOccupation(result.getString("occupation"));

			list.add(otherOccupationsOutro);
		}

		String otherOccupations = "";

		Iterator itr = list.iterator();

		if(list.isEmpty()) {
			otherOccupations = "<dd class=\"user\">None</dd>";
		} else {
			while(itr.hasNext()) {
				OtherOccupationsOutro o = (OtherOccupationsOutro) itr.next();
				otherOccupations += "<dd class=\"user\">"+o.getOccupation()+"</dd>";
			}
		}

		return otherOccupations;
	}

}