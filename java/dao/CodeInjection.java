
package recBook;

import java.util.Date;
import java.text.SimpleDateFormat;

public class CodeInjection {

	private Long id;
	private Long recommender;
	private String ip;
	private String codeInjection;
	private Date lastUpdatedOn;
	private Date createdOn;


	public CodeInjection() {
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

	public String getIp() {
		return this.ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public String getCodeInjection() {
		return this.codeInjection;
	}

	public void setCodeInjection(String codeInjection) {
		this.codeInjection = codeInjection;
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