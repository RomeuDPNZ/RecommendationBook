
package recBook;

import java.util.Date;
import java.text.SimpleDateFormat;

public class Errors {

	private Long id;
	private String message;
	private String stacktrace;
	private Date lastUpdatedOn;
	private Date createdOn;


	public Errors() {
	}

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getMessage() {
		return this.message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getStacktrace() {
		return this.stacktrace;
	}

	public void setStacktrace(String stacktrace) {
		this.stacktrace = stacktrace;
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