
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PageViewsDAOOutro {

	public PageViewsDAOOutro() {

	}

	public void incrementPageViews(String page) throws Exception {
		DB db = new DB();
		db.ConectaDB();

		PreparedStatement ps = db.conexao.prepareStatement("UPDATE PageViews SET pageViews = pageViews + 1 WHERE page = ?");
		ps.setString(1, page);
		ps.executeUpdate();

		db.DesconectaDB();
	}

}