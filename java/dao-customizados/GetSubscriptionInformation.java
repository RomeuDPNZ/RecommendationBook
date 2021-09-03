
package recBook;

import java.util.Date;
import java.text.SimpleDateFormat;

public class GetSubscriptionInformation {

	private String nickName;
	private Long nickNameId;
	private String action;
	private String thing;
	private Long thingId;
	private Date createdOn;

	public GetSubscriptionInformation() {
	}

	public String getNickName() {
		return this.nickName;
	}

	public void setNickName(String nickName) {
		this.nickName = nickName;
	}

	public Long getNickNameId() {
		return this.nickNameId;
	}

	public void setNickNameId(Long nickNameId) {
		this.nickNameId = nickNameId;
	}

	public String getAction() {
		return this.action;
	}

	public void setAction(String action) {
		this.action = action;
	}

	public String getThing() {
		return this.thing;
	}

	public void setThing(String thing) {
		this.thing = thing;
	}

	public Long getThingId() {
		return this.thingId;
	}

	public void setThingId(Long thingId) {
		this.thingId = thingId;
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