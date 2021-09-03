
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AwaitingConfirmationDAO {

	public DB db;

	public AwaitingConfirmationDAO(DB db) {
		this.db = db;
	}

	public Long insert(AwaitingConfirmation awaitingConfirmation) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("INSERT INTO AwaitingConfirmation (email,password,role,code,nickName,sex,country,birthDate,officialWebsite,about,extensionImage,image) VALUES(?,?,?,?,?,?,?,?,?,?,?,?)");
		ps.setString(1, awaitingConfirmation.getEmail());
		ps.setBytes(2, awaitingConfirmation.getPassword());
		ps.setString(3, awaitingConfirmation.getRoleToMySQL());
		ps.setString(4, awaitingConfirmation.getCode());
		ps.setString(5, awaitingConfirmation.getNickName());
		ps.setString(6, awaitingConfirmation.getSexToMySQL());
		ps.setInt(7, awaitingConfirmation.getCountry());
		ps.setString(8, awaitingConfirmation.getBirthDateToMySQL());
		ps.setString(9, awaitingConfirmation.getOfficialWebsite());
		ps.setString(10, awaitingConfirmation.getAbout());
		ps.setString(11, awaitingConfirmation.getExtensionImage());
		ps.setBytes(12, awaitingConfirmation.getImage());
		ps.executeUpdate();

		Long lastInsertId = 0l;

		ps = db.conexao.prepareStatement("SELECT LAST_INSERT_ID()");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			lastInsertId = result.getLong(1);
		}

		return lastInsertId;
	}

	public AwaitingConfirmation select(Long id) throws Exception {
		AwaitingConfirmation awaitingConfirmation = new AwaitingConfirmation();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM AwaitingConfirmation WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			awaitingConfirmation.setId(result.getLong("id"));
			awaitingConfirmation.setEmail(result.getString("email"));
			awaitingConfirmation.setPassword(result.getBytes("password"));
			awaitingConfirmation.setRoleFromMySQL(result.getString("role"));
			awaitingConfirmation.setCode(result.getString("code"));
			awaitingConfirmation.setNickName(result.getString("nickName"));
			awaitingConfirmation.setSexFromMySQL(result.getString("sex"));
			awaitingConfirmation.setCountry(result.getInt("country"));
			awaitingConfirmation.setBirthDateFromMySQL(result.getString("birthDate"));
			awaitingConfirmation.setOfficialWebsite(result.getString("officialWebsite"));
			awaitingConfirmation.setAbout(result.getString("about"));
			awaitingConfirmation.setExtensionImage(result.getString("extensionImage"));
			awaitingConfirmation.setImage(result.getBytes("image"));
			awaitingConfirmation.setCreatedOnFromMySQL(result.getString("createdOn"));
		}

		return awaitingConfirmation;
	}

	public void update(AwaitingConfirmation awaitingConfirmation) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("UPDATE AwaitingConfirmation SET email = ?,password = ?,role = ?,code = ?,nickName = ?,sex = ?,country = ?,birthDate = ?,officialWebsite = ?,about = ?,extensionImage = ?,image = ? WHERE id = ?");
		ps.setString(1, awaitingConfirmation.getEmail());
		ps.setBytes(2, awaitingConfirmation.getPassword());
		ps.setString(3, awaitingConfirmation.getRoleToMySQL());
		ps.setString(4, awaitingConfirmation.getCode());
		ps.setString(5, awaitingConfirmation.getNickName());
		ps.setString(6, awaitingConfirmation.getSexToMySQL());
		ps.setInt(7, awaitingConfirmation.getCountry());
		ps.setString(8, awaitingConfirmation.getBirthDateToMySQL());
		ps.setString(9, awaitingConfirmation.getOfficialWebsite());
		ps.setString(10, awaitingConfirmation.getAbout());
		ps.setString(11, awaitingConfirmation.getExtensionImage());
		ps.setBytes(12, awaitingConfirmation.getImage());
		ps.setLong(13, awaitingConfirmation.getId());
		ps.executeUpdate();

	}

	public void updateOnlyChanged(AwaitingConfirmation awaitingConfirmation) throws Exception {
		PreparedStatement ps;
		AwaitingConfirmation awaitingConfirmationAtual = select(awaitingConfirmation.getId());

		if(awaitingConfirmationAtual.getId().equals(awaitingConfirmation.getId())) {

			if(!awaitingConfirmationAtual.getEmail().equals(awaitingConfirmation.getEmail())) {
				ps = db.conexao.prepareStatement("UPDATE AwaitingConfirmation SET email = ? WHERE id = ?");
				ps.setString(1, awaitingConfirmation.getEmail());
				ps.setLong(2, awaitingConfirmation.getId());
				ps.executeUpdate();
			}

			if(!awaitingConfirmationAtual.getPassword().equals(awaitingConfirmation.getPassword())) {
				ps = db.conexao.prepareStatement("UPDATE AwaitingConfirmation SET password = ? WHERE id = ?");
				ps.setBytes(1, awaitingConfirmation.getPassword());
				ps.setLong(2, awaitingConfirmation.getId());
				ps.executeUpdate();
			}

			if(!awaitingConfirmationAtual.getRoleToMySQL().equals(awaitingConfirmation.getRoleToMySQL())) {
				ps = db.conexao.prepareStatement("UPDATE AwaitingConfirmation SET role = ? WHERE id = ?");
				ps.setString(1, awaitingConfirmation.getRoleToMySQL());
				ps.setLong(2, awaitingConfirmation.getId());
				ps.executeUpdate();
			}

			if(!awaitingConfirmationAtual.getCode().equals(awaitingConfirmation.getCode())) {
				ps = db.conexao.prepareStatement("UPDATE AwaitingConfirmation SET code = ? WHERE id = ?");
				ps.setString(1, awaitingConfirmation.getCode());
				ps.setLong(2, awaitingConfirmation.getId());
				ps.executeUpdate();
			}

			if(!awaitingConfirmationAtual.getNickName().equals(awaitingConfirmation.getNickName())) {
				ps = db.conexao.prepareStatement("UPDATE AwaitingConfirmation SET nickName = ? WHERE id = ?");
				ps.setString(1, awaitingConfirmation.getNickName());
				ps.setLong(2, awaitingConfirmation.getId());
				ps.executeUpdate();
			}

			if(!awaitingConfirmationAtual.getSexToMySQL().equals(awaitingConfirmation.getSexToMySQL())) {
				ps = db.conexao.prepareStatement("UPDATE AwaitingConfirmation SET sex = ? WHERE id = ?");
				ps.setString(1, awaitingConfirmation.getSexToMySQL());
				ps.setLong(2, awaitingConfirmation.getId());
				ps.executeUpdate();
			}

			if(!awaitingConfirmationAtual.getCountry().equals(awaitingConfirmation.getCountry())) {
				ps = db.conexao.prepareStatement("UPDATE AwaitingConfirmation SET country = ? WHERE id = ?");
				ps.setInt(1, awaitingConfirmation.getCountry());
				ps.setLong(2, awaitingConfirmation.getId());
				ps.executeUpdate();
			}

			if(!awaitingConfirmationAtual.getBirthDateToMySQL().equals(awaitingConfirmation.getBirthDateToMySQL())) {
				ps = db.conexao.prepareStatement("UPDATE AwaitingConfirmation SET birthDate = ? WHERE id = ?");
				ps.setString(1, awaitingConfirmation.getBirthDateToMySQL());
				ps.setLong(2, awaitingConfirmation.getId());
				ps.executeUpdate();
			}

			if(!awaitingConfirmationAtual.getOfficialWebsite().equals(awaitingConfirmation.getOfficialWebsite())) {
				ps = db.conexao.prepareStatement("UPDATE AwaitingConfirmation SET officialWebsite = ? WHERE id = ?");
				ps.setString(1, awaitingConfirmation.getOfficialWebsite());
				ps.setLong(2, awaitingConfirmation.getId());
				ps.executeUpdate();
			}

			if(!awaitingConfirmationAtual.getAbout().equals(awaitingConfirmation.getAbout())) {
				ps = db.conexao.prepareStatement("UPDATE AwaitingConfirmation SET about = ? WHERE id = ?");
				ps.setString(1, awaitingConfirmation.getAbout());
				ps.setLong(2, awaitingConfirmation.getId());
				ps.executeUpdate();
			}

			if(!awaitingConfirmationAtual.getExtensionImage().equals(awaitingConfirmation.getExtensionImage())) {
				ps = db.conexao.prepareStatement("UPDATE AwaitingConfirmation SET extensionImage = ? WHERE id = ?");
				ps.setString(1, awaitingConfirmation.getExtensionImage());
				ps.setLong(2, awaitingConfirmation.getId());
				ps.executeUpdate();
			}

			if(!awaitingConfirmationAtual.getImage().equals(awaitingConfirmation.getImage())) {
				ps = db.conexao.prepareStatement("UPDATE AwaitingConfirmation SET image = ? WHERE id = ?");
				ps.setBytes(1, awaitingConfirmation.getImage());
				ps.setLong(2, awaitingConfirmation.getId());
				ps.executeUpdate();
			}

		}
	}

	public void delete(AwaitingConfirmation awaitingConfirmation) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM AwaitingConfirmation WHERE id = ?");
		ps.setLong(1, awaitingConfirmation.getId());
		ps.executeUpdate();
	}

	public void delete(Long id) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM AwaitingConfirmation WHERE id = ?");
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

		ResultSet result = db.Consulta("SELECT * FROM AwaitingConfirmation LIMIT "+from+","+to+"");

		while(result.next()) {
			AwaitingConfirmation awaitingConfirmation = new AwaitingConfirmation();
			awaitingConfirmation.setId(result.getLong("id"));
			awaitingConfirmation.setEmail(result.getString("email"));
			awaitingConfirmation.setPassword(result.getBytes("password"));
			awaitingConfirmation.setRoleFromMySQL(result.getString("role"));
			awaitingConfirmation.setCode(result.getString("code"));
			awaitingConfirmation.setNickName(result.getString("nickName"));
			awaitingConfirmation.setSexFromMySQL(result.getString("sex"));
			awaitingConfirmation.setCountry(result.getInt("country"));
			awaitingConfirmation.setBirthDateFromMySQL(result.getString("birthDate"));
			awaitingConfirmation.setOfficialWebsite(result.getString("officialWebsite"));
			awaitingConfirmation.setAbout(result.getString("about"));
			awaitingConfirmation.setExtensionImage(result.getString("extensionImage"));
			awaitingConfirmation.setImage(result.getBytes("image"));
			awaitingConfirmation.setCreatedOnFromMySQL(result.getString("createdOn"));

			list.add(awaitingConfirmation);

		}

		return list;
	}

	public Long getCount() throws Exception {
		Long count = 0l;

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM AwaitingConfirmation");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			count = result.getLong(1);
		}

		return count;
	}

}