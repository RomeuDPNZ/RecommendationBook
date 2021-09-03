
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class PersonsGroupsDAOOutro {

	public DB db;

	public PersonsGroupsDAOOutro(DB db) {
		this.db = db;
	}

	public String getGroupMembers(Long groupId) throws Exception {
		List list = new ArrayList();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT (SELECT id FROM Persons WHERE id=PersonsGroups.person) as id, (SELECT CONCAT(Persons.firstName,' ',Persons.lastName) FROM Persons WHERE id=PersonsGroups.person) as name FROM PersonsGroups WHERE groupID = ?");
		ps.setLong(1, groupId);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			GroupMembers groupMembers = new GroupMembers();

			groupMembers.setId(result.getLong("id"));
			groupMembers.setName(result.getString("name"));

			list.add(groupMembers);
		}

		String members = "";

		Iterator itr = list.iterator();

		if(list.isEmpty()) {
			members = "<dd class=\"user\">None</dd>";
		} else {
			while(itr.hasNext()) {
				GroupMembers groupMembers = (GroupMembers) itr.next();
				members += "<dd class=\"user\"><a href=\"Persons.jsp?id="+groupMembers.getId()+"\">"+groupMembers.getName()+"</a></dd>";
			}
		}

		return members;
	}

}