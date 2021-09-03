
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class EmailDAO {

	public EmailDAO() {

	}

	public Login select(String email) throws Exception {
		Login login = new Login();
		DB db = new DB();
		db.ConectaDB();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM Login WHERE email = ?");
		ps.setString(1, email);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			login.setId(result.getLong("id"));
			login.setEmail(result.getString("email"));
			login.setPassword(result.getBytes("password"));
			login.setRoleFromMySQL(result.getString("role"));
			login.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			login.setCreatedOnFromMySQL(result.getString("createdOn"));
		}

		db.DesconectaDB();

		return login;
	}

	public Long isEmailAlreadyRegistered(String email) throws Exception {
		DB db = new DB();
		db.ConectaDB();

		Long wasFinded = 0l;

		try {
			PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) AS wasFinded FROM Login WHERE email = ?");
			ps.setString(1, email);
			ResultSet result = ps.executeQuery();

			while(result.next()) {

				wasFinded = result.getLong("wasFinded");

			}

		} catch(SQLException e) {
			System.err.println("SQLException: "+e.getMessage());
		} finally { }

		return wasFinded;
	}

}