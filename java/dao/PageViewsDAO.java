
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PageViewsDAO {

	public DB db;

	public PageViewsDAO(DB db) {
		this.db = db;
	}

	public Long insert(PageViews pageViews) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("INSERT INTO PageViews (page,pageViews) VALUES(?,?)");
		ps.setString(1, pageViews.getPage());
		ps.setLong(2, pageViews.getPageViews());
		ps.executeUpdate();

		Long lastInsertId = 0l;

		ps = db.conexao.prepareStatement("SELECT LAST_INSERT_ID()");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			lastInsertId = result.getLong(1);
		}

		return lastInsertId;
	}

	public PageViews select(Long id) throws Exception {
		PageViews pageViews = new PageViews();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM PageViews WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			pageViews.setId(result.getLong("id"));
			pageViews.setPage(result.getString("page"));
			pageViews.setPageViews(result.getLong("pageViews"));
			pageViews.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			pageViews.setCreatedOnFromMySQL(result.getString("createdOn"));
		}

		return pageViews;
	}

	public void update(PageViews pageViews) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("UPDATE PageViews SET page = ?,pageViews = ? WHERE id = ?");
		ps.setString(1, pageViews.getPage());
		ps.setLong(2, pageViews.getPageViews());
		ps.setLong(3, pageViews.getId());
		ps.executeUpdate();

	}

	public void updateOnlyChanged(PageViews pageViews) throws Exception {
		PreparedStatement ps;
		PageViews pageViewsAtual = select(pageViews.getId());

		if(pageViewsAtual.getId().equals(pageViews.getId())) {

			if(!pageViewsAtual.getPage().equals(pageViews.getPage())) {
				ps = db.conexao.prepareStatement("UPDATE PageViews SET page = ? WHERE id = ?");
				ps.setString(1, pageViews.getPage());
				ps.setLong(2, pageViews.getId());
				ps.executeUpdate();
			}

			if(!pageViewsAtual.getPageViews().equals(pageViews.getPageViews())) {
				ps = db.conexao.prepareStatement("UPDATE PageViews SET pageViews = ? WHERE id = ?");
				ps.setLong(1, pageViews.getPageViews());
				ps.setLong(2, pageViews.getId());
				ps.executeUpdate();
			}

		}
	}

	public void delete(PageViews pageViews) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM PageViews WHERE id = ?");
		ps.setLong(1, pageViews.getId());
		ps.executeUpdate();
	}

	public void delete(Long id) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM PageViews WHERE id = ?");
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

		ResultSet result = db.Consulta("SELECT * FROM PageViews LIMIT "+from+","+to+"");

		while(result.next()) {
			PageViews pageViews = new PageViews();
			pageViews.setId(result.getLong("id"));
			pageViews.setPage(result.getString("page"));
			pageViews.setPageViews(result.getLong("pageViews"));
			pageViews.setLastUpdatedOnFromMySQL(result.getString("lastUpdatedOn"));
			pageViews.setCreatedOnFromMySQL(result.getString("createdOn"));

			list.add(pageViews);

		}

		return list;
	}

	public Long getCount() throws Exception {
		Long count = 0l;

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM PageViews");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			count = result.getLong(1);
		}

		return count;
	}

}