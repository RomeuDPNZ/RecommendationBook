
<%@ page errorPage="Error.jsp" %>

<%@ page import="recBook.PageViewsDAOOutro" %>

<%

	try {

		new PageViewsDAOOutro().incrementPageViews("SaveUpdateRecommender");

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
<%@ page import="recBook.Recommender" %>
<%@ page import="recBook.RecommenderDAO" %>
<%@ page import="recBook.Login" %>
<%@ page import="recBook.LoginDAO" %>
<%@ page import="recBook.DeleteImage" %>
<%@ page import="recBook.RecordImage" %>
<%@ page import="recBook.Cryptography" %>

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
	String password = (String) session.getAttribute("passwordS");
	String country = (String) session.getAttribute("countryS");
	String officialWebsite = (String) session.getAttribute("officialWebsiteS");
	String about = (String) session.getAttribute("aboutS");
	byte[] imagem = (byte[]) session.getAttribute("image");
	byte[] imagemVazia = {};
	Long imagemTamanho = (Long) session.getAttribute("imageTamanho");

	String sex = (String) session.getAttribute("sexS");
	String year = (String) session.getAttribute("yearS");
	String month = (String) session.getAttribute("monthS");
	String day = (String) session.getAttribute("dayS");

	/*
	 * Criptografa Password
	 */

	byte[] pcBytes = {};

	try {

		Cryptography c = new Cryptography(password);

		pcBytes = c.Encrypt(password);

	} catch(Exception e) {
		System.err.println("CryptographyException: "+e.getMessage());

		String uri = request.getRequestURI();
		String pageName = uri.substring(uri.lastIndexOf("/")+1);

		if(e.getMessage() != null) {
			throw new SQLException(e.getMessage()+" Page: "+pageName);
		}
	}

	/*
	 * Conecta ao Banco de Dados
	 */

	DB db = new DB();
	db.ConectaDB();

	if(db.conexao == null) {
		System.err.println("DB Connection Error: "+db.conexao);
	}

	Recommender recommenderAtual = new Recommender();

	try {

		recommenderAtual = new RecommenderDAO(db).select(Long.valueOf(id));

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
	} finally {}

	Boolean permissionDenied = false;

	if(recommenderIdLogged.equals(recommenderAtual.getId())) {

	try {

		PreparedStatement ps;
		Login loginAtual = new LoginDAO(db).select(recommenderAtual.getLogin());

		if(password != null && !password.equals("")) {
			if(!loginAtual.getPassword().equals(password)) {
				ps = db.conexao.prepareStatement("UPDATE Login SET password = ? WHERE id = ?");
				ps.setBytes(1, pcBytes);
				ps.setLong(2, Long.valueOf(id));
				ps.executeUpdate();
			}
		}

		if(country != null) {
			if(!recommenderAtual.getCountry().equals(Integer.valueOf(country))) {
				ps = db.conexao.prepareStatement("UPDATE Recommender SET country = ? WHERE id = ?");
				ps.setInt(1, Integer.valueOf(country));
				ps.setLong(2, Long.valueOf(id));
				ps.executeUpdate();
			}
		}

		if(officialWebsite != null) {
			ps = db.conexao.prepareStatement("UPDATE Recommender SET officialWebsite = ? WHERE id = ?");
			ps.setString(1, officialWebsite);
			ps.setLong(2, Long.valueOf(id));
			ps.executeUpdate();
		}

		if(about != null) {
			ps = db.conexao.prepareStatement("UPDATE Recommender SET about = ? WHERE id = ?");
			ps.setString(1, about);
			ps.setLong(2, Long.valueOf(id));
			ps.executeUpdate();
		}

		if((imagem != null) && (!imagem.equals(imagemVazia)) && (imagemTamanho > 0l)) {
				/*
				 * Deleta imagem antiga
				 */
				new DeleteImage(request, "\\img\\user\\", "Recommender"+id+".jpg");

				/*
				 * Salva imagem nova
				 */
				new RecordImage(request, imagem, "\\img\\user\\", "Recommender"+id+".jpg");
		}

		if(sex != null) {
			ps = db.conexao.prepareStatement("UPDATE Recommender SET sex = ? WHERE id = ?");
			ps.setString(1, sex);
			ps.setLong(2, Long.valueOf(id));
			ps.executeUpdate();
		}

		if((year != null) && (month != null) && (day != null)) {
			ps = db.conexao.prepareStatement("UPDATE Recommender SET birthDate = ? WHERE id = ?");
			ps.setString(1, ""+year+""+month+""+day+"");
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

		if(db.conexao != null) {
			db.DesconectaDB();
		}
	}

	} else {
		permissionDenied = true;
	}

	session.setAttribute("IdS", "");
	session.setAttribute("nickNameS", "");
	session.setAttribute("sexS", "");
	session.setAttribute("countryS", "");
	session.setAttribute("yearS", "");
	session.setAttribute("monthS", "");
	session.setAttribute("dayS", "");
	session.setAttribute("officialWebsiteS", "");
	session.setAttribute("aboutS", "");
	session.setAttribute("image", "");
	session.setAttribute("imageExtension", "");

	if(permissionDenied) {
		response.sendRedirect("Error.jsp?id=7");
	} else {
		response.sendRedirect("Recommender.jsp?id="+id+"");
	}

%>

<% } %>
