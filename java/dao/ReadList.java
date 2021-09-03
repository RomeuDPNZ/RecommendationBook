
package recBook;

import java.util.Date;
import java.text.SimpleDateFormat;

public class ReadList {

	private Long id;
	private Long book;
	private Long recommender;
	private StateRead stateRead;
	private Date lastUpdatedOn;
	private Date createdOn;


	public ReadList() {
	}

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getBook() {
		return this.book;
	}

	public void setBook(Long book) {
		this.book = book;
	}

	public Long getRecommender() {
		return this.recommender;
	}

	public void setRecommender(Long recommender) {
		this.recommender = recommender;
	}

	public StateRead getStateRead() {
		return this.stateRead;
	}

	public void setStateRead(StateRead stateRead) {
		this.stateRead = stateRead;
	}

	public String getStateReadToMySQL() {
		return this.getStateRead().toString();
	}

	public void setStateReadFromMySQL(String stateRead) {
		this.setStateRead(StateRead.valueOf(stateRead));
	}

	public Date getLastUpdatedOn() {
		return this.lastUpdatedOn;
	}

	public void setLastUpdatedOn(Date lastUpdatedOn) {
		this.lastUpdatedOn = lastUpdatedOn;
	}

	public String getLastUpdatedOnToMySQL() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return sdf.format(this.getLastUpdatedOn()).toString();
	}

	public void setLastUpdatedOnFromMySQL(String lastUpdatedOn) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		this.setLastUpdatedOn(sdf.parse(lastUpdatedOn));
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