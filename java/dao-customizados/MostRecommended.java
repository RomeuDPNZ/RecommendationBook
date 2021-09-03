
package recBook;

public class MostRecommended {

	private Long id;
	private String name;
	private Long recommendations;
	private Long idRecommender;
	private String recommender;

	public MostRecommended() {
	}

	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Long getRecommendations() {
		return this.recommendations;
	}

	public void setRecommendations(Long recommendations) {
		this.recommendations = recommendations;
	}

	public Long getIdRecommender() {
		return this.idRecommender;
	}

	public void setIdRecommender(Long idRecommender) {
		this.idRecommender = idRecommender;
	}

	public String getRecommender() {
		return this.recommender;
	}

	public void setRecommender(String recommender) {
		this.recommender = recommender;
	}

}