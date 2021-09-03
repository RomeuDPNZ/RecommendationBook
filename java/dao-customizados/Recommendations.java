
package recBook;

import java.util.Date;
import java.text.SimpleDateFormat;

public class Recommendations {

	private Long id;
	private String recommended;
	private Long recommendations;
	private Date createdOn;

	public Recommendations() {
	}

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getRecommended() {
		return this.recommended;
	}

	public void setRecommended(String recommended) {
		this.recommended = recommended;
	}

	public Long getRecommendations() {
		return this.recommendations;
	}

	public void setRecommendations(Long recommendations) {
		this.recommendations = recommendations;
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