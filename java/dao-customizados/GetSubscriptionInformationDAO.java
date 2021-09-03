
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class GetSubscriptionInformationDAO {

	public DB db;

	public GetSubscriptionInformationDAO(DB db) {
		this.db = db;
	}

	public List getList(Long recommenderId, Integer limitFrom, Integer limitTo, String age) throws Exception {
		List subscription = new ArrayList();

		PreparedStatement ps = db.conexao.prepareStatement("CALL getSubscriptionInformation(?,?,?,?)");
		ps.setLong(1, recommenderId);
		ps.setInt(2, limitFrom);
		ps.setInt(3, limitTo);
		ps.setInt(4, Integer.valueOf(age));
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			GetSubscriptionInformation s = new GetSubscriptionInformation();

			s.setNickName(result.getString("nickName"));
			s.setNickNameId(result.getLong("id"));
			s.setAction(result.getString("RAction"));
			s.setThing(result.getString("thingName"));
			s.setThingId(result.getLong("thingId"));
			s.setCreatedOnFromMySQL(result.getString("createdOn"));

			subscription.add(s);
		}

		return subscription;
	}

}