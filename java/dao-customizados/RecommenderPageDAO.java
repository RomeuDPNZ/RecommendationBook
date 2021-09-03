
package recBook;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.io.File;

public class RecommenderPageDAO {

	private Recommender recommender;
	private String country;
	private String age;
	private String imagem;
	private String officialWebsite;
	private String about;
	private Integer action;
	private Long recommended;
	private Long subscribed;
	private Long timesRecommended;
	private Long subscribers;
	private Long hasSubscribedTo;

	public RecommenderPageDAO(DB db, Long recommenderIdLogged, Long recommenderIdShowed) throws Exception {
		action = 0;
		recommended = 0l;
		subscribed = 0l;
		RecommenderDAO recommenderDAO = new RecommenderDAO(db);

		action = new ActionsDAOOutro(db).getActionId("Recommended the Recommender");

		recommended = new AddRecDAOOutro(db).isRecommender(recommenderIdLogged, recommenderIdShowed, action);

		subscribed = new SubscriptionDAOOutro(db).isSubscribed(recommenderIdShowed, recommenderIdLogged);

		recommender = recommenderDAO.select(recommenderIdShowed);

		age = new RecommenderUtils().getAge(recommender.getBirthDate());

		Countries countries = new Countries();
		CountriesDAO countriesDAO = new CountriesDAO(db);
		countries = countriesDAO.select(Long.valueOf(recommender.getCountry()));
		country = countries.getCountry();

		if(recommender.getOfficialWebsite() == null || recommender.getOfficialWebsite().equals("")) {
			officialWebsite = "Website Pending";
		} else {
			officialWebsite = recommender.getOfficialWebsite();
		}

		if(recommender.getAbout() == null || recommender.getAbout().equals("")) {
			about = "About Pending";
		} else {
			about = recommender.getAbout().replace("\n", "<br />");
		}

		AddRecDAOOutro addRecDAOOutro = new AddRecDAOOutro(db);
		timesRecommended = addRecDAOOutro.recommended(recommender.getId());

		SubscriptionDAOOutro subscriptionDAOOutro = new SubscriptionDAOOutro(db);
		subscribers = subscriptionDAOOutro.getSubscribers(recommenderIdShowed);
		hasSubscribedTo = subscriptionDAOOutro.getSubscribed(recommenderIdShowed);

	}

	public Recommender getRecommender() {
		return this.recommender;
	}

	public Integer getAction() {
		return this.action;
	}

	public Long getRecommended() {
		return this.recommended;
	}

	public Long getSubscribed() {
		return this.subscribed;
	}

	public String getCountry() {
		return this.country;
	}

	public String getAge() {
		return this.age;
	}

	public String getImagem() {
		return this.imagem;
	}

	public String getOfficialWebsite() {
		return this.officialWebsite;
	}

	public String getAbout() {
		return this.about;
	}

	public Long getTimesRecommended() {
		return this.timesRecommended;
	}

	public Long getSubscribers() {
		return this.subscribers;
	}

	public Long getHasSubscribedTo() {
		return this.hasSubscribedTo;
	}

}