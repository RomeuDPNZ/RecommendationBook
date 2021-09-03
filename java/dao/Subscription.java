
package recBook;

import java.util.Date;
import java.text.SimpleDateFormat;

public class Subscription {

	private Long id;
	private Long recommender;
	private Long subscriber;
	private Date createdOn;


	public Subscription() {
	}

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getRecommender() {
		return this.recommender;
	}

	public void setRecommender(Long recommender) {
		this.recommender = recommender;
	}

	public Long getSubscriber() {
		return this.subscriber;
	}

	public void setSubscriber(Long subscriber) {
		this.subscriber = subscriber;
	}

	public Date getCreatedOn() {
		return this.createdOn;
	}

	public void setCreatedOn(Date createdOn) {
		this.createdOn = createdOn;
	}

	public String getCreatedOnToMySQL() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return sdf.format(this.getCreatedOn()).toString();
	}

	public void setCreatedOnFromMySQL(String createdOn) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		this.setCreatedOn(sdf.parse(createdOn));
	}

}