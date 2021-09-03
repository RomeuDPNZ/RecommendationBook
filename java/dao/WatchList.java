
package recBook;

import java.util.Date;
import java.text.SimpleDateFormat;

public class WatchList {

	private Long id;
	private Long movie;
	private Long recommender;
	private StateWatch stateWatch;
	private Date lastUpdatedOn;
	private Date createdOn;


	public WatchList() {
	}

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getMovie() {
		return this.movie;
	}

	public void setMovie(Long movie) {
		this.movie = movie;
	}

	public Long getRecommender() {
		return this.recommender;
	}

	public void setRecommender(Long recommender) {
		this.recommender = recommender;
	}

	public StateWatch getStateWatch() {
		return this.stateWatch;
	}

	public void setStateWatch(StateWatch stateWatch) {
		this.stateWatch = stateWatch;
	}

	public String getStateWatchToMySQL() {
		return this.getStateWatch().toString();
	}

	public void setStateWatchFromMySQL(String stateWatch) {
		this.setStateWatch(StateWatch.valueOf(stateWatch));
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