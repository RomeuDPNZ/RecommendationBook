
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CountriesDAO {

	public DB db;

	public CountriesDAO(DB db) {
		this.db = db;
	}

	public Long insert(Countries countries) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("INSERT INTO Countries (country) VALUES(?)");
		ps.setString(1, countries.getCountry());
		ps.executeUpdate();

		Long lastInsertId = 0l;

		ps = db.conexao.prepareStatement("SELECT LAST_INSERT_ID()");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			lastInsertId = result.getLong(1);
		}

		return lastInsertId;
	}

	public Countries select(Long id) throws Exception {
		Countries countries = new Countries();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM Countries WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			countries.setId(result.getLong("id"));
			countries.setCountry(result.getString("country"));
		}

		return countries;
	}

	public void update(Countries countries) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("UPDATE Countries SET country = ? WHERE id = ?");
		ps.setString(1, countries.getCountry());
		ps.setLong(2, countries.getId());
		ps.executeUpdate();

	}

	public void updateOnlyChanged(Countries countries) throws Exception {
		PreparedStatement ps;
		Countries countriesAtual = select(countries.getId());

		if(countriesAtual.getId().equals(countries.getId())) {

			if(!countriesAtual.getCountry().equals(countries.getCountry())) {
				ps = db.conexao.prepareStatement("UPDATE Countries SET country = ? WHERE id = ?");
				ps.setString(1, countries.getCountry());
				ps.setLong(2, countries.getId());
				ps.executeUpdate();
			}

		}
	}

	public void delete(Countries countries) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM Countries WHERE id = ?");
		ps.setLong(1, countries.getId());
		ps.executeUpdate();
	}

	public void delete(Long id) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM Countries WHERE id = ?");
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

		ResultSet result = db.Consulta("SELECT * FROM Countries LIMIT "+from+","+to+"");

		while(result.next()) {
			Countries countries = new Countries();
			countries.setId(result.getLong("id"));
			countries.setCountry(result.getString("country"));

			list.add(countries);

		}

		return list;
	}

	public Long getCount() throws Exception {
		Long count = 0l;

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM Countries");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			count = result.getLong(1);
		}

		return count;
	}

}