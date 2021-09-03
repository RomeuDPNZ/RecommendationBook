
package recBook;

import java.util.Date;
import java.text.SimpleDateFormat;

public class ListenList {

	private Long id;
	private Long album;
	private Long recommender;
	private StateListen stateListen;
	private Date lastUpdatedOn;
	private Date createdOn;


	public ListenList() {
	}

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getAlbum() {
		return this.album;
	}

	public void setAlbum(Long album) {
		this.album = album;
	}

	public Long getRecommender() {
		return this.recommender;
	}

	public void setRecommender(Long recommender) {
		this.recommender = recommender;
	}

	public StateListen getStateListen() {
		return this.stateListen;
	}

	public void setStateListen(StateListen stateListen) {
		this.stateListen = stateListen;
	}

	public String getStateListenToMySQL() {
		return this.getStateListen().toString();
	}

	public void setStateListenFromMySQL(String stateListen) {
		this.setStateListen(StateListen.valueOf(stateListen));
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