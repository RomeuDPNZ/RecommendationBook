
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SubscriptionDAO {

	public DB db;

	public SubscriptionDAO(DB db) {
		this.db = db;
	}

	public Long insert(Subscription subscription) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("INSERT INTO Subscription (recommender,subscriber) VALUES(?,?)");
		ps.setLong(1, subscription.getRecommender());
		ps.setLong(2, subscription.getSubscriber());
		ps.executeUpdate();

		Long lastInsertId = 0l;

		ps = db.conexao.prepareStatement("SELECT LAST_INSERT_ID()");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			lastInsertId = result.getLong(1);
		}

		return lastInsertId;
	}

	public Subscription select(Long id) throws Exception {
		Subscription subscription = new Subscription();

		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM Subscription WHERE id = ?");
		ps.setLong(1, id);
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			subscription.setId(result.getLong("id"));
			subscription.setRecommender(result.getLong("recommender"));
			subscription.setSubscriber(result.getLong("subscriber"));
			subscription.setCreatedOnFromMySQL(result.getString("createdOn"));
		}

		return subscription;
	}

	public void update(Subscription subscription) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("UPDATE Subscription SET recommender = ?,subscriber = ? WHERE id = ?");
		ps.setLong(1, subscription.getRecommender());
		ps.setLong(2, subscription.getSubscriber());
		ps.setLong(3, subscription.getId());
		ps.executeUpdate();

	}

	public void updateOnlyChanged(Subscription subscription) throws Exception {
		PreparedStatement ps;
		Subscription subscriptionAtual = select(subscription.getId());

		if(subscriptionAtual.getId().equals(subscription.getId())) {

			if(!subscriptionAtual.getRecommender().equals(subscription.getRecommender())) {
				ps = db.conexao.prepareStatement("UPDATE Subscription SET recommender = ? WHERE id = ?");
				ps.setLong(1, subscription.getRecommender());
				ps.setLong(2, subscription.getId());
				ps.executeUpdate();
			}

			if(!subscriptionAtual.getSubscriber().equals(subscription.getSubscriber())) {
				ps = db.conexao.prepareStatement("UPDATE Subscription SET subscriber = ? WHERE id = ?");
				ps.setLong(1, subscription.getSubscriber());
				ps.setLong(2, subscription.getId());
				ps.executeUpdate();
			}

		}
	}

	public void delete(Subscription subscription) throws Exception {
		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM Subscription WHERE id = ?");
		ps.setLong(1, subscription.getId());
		ps.executeUpdate();
	}

	public void delete(Long id) throws Exception {

		PreparedStatement ps = db.conexao.prepareStatement("DELETE FROM Subscription WHERE id = ?");
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

		ResultSet result = db.Consulta("SELECT * FROM Subscription LIMIT "+from+","+to+"");

		while(result.next()) {
			Subscription subscription = new Subscription();
			subscription.setId(result.getLong("id"));
			subscription.setRecommender(result.getLong("recommender"));
			subscription.setSubscriber(result.getLong("subscriber"));
			subscription.setCreatedOnFromMySQL(result.getString("createdOn"));

			list.add(subscription);

		}

		return list;
	}

	public Long getCount() throws Exception {
		Long count = 0l;

		PreparedStatement ps = db.conexao.prepareStatement("SELECT COUNT(*) FROM Subscription");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			count = result.getLong(1);
		}

		return count;
	}

}