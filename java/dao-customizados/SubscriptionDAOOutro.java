
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class SubscriptionDAOOutro {

	public DB db;

	public SubscriptionDAOOutro(DB db) {
		this.db = db;
	}

	public Long getSubscribers(Long id) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM Subscription WHERE recommender = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		Long subscribers = 0l;

		while(result.next()) {
			subscribers = result.getLong(1);
		}

		return subscribers;
	}

	public Long getSubscribed(Long id) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM Subscription WHERE subscriber = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		Long subscribed = 0l;

		while(result.next()) {
			subscribed = result.getLong(1);
		}

		return subscribed;
	}

	public Long isSubscribed(Long recommender, Long subscriber) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT id FROM Subscription WHERE recommender = ? AND subscriber = ?");
		ps.setLong(1, recommender);
		ps.setLong(2, subscriber);
		ResultSet result = ps.executeQuery();

		Long subscribedId = 0l;

		while(result.next()) {
			subscribedId = result.getLong("id");
		}

		return subscribedId;
	}

}