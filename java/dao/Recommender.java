
package recBook;

import java.util.Date;
import java.text.SimpleDateFormat;

public class Recommender {

	private Long id;
	private Long login;
	private Long recommendations;
	private Long pageViews;
	private String nickName;
	private Sex sex;
	private Integer country;
	private Date birthDate;
	private Boolean showSex;
	private Boolean showCountry;
	private Boolean showBirth;
	private String officialWebsite;
	private String about;
	private Date lastUpdatedOn;
	private Date createdOn;


	public Recommender() {
	}

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getLogin() {
		return this.login;
	}

	public void setLogin(Long login) {
		this.login = login;
	}

	public Long getRecommendations() {
		return this.recommendations;
	}

	public void setRecommendations(Long recommendations) {
		this.recommendations = recommendations;
	}

	public Long getPageViews() {
		return this.pageViews;
	}

	public void setPageViews(Long pageViews) {
		this.pageViews = pageViews;
	}

	public String getNickName() {
		return this.nickName;
	}

	public void setNickName(String nickName) {
		this.nickName = nickName;
	}

	public Sex getSex() {
		return this.sex;
	}

	public void setSex(Sex sex) {
		this.sex = sex;
	}

	public String getSexToMySQL() {
		return this.getSex().toString();
	}

	public void setSexFromMySQL(String sex) {
		this.setSex(Sex.valueOf(sex));
	}

	public Integer getCountry() {
		return this.country;
	}

	public void setCountry(Integer country) {
		this.country = country;
	}

	public Date getBirthDate() {
		return this.birthDate;
	}

	public void setBirthDate(Date birthDate) {
		this.birthDate = birthDate;
	}

	public String getBirthDateToMySQL() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		return sdf.format(this.getBirthDate()).toString();
	}

	public void setBirthDateFromMySQL(String birthDate) throws Exception {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		this.setBirthDate(sdf.parse(birthDate));
	}

	public Boolean getShowSex() {
		return this.showSex;
	}

	public void setShowSex(Boolean showSex) {
		this.showSex = showSex;
	}

	public Boolean getShowCountry() {
		return this.showCountry;
	}

	public void setShowCountry(Boolean showCountry) {
		this.showCountry = showCountry;
	}

	public Boolean getShowBirth() {
		return this.showBirth;
	}

	public void setShowBirth(Boolean showBirth) {
		this.showBirth = showBirth;
	}

	public String getOfficialWebsite() {
		return this.officialWebsite;
	}

	public void setOfficialWebsite(String officialWebsite) {
		this.officialWebsite = officialWebsite;
	}

	public String getAbout() {
		return this.about;
	}

	public void setAbout(String about) {
		this.about = about;
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