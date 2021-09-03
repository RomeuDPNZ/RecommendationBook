
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CodeInjectionDAO {

	public DB db;

	public CodeInjectionDAO(DB db) {
		this.db = db;
	}

	public Long insert(CodeInjection codeInjection) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("INSERT INTO CodeInjection (recommender,ip,codeInjection) VALUES(?,?,?)");
		ps.setLong(1, codeInjection.getRecommender());
		ps.setString(2, codeInjection.getIp());
		ps.setString(3, codeInjection.getCodeInjection());
		ps.executeUpdate();

		Long lastInsertId = 0l;

		ps = db.conexao.prepareStatement("SELECT LAST_INSERT_ID()");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			lastInsertId = result.getLong(1);
		}

		return lastInsertId;
	}

	public CodeInjection select(Long id) throws Exception {
		CodeInjection codeInjection = new CodeInjection();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM CodeInjection WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			codeInjection.setId(result.getLong("id"));
			codeInjection.setRecommender(result.getLong("recommender"));
			codeInjection.setIp(result.getString("ip"));
			codeInjection.setCodeInjection(result.getString("codeInjection"));
			codeInjection.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			codeInjection.setCreatedOnFromMySQL(result.getString("createdOn"));
		}

		return codeInjection;
	}

	public void update(CodeInjection codeInjection) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("UPDATE CodeInjection SET recommender = ?,ip = ?,codeInjection = ? WHERE id = ?");
		ps.setLong(1, codeInjection.getRecommender());
		ps.setString(2, codeInjection.getIp());
		ps.setString(3, codeInjection.getCodeInjection());
		ps.setLong(4, codeInjection.getId());
		ps.executeUpdate();

	}

	public void updateOnlyChanged(CodeInjection codeInjection) throws Exception {
		PreparedStatement ps;
		CodeInjection codeInjectionAtual = select(codeInjection.getId());

		if(codeInjectionAtual.getId().equals(codeInjection.getId())) {

			if(!codeInjectionAtual.getRecommender().equals(codeInjection.getRecommender())) {
				ps = db.conexao.prepareStatement("UPDATE CodeInjection SET recommender = ? WHERE id = ?");
				ps.setLong(1, codeInjection.getRecommender());
				ps.setLong(2, codeInjection.getId());
				ps.executeUpdate();
			}

			if(!codeInjectionAtual.getIp().equals(codeInjection.getIp())) {
				ps = db.conexao.prepareStatement("UPDATE CodeInjection SET ip = ? WHERE id = ?");
				ps.setString(1, codeInjection.getIp());
				ps.setLong(2, codeInjection.getId());
				ps.executeUpdate();
			}

			if(!codeInjectionAtual.getCodeInjection().equals(codeInjection.getCodeInjection())) {
				ps = db.conexao.prepareStatement("UPDATE CodeInjection SET codeInjection = ? WHERE id = ?");
				ps.setString(1, codeInjection.getCodeInjection());
				ps.setLong(2, codeInjection.getId());
				ps.executeUpdate();
			}

		}
	}

	public void delete(CodeInjection codeInjection) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM CodeInjection WHERE id = ?");
		ps.setLong(1, codeInjection.getId());
		ps.executeUpdate();
	}

	public void delete(Long id) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM CodeInjection WHERE id = ?");
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

		ResultSet result = db.Consulta("SELECT * FROM CodeInjection LIMIT "+from+","+to+"");

		while(result.next()) {
			CodeInjection codeInjection = new CodeInjection();
			codeInjection.setId(result.getLong("id"));
			codeInjection.setRecommender(result.getLong("recommender"));
			codeInjection.setIp(result.getString("ip"));
			codeInjection.setCodeInjection(result.getString("codeInjection"));
			codeInjection.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			codeInjection.setCreatedOnFromMySQL(result.getString("createdOn"));

			list.add(codeInjection);

		}

		return list;
	}

	public Long getCount() throws Exception {
		Long count = 0l;

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM CodeInjection");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			count = result.getLong(1);
		}

		return count;
	}

}