
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class LoginDAO {

	public DB db;

	public LoginDAO(DB db) {
		this.db = db;
	}

	public Long insert(Login login) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("INSERT INTO Login (email,password,role) VALUES(?,?,?)");
		ps.setString(1, login.getEmail());
		ps.setBytes(2, login.getPassword());
		ps.setString(3, login.getRoleToMySQL());
		ps.executeUpdate();

		Long lastInsertId = 0l;

		ps = db.conexao.prepareStatement("SELECT LAST_INSERT_ID()");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			lastInsertId = result.getLong(1);
		}

		return lastInsertId;
	}

	public Login select(Long id) throws Exception {
		Login login = new Login();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM Login WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			login.setId(result.getLong("id"));
			login.setEmail(result.getString("email"));
			login.setPassword(result.getBytes("password"));
			login.setRoleFromMySQL(result.getString("role"));
			login.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			login.setCreatedOnFromMySQL(result.getString("createdOn"));
		}

		return login;
	}

	public void update(Login login) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("UPDATE Login SET email = ?,password = ?,role = ? WHERE id = ?");
		ps.setString(1, login.getEmail());
		ps.setBytes(2, login.getPassword());
		ps.setString(3, login.getRoleToMySQL());
		ps.setLong(4, login.getId());
		ps.executeUpdate();

	}

	public void updateOnlyChanged(Login login) throws Exception {
		PreparedStatement ps;
		Login loginAtual = select(login.getId());

		if(loginAtual.getId().equals(login.getId())) {

			if(!loginAtual.getEmail().equals(login.getEmail())) {
				ps = db.conexao.prepareStatement("UPDATE Login SET email = ? WHERE id = ?");
				ps.setString(1, login.getEmail());
				ps.setLong(2, login.getId());
				ps.executeUpdate();
			}

			if(!loginAtual.getPassword().equals(login.getPassword())) {
				ps = db.conexao.prepareStatement("UPDATE Login SET password = ? WHERE id = ?");
				ps.setBytes(1, login.getPassword());
				ps.setLong(2, login.getId());
				ps.executeUpdate();
			}

			if(!loginAtual.getRoleToMySQL().equals(login.getRoleToMySQL())) {
				ps = db.conexao.prepareStatement("UPDATE Login SET role = ? WHERE id = ?");
				ps.setString(1, login.getRoleToMySQL());
				ps.setLong(2, login.getId());
				ps.executeUpdate();
			}

		}
	}

	public void delete(Login login) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM Login WHERE id = ?");
		ps.setLong(1, login.getId());
		ps.executeUpdate();
	}

	public void delete(Long id) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM Login WHERE id = ?");
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

		ResultSet result = db.Consulta("SELECT * FROM Login LIMIT "+from+","+to+"");

		while(result.next()) {
			Login login = new Login();
			login.setId(result.getLong("id"));
			login.setEmail(result.getString("email"));
			login.setPassword(result.getBytes("password"));
			login.setRoleFromMySQL(result.getString("role"));
			login.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			login.setCreatedOnFromMySQL(result.getString("createdOn"));

			list.add(login);

		}

		return list;
	}

	public Long getCount() throws Exception {
		Long count = 0l;

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM Login");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			count = result.getLong(1);
		}

		return count;
	}

}