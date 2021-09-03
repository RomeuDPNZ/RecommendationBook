
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ErrorsDAO {

	public DB db;

	public ErrorsDAO(DB db) {
		this.db = db;
	}

	public Long insert(Errors errors) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("INSERT INTO Errors (message,stacktrace) VALUES(?,?)");
		ps.setString(1, errors.getMessage());
		ps.setString(2, errors.getStacktrace());
		ps.executeUpdate();

		Long lastInsertId = 0l;

		ps = db.conexao.prepareStatement("SELECT LAST_INSERT_ID()");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			lastInsertId = result.getLong(1);
		}

		return lastInsertId;
	}

	public Errors select(Long id) throws Exception {
		Errors errors = new Errors();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM Errors WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			errors.setId(result.getLong("id"));
			errors.setMessage(result.getString("message"));
			errors.setStacktrace(result.getString("stacktrace"));
			errors.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			errors.setCreatedOnFromMySQL(result.getString("createdOn"));
		}

		return errors;
	}

	public void update(Errors errors) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("UPDATE Errors SET message = ?,stacktrace = ? WHERE id = ?");
		ps.setString(1, errors.getMessage());
		ps.setString(2, errors.getStacktrace());
		ps.setLong(3, errors.getId());
		ps.executeUpdate();

	}

	public void updateOnlyChanged(Errors errors) throws Exception {
		PreparedStatement ps;
		Errors errorsAtual = select(errors.getId());

		if(errorsAtual.getId().equals(errors.getId())) {

			if(!errorsAtual.getMessage().equals(errors.getMessage())) {
				ps = db.conexao.prepareStatement("UPDATE Errors SET message = ? WHERE id = ?");
				ps.setString(1, errors.getMessage());
				ps.setLong(2, errors.getId());
				ps.executeUpdate();
			}

			if(!errorsAtual.getStacktrace().equals(errors.getStacktrace())) {
				ps = db.conexao.prepareStatement("UPDATE Errors SET stacktrace = ? WHERE id = ?");
				ps.setString(1, errors.getStacktrace());
				ps.setLong(2, errors.getId());
				ps.executeUpdate();
			}

		}
	}

	public void delete(Errors errors) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM Errors WHERE id = ?");
		ps.setLong(1, errors.getId());
		ps.executeUpdate();
	}

	public void delete(Long id) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM Errors WHERE id = ?");
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

		ResultSet result = db.Consulta("SELECT * FROM Errors LIMIT "+from+","+to+"");

		while(result.next()) {
			Errors errors = new Errors();
			errors.setId(result.getLong("id"));
			errors.setMessage(result.getString("message"));
			errors.setStacktrace(result.getString("stacktrace"));
			errors.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			errors.setCreatedOnFromMySQL(result.getString("createdOn"));

			list.add(errors);

		}

		return list;
	}

	public Long getCount() throws Exception {
		Long count = 0l;

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM Errors");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			count = result.getLong(1);
		}

		return count;
	}

}