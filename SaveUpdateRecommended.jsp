
<%@ page errorPage="Error.jsp" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("SaveUpdateRecommended");

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

%>

<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="recBook.DB" %>
<%@ page import="recBook.Recommended" %>
<%@ page import="recBook.RecommendedDAO" %>
<%@ page import="recBook.DeleteImage" %>
<%@ page import="recBook.RecordImage" %>

<%
	Cookie[] cookies = request.getCookies();

	Boolean isRecommenderLogged = false;
	Long recommenderIdLogged = 0l;

	if(cookies != null) {

	for(Cookie cookie:cookies) {
 		if(cookie.getName().equals("IsRecommenderLogged")) {
			if(cookie.getValue().equals("Yes")) {
				isRecommenderLogged = true;
			}
		}
	}

	for(Cookie cookie:cookies) {
 		if(cookie.getName().equals("RecommenderId")) {
			if(isRecommenderLogged) {
				recommenderIdLogged = Long.valueOf((String) cookie.getValue());
			}
		}
	}

	}

%>

<% if(!isRecommenderLogged) { %>

	<jsp:forward page="/Login.jsp" />

<% } else { %>

<%
	Long id = (Long) session.getAttribute("IdS");
	String country = (String) session.getAttribute("countryS");
	String officialWebsite = (String) session.getAttribute("officialWebsiteS");
	String about = (String) session.getAttribute("aboutS");
	String descricao = (String) session.getAttribute("descriptionS");
	byte[] imagem = (byte[]) session.getAttribute("image");
	byte[] imagemVazia = {};
	Long imagemTamanho = (Long) session.getAttribute("imageTamanho");

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	Recommended recommendedAtual = new Recommended();

	try {

		recommendedAtual = new RecommendedDAO(db).select(Long.valueOf(id));

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally { }

	Boolean permissionDenied = false;

	if(recommenderIdLogged.equals(recommendedAtual.getRecommender())) {

	try {

		PreparedStatement ps;

		if(country != null) {
			if(!recommendedAtual.getCountry().equals(Integer.valueOf(country))) {
				ps = db.conexao.prepareStatement("UPDATE Recommended SET country = ? WHERE id = ?");
				ps.setInt(1, Integer.valueOf(country));
				ps.setLong(2, Long.valueOf(id));
				ps.executeUpdate();
			}
		}

		if(officialWebsite != null) {
			ps = db.conexao.prepareStatement("UPDATE Recommended SET officialWebsite = ? WHERE id = ?");
			ps.setString(1, officialWebsite);
			ps.setLong(2, Long.valueOf(id));
			ps.executeUpdate();
		}

		if(about != null) {
			ps = db.conexao.prepareStatement("UPDATE Recommended SET about = ? WHERE id = ?");
			ps.setString(1, about);
			ps.setLong(2, Long.valueOf(id));
			ps.executeUpdate();
		}

		if((!imagem.equals(imagemVazia)) && (imagemTamanho > 0l)) {

				/*
				 * Deleta imagem antiga
				 */
				new DeleteImage(request, "\\img\\user\\", "Recommended"+id+".jpg");

				/*
				 * Salva imagem nova
				 */
				new RecordImage(request, imagem, "\\img\\user\\", "Recommended"+id+".jpg");

		}

		if(descricao != null) {
			ps = db.conexao.prepareStatement("UPDATE Recommended SET descriptionImage = ? WHERE id = ?");
			ps.setString(1, descricao);
			ps.setLong(2, Long.valueOf(id));
			ps.executeUpdate();
		}

	} catch(SQLException e) {
		System.err.println("SQLException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	} finally {

		/*
		 * Desconecta do Banco de Dados
		 */

		if(db.conexao != null) {
			db.DesconectaDB();
		}
	}

	} else {
		permissionDenied = true;
	}

	session.setAttribute("IdS", "");
	session.setAttribute("nameS", "");
	session.setAttribute("countryS", "");
	session.setAttribute("officialWebsiteS", "");
	session.setAttribute("aboutS", "");
	session.setAttribute("image", "");
	session.setAttribute("descriptionS", "");

	if(permissionDenied) {
		response.sendRedirect("Error.jsp?id=7");
	} else {
		response.sendRedirect("Recommended.jsp?id="+id+"");
	}

%>

<% } %>

