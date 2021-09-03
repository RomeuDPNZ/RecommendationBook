
<%!

public class MostRecommended {

	private Long id;
	private String name;
	private String recommendations;

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

	public String getRecommendations() {
		return this.recommendations;
	}

	public void setRecommendations(String recommendations) {
		this.recommendations = recommendations;
	}

}

%>

<%@ page errorPage="Error.jsp" %>

<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.IsImageRecorded" %>

<%

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	/*
	 * Select Views
	 */

	List mostRecommendedPersons = new ArrayList();

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM MostRecommendedPersons");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			MostRecommended mr = new MostRecommended();

			mr.setId(result.getLong("id"));
			mr.setName(result.getString("name"));
			mr.setRecommendations(result.getString("recommendations"));

			mostRecommendedPersons.add(mr);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	List mostRecommendedGroups = new ArrayList();

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM MostRecommendedGroups");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			MostRecommended mr = new MostRecommended();

			mr.setId(result.getLong("id"));
			mr.setName(result.getString("name"));
			mr.setRecommendations(result.getString("recommendations"));

			mostRecommendedGroups.add(mr);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	List mostRecommendedBooks = new ArrayList();

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM MostRecommendedBooks");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			MostRecommended mr = new MostRecommended();

			mr.setId(result.getLong("id"));
			mr.setName(result.getString("name"));
			mr.setRecommendations(result.getString("recommendations"));

			mostRecommendedBooks.add(mr);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	List mostRecommendedMovies = new ArrayList();

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM MostRecommendedMovies");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			MostRecommended mr = new MostRecommended();

			mr.setId(result.getLong("id"));
			mr.setName(result.getString("name"));
			mr.setRecommendations(result.getString("recommendations"));

			mostRecommendedMovies.add(mr);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	List mostRecommendedBands = new ArrayList();

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM MostRecommendedBands");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			MostRecommended mr = new MostRecommended();

			mr.setId(result.getLong("id"));
			mr.setName(result.getString("name"));
			mr.setRecommendations(result.getString("recommendations"));

			mostRecommendedBands.add(mr);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	List mostRecommendedAlbums = new ArrayList();

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM MostRecommendedAlbums");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			MostRecommended mr = new MostRecommended();

			mr.setId(result.getLong("id"));
			mr.setName(result.getString("name"));
			mr.setRecommendations(result.getString("recommendations"));

			mostRecommendedAlbums.add(mr);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	List mostRecommendedSongs = new ArrayList();

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM MostRecommendedSongs");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			MostRecommended mr = new MostRecommended();

			mr.setId(result.getLong("id"));
			mr.setName(result.getString("name"));
			mr.setRecommendations(result.getString("recommendations"));

			mostRecommendedSongs.add(mr);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	List mostRecommendedProjects = new ArrayList();

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM MostRecommendedProjects");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			MostRecommended mr = new MostRecommended();

			mr.setId(result.getLong("id"));
			mr.setName(result.getString("name"));
			mr.setRecommendations(result.getString("recommendations"));

			mostRecommendedProjects.add(mr);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	List mostRecommendedWebsites = new ArrayList();

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM MostRecommendedWebsites");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			MostRecommended mr = new MostRecommended();

			mr.setId(result.getLong("id"));
			mr.setName(result.getString("name"));
			mr.setRecommendations(result.getString("recommendations"));

			mostRecommendedWebsites.add(mr);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	List mostRecommendedCompanies = new ArrayList();

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM MostRecommendedCompanies");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			MostRecommended mr = new MostRecommended();

			mr.setId(result.getLong("id"));
			mr.setName(result.getString("name"));
			mr.setRecommendations(result.getString("recommendations"));

			mostRecommendedCompanies.add(mr);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	List mostRecommendedProducts = new ArrayList();

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM MostRecommendedProducts");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			MostRecommended mr = new MostRecommended();

			mr.setId(result.getLong("id"));
			mr.setName(result.getString("name"));
			mr.setRecommendations(result.getString("recommendations"));

			mostRecommendedProducts.add(mr);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	List mostRecommendedPlaces = new ArrayList();

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM MostRecommendedPlaces");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			MostRecommended mr = new MostRecommended();

			mr.setId(result.getLong("id"));
			mr.setName(result.getString("name"));
			mr.setRecommendations(result.getString("recommendations"));

			mostRecommendedPlaces.add(mr);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }


	List mostRecommendedFoods = new ArrayList();

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM MostRecommendedFoods");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			MostRecommended mr = new MostRecommended();

			mr.setId(result.getLong("id"));
			mr.setName(result.getString("name"));
			mr.setRecommendations(result.getString("recommendations"));

			mostRecommendedFoods.add(mr);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	List mostRecommendedGames = new ArrayList();

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM MostRecommendedGames");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			MostRecommended mr = new MostRecommended();

			mr.setId(result.getLong("id"));
			mr.setName(result.getString("name"));
			mr.setRecommendations(result.getString("recommendations"));

			mostRecommendedGames.add(mr);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	List mostRecommendedGuns = new ArrayList();

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM MostRecommendedGuns");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			MostRecommended mr = new MostRecommended();

			mr.setId(result.getLong("id"));
			mr.setName(result.getString("name"));
			mr.setRecommendations(result.getString("recommendations"));

			mostRecommendedGuns.add(mr);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	List mostRecommendedKnives = new ArrayList();

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM MostRecommendedKnives");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			MostRecommended mr = new MostRecommended();

			mr.setId(result.getLong("id"));
			mr.setName(result.getString("name"));
			mr.setRecommendations(result.getString("recommendations"));

			mostRecommendedKnives.add(mr);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	List mostRecommendedCars = new ArrayList();

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM MostRecommendedCars");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			MostRecommended mr = new MostRecommended();

			mr.setId(result.getLong("id"));
			mr.setName(result.getString("name"));
			mr.setRecommendations(result.getString("recommendations"));

			mostRecommendedCars.add(mr);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	List mostRecommendedMotorcycles = new ArrayList();

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM MostRecommendedMotorcycles");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			MostRecommended mr = new MostRecommended();

			mr.setId(result.getLong("id"));
			mr.setName(result.getString("name"));
			mr.setRecommendations(result.getString("recommendations"));

			mostRecommendedMotorcycles.add(mr);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	List mostRecommendedRecommenders = new ArrayList();

	try {
		PreparedStatement ps = db.conexao.prepareStatement("SELECT * FROM MostRecommendedRecommenders");
		ResultSet result = ps.executeQuery();

		while(result.next()) {
			MostRecommended mr = new MostRecommended();

			mr.setId(result.getLong("id"));
			mr.setName(result.getString("name"));
			mr.setRecommendations(result.getString("recommendations"));

			mostRecommendedRecommenders.add(mr);
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	/*
	 * Desconecta do Banco de Dados
	 */

	if(db.conexao != null) {
		db.DesconectaDB();
	}

%>
	<div class="Corpo">
		<div class="CenterColumn">
			<fieldset>
				<legend>Recommenders</legend>
				<table>
				<tbody>
				<%

				Iterator itr15 = mostRecommendedRecommenders.iterator();

				while(itr15.hasNext()) {
				MostRecommended mr = (MostRecommended) itr15.next();

				String imagemNome = "Recommender"+mr.getId()+".jpg";
				String imagemOutro = "NoImageAvailable.png";

				if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

					imagemOutro = imagemNome;

				}

				String r = "recs";
				if(Long.valueOf(mr.getRecommendations()) < 2) { r = "rec"; }

				out.println("<tr><th rowspan=\"2\"><a href=\"Recommender.jsp?id="+mr.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" alt=\""+mr.getName()+"\" width=\"300\" height=\"300\" /></a></th><td style=\"width: 100%\" class=\"LightGrayBorder\"><a href=\"Recommender.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+" "+r+"</span></td></tr>");

				/* out.println("<tr><td class=\"LightGrayBorder\"><a href=\"Recommender.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+"</span></td></tr>"); */
				}

out.println("<tr><td colspan=\"2\" class=\"LightGrayBorder\"><a href=\"MostRecommended.jsp?type=Recommender\">See The 1000 Most Recommended Recommenders</a></td></tr>");

				%>
				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Persons</legend>
				<table>
				<tbody>
				<%

				Iterator itr1 = mostRecommendedPersons.iterator();

				while(itr1.hasNext()) {
				MostRecommended mr = (MostRecommended) itr1.next();

				String imagemNome = "Recommended"+mr.getId()+".jpg";
				String imagemOutro = "NoImageAvailable.png";

				if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

					imagemOutro = imagemNome;

				}

				String r = "recs";
				if(Long.valueOf(mr.getRecommendations()) < 2) { r = "rec"; }

				out.println("<tr><th rowspan=\"2\"><a href=\"Recommended.jsp?id="+mr.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" alt=\""+mr.getName()+"\" width=\"300\" height=\"300\" /></a></th><td style=\"width: 100%\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+" "+r+"</span></td></tr>");

				/* out.println("<tr><td class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+"</span></td></tr>"); */
				}

	if(mostRecommendedPersons.isEmpty()) {

out.println("<tr><td class=\"LightGrayBorder\"><a href=\"AddRecommender.jsp\">Nothing yet! Be the first to add a Persons!</a></td></tr>");

	} else {

out.println("<tr><td colspan=\"2\" class=\"LightGrayBorder\"><a href=\"MostRecommended.jsp?type=Person\">See The 1000 Most Recommended Persons</a></td></tr>");

	}

				%>
				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Groups</legend>
				<table>
				<tbody>
				<%

				Iterator itr2 = mostRecommendedGroups.iterator();

				while(itr2.hasNext()) {
				MostRecommended mr = (MostRecommended) itr2.next();

				String imagemNome = "Recommended"+mr.getId()+".jpg";
				String imagemOutro = "NoImageAvailable.png";

				if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

					imagemOutro = imagemNome;

				}

				String r = "recs";
				if(Long.valueOf(mr.getRecommendations()) < 2) { r = "rec"; }

				out.println("<tr><th rowspan=\"2\"><a href=\"Recommended.jsp?id="+mr.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" alt=\""+mr.getName()+"\" width=\"300\" height=\"300\" /></a></th><td style=\"width: 100%\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+" "+r+"</span></td></tr>");
				}

out.println("<tr><td colspan=\"2\" class=\"LightGrayBorder\"><a href=\"MostRecommended.jsp?type=Group\">See The 1000 Most Recommended Groups</a></td></tr>");

				%>
				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Books</legend>
				<table>
				<tbody>
				<%

				Iterator itr3 = mostRecommendedBooks.iterator();

				while(itr3.hasNext()) {
				MostRecommended mr = (MostRecommended) itr3.next();

				String imagemNome = "Recommended"+mr.getId()+".jpg";
				String imagemOutro = "NoImageAvailable.png";

				if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

					imagemOutro = imagemNome;

				}

				String r = "recs";
				if(Long.valueOf(mr.getRecommendations()) < 2) { r = "rec"; }

				out.println("<tr><th rowspan=\"2\"><a href=\"Recommended.jsp?id="+mr.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" alt=\""+mr.getName()+"\" width=\"300\" height=\"300\" /></a></th><td style=\"width: 100%\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+" "+r+"</span></td></tr>");
				}

out.println("<tr><td colspan=\"2\" class=\"LightGrayBorder\"><a href=\"MostRecommended.jsp?type=Book\">See The 1000 Most Recommended Books</a></td></tr>");

				%>
				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Movies</legend>
				<table>
				<tbody>
				<%

				Iterator itr4 = mostRecommendedMovies.iterator();

				while(itr4.hasNext()) {
				MostRecommended mr = (MostRecommended) itr4.next();

				String imagemNome = "Recommended"+mr.getId()+".jpg";
				String imagemOutro = "NoImageAvailable.png";

				if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

					imagemOutro = imagemNome;

				}

				String r = "recs";
				if(Long.valueOf(mr.getRecommendations()) < 2) { r = "rec"; }

				out.println("<tr><th rowspan=\"2\"><a href=\"Recommended.jsp?id="+mr.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" alt=\""+mr.getName()+"\" width=\"300\" height=\"300\" /></a></th><td style=\"width: 100%\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+" "+r+"</span></td></tr>");
				}

out.println("<tr><td colspan=\"2\" class=\"LightGrayBorder\"><a href=\"MostRecommended.jsp?type=Movie\">See The 1000 Most Recommended Movies</a></td></tr>");


				%>
				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Bands</legend>
				<table>
				<tbody>
				<%

				Iterator itr5 = mostRecommendedBands.iterator();

				while(itr5.hasNext()) {
				MostRecommended mr = (MostRecommended) itr5.next();

				String imagemNome = "Recommended"+mr.getId()+".jpg";
				String imagemOutro = "NoImageAvailable.png";

				if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

					imagemOutro = imagemNome;

				}

				String r = "recs";
				if(Long.valueOf(mr.getRecommendations()) < 2) { r = "rec"; }

				out.println("<tr><th rowspan=\"2\"><a href=\"Recommended.jsp?id="+mr.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" alt=\""+mr.getName()+"\" width=\"300\" height=\"300\" /></a></th><td style=\"width: 100%\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+" "+r+"</span></td></tr>");
				}

out.println("<tr><td colspan=\"2\" class=\"LightGrayBorder\"><a href=\"MostRecommended.jsp?type=Band\">See The 1000 Most Recommended Bands</a></td></tr>");

				%>
				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Albums</legend>
				<table>
				<tbody>
				<%

				Iterator itr6 = mostRecommendedAlbums.iterator();

				while(itr6.hasNext()) {
				MostRecommended mr = (MostRecommended) itr6.next();

				String imagemNome = "Recommended"+mr.getId()+".jpg";
				String imagemOutro = "NoImageAvailable.png";

				if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

					imagemOutro = imagemNome;

				}

				String r = "recs";
				if(Long.valueOf(mr.getRecommendations()) < 2) { r = "rec"; }

				out.println("<tr><th rowspan=\"2\"><a href=\"Recommended.jsp?id="+mr.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" alt=\""+mr.getName()+"\" width=\"300\" height=\"300\" /></a></th><td style=\"width: 100%\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+" "+r+"</span></td></tr>");
				}

out.println("<tr><td colspan=\"2\" class=\"LightGrayBorder\"><a href=\"MostRecommended.jsp?type=Album\">See The 1000 Most Recommended Albums</a></td></tr>");

				%>
				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Songs</legend>
				<table>
				<tbody>
				<%

				Iterator itr7 = mostRecommendedSongs.iterator();

				while(itr7.hasNext()) {
				MostRecommended mr = (MostRecommended) itr7.next();

				String imagemNome = "Recommended"+mr.getId()+".jpg";
				String imagemOutro = "NoImageAvailable.png";

				if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

					imagemOutro = imagemNome;

				}

				String r = "recs";
				if(Long.valueOf(mr.getRecommendations()) < 2) { r = "rec"; }

				out.println("<tr><th rowspan=\"2\"><a href=\"Recommended.jsp?id="+mr.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" alt=\""+mr.getName()+"\" width=\"300\" height=\"300\" /></a></th><td style=\"width: 100%\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+" "+r+"</span></td></tr>");
				}

out.println("<tr><td colspan=\"2\" class=\"LightGrayBorder\"><a href=\"MostRecommended.jsp?type=Song\">See The 1000 Most Recommended Songs</a></td></tr>");

				%>
				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Companies</legend>
				<table>
				<tbody>
				<%

				Iterator itr10 = mostRecommendedCompanies.iterator();

				while(itr10.hasNext()) {
				MostRecommended mr = (MostRecommended) itr10.next();

				String imagemNome = "Recommended"+mr.getId()+".jpg";
				String imagemOutro = "NoImageAvailable.png";

				if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

					imagemOutro = imagemNome;

				}

				String r = "recs";
				if(Long.valueOf(mr.getRecommendations()) < 2) { r = "rec"; }

				out.println("<tr><th rowspan=\"2\"><a href=\"Recommended.jsp?id="+mr.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" alt=\""+mr.getName()+"\" width=\"300\" height=\"300\" /></a></th><td style=\"width: 100%\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+" "+r+"</span></td></tr>");
				}

	if(mostRecommendedCompanies.isEmpty()) {

out.println("<tr><td class=\"LightGrayBorder\"><a href=\"AddRecommender.jsp\">Nothing yet! Be the first to add a Company!</a></td></tr>");

	} else {

out.println("<tr><td colspan=\"2\" class=\"LightGrayBorder\"><a href=\"MostRecommended.jsp?type=Company\">See The 1000 Most Recommended Companies</a></td></tr>");

	}

				%>
				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Foods</legend>
				<table>
				<tbody>
				<%

				Iterator itr13 = mostRecommendedFoods.iterator();

				while(itr13.hasNext()) {
				MostRecommended mr = (MostRecommended) itr13.next();

				String imagemNome = "Recommended"+mr.getId()+".jpg";
				String imagemOutro = "NoImageAvailable.png";

				if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

					imagemOutro = imagemNome;

				}

				String r = "recs";
				if(Long.valueOf(mr.getRecommendations()) < 2) { r = "rec"; }

				out.println("<tr><th rowspan=\"2\"><a href=\"Recommended.jsp?id="+mr.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" alt=\""+mr.getName()+"\" width=\"300\" height=\"300\" /></a></th><td style=\"width: 100%\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+" "+r+"</span></td></tr>");
				}

out.println("<tr><td colspan=\"2\" class=\"LightGrayBorder\"><a href=\"MostRecommended.jsp?type=Food\">See The 1000 Most Recommended Foods</a></td></tr>");

				%>
				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Projects</legend>
				<table>
				<tbody>
				<%

				Iterator itr8 = mostRecommendedProjects.iterator();

				while(itr8.hasNext()) {
				MostRecommended mr = (MostRecommended) itr8.next();

				String imagemNome = "Recommended"+mr.getId()+".jpg";
				String imagemOutro = "NoImageAvailable.png";

				if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

					imagemOutro = imagemNome;

				}

				String r = "recs";
				if(Long.valueOf(mr.getRecommendations()) < 2) { r = "rec"; }

				out.println("<tr><th rowspan=\"2\"><a href=\"Recommended.jsp?id="+mr.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" alt=\""+mr.getName()+"\" width=\"300\" height=\"300\" /></a></th><td style=\"width: 100%\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+" "+r+"</span></td></tr>");
				}

out.println("<tr><td colspan=\"2\" class=\"LightGrayBorder\"><a href=\"MostRecommended.jsp?type=Project\">See The 1000 Most Recommended Projects</a></td></tr>");

				%>
				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Products</legend>
				<table>
				<tbody>
				<%

				Iterator itr11 = mostRecommendedProducts.iterator();

				while(itr11.hasNext()) {
				MostRecommended mr = (MostRecommended) itr11.next();

				String imagemNome = "Recommended"+mr.getId()+".jpg";
				String imagemOutro = "NoImageAvailable.png";

				if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

					imagemOutro = imagemNome;

				}

				String r = "recs";
				if(Long.valueOf(mr.getRecommendations()) < 2) { r = "rec"; }

				out.println("<tr><th rowspan=\"2\"><a href=\"Recommended.jsp?id="+mr.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" alt=\""+mr.getName()+"\" width=\"300\" height=\"300\" /></a></th><td style=\"width: 100%\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+" "+r+"</span></td></tr>");
				}

out.println("<tr><td colspan=\"2\" class=\"LightGrayBorder\"><a href=\"MostRecommended.jsp?type=Product\">See The 1000 Most Recommended Products</a></td></tr>");

				%>
				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Games</legend>
				<table>
				<tbody>
				<%

				Iterator itr14 = mostRecommendedGames.iterator();

				while(itr14.hasNext()) {
				MostRecommended mr = (MostRecommended) itr14.next();

				String imagemNome = "Recommended"+mr.getId()+".jpg";
				String imagemOutro = "NoImageAvailable.png";

				if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

					imagemOutro = imagemNome;

				}

				String r = "recs";
				if(Long.valueOf(mr.getRecommendations()) < 2) { r = "rec"; }

				out.println("<tr><th rowspan=\"2\"><a href=\"Recommended.jsp?id="+mr.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" alt=\""+mr.getName()+"\" width=\"300\" height=\"300\" /></a></th><td style=\"width: 100%\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+" "+r+"</span></td></tr>");

				}

out.println("<tr><td colspan=\"2\" class=\"LightGrayBorder\"><a href=\"MostRecommended.jsp?type=Game\">See The 1000 Most Recommended Games</a></td></tr>");

				%>
				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Websites</legend>
				<table>
				<tbody>
				<%

				Iterator itr9 = mostRecommendedWebsites.iterator();

				while(itr9.hasNext()) {
				MostRecommended mr = (MostRecommended) itr9.next();

				String imagemNome = "Recommended"+mr.getId()+".jpg";
				String imagemOutro = "NoImageAvailable.png";

				if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

					imagemOutro = imagemNome;

				}

				String r = "recs";
				if(Long.valueOf(mr.getRecommendations()) < 2) { r = "rec"; }

				out.println("<tr><th rowspan=\"2\"><a href=\"Recommended.jsp?id="+mr.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" alt=\""+mr.getName()+"\" width=\"300\" height=\"300\" /></a></th><td style=\"width: 100%\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+" "+r+"</span></td></tr>");
				}

	if(mostRecommendedWebsites.isEmpty()) {

out.println("<tr><td class=\"LightGrayBorder\"><a href=\"AddRecommender.jsp\">Nothing yet! Be the first to add a Website!</a></td></tr>");

	} else {

out.println("<tr><td colspan=\"2\" class=\"LightGrayBorder\"><a href=\"MostRecommended.jsp?type=Website\">See The 1000 Most Recommended Websites</a></td></tr>");

	}

				%>
				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Places</legend>
				<table>
				<tbody>
				<%

				Iterator itr12 = mostRecommendedPlaces.iterator();

				while(itr12.hasNext()) {
				MostRecommended mr = (MostRecommended) itr12.next();

				String imagemNome = "Recommended"+mr.getId()+".jpg";
				String imagemOutro = "NoImageAvailable.png";

				if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

					imagemOutro = imagemNome;

				}

				String r = "recs";
				if(Long.valueOf(mr.getRecommendations()) < 2) { r = "rec"; }

				out.println("<tr><th rowspan=\"2\"><a href=\"Recommended.jsp?id="+mr.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" alt=\""+mr.getName()+"\" width=\"300\" height=\"300\" /></a></th><td style=\"width: 100%\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+" "+r+"</span></td></tr>");
				}

	if(mostRecommendedPlaces.isEmpty()) {

out.println("<tr><td class=\"LightGrayBorder\"><a href=\"AddRecommender.jsp\">Nothing yet! Be the first to add a Place!</a></td></tr>");

	} else {

out.println("<tr><td colspan=\"2\" class=\"LightGrayBorder\"><a href=\"MostRecommended.jsp?type=Place\">See The 1000 Most Recommended Places</a></td></tr>");

	}

				%>
				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Cars</legend>
				<table>
				<tbody>
				<%

				Iterator itr18 = mostRecommendedCars.iterator();

				while(itr18.hasNext()) {
				MostRecommended mr = (MostRecommended) itr18.next();

				String imagemNome = "Recommended"+mr.getId()+".jpg";
				String imagemOutro = "NoImageAvailable.png";

				if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

					imagemOutro = imagemNome;

				}

				String r = "recs";
				if(Long.valueOf(mr.getRecommendations()) < 2) { r = "rec"; }

				out.println("<tr><th rowspan=\"2\"><a href=\"Recommended.jsp?id="+mr.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" alt=\""+mr.getName()+"\" width=\"300\" height=\"300\" /></a></th><td style=\"width: 100%\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+" "+r+"</span></td></tr>");
				}

	if(mostRecommendedCars.isEmpty()) {

out.println("<tr><td class=\"LightGrayBorder\"><a href=\"AddRecommender.jsp\">Nothing yet! Be the first to add a Car!</a></td></tr>");

	} else {

out.println("<tr><td colspan=\"2\" class=\"LightGrayBorder\"><a href=\"MostRecommended.jsp?type=Car\">See The 1000 Most Recommended Cars</a></td></tr>");

	}
				%>
				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Motorcycles</legend>
				<table>
				<tbody>
				<%

				Iterator itr19 = mostRecommendedMotorcycles.iterator();

				while(itr19.hasNext()) {
				MostRecommended mr = (MostRecommended) itr19.next();

				String imagemNome = "Recommended"+mr.getId()+".jpg";
				String imagemOutro = "NoImageAvailable.png";

				if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

					imagemOutro = imagemNome;

				}

				String r = "recs";
				if(Long.valueOf(mr.getRecommendations()) < 2) { r = "rec"; }

				out.println("<tr><th rowspan=\"2\"><a href=\"Recommended.jsp?id="+mr.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" alt=\""+mr.getName()+"\" width=\"300\" height=\"300\" /></a></th><td style=\"width: 100%\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+" "+r+"</span></td></tr>");
				}

out.println("<tr><td colspan=\"2\" class=\"LightGrayBorder\"><a href=\"MostRecommended.jsp?type=Motorcycle\">See The 1000 Most Recommended Motorcycles</a></td></tr>");

				%>
				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Guns</legend>
				<table>
				<tbody>
				<%

				Iterator itr16 = mostRecommendedGuns.iterator();

				while(itr16.hasNext()) {
				MostRecommended mr = (MostRecommended) itr16.next();

				String imagemNome = "Recommended"+mr.getId()+".jpg";
				String imagemOutro = "NoImageAvailable.png";

				if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

					imagemOutro = imagemNome;

				}

				String r = "recs";
				if(Long.valueOf(mr.getRecommendations()) < 2) { r = "rec"; }

				out.println("<tr><th rowspan=\"2\"><a href=\"Recommended.jsp?id="+mr.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" alt=\""+mr.getName()+"\" width=\"300\" height=\"300\" /></a></th><td style=\"width: 100%\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+" "+r+"</span></td></tr>");
				}

	if(mostRecommendedGuns.isEmpty()) {

out.println("<tr><td class=\"LightGrayBorder\"><a href=\"AddRecommender.jsp\">Nothing yet! Be the first to add a Gun!</a></td></tr>");

	} else {

out.println("<tr><td colspan=\"2\" class=\"LightGrayBorder\"><a href=\"MostRecommended.jsp?type=Gun\">See The 1000 Most Recommended Guns</a></td></tr>");

	}

				%>
				</tbody>
				</table>
			</fieldset>
			<fieldset>
				<legend>Knives</legend>
				<table>
				<tbody>
				<%

				Iterator itr17 = mostRecommendedKnives.iterator();

				while(itr17.hasNext()) {
				MostRecommended mr = (MostRecommended) itr17.next();

				String imagemNome = "Recommended"+mr.getId()+".jpg";
				String imagemOutro = "NoImageAvailable.png";

				if(new IsImageRecorded().Exists(request, "\\img\\user\\", imagemNome)) {

					imagemOutro = imagemNome;

				}

				String r = "recs";
				if(Long.valueOf(mr.getRecommendations()) < 2) { r = "rec"; }

				out.println("<tr><th rowspan=\"2\"><a href=\"Recommended.jsp?id="+mr.getId()+"\"><img src=\"./img/user/"+imagemOutro+"\" alt=\""+mr.getName()+"\" width=\"300\" height=\"300\" /></a></th><td style=\"width: 100%\" class=\"LightGrayBorder\"><a href=\"Recommended.jsp?id="+mr.getId()+"\">"+mr.getName()+"</a></td></tr><tr><td class=\"LightGrayBorder\"><span class=\"green\">"+mr.getRecommendations()+" "+r+"</span></td></tr>");

				}

out.println("<tr><td colspan=\"2\" class=\"LightGrayBorder\"><a href=\"MostRecommended.jsp?type=Knife\">See The 1000 Most Recommended Knives</a></td></tr>");

				%>
				</tbody>
				</table>
			</fieldset>
		</div>
	</div>