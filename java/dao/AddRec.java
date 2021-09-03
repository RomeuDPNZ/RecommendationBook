
package recBook;

import java.util.Date;
import java.text.SimpleDateFormat;

public class AddRec {

	private Long id;
	private Long recommender;
	private Long addRec;
	private Integer action;
	private Date createdOn;


	public AddRec() {
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

	public Long getAddRec() {
		return this.addRec;
	}

	public void setAddRec(Long addRec) {
		this.addRec = addRec;
	}

	public Integer getAction() {
		return this.action;
	}

	public void setAction(Integer action) {
		this.action = action;
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